function [out,K]=CuspShaper(x,k,m,K)
if nargin<4
 K=1;
end;
b=zeros(k+1,1);
a=1;
b(1)=1;
b(k+1)=b(k+1)-1;
y=filter(b,a,x);

b=1;
a=[1;-1];
e=filter(b,a,y);

f=filter(b,a,e-circshift(x,m)*k);
out=f*K;
K=max(f);