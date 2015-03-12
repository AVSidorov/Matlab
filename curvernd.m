function r=curvernd(pdf,m,n)
%makes random values with arbitary pdf form
if min(size(pdf))==1    
    x(:,1)=0:numel(pdf)-1;
    y(:,1)=pdf;    
else
    x=pdf(:,1);
    y=pdf(:,2);
end;
y(isnan(y))=0;

Int=trapz(x,y);
y=y/Int;

ycdf=cumtrapz(x,y);
i=find(diff(ycdf)>0);
x=x(i);
y=y(i);
ycdf=ycdf(i);
if nargin<2
    m=1;
end;
if nargin<3
    n=1;
end;
r=interp1(ycdf,x,rand(m,n),'linear',0);

