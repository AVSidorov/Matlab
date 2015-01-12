function [khi,FIT]=FitAN(Y,F,FIT)
n=size(F,2);
N=numel(Y);
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
end;
khi=sum((Y-sum(Ffit,2)).^2)/N;
FIT.A=A;
FIT.khi=khi;
FIT.Y=Y;
FIT.Ffit=Ffit;
FIT.Yfit=sum(Ffit,2);
FIT.N=N;
