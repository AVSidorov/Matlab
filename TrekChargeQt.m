function TrekSet=TrekChargeQt(TrekSetIn);
tic;
TrekSet=TrekSetIn;


NPeak=size(TrekSet.peaks,1);
TrekSet.charge=zeros(NPeak,1);
peaks=TrekSet.peaks;

if peaks(1,3)~=0
    peaks(2:end,3)=diff(peaks(:,2)); peaks(1,3)=0; 
end;
peaksSh=circshift(peaks(:,5),1);
TrekSet.charge=peaks(:,3)./peaksSh;
toc;
