function x=DriftTime(Vo,P,N);
% Vo in volts P in atm ~N number of points
if nargin==2 N=1000; end;
Plot=false;

a=0.0025; %50um in cm is diameter r is 25um
b=0.9;    %R of counter in cm


t=0;
dx=(b-a)/(N-1);
% fix dx is better then dt because near the wire field is high and has high
% gradien, so if dt is fixed first step is too large;
x(1,2)=a;

 if Plot 
     figure;
     grid on; hold on;
 end;

tic;
while x(end,2)<b
    E=Vo/log(b/a)/x(end,2);
    V=Ar_velocity(E,P);
    %V=1.7*E/P;
    dt=dx/V;
    t=t+dt;   
    x(end+1,1)=t;
    x(end,2)=x(end-1,2)+dx;
end;
x(end,:)=[];
x(end+1,1)=x(end,1)+(b-x(end,2))/V;
x(end)=b;
if Plot plot(x(:,1),x(:,2),'.b-'); end;
fprintf('Drift time is %5.2f us \n',x(end,1)/1e-6);
toc;