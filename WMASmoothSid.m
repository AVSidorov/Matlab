function B=WMASmoothSid(A,n)
%weighted moving average smooth sid
if nargin<2
    n=3;
end;
n=n+(1-mod(n,2)); %make n odd
if size(A,1)<size(A,2)
    A=A';
end;
N=size(A,1);
B=zeros(N,1);
for i=1:N
    ind=[1:n]+(i-1)-fix(n/2);
    ind(ind<1|ind>N)=[];
    B(i)=sum(A(ind,1).*A(ind,2))/sum(A(ind,2));
end;