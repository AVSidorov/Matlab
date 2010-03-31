% function TrekSet=Trek(FileName);
function Trek(FileName);

tic;
fprintf('>>>>>>>>>>>>>>>>>>>>> Trek started\n');

MaxBlock=2.5e6;

TrekSet.FileType='single';      %choose file type for precision in fread function 
TrekSet.tau=0.020;              %ADC period
TrekSet.StartOffset=0;          %in us old system was Tokamak delay + 1.6ms
TrekSet.OverStStd=3;
TrekSet.OverStThr=-1;
TrekSet.StandardPulseFile='D:\!SCN\EField\StandPeakAnalys\StPeak20ns_2.dat';
TrekSet.MaxSignal=4000;
TrekSet.peaks=[];
TrekSet.StdVal=0;
TrekSet.Threshold=500;
TrekSet.StartTime=TrekSet.StartOffset;

%??? May be Place for insertion cycle if Directory Name inputed

%Checking for existing and initialization
TrekSet=TrekRecognize(FileName,TrekSet);

if TrekSet.type==0 return; end;

%Loading Standard Pulse
TrekSet=TrekStPLoad(TrekSet);

%Choosing time interval for working
% TrekSet=TrekPickTime(TrekSet);

dT=TrekSet.tau*size(TrekSet.StandardPulse,1);

trek=[];
LastInd=0;

PartN=fix(TrekSet.size/MaxBlock)+1;
for i=1:PartN 
fprintf('==== Processing  Part %u of %u file %s\n',i,PartN,TrekSet.name);
    TrekSet1=TrekSet;

    TrekSet1.size=min([TrekSet.size-(i-1)*MaxBlock;MaxBlock]);
    TrekSet1.StartTime=TrekSet.StartTime+(i-1)*MaxBlock*TrekSet1.tau;
    
    %Loading trek data
    TrekSet1=TrekLoad(FileName,TrekSet1);

    %Standard Deviation calulations and/or Peak Polarity Changing    
    %calculating Standard Deviation only at first Time   
    if isfield(TrekSet1,'MeanVal')
        if TrekSet1.MeanVal~=0
            TrekSet1.trek=TrekSet1.PeakPolarity*(TrekSet1.trek-TrekSet1.MeanVal);
        else
            TrekSet1=TrekStdVal(TrekSet1);
            TrekSet.MeanVal=TrekSet1.MeanVal;
            TrekSet.PeakPolarity=TrekSet1.PeakPolarity;           
        end;
    else
        TrekSet1=TrekStdVal(TrekSet1);
        TrekSet.MeanVal=TrekSet1.MeanVal;
        TrekSet.PeakPolarity=TrekSet1.PeakPolarity;           
    end;
    
    %Threshold Determination
     if TrekSet.OverStThr<0
        TrekSet1=TrekPickThr(TrekSet1);
     else
        TrekSet1.Threshold=TrekSet1.Threshold*2;   
     end;
%     TrekSet1.Threshold=500;
   
%     TrekSet1.StartTime=15000;
%     TrekSet1.size=2.85e6;
%     TrekSet1=TrekLoad(FileName,TrekSet1);
%     TrekSet1=TrekStdVal(TrekSet1);
%     
%     %Searching for Indexes of potential Peaks
      TrekSet1=TrekPeakSearch(TrekSet1);
% 
%     %!!!Searching for Standard Pulse
% 
%     %Getting Peaks
      TrekSet1=TrekGetPeaks(TrekSet1);

    %making trek whithout noise spaces
    if not(isempty(TrekSet1.peaks))>0
        bool=(TrekSet1.peaks(:,2)>(TrekSet1.StartTime+dT))&...
             (TrekSet1.peaks(:,2)<(TrekSet1.StartTime+TrekSet1.size*TrekSet1.tau-2*dT));
        StartTime=TrekSet1.peaks(bool,2)-dT;
        EndTime=TrekSet1.peaks(bool,2)+2*dT;
        if not(isempty(StartTime))
            NCross=1;

            while NCross>0
                StartTimeSh=circshift(StartTime,-1);
                StartTimeSh(end)=[];
                delta=EndTime(1:end-1)-StartTimeSh;
                Ind=find(delta>=0);
                NCross=size(Ind,1);
                EndTime(Ind)=[];
                StartTime(Ind+1)=[];
            end;

            StartInd=fix((StartTime-TrekSet1.StartTime)/TrekSet1.tau);
            EndInd=fix((EndTime-TrekSet1.StartTime)/TrekSet1.tau);
            Intervs=EndInd-StartInd;
            Intervs=Intervs+5;
            NInterv=size(StartInd,1);
            NPoints=sum(Intervs);
            trek=[trek;zeros(NPoints,1)];
            for ii=1:NInterv
                trek(LastInd+2)=StartTime(ii)/1e6;
                trek(LastInd+3:LastInd+Intervs(ii)-2)=TrekSet1.trek(StartInd(ii):EndInd(ii));
                trek(LastInd+Intervs(ii)-1)=EndTime(ii)/1e6;
                LastInd=LastInd+Intervs(ii);
            end;
        end;
    end;

      TrekSet.peaks=TrekSet1.peaks;
      TrekSet.StdVal=(TrekSet.StdVal*(i-1)+TrekSet1.StdVal)/i;
      TrekSet.Threshold=(TrekSet.Threshold*(i-1)+TrekSet1.Threshold)/i;
      TrekSet.OverStStd=TrekSet1.OverStStd;
      TrekSet.OverStThr=TrekSet1.OverStThr;
    clear StartTime EndTime StartInd EndInd bool StartTimeSh delta Ind TrekSet1 ii NCross;
end;

FileName=['shr',FileName];
fid=fopen(FileName,'w');
fwrite(fid,trek,'single');
fclose(fid);

 assignin('base','TrekSet',TrekSet);
 evalin('base','Treks(end+1)=TrekSet;');
fprintf('>>>>>>>>>>>>>>>>>>>> Trek finished\n');
toc;
fprintf('\n \n');
 
% N='17';
% points=8000000;
% tau=0.02;
% combStr=['p',N,'=['];
% tic
% fid = fopen([N,'sxr.dat']); trek = fread(fid,inf,'single'); fclose(fid); clear fid; trek(end-8:end)=[];
% toc
% partN=fix(size(trek,1)/points);
% for i=1:partN-1
%     eval(['ProcessingTrekClb(trek(',num2str((i-1)*points+1),':',num2str(i*points),'));']);
%     combStr=[combStr,'p',N,'T',num2str(round((i-1)*points*tau/1000)),'d',num2str(round(i*points*tau/1000)),'ms;'];
% end;
%     eval(['ProcessingTrekClb(trek(',num2str((partN-1)*points+1),':end));']);
%     combStr=[combStr,'p',N,'T',num2str(round((partN-1)*points*tau/1000)),'d',num2str(round(size(trek,1)*tau/1000)),'ms];'];
% clear trek partN i tau;
% evalin('base',combStr);
% clear combStr;
% evalin('base',['[spec',N,',spec',N,'Int]=sid_hist(p',N,',5);']);
% evalin('base',['[spec',N,',spec',N,'Int]=sid_hist(p',N,',5,spec',N,'Int/50,spec',N,'Int/5);']);
% evalin('base',['Poisson(spec',N,');']);


