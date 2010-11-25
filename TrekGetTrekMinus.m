function TrekSet=TrekGetTrekMinus(TrekSetIn);
tic;
MaxBlock=3e6;

TrekSet=TrekSetIn;

FileName=[TrekSet.name,'.dat']

TrekSet=TrekRecognize(FileName,TrekSet);

if TrekSet.type==0 return; end;

PeakN=size(TrekSet.peaks,1);
peaks=TrekSet.peaks;
tau=TrekSet.tau;
TrekSet.StartTime=(round(peaks(1,2)/tau)-size(TrekSet.StandardPulse,1))*tau;
TrekSet.size=round((peaks(end,2)+size(TrekSet.StandardPulse,1)*tau-TrekSet.StartTime)/tau);

TrekSet=TrekLoad(FileName,TrekSet);
TrekSet.trek=TrekSet.PeakPolarity*(TrekSet.trek-TrekSet.MeanVal);

trek=TrekSet.trek;

%  same parameters as in GetPeaks
BckgFitN=2;       %number of points for background fitting
InterpN=8;        %number of extra intervals for interpolation of Standard Pulse in fitting
FineInterpN=40;   %number of extra intervals for fine interpolation of Standard Pulse in fitting

[PulseInterpFine,PulseInterp]=...
    InterpStanrdadPulse(BckgFitN,InterpN,FineInterpN,0,TrekSet.StandardPulse);

trekMinus=trek;
trekN=size(trek,1);

for i=1:PeakN
   Idx=(peaks(i,2)-TrekSet.StartTime)/tau+PulseInterpFine(:,1);
   Idx2=find(abs(Idx-round(Idx))<0.5/FineInterpN);
   IdxTrk=round((peaks(i,2)-TrekSet.StartTime)/tau+PulseInterpFine(Idx2,1));
   bool=IdxTrk>trekN;
   IdxTrk(bool)=[];
   Idx2(bool)=[];
   trekMinus(IdxTrk)=trekMinus(IdxTrk)-(peaks(i,4)+peaks(i,5)*PulseInterpFine(Idx2,2));
end;
plot(trek);
grid on; hold on;
plot(trekMinus,'r');
toc;