function [HistA,peaks1,trek1]=ProcessTrek(FileName1);


Text1=false;           % switch between text and binary input files
OverSt1=2.5;         % noise regection threshold, in standard deviations    
Pass1=3;
StartOffset=14600; %in us Tokamak delay + 1.6ms

tic;

if not(isstr(FileName1)); 
    trek1=FileName1; 
else
   if Text1;  
       trek1=load(FileName1);  
   else  
       fid = fopen(FileName1); trek1 = fread(fid,inf,'int16'); fclose(fid); clear fid; 
   end; 
end; 

if size(trek1,2)==2; trek1(:,1)=trek1(:,2); trek1(:,2)=[]; end; 
bool=(trek1(:)>4095)|(trek1(:)<0); OutRangeN=size(find(bool),1); 
if OutRangeN>0; fprintf('%7.0f  points out of the ADC range  \n',OutRangeN); end; 
trek1(bool,:)=[];  clear bool; 
trekSize1=size(trek1(:,1),1);
fprintf('Loading time =                                %7.4f  sec\n', toc); tic; 

NoiseArray=logical(true(trekSize1,1));  % first, all measurements are considered as noise
[MeanVal,StdVal,PeakPolarity,NoiseArray]=MeanSearch(trek1,OverSt1,NoiseArray);
if PeakPolarity==1; trek1(:)=trek1(:)-MeanVal;  else trek1(:)=MeanVal-trek1(:); end;
fprintf('First mean search   =                        %7.4f  sec\n', toc); 
fprintf('  Standard deviat = %6.4f\n', StdVal);
gr_input_decision=input('For graph interval input press ''g'' \n Default Time interval input \n','s');
gr_input_decision=lower(gr_input_decision);
if gr_input_decision=='g'
    trf=figure;
        plot(trek1);
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
        ProcIntTime=[StartOffset+StI*0.025,StartOffset+EndI*0.025];
else
    ProcIntTime=input(['Input Process Interval Times [...,...]\n Default is whole trek[',num2str(StartOffset),',',num2str(StartOffset+size(trek1,1)*0.025),'] by indexes input\n']);
    if isempty(ProcIntTime)
        StI=1;
        EndI=size(trek1,1);
        ProcInt=[StI:EndI];
        ProcIntTime=[StartOffset+StI*0.025,StartOffset+EndI*0.025];
    else
        StI=max([(ProcIntTime(1)-StartOffset)/0.025+1,1]);
        EndI=min([(ProcIntTime(end)-StartOffset)/0.025,trekSize1]);
        ProcInt=[StI:EndI];
    end;
end;

ProcInt1=input(['Input Process Interval indexes[...:...]\n Default is [',num2str(StI) ,':',num2str(EndI),']\n']);
 if not(isempty(ProcInt1)) 
    ProcInt=ProcInt1;
    clear ProcInt1;
 end;

ProcIntTime=[StartOffset+ProcInt(1)*0.025,StartOffset+ProcInt(end)*0.025];
fprintf('Process Inteval is %8.3f-%8.3fus  %8.3f us long\n Indexes [%5.0f:%7.0f]\n',ProcIntTime(1),ProcIntTime(end),(ProcIntTime(end)-ProcIntTime(1)),ProcInt(1),ProcInt(end));

clear MeanVal NoiseArray OutRangeN  PeakPolarity StdVal Text trekSize1;
if isstr(FileName1)
   [path1,name1,ext1,versn1]=fileparts(FileName1);
   FileName1=[strrep(name1,'trek',''),num2str(ProcIntTime(1)/1000,'T%5.0fms-'),num2str((ProcIntTime(end))/1000,'%5.0fms')];
else
    trNum=input('Input number of trek\n');
    name1=num2str(trNum,'%03.0f')
    FileName1=[name1,num2str(ProcIntTime(1)/1000,'T%5.0fms-'),num2str((ProcIntTime(end))/1000,'%5.0fms')];
end;

[peaks1,trekMinus]=GetPeaks(trek1(ProcInt),Pass1);

if exist('PEAKS')==7
    PeakFolder=[cd,'\PEAKS\'];
else
    mkdir(cd,'PEAKS');
    PeakFolder=[cd,'\PEAKS\'];
end;
 if isstr(FileName1) 
     PassStr=num2str(Pass1);   
     PeakFile=[PeakFolder,'Peak',FileName1,'P',PassStr,'.dat']; 
 end;

fprintf('Peaks will be writen \n in %s \n file', PeakFile);


fid=fopen(PeakFile,'w');
%fprintf(fid,'InitMaxInd   FitMaxTime     interv    zero    ampl    MinKhi  Pass\n'); 
fprintf(fid,'%10.3f %10.3f %9.3f %7.2f %7.2f %7.2f %5.3f\n' ,peaks');
fclose(fid);    

HistA=HistNew(peaks1,FileName1,ProcIntTime);


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
