function peaks1=peaks_collect2(TrekSet,AmpHV,AmpPVQ);
Ampdef=94.3333;
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
       Date=100331;
   end;
   
   P=input('Input P 0=1atm \n');
   if isempty(P)
       P=0.1;
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
if NPeak==0 return; end;
TrekSet.charge=zeros(NPeak,1);
peaks=TrekSet.peaks;

if peaks(1,3)~=0
    peaks(2:end,3)=diff(peaks(:,2)); peaks(1,3)=0; 
end;

peaksSh=circshift(peaks(:,5),1);
peaksSh(1)=0;

peaks1=zeros(NPeak,7);
peaks1(:,1)=Date;
peaks1(:,2)=N;
peaks1(:,3)=P;
peaks1(:,4)=HV;
peaks1(:,5)=peaks(:,5)/5.9/Amp; 
peaks1(:,6)=peaks(:,3);
peaks1(:,7)=peaksSh/5.9/Amp;


assignin('base','peaks1',peaks1);
evalin('base','peaks=[peaks;peaks1];');