function [R,C,dPhdL,denPh,Den]=density_pancake(x,fx,freq)
if nargin<3
    freq=[];
end;
x=reshape(x,[],1);
[x,index]=sortrows(x);
fx=fx(index);
fx=reshape(fx,[],1);

%we should reduce Radii to avoid "touching" of circles
    dr=min([10*eps,min(diff(x))/numel(x)]);
%phase must have zeros at ends
    if fx(1)~=0
        x=[x(1)-2*dr;x];
        fx=[0;fx];
    end
    if fx(end)~=0
        x=[x;x(end)+2*dr];
        fx=[fx;0];
    end
%preallocation    
n=numel(x);
R=zeros(n,1);
C=zeros(n,1);
dPhdL=zeros(n,1);
    
    i=0;
while numel(x)>1 % "while" instead "for" because two or more points can be reduced
    % on each step we leave only one zero point on each end
    stI=find(abs(fx)>eps,1,'first')-1;
    endI=find(abs(fx)>eps,1,'last')+1;
    % abs(fx)>eps due to limited accuracy  fx(2)or/and fx(end-1) may be not
    % exact zero
    x=x(stI:endI);
    fx=fx(stI:endI);   
    if isempty(x)
        break;
    end;
    %make ends exact zero
    fx(1)=0;
    fx(end)=0;    
    i=i+1;
    R(i)=(x(end)-x(1))/2-dr*i;
    C(i)=(x(end)+x(1))/2;
    if numel(x)<2
        break;
    end;    
    %make pancake chord lengths
    L=2*sqrt(R(i)^2-(x(2:end-1)-C(i)).^2); % 2:end-1 to avoid negative value under root and L on circle borders (or out side) is zero
    %determine dPhdL on current pancake
    [dPhdL(i),ind]=min([fx(2)/L(1) fx(end-1)/L(end)]);    
    %make new x and fx subtract pancake and reduce ends.
    % new fx subtract pancake
    fx(2:end-1)=fx(2:end-1)-L.*dPhdL(i);
end
if i<n
    R(i+1:end)=[];
    C(i+1:end)=[];
    dPhdL(i+1:end)=[];
end
    
denPh=cumsum(dPhdL);
denPh(denPh<0)=0;
Den=density_phase2den(denPh,freq);
end
function [l,x,y]=ChordLength(x,r,t,e)
% calculates chord length surface radius r, triangularity t and elongation e
% x distance to center
    if t~=0
        c=(1-sqrt(1+4*t*(x/r+t)))/2/t;
        x(abs(c)>1)=[];
        c(abs(c)>1)=[];
    else
        c=x/r;
    end
    
    y=r*e*sqrt(1-c.^2);
    l=2*y;    
end
