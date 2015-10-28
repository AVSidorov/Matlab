function [khi,FIT]=FitAN(Y,F,FIT)
n=size(F,2);
N=numel(Y);
C=ones(N,1);
S=zeros(n);
for i=1:n
    for ii=1:n
        S(i,ii)=sum(F(:,i).*F(:,ii));
    end;
end;
for i=1:n
    V(i,1)=sum(Y.*F(:,i));
end;
A=linsolve(S,V);

for i=1:n
    Ffit(:,i)=F(:,i)*A(i);
    if A(i)<0
        Ind=find(abs(Ffit(:,i))>1);
        C(Ind)=abs(Ffit(Ind,i));
    end;
end;
khi=sum(C.*(Y-sum(Ffit,2)).^2./Y)/N;
% khi=sum((Y-sum(Ffit,2)).^2./Y)/N;
FIT.A=A;
FIT.khi=khi;
FIT.Y=Y;
FIT.Ffit=Ffit;
FIT.Yfit=sum(Ffit,2);
FIT.N=N;
