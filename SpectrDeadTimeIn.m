function Spectr=SpectrDeadTimeIn(TrekSet,HistInterv,DeadTime,HistTime);

peaks=TrekSet.peaks;
if peaks(1,3)~=0
    peaks(2:end,3)=diff(peaks(:,2)); peaks(1,3)=0; 
end;

if nargin<4
    HistTime=[peaks(1,2):peaks(end,2)];
end;
bool=(peaks(:,3)<=DeadTime)&(peaks(:,2)>=HistTime(1))&(peaks(:,2)<=HistTime(end));
[Hist,HistInterval,HistStep,Spectr]=sid_hist(peaks(bool,5),1,HistInterv,HistInterv);