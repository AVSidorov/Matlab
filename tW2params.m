function [Go,tau,C]=tW2params(tW,TrekSet,AmpHV,AmpPVQ);
a=0.005;
b=0.9;
% A=2.3265e-004;
% B=0.006;
A=2.3319e-004;
B=0.0058;
Ampdef=32.85;
Ns=TrekSet.name(1:2);
N=str2num(Ns);
IndHV=find(AmpHV(:,1)==N);
disp(Ns);
if isempty(IndHV)    
   Amp=input('Input Amplification 1, 1.123, 10.333, 32.85, 94.3333 \n');
   if isempty(Amp)
       Amp=Ampdef;
   end;
else
    Amp=AmpHV(IndHV,10);
end;

IndPVQ=find(AmpPVQ(:,2)==N);
if isempty(IndPVQ)   
   
   Date=input('Input Date yymmdd \n');
   if isempty(Date)
       Date=100303;
   end;
   
   P=input('Input P 0=1atm \n');
   if isempty(P)
       P=0;
   end;
   
   HV=input('Input HV xxxxV\n');
   if isempty(HV)
       HV=1700;
   end;

%    Gmean=input('Input Gmean \n');
%    if isempty(Gmean)
%        Gmean=mean(G);
%    end;
else
    Date=AmpPVQ(IndPVQ,1);
    P=AmpPVQ(IndPVQ,4);
    HV=AmpPVQ(IndPVQ,3);
%     Gmean=AmpPVQ(IndPVQ,6);
end;

NI=size(tW,1);
if tW(1,1)==0;
 St=2;
%  Gmean=tW(1,5)/Amp/5.9;
else
 St=1;
end;

AmpPVGCtau(1,1)=Date;
AmpPVGCtau(1,2)=N;
AmpPVGCtau(1,3)=P;
AmpPVGCtau(1,4)=HV;




E=HV./log(b/a)/a;
P=760*(1+P);
X=E/P;
% S=P*a;
% K=X*S;
K=E*a;
Go=exp(K.*(A*X+B));
% Go=max([max(G+0.1),Go]);
G=5e2*tW(St:end,5)/Amp/5.9;
% Gmean=Gmean*5e2;
t=tW(St:end,2);

k1=A/log(b/a)/log(b/a)/a./P;
k2=B/log(b/a);
V=(-k2+sqrt(k2^2+4.*k1.*log(G)))./(2*k1);

figure;
grid on; hold on;
plot(t,G,'*r');
plot([0,max(t)],[Go,Go],'r','LineWidth',2);
% plot([0,max(t)],[Gmean,Gmean],'g','LineWidth',2);

Gman=input('Input Go\n');

Gmin=1.01*max(G);
Gmin=min([Gman,Gmin]);
Gmax=max([Go,2*Gman]);
Grange=Gmax-Gmin;
Gst=Grange/100;
for i=1:101
    Gi(i)=Gmin+(i-1)*Gst;
    p=polyfit(t,log(1-G./Gi(i)),1);
    C(i)=exp(p(2));
    tau(i)=-1/p(1);
    khi2(i)=sum((G-Gi(i)*(1-C(i)*exp(-t/tau(i)))).^2);
end;

[MinKhi2,Ind]=min(khi2);
AmpPVGCtau(1,5)=Gi(Ind)/5e2;
AmpPVGCtau(1,6)=C(Ind);
AmpPVGCtau(1,7)=tau(Ind);

subplot(2,1,1);
plot(t,G,'*r');
grid on; hold on;
plot(t,Gi(Ind)*(1-C(Ind)*exp(-t/tau(Ind))),'r');

subplot(2,1,2);
plot(Gi,khi2,'b');
grid on; hold on;
assignin('base','AmpPVGCtau1',AmpPVGCtau);
evalin('base','AmpPVGCtau=[AmpPVGCtau;AmpPVGCtau1];');