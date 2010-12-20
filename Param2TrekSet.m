function TrekSet=Param2TrekSet(TrekSetIn,AllPrms);
TrekSet=TrekSetIn;
Date=100611;
Ns=TrekSet.name(1:2);
N=str2num(Ns);
Ind=find(AllPrms(:,2)==N);
disp(Ns);
if isempty(Ind) 
    return;
else
   Amp=AllPrms(Ind,6);
   P=AllPrms(Ind,4)+AllPrms(Ind,5)+1;
   HV=AllPrms(Ind,3);
end;

peaks=TrekSet.peaks;

if peaks(1,3)~=0
    peaks(2:end,3)=diff(peaks(:,2)); peaks(1,3)=0; 
end;

TrekSet.peaks=peaks;
TrekSet.Date=Date;
TrekSet.Shot=N;
TrekSet.Amp=Amp;
TrekSet.HV=HV;
TrekSet.P=P;
% TrekSet=TrekChargeQX(TrekSet,HV,P);

