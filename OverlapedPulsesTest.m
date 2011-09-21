function OverlapedPulsesTest;

TrekSet.FileType='single';      %choose file type for precision in fread function 
TrekSet.tau=0.02;               %ADC period
TrekSet.StartOffset=0;       %in us old system was Tokamak delay + 1.6ms
TrekSet.OverSt=3;               %uses in StdVal
TrekSet.StandardPulseFile='D:\!SCN\EField\StandPeakAnalys\StPeakAmp4_20ns_1.dat';
% TrekSet.StandardPulseFile='D:\!SCN\EField\StandPeakAnalys\StPeak20ns_1.dat';
%TrekSet.StandardPulseFile='D:\!SCN\EField\StandPeakAnalys\StPeak.dat';
TrekSet.MaxSignal=4095;
TrekSet.MinSignal=0;
TrekSet.peaks=[];
TrekSet.StdVal=0;
TrekSet.Threshold=[];
TrekSet.StartTime=TrekSet.StartOffset;
% TrekSet.StartTime=3e4;
TrekSet.Plot=false;
TrekSet.type=[];              
TrekSet.FileName='test';
TrekSet.size=[];
TrekSet.name=[];
TrekSet.StandardPulse=[];
TrekSet.MeanVal=[];
TrekSet.PeakPolarity=1;
TrekSet.charge=[];
TrekSet.Date=[];
TrekSet.Shot=[];
TrekSet.Amp=[];
TrekSet.HV=[];
TrekSet.P=[];
TrekSet.Merged=true; %This field is neccessary to avoid repeat merging and Max/MinSignal level changing 

%Loading Standard Pulse
TrekSet=TrekStPLoad(TrekSet);

%Emuleating Amp4 Thr~50 StdVal~10
TrekSet.trek=-17+2*17*rand(numel(TrekSet.StandardPulse),1);

MaxInd=find(TrekSet.StandardPulse==1); %Standard Pulse must be normalized by Amp
BckgFitInd=find(TrekSet.StandardPulse==0);%Standard Pulse must have several zero point at front end and las zero point
BckgFitInd(end)=[];
BckgFitN=size(BckgFitInd,1); 
FrontN=MaxInd-BckgFitN;
TailInd=find(TrekSet.StandardPulse<=0);
TailInd(TailInd<MaxInd)=[];
TailInd=TailInd(1);
