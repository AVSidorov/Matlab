function [out,K]=TrapeizodalShaper(in,k,m,M,K)
if nargin<5
 K=1;
end;
b=zeros(k+m+1,1);
a=1;
b([1,k+m+1])=1;
b(k+1)=b(k+1)-1;
b(m+1)=b(m+1)-1;
d=filter(b,a,in);
b=1;
a=[1;-1];
p=filter(b,a,d);
r=p+M*d;
s=filter(b,a,r);
out=s*K;
K=max(s);
