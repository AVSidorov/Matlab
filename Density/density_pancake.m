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

%we should reduce Radii to avoid "touching" of circles
    dr=min([10*eps,min(diff(x))/n]);
    i=0;
while numel(x)>1 % "while" instead "for" because two points can be reduced
    i=i+1;
    R(i)=(x(end)-x(1))/2-dr*i;
    C(i)=(x(end)+x(1))/2;
    %make pancake chord lengths
    L=2*sqrt(R(i)^2-(x(2:end-1)-C(i)).^2); % 2:end-1 to avoid negative value under root and L on circle borders (or out side) is zero
    %determine dPhdL on current pancake
    [dPhdL(i),ind]=min([fx(2)/L(1) fx(end-1)/L(end)]);
    %make new x and fx subtract pancake and reduce ends.
    % new fx subtract pancake
    fx(2:end-1)=fx(2:end-1)-L.*dPhdL(i);
    % on each step we reduce either one point or two 
    if fx(2)/L(1)==fx(end-1)/L(end)
        x([1,end])=[];    %reduce two points
        fx([1,end])=[];
    elseif ind==1
        x(1)=[];
        fx(1)=[];
    else
        x(end)=[];
        fx(end)=[];
    end
end
C(i+1)=x;
R(i+1)=max([0 R(i)+max(diff(R(1:i))) R(i)/2]); %dR is negative take min by abs
if i+1<n
    R(i+2:end)=[];
    C(i+2:end)=[];
    dPhdL(i+2:end)=[];
end
    
denPh=cumsum(dPhdL);
denPh(denPh<0)=0;
Den=density_phase2den(denPh,freq);
end