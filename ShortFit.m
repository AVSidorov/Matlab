function FitSet=ShortFit(Base,Fit);
 tic;
Nfit=5;
N=max(size(Fit));

for i=-1:1/Nfit:1
    n=round((i+1)*Nfit)+1;
    Fitted=interp1([1:N],Fit,[1:N]+i,'spline',0);
    p=polyfit(Fitted(2:end-1),Base(2:end-1),1);
    Khi(n)=sum((Base(2:end-1)-(p(1)*Fitted(2:end-1)+p(2))).^2)/(N-2);
end;

FineInd=[-1:1/Nfit:1];

% figure;
% plot([-1:1/Nfit:1],Khi,'.r-');
% grid on; hold on;

[KhiMin,KhiMinInd]=min(Khi);

StInd=max([1,KhiMinInd-2]);
EndInd=min([2*Nfit+1,KhiMinInd+2]);

KhiFit=polyfit(FineInd(StInd:EndInd),Khi(StInd:EndInd),2);
Shift=-KhiFit(2)/(2*KhiFit(1));

Fitted=interp1([1:N],Fit,[1:N]+Shift,'spline','extrap');
[A,B]=polyfit(Fitted(2:end-1),Base(2:end-1),1);
Fitted=A(1)*Fitted+A(2);

KhiMin=sum((Base(2:end-1)-Fitted(2:end-1)).^2)/(N-2);

FitSet.Fitted=Fitted;
FitSet.Shift=Shift;
FitSet.A=A(1);
FitSet.B=A(2);
FitSet.p=A;
FitSet.KhiMin=KhiMin;
FitSet.Nfit=Nfit;
 toc;
