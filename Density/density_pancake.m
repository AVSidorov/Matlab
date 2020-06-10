function [R,C,dPhdL,denPh,Den]=density_pancake(x,fx,freq)
if nargin<3
    freq=[];
end;
x=reshape(x,[],1);
[x,index]=sortrows(x);
fx=fx(index);
fx=reshape(fx,[],1);

%phase must have zeros at ends
n=numel(x);
R=zeros(n,1);
C=zeros(n,1);
dPhdL=zeros(n,1);
for i=1:n-1
    R(i)=(x(end)-x(1))/2;
    C(i)=(x(end)+x(1))/2;
    %make pancake chord lengths
    L=2*sqrt(R(i)^2-(x-C(i)).^2);
    %determine dPhdL
    [dPhdL(i),ind]=min([fx(2)/L(2) fx(end-1)/L(end-1)]);
    %make new x and fx subtract pancake and reduce ends.
    % new fx
    fx=fx-L.*dPhdL(i);
    % on each step we reduce one point 
    if ind==1
        x(1)=[];
        fx(1)=[];
    else
        x(end)=[];
        fx(end)=[];
    end
end
denPh=cumsum(dPhdL);
Den=density_phase2den(denPh,freq);
end