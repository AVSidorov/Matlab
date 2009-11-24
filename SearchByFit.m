function PeakSet=SearchByFit(trek);

tic;
disp('>>>>>>>>Search by Fit started');

OverSt=3;
% SmoothPar=5;

StandardPulseFile='D:\!SCN\EField\StandPeakAnalys\StPeak20ns_2.dat';

[MeanVal,StdVal,PeakPolarity,Noise]=MeanSearch(trek,OverSt,0);
Threshold=StdVal*OverSt;

% trekS=smooth(trek,SmoothPar);

trR1=circshift(trek,1);  trR1(1)=trR1(2);
trR2=circshift(trek,2);  trR2(1)=trR2(3); trR2(2)=trR2(3);

trL1=circshift(trek,-1); trL1(end)=trL1(end-1);
trL2=circshift(trek,-2); trL2(end)=trL2(end-2); trL2(end-1)=trL2(end-2);


PeakBool=trek>=trR1&trek>=trL1&trR1>trR2&trL1>trL2; 
PeakInd=find(PeakBool);
PeakIndN=size(PeakInd,1);


clear trR1 trR2 trL1 trL2 ;



if exist(StandardPulseFile,'file');
     StandardPulse=load(StandardPulseFile);
end;

[StPMax,StPMaxInd]=max(StandardPulse);

FitN=StPMaxInd+2;
Sums1=sum(StandardPulse(1:FitN));
Sums2=sum(StandardPulse(1:FitN).^2);

bool=PeakInd<StPMaxInd|PeakInd>(size(trek,1)-2);
PeakInd(bool)=[]; 
PeakIndN=size(PeakInd,1);

for i=1:PeakIndN;
 Sums3(i)=sum(trek(PeakInd(i)-StPMaxInd+1:PeakInd(i)-StPMaxInd+FitN));
 Sums4(i)=sum(trek(PeakInd(i)-StPMaxInd+1:PeakInd(i)-StPMaxInd+FitN).*StandardPulse(1:FitN));
 Sums5(i)=sum(trek(PeakInd(i)-StPMaxInd+1:PeakInd(i)-StPMaxInd+FitN).^2);
end;
 A=(FitN*Sums4(:)-Sums3(:)*Sums1)./(FitN*Sums2-Sums1^2);
 bool=(A<Threshold);
 A(bool)=[];
 Sums3(bool)=[];
 Sums4(bool)=[];
 Sums5(bool)=[];
 PeakInd(bool)=[];
 PeakIndN=size(PeakInd,1);
 
 B=(Sums3(:)-A(:)*Sums1)/FitN;
 Khi=(Sums5(:)+(A(:).^2).*Sums2+FitN*B(:).^2+2*A(:).*B(:)*Sums1-2*A(:).*Sums4(:)-2*B(:).*Sums3(:))./(FitN*A(:).^2);

 PeakSet.SelectedPeakInd=PeakInd;
 PeakSet.Threshold=Threshold;
 
toc

figure;
plot(trek,'b-');
hold on;grid on;
plot(PeakInd,A+B,'>r');
plot(PeakInd,B,'<g');
plot(PeakInd,A,'ob');
% plot(PeakInd,Khi,'*r');
plot([1,size(trek,1)],[Threshold,Threshold],'-r','LineWidth',2);

tic
%  HistKhi=sid_hist(log10(Khi),1,'mean','mean');
%  HistA=sid_hist(log10(A),1,'mean','mean');
  HistKhi=sid_hist(log10(Khi));
  [MaxHK,MaxHKInd]=max(HistKhi(:,2));

  HistKhiInv=HistKhi;
  HistKhiInv(:,1)=-HistKhi(:,1)+2*HistKhi(MaxHKInd,1);

  Start=max([1,2*MaxHKInd-size(HistKhi,1)+1]);
  End=min([size(HistKhi,1),2*MaxHKInd-1]);
  difHK=zeros(size(HistKhi,1),1);
  for i=Start:End
      difHK(i)=HistKhi(i,2)-HistKhi(2*MaxHKInd-i,2);
  end;
%   ThresholdKhiInd=find(difHK(:)>HistKhi(:,3)*OverSt&HistKhi(:,1)>HistKhi(MaxHKInd,1),1,'first');
%   ThresholdKhi=10^HistKhi(ThresholdKhiInd,1);
  HistA=sid_hist(log10(A));
%   SelectedPeakBool=Khi>ThresholdKhi;
%   HistA1=sid_hist(log10(A(SelectedPeakBool)));
  
 figure;
 subplot(2,1,1);
 errorbar(HistKhi(:,1),HistKhi(:,2),HistKhi(:,3));
 grid on; hold on;
%  plot([log10(ThresholdKhi),log10(ThresholdKhi)],[1,MaxHK],'r-','LineWidth',2);
 plot(HistKhiInv(:,1),HistKhiInv(:,2),'.r-');
 plot(HistKhi(:,1),difHK(:),'g-','LineWidth',2);

 subplot(2,1,2);
 errorbar(HistA(:,1),HistA(:,2),HistA(:,3));
 grid on; hold on;
 plot([log10(Threshold),log10(Threshold)],[1,max(HistA(:,2))],'r-','LineWidth',2);
%  errorbar(HistA1(:,1),HistA1(:,2),HistA1(:,3),'r-');
