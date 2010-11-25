function AmpPVQt=tW2AmpPVQt(tW,TrekSet,AmpHV,AmpPVQ);
Ns=TrekSet.name(1:2);
N=str2num(Ns);
IndHV=find(AmpHV(:,1)==N);
if isempty(IndHV)    
    return; 
else
    Amp=AmpHV(IndHV,10);
end;

IndPVQ=find(AmpPVQ(:,2)==N);
if isempty(IndPVQ)   
    return; 
else
    Date=AmpPVQ(IndPVQ,1);
    P=AmpPVQ(IndPVQ,4);
    HV=AmpPVQ(IndPVQ,3);
    Gmean=AmpPVQ(IndPVQ,6);
end;
NI=size(tW,1);
if tW(1,1)==0;
 St=1;
 Gmean=tW(1,5)/Amp/5.9;
else
 St=0;
end;
for i=1:NI-St
 AmpPVQt(i,1)=Date;
 AmpPVQt(i,2)=N;
 AmpPVQt(i,3)=P;
 AmpPVQt(i,4)=HV;
 AmpPVQt(i,5)=Gmean;
 AmpPVQt(i,6)=tW(i+St,2);
 AmpPVQt(i,7)=tW(i+St,5)/Amp/5.9;
 AmpPVQt(i,8)=tW(i+St,6);
end;
assignin('base','AmpPVQt1',AmpPVQt);
evalin('base','AmpPVQt=[AmpPVQt;AmpPVQt1];');