function peaks=TrekPeaks2keV(TrekSet,C);

if nargin==1
    C=-0.19/2;
end;

St=25000; % start time in us
Ed=26000; % end time in us

peaks=TrekSet.peaks;
Vo=TrekSet.HV;
P=TrekSet.P;

V=Vo+C.*TrekSet.charge;
G=GasAmp1(V,P);
peaks(:,5)=(peaks(:,5)./G)/TrekSet.Amp;

bool=peaks(:,2)>=St&peaks(:,2)<=Ed;
peaks=peaks(bool,:);


















