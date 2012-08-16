function [gDD,gD,g]=SmoothDiff2(X,fDD,fD,f)
%This function smooths the second derivative by 3th degree polynom. This
%polynom and its integrals are equal  in interval ends to origin values.

Plot=true;
if nargin<3 
    disp('Not enough params');
    return; 
end;
if numel(X)<5
    disp('Not enough x-points');
    return; 
end;
if numel(fDD)+1~=numel(fD)
    disp('first and second diff did not fit to each other');
    return; 
end;

    
if size(fDD,2)>1
    fDD=fDD';
    fD=fD';
end;

if nargin==4
    fD=diff(f);
    fDD=diff(f,2);    
    g=f;
else
   f=zeros(numel(fD)+1,1);
   for i=2:numel(f)
       f(i)=f(i-1)+fD(i-1);
   end;
   
end;

g=f;
gD=fD;
gDD=fDD;

n=numel(X);

ka=0;
kb=0;
kc=0;
kd=0;

for i=1:n
    ka=ka+X(i)^3*(n-i+1);
    kb=kb+X(i)^2*(n-i+1);
    kc=kc+X(i)*(n-i+1);
    kd=kd+(n-i+1);
end;
    

B=[sum(fD(X(2):X(end)+1))-n*fD(X(1));sum(fDD(X));fDD(X(1));fDD(X(end))];
A=[[ka,kb,kc,kd];
   [sum(X.^3),sum(X.^2),sum(X),n];
   [X(1)^3,X(1)^2,X(1),1];
   [X(end)^3,X(end)^2,X(end),1]];

x=linsolve(A,B);
gDD(X)=x(1)*X.^3+x(2)*X.^2+x(3)*X+x(4);

for i=2:numel(gD)
   gD(i)=gD(i-1)+gDD(i-1);
end;

for i=2:numel(g)
   g(i)=g(i-1)+gD(i-1);
end;

if Plot

fi=figure(gcf);
X(1)=X(1)-2;
X(end)=X(end)+2;
X=[X(1):X(end)];
    subplot(3,2,1);
     plot(X,f(X));
     grid on; hold on;
     plot(X,g(X),'.r-');
    subplot(3,2,3);
     plot(X,fD(X));
     grid on; hold on;
     plot(X,gD(X),'.r-');
    subplot(3,2,5);
     plot(X,fDD(X));
     grid on; hold on;
     plot(X,gDD(X),'.r-');   

    subplot(3,2,2);
     plot(X,f(X)-g(X),'.k-');
     grid on; hold on;
    subplot(3,2,4);
     plot(X,fD(X)-gD(X),'.k-');
     grid on; hold on;
    subplot(3,2,6);
     grid on; hold on;
     plot(X,fDD(X)-gDD(X),'.k-');   
figure(fi);
end;

