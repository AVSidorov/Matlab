function TrekSet=TrekChargeQX(TrekSetIn);
%P in Atm
Xo=0.5; %minimal distance in cm where iflunce of previous peak is neglible
a=0.0025; %radius
tic;
TrekSet=TrekSetIn;


NPeak=size(TrekSet.peaks,1);
TrekSet.charge=zeros(NPeak,1);
% peaks=TrekSet.peaks;

Rt=DriftTime(TrekSet.HV,TrekSet.P,1e4);
To=interp1(Rt(:,2),Rt(:,1),Xo)/1e-6;

if NPeak>0
     StartTime=TrekSet.peaks(:,2)-To;
     StartTime(StartTime<0)=0;
     % StartInd=ones(NPeak,1);
     TrekSet.charge(1)=0;
     for i=2:NPeak
         StartInd=find(TrekSet.peaks(:,2)>StartTime(i),1,'first');
         t=TrekSet.peaks(i,2)-TrekSet.peaks(StartInd:i-1,2);
         x=interp1(Rt(:,1),Rt(:,2),t*1e-6);
         TrekSet.charge(i)=sum(TrekSet.peaks(StartInd:i-1,5).*(Xo-x)/(Xo-a));
%        TrekSet.charge(i)=sum(TrekSet.peaks(StartInd:i,5));
     end;
 end;
 TrekSet.charge=TrekSet.charge/TrekSet.Amp;
toc;
