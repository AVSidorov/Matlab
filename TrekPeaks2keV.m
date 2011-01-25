function peaks=TrekPeaks2keV(TrekSet);
A=0.00023088005376;
B=0.005852816303349;
a=0.005; %So A&B is fitted for this value of a, but correct is 0.0025
b=0.9;
% C=0.21;
C=0.3;
peaks=TrekSet.peaks;
Vo=TrekSet.HV;
P=TrekSet.P;
V=Vo-C.*TrekSet.charge;
E=V/log(b/a)/a;
K=E*a;
X=E./(P*760);
G=exp(K.*(A*X+B));
A=G/5e2;
peaks(:,5)=(peaks(:,5)./A)/TrekSet.Amp;

















