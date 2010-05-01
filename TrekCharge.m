function TrekSet=TrekCharge(TrekSetIn);
tic;
TrekSet=TrekSetIn;

Tdr=895; %Full ions drift time us
NPeak=size(TrekSet.peaks,1);
TrekSet.charge=zeros(NPeak,1);
 if NPeak>0
     StartTime=TrekSet.peaks(:,2)-Tdr;
     StartTime(StartTime<0)=0;
     % StartInd=ones(NPeak,1);
     for i=1:NPeak
         StartInd=find(TrekSet.peaks(:,2)>StartTime(i),1,'first');
         t=TrekSet.peaks(StartInd:i,2)-TrekSet.peaks(i,2);     
         TrekSet.charge(i)=sum(TrekSet.peaks(StartInd:i,5).*exp(t/(Tdr/5)));
     end;
 end;
toc;
