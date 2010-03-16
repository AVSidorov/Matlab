% function TrekSet=Trek(FileName);
function Trek(FileName);

tic;
fprintf('>>>>>>>>>>>>>>>>>>>>> Trek started\n');

MaxBlock=3e6;

TrekSet.FileType='single';      %choose file type for precision in fread function 
TrekSet.tau=0.020;              %ADC period
TrekSet.StartOffset=0;          %in us old system was Tokamak delay + 1.6ms
TrekSet.OverStStd=3;
TrekSet.OverStThr=-1;
TrekSet.StandardPulseFile='D:\!SCN\EField\StandPeakAnalys\StPeak20ns_2.dat';
TrekSet.MaxSignal=4000;
TrekSet.peaks=[];
TrekSet.StdVal=0;
TrekSet.StartTime=TrekSet.StartOffset;

%??? May be Place for insertion cycle if Directory Name inputed

%Checking for existing and initialization
TrekSet=TrekRecognize(FileName,TrekSet);

if TrekSet.type==0 return; end;

%Loading Standard Pulse
TrekSet=TrekStPLoad(TrekSet);

%Choosing time interval for working
%TrekSet=TrekPickTime(TrekSet);


PartN=fix(TrekSet.size/MaxBlock)+1;
for i=1:PartN 
fprintf('==== Processing  Part %u of %s\n',i,TrekSet.name);
    TrekSet1=TrekSet;

    TrekSet1.size=MaxBlock;
    TrekSet1.StartTime=TrekSet.StartTime+(i-1)*MaxBlock*TrekSet1.tau;
    
    %Loading trek data
    TrekSet1=TrekLoad(FileName,TrekSet1);

    %Standard Deviation calulations and Peak Polarity Changing
    %if i==1                
    %calculating Standard Deviation only at first Time
    TrekSet1=TrekStdVal(TrekSet1);
    %end;
    
    %Threshold Determination
    if TrekSet.OverStThr<0
        TrekSet1=TrekPickThr(TrekSet1);
    end;
    
    %Searching for Indexes of potential Peaks
    TrekSet1=TrekPeakSearch(TrekSet1);

    %!!!Searching for Standard Pulse

    %Getting Peaks
     TrekSet1=TrekGetPeaks(TrekSet1);

     TrekSet.peaks=TrekSet1.peaks;
     TrekSet.StdVal=(TrekSet.StdVal*(i-1)+TrekSet1.StdVal)/i;
     TrekSet.OverStStd=TrekSet1.OverStStd;
     TrekSet.OverStThr=TrekSet1.OverStThr;
     clear TrekSet1;
end;

 assignin('base','TrekSet',TrekSet);
 evalin('base','Treks(end+1)=TrekSet;');
fprintf('>>>>>>>>>>>>>>>>>>>> Trek finished\n');
toc;
 
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


