function peaks=peaks_collect1(TrekSet,AmpHV,AmpPVQ);
a=0.005;
b=0.9;
A=2.3319e-004;
B=0.0058;
Ampdef=10.3333;
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
    Amp=AmpHV(IndHV(1),10);
end;

IndPVQ=find(AmpPVQ(:,2)==N);
if isempty(IndPVQ)   
   
   Date=input('Input Date yymmdd \n');
   if isempty(Date)
       Date=100405;
   end;
   
   P=input('Input P 0=1atm \n');
   if isempty(P)
       P=-0.22;
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
NPeak=size(TrekSet.peaks,1);
peaks=zeros(NPeak,7);
peaks(:,1)=Date;
peaks(:,2)=N;
peaks(:,3)=P;
peaks(:,4)=HV;
peaks(:,6)=TrekSet.peaks(:,5)/5.9/Amp; % mult because in Qt 'charge' is devided to Amp


TrekSet1=TrekChargeQt(TrekSet);
peaks(:,5)=TrekSet1.charge*5.9*Amp; % mult because in Qt 'charge' is devided to peaks amplitude 

assignin('base','peaks1',peaks);
evalin('base','peaks=[peaks;peaks1];');