% function TrekSet=Trek(FileName);
function TrekStandardPulseSearch(FileName);
% Fields of struct TrekSet is take from old data. Updated 03.03.11
% FileType
% tau
% StartOffset
% OverStStd          - used in old version now only one field OverSt
% OverStThr
% StandardPulseFile
% MaxSignal
% peaks
% StdVal
% Threshold
% StartTime
% type              - output of exist function 2-means file;
% FileName
% size
% name
% StandardPulse
% MeanVal
% PeakPolarity
% charge
% Date
% Shot
% Amp
% HV
% P

tic;
fprintf('>>>>>>>>>>>>>>>>>>>>> Trek started\n');

MaxBlock=4.2e6;

%TrekSet.FileType='int16';      %choose file type for precision in fread function 
TrekSet.FileType='single';      %choose file type for precision in fread function 
TrekSet.tau=0.02;               %ADC period
TrekSet.StartOffset=13000;       %in us old system was Tokamak delay + 1.6ms
TrekSet.OverSt=3;               %uses in StdVal
TrekSet.StandardPulseFile='D:\!SCN\EField\StandPeakAnalys\StPeak20ns_2.dat';
%TrekSet.StandardPulseFile='D:\!SCN\EField\StandPeakAnalys\StPeak.dat';
TrekSet.MaxSignal=4000;
TrekSet.peaks=[];
TrekSet.StdVal=0;
TrekSet.Threshold=50;
TrekSet.StartTime=TrekSet.StartOffset;
% TrekSet.StartTime=3e4;
TrekSet.Plot=false;
TrekSet.type=[];              
TrekSet.FileName=[];
TrekSet.size=[];
TrekSet.name=[];
TrekSet.StandardPulse=[];
TrekSet.MeanVal=[];
TrekSet.PeakPolarity=-1;
TrekSet.charge=[];
TrekSet.Date=100611;
TrekSet.Shot=[];
TrekSet.Amp=6;
TrekSet.HV=1700;
TrekSet.P=1;

Pass=2;

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
    

    
    %Threshold Determination
     if TrekSet.Threshold<0
         TrekSet1=TrekPickThr(TrekSet1);
         TrekSet.Threshold=TrekSet1.Threshold;
     end;
 

    TrekSet1=TrekStdVal(TrekSet1);
    TrekSet.MeanVal=TrekSet1.MeanVal;
     
    
%     %Searching for Indexes of potential Peaks

    
     TrekSet1=TrekPeakSearch(TrekSet1);
     TrekAlonePeakSearch(TrekSet1);
end;



