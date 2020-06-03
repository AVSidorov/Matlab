function [ok,delta,Rlcs,dCzero,limSide]=density_CrPcheck(coeffs)
Rdia=7.9;
R=55;

delta=coeffs(end); 

corC=zeros(size(coeffs));
corC(end)=Rdia;
corC(end-1)=-1;
RlcsHFS=roots(coeffs+corC);
RlcsHFS(real(RlcsHFS)<0)=[];
if any(abs(imag(RlcsHFS))<eps)
    RlcsHFS=min(RlcsHFS(abs(imag(RlcsHFS))<eps));
else
    RlcsHFS=inf;
end;


corC=zeros(size(coeffs));
corC(end)=-Rdia;
corC(end-1)=1;
RlcsLFS=roots(coeffs+corC);
RlcsLFS(real(RlcsLFS)<0)=[];
if any(abs(imag(RlcsLFS))<eps)
    RlcsLFS=min(RlcsLFS(abs(imag(RlcsLFS))<eps));
else
    RlcsLFS=inf;
end

[Rlcs,limSide]=min([RlcsHFS RlcsLFS]);
if Rlcs<=Rdia
    limSide=limSide*2-3;
else
    Rlcs=NaN;
    limSide=NaN;
end

coeffsD=polyder(coeffs);
dRoots=roots(coeffsD);
[~,index]=sortrows(real(dRoots));
dRoots=dRoots(index);
if real(dRoots(1))<0
    dCzero=dRoots(1);
else
    dCzero=dRoots(2);
end
ok=false;
if isfinite(Rlcs)
    ok=abs(polyval(coeffsD,Rlcs))<=Rlcs/R;
end;
