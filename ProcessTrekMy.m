function [HistA,peaks1,trek1]=ProcessTrekMy(FileName1);


Text1=false;           % switch between text and binary input files
Plot1=true;
OverSt1=2.5;         % noise regection threshold, in standard deviations    
Pass1=1;
StartOffset=14600; %in us Tokamak delay + 1.6ms
StPeakWrite=true;
StPeakFile='D:\!SCN\EField\StandPeakAnalys\stpeak.dat' ;
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
   FileName1=[strrep(name1,'trek',''),'T',num2str(ProcIntTime(1)/1000,'%5.0fms-'),num2str((ProcIntTime(end))/1000,'%5.0fms')];
end;
for CurPass=1:Pass1
    fprintf('Current Pass is %2.0f\n',CurPass);
    tic;
    if CurPass==1
        PeakSet=Tops_my(trek1(ProcInt),Plot1);
        if exist(StPeakFile)==2
            PeakSet.StandardPulseNorm=load(StPeakFile);
            
            fprintf('\n \n %s loaded \n \n',StPeakFile);
        else
            %PeakSet1.StandardPulseNorm=PeakSet.StandardPulseNorm;
        end;
        Threshold=PeakSet.Threshold;
        StandardPulseNorm=PeakSet.StandardPulseNorm;
    else    
        %fprintf('Paused press any key\n');
        %pause;
        PeakSet=Tops_my(trek1,Plot1);
        PeakSet.StandardPulseNorm=StandardPulseNorm;
        %PeakSet.Threshold=Threshold;
    end;

    fprintf('Peak Markers search =                        %7.4f  sec\n', toc); tic;
    if StPeakWrite
        if exist('StandPulse')==7
            PulseFolder=[cd,'\StandPulse\'];   
        else
            mkdir(cd,'StandPulse');
            PulseFolder=[cd,'\StandPulse\'];
        end;
        if isstr(FileName1)
            [path1,name1,ext1,versn1]=fileparts(FileName1);
            StPeakFile=[PulseFolder,'StP',FileName1,'Pass',num2str(CurPass),'.dat'];
        else
            StPeakFile=[PulseFolder,'StP',FileName1,'Pass',num2str(CurPass),'.dat'];
        end;
        fid=fopen(StPeakFile,'w');
        fprintf(fid,'%5.3f\n',StandardPulseNorm);       
        fclose(fid);
    end;

    if CurPass==1
        [peaks1,trekMinus1]=GetPeaks_my(trek1(ProcInt),PeakSet,CurPass,FileName1);
    else
    
        [peaks2,trekMinus1]=GetPeaks_my(trek1,PeakSet,CurPass,FileName1);
        peaks1=[peaks1; peaks2];
    end;
    trek1=trekMinus1;
%    peaks1=[peaks1,peaks]
    fprintf('Trek  scan          =                        %7.4f  sec\n', toc);
    clear SelectedPeakInd PeakOnFrontInd StandardPulseNorm StdNoise trekMinus1;
end;


%exit='n';
%while exit~='y'
    HistA=HistNew(peaks1,FileName1,ProcIntTime);
%    exit=input('Exit? y/[n]\n','s');
%    exit=lower(exit);    
%    if isempty(exit) exit='n'; end;
%end;
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
