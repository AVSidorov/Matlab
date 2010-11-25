function TrekSet=TrekChargeT(TrekSetIn,T,Tdr);
tic;
TrekSet=TrekSetIn;

if nargin==1
    T=50;
end;
if nargin==2 
    Tdr=895; %Full ions drift time us
end;

NPeak=size(TrekSet.peaks,1);
TrekSet.charge=zeros(NPeak,1);

 if NPeak>0
     StartTime=TrekSet.peaks(:,2)-Tdr;
     StartTime(StartTime<0)=0;
     % StartInd=ones(NPeak,1);
     TrekSet.charge(1)=0;
     for i=2:NPeak
         StartInd=find(TrekSet.peaks(:,2)>StartTime(i),1,'first');
         t=TrekSet.peaks(StartInd:i-1,2)-TrekSet.peaks(i,2);     
         TrekSet.charge(i)=sum(TrekSet.peaks(StartInd:i-1,5).*exp(t/T));
%        TrekSet.charge(i)=sum(TrekSet.peaks(StartInd:i,5));
     end;
 end;
toc;
