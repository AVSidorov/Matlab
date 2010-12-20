function peaks1=peaks_collect4(TrekSet,AmpHV,AmpPVQ);
Ampdef=94.3333;
Ns=TrekSet.name(1:2);
N=str2num(Ns);
IndHV=find(AmpHV(:,1)==N);
disp(Ns);
if isempty(IndHV)    
   Amp=input('Input Amplification 1, 1.123, 3.3333, 10.333, 32.85, 94.3333 \n');
   if isempty(Amp)
       Amp=Ampdef;
   end;
else
    Amp=AmpHV(IndHV(1),10);
end;
   fprintf('Amp=%7.4f\n',Amp);   

IndPVQ=find(AmpPVQ(:,2)==N);
if isempty(IndPVQ)   
   
   Date=input('Input Date yymmdd \n');
   if isempty(Date)
       Date=100405;
   end;
   fprintf('P=%6.0f\n',Date);   
   
   P=input('Input P 0=1atm \n');
   if isempty(P)
       P=0.1;
   end;
   fprintf('P=%4.3f\n',P);   
   HV=input('Input HV xxxxV\n');
   if isempty(HV)
       HV=1700;
   end;
   fprintf('HV=%4.0f\n',HV);

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


peaks1=zeros(NPeak,6);
peaks1(:,1)=Date;
peaks1(:,2)=N;
peaks1(:,3)=P;
peaks1(:,4)=HV;
TrekSet=TrekChargeQX(TrekSet,HV,P+1);
peaks1(:,5)=TrekSet.charge/Amp/5.9;
peaks1(:,6)=peaks(:,5)/Amp/5.9;

assignin('base','peaks1',peaks1);
evalin('base','peaks=[peaks;peaks1];');