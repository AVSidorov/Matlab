function TrekSet=TrekGetTrekMinus(TrekSetIn);
tic;
MaxBlock=3e6;

TrekSet=TrekSetIn;

if isfield(TrekSet,'trek');
    if not(isempty(TrekSet.trek));
        FileName=TrekSet;
    else
        FileName=[TrekSet.name,'.dat']
    end;
else    
    FileName=[TrekSet.name,'.dat']
end;
TrekSet=TrekRecognize(FileName,TrekSet);

if TrekSet.type==0 return; end;

PeakN=size(TrekSet.peaks,1);
peaks=TrekSet.peaks;
tau=TrekSet.tau;
TrekSet.StartTime=(round(peaks(1,2)/tau)-size(TrekSet.StandardPulse,1))*tau;
TrekSet.size=round((peaks(end,2)+size(TrekSet.StandardPulse,1)*tau-TrekSet.StartTime)/tau);

TrekSet=TrekLoad(FileName,TrekSet);
if not(TrekSet.Merged)
    TrekSet.trek=TrekSet.PeakPolarity*(TrekSet.trek-TrekSet.MeanVal);
end;
trek=TrekSet.trek;


trekMinus=trek;
trekN=size(trek,1);

PulseN=size(TrekSet.StandardPulse,1);
MaxInd=find(TrekSet.StandardPulse==1); %Standard Pusle must be normalized by Amp

for i=1:PeakN
    PulseInd=round((peaks(i,2)-TrekSet.StartTime)/tau);
    Shift=-1*((peaks(i,2)-TrekSet.StartTime)/tau-PulseInd);%look in TrekGetPeaksSid peaks(NPeaksSubtr,2)=TrekSet.StartTime+TrekSet.SelectedPeakInd(i)*tau-Shift*tau
    
    %same as in TrekGetPeaksSid
    FitInd=[1:PulseN]+PulseInd-MaxInd;      
    FitInd=FitInd(FitInd<=TrekSet.size&FitInd>=1);%reduce points out of bounds trek
    FitIndPulse=FitInd-PulseInd+MaxInd; %make Indexes same size
    PulseFine=interp1([1:PulseN],TrekSet.StandardPulse,[1:PulseN]+Shift,'spline',0)';
    
    PulseSubtract=peaks(i,5)*PulseFine+peaks(i,4);
    trekMinus(FitInd)=trekMinus(FitInd)-PulseSubtract(FitIndPulse);
end;
TrekSet.trek=trekMinus;
plot(trek);
grid on; hold on;
plot(trekMinus,'r');
toc;