function [khi,FIT]=FitABNg(Y,F,V,FIT)
n=size(F,2)+1;
X=F;
X(:,end+1)=1;
N=numel(Y);
if nargin<3||isempty(V)
    V=eye(N);
else
    V=V(1:N,1:N);
end;
Vi=inv(V);
A=inv(X'*Vi*X)*X'*Vi*Y;

for i=1:n
    Ffit(:,i)=X(:,i)*A(i);
end;
khi=sum((Y-sum(Ffit,2)).^2)/N;
FIT.Khi=khi;
FIT.A=A;
FIT.Y=Y;
FIT.Ffit=Ffit;
FIT.Yfit=sum(Ffit,2);
FIT.N=N;
