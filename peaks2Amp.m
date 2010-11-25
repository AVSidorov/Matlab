function Amp=peaks2Amp(peaks);
Npoint=234;
Date=100331;
P=0.1;
HV=1700;
QCol=8;
bool=peaks(:,1)==Date&abs(peaks(:,3)-P)<=0.01&abs(peaks(:,4)-HV)<=5;
Nall=size(find(bool),1);
Nmean=max([2e3,round(Nall/Npoint)]);
Nmean=min([1e4,Nmean]);
if Nall<3*Nmean Amp=[]; return; end;
St=0;
dQ=mean(peaks(bool,QCol))/(Nall/Nmean/2);
i=1;
Ex=0;
IN=zeros(7,1);

while Ex==0
N=0;
while abs(N-Nmean)>10*sqrt(Nmean)
    En=St+dQ;
    bool=peaks(:,1)==Date&abs(peaks(:,3)-P)<=0.01&abs(peaks(:,4)-HV)<=5&peaks(:,QCol)>=St&peaks(:,QCol)<En;
    N=size(find(bool),1);
    if  Nmean/N<1.3
        dQ=dQ*Nmean/N;
    else
        if N<Nmean 
            dQ=1.1*dQ;
        else
            dQ=0.9*dQ;
        end;
    end;
end;
Hist=sid_hist(peaks(bool,9),1,0.05,0.05);
[Ps,IN]=Poisson(Hist,IN);

Amp(i,1)=Date;
Amp(i,2)=P;
Amp(i,3)=HV;
Amp(i,4)=mean(peaks(bool,QCol));
Amp(i,5)=Ps.Wmain;
Amp(i,6)=Ps.SigmaMainP;

figure(gcf);

ch=input(['Step ',num2str(i),'. For exit not empty input.\n'],'s');
if not(isempty(ch)) close(gcf); return; end;

close(gcf);
IN(1)=Ps.W1;
IN(5)=Ps.W41;
St=En;
i=i+1;

if size(find(peaks(:,1)==Date&abs(peaks(:,3)-P)<=0.01&abs(peaks(:,4)-HV)<=5&peaks(:,QCol)>=St),1)-Nmean<-10*sqrt(Nmean) Ex=1; end;
    
end;