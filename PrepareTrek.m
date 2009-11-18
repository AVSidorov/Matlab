function [trek,ProcInt,ProcIntTime,StdVal]=PrepareTrek(FileName);

Text=false;           % switch between text and binary input files
FileType='single';      %choose file type for precision in fread function 
OverSt1=2.5;         % noise regection threshold, in standard deviations    
StartOffsetDef=0;     %in us old system was Tokamak delay + 1.6ms
tau=0.020;
MaxSignal=3650;

disp('>>>>>>>>Prepare Trek started');
tic;
 if not(isstr(FileName)); 
     trek=FileName;
     type=8;
 else
     type=exist(FileName);
 end;

 switch type
    case 0
        disp('File or Variable not found');
        trek=[];
        ProcInt=[];
        ProcIntTime=[];
        StdVal=[];
        return;
    case 1
        trek=FileName;
    case 2
       if Text;  
           trek=load(FileName);  
       else  
            fid = fopen(FileName); trek = fread(fid,inf,FileType); fclose(fid); clear fid; 
       end; 
  end;

 if size(trek,2)==2; trek(:,1)=[]; end;      
% if not(isstr(FileName)); 
%     trek=FileName; 
% else
%    if Text;  
%        trek=load(FileName);  
%    else  
%        %fid = fopen(FileName); trek = fread(fid,inf,'int16'); fclose(fid); clear fid; 
%        fid = fopen(FileName); trek = fread(fid,inf,'single'); fclose(fid); clear fid; 
%    end; 
% end; 

if size(trek,2)==2; trek(:,1)=trek(:,2); trek(:,2)=[]; end; 

bool=(trek(:)>4095)|(trek(:)<0); OutRangeN=size(find(bool),1); 
if OutRangeN>0; fprintf('%7.0f  points out of the ADC range  \n',OutRangeN); end; 
trek(bool,:)=[];  clear bool; 

trekSize1=size(trek(:,1),1);
fprintf('Loading time =                                %7.4f  sec\n', toc); tic; 

NoiseArray=logical(true(trekSize1,1));  % first, all measurements are considered as noise
[MeanVal,StdVal,PeakPolarity,NoiseArray]=MeanSearch(trek,OverSt1,NoiseArray);
if PeakPolarity==1; trek(:)=trek(:)-MeanVal;  else trek(:)=MeanVal-trek(:); end;
fprintf('First mean search   =                        %7.4f  sec\n', toc); 
fprintf('  Standard deviat = %6.4f\n', StdVal);

bool=(trek(:)>MaxSignal); OutRangeN=size(find(bool),1); 
if OutRangeN>0; fprintf('%7.0f  points out of Amplifier Range  \n',OutRangeN); end; 
trek(bool,:)=0;  clear bool; 



StartOffset=input(['Input Start Offset Default is ',num2str(StartOffsetDef,'%6.0f us'),'\n']);
if isempty(StartOffset)
    StartOffset=StartOffsetDef;
end;
    
gr_input_decision=input('For graph interval input press ''g'' \n Default Time interval input \n','s');
gr_input_decision=lower(gr_input_decision);
if gr_input_decision=='g'
    trf=figure;
        plot(trek);
        hold on;
        disp('Zoom figure if nessecary');
        pause;
        figure(trf);
        [x,y]=ginput(1);
        StI=round(x);
        plot([x,x],[0,2500],'r','LineWidth',2);
        disp('Zoom figure if nessecary');
        pause;
        figure(trf);
        [x,y]=ginput(1);
        EndI=round(x);
        plot([x,x],[0,2500],'r','LineWidth',2);
        ProcInt=[StI:EndI];
        ProcIntTime=[StartOffset+StI*tau,StartOffset+EndI*tau];
else
    ProcIntTime=input(['Input Process Interval Times [...,...]\n Default is whole trek[',num2str(StartOffset),',',num2str(StartOffset+size(trek,1)*tau),'] by indexes input\n']);
    if isempty(ProcIntTime)
        StI=1;
        EndI=size(trek,1);
        ProcInt=[StI:EndI];
        ProcIntTime=[StartOffset+(StI-1)*tau,StartOffset+(EndI-1)*tau];
    else
        StI=max([(ProcIntTime(1)-StartOffset)/tau+1,1]);
        EndI=min([(ProcIntTime(end)-StartOffset)/tau+1,trekSize1]);
        ProcInt=[StI:EndI];
    end;
end;

ProcInt1=input(['Input Process Interval indexes[...:...]\n Default is [',num2str(StI) ,':',num2str(EndI),']\n']);
 if not(isempty(ProcInt1)) 
    ProcInt=ProcInt1;
    clear ProcInt1;
 end;

ProcIntTime=[StartOffset+(ProcInt(1)-1)*tau,StartOffset+(ProcInt(end)-1)*tau];
fprintf('Process Inteval is %8.3f-%8.3fus  %8.3f us long\n Indexes [%5.0f:%7.0f]\n',ProcIntTime(1),ProcIntTime(end),(ProcIntTime(end)-ProcIntTime(1)),ProcInt(1),ProcInt(end));
trek=trek(ProcInt);
disp('==========Prepare Trek finished');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [MeanVal,StdVal,PP,Noise]=MeanSearch(tr,OverSt,Noise);    
% search the signal pedestal and make it zero
           % Input parameters: tr or trD - input measurements, Over St (see above), Noise - assumed initial noise array  
           % Output parameters: MeanValue, Standad deviation, Pulse polarity, Noise - residual noise array
trSize=size(tr,1); %  (N,1) dimension

M =mean(tr(:)); St=std(tr(:));  
Positive=size(find(tr(:)-(M+5*St)>0),1);  
Negative=size(find(tr(:)-(M-5*St)<0),1); 
MaxVal=max(tr(:)); MinVal=min(tr(:)); DeltaM=MaxVal-MinVal;  

if Positive>Negative PeakPolarity=1; else PeakPolarity=-1;  end; 

NoisePoints=size(find(Noise),1); 
while DeltaM>0.1
    M =[M,mean(tr(Noise))];  St=[St,std(tr(Noise))];          
    L=length(M);    
    if L>2   DeltaM=abs(M(L)-M(L-1));  else     DeltaM=10;    end; 
    NoiseLevel=M(L)+PeakPolarity*OverSt*St(L);    
    if PeakPolarity==1 Noise=(tr(:)<NoiseLevel); else; Noise=(tr(:)>NoiseLevel); end;  %(abs(M(L)-tr(:,2))<OverSt*St(L));
    NoisePoints=[NoisePoints,size(find(Noise),1)];
    %if St(L)==0 DeltaM=0;end;
end; 
    NoiseL=circshift(Noise,-1);   NoiseL(end)=Noise(end);     
    NoiseR=circshift(Noise,1);    NoiseR(1)=Noise(1);
    SingleNoise=not(Noise)&NoiseR&NoiseL;           %search alone peaks above the NoiseLevel
    Noise(SingleNoise)=true;                        %the alone peaks are brought to the Noise array
    NoiseIndx=find(Noise);
    Noise(1:NoiseIndx(1))=1;  Noise(NoiseIndx(end):end)=1;
    MeanVal=M(L); StdVal=St(L); PP=PeakPolarity;
