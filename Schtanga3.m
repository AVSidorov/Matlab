function Schtanga3;
g=9.80665;
xo=1;
dx=1;
Vso=1.93;
m=77;
M=125;
Xamin=0.3;
Xmin=(m*Xamin+M*(Xamin+dx))/(M+m);
d=0.45;
Fmax=4*m*g;

F=[0:10:M*10];
Vao=[Vso-dx/0.1:0.1:Vso];
for i=1:numel(F)
    for ii=1:numel(Vao)
        Vo(i,ii)=(m*Vao(ii)+M*Vso)/(m+M);
        Euhod(i,ii)=F(i).*dx;
        Estart(i,ii)=m*g*(xo-Xamin)+M*(xo-d/2)+m*Vao(ii)^2/2+M*Vso^2/2;
        E1(i,ii)=(m+M)*g*xo+m*Vao(ii)^2/2+M*Vso^2/2;
        r=roots([F(i)*(M+m)/(2*m*M),Vso-Vao(ii),-dx]);
        if not(isempty(r))            
             t(i,ii)=r(end);
%              Wup(i,ii)=Eup(i,ii)/t(i,ii);
             Xa(i,ii)=xo+Vao(ii)*t(i,ii)+(-g-F(i)/m)*t(i,ii)^2/2;
             Xs(i,ii)=xo+Vso*t(i,ii)+(-g+F(i)/M)*t(i,ii)^2/2;
             X(i,ii)=(m*Xa(i,ii)+M*Xs(i,ii))/(M+m);
             Va(i,ii)=Vao(ii)+(-g-F(i)/m)*t(i,ii);
             Vs(i,ii)=Vso+(-g+F(i)/m)*t(i,ii);
             V(i,ii)=Vo(i,ii)-g*t(i,ii);      
        end;
    end;
end;
E2=m*g*Xa+M*g*Xs+m*Va.^2/2+M*Vs.^2/2;
Ecm0=(m+M)*g*xo+(m+M)*Vo.^2/2;
Ecm=(M+m)*g*X+(m+M)*V.^2/2;
Edown=(m+M).*V.^2/2;
E=Estart+Euhod+E2-(m+M)*g*Xmin+(m+M)*g*(xo+dx-Xmin);

dX=Edown./(Fmax-(m+M)*g);
EE=Estart+Euhod+E2-(m+M)*g*(X-dX)+(m+M)*g*(xo+dx-(X-dX));

bool=Xa<Xamin;
Xa(bool)=0.9*Xamin;
V(bool)=0.9*min(V(not(bool)));
Wup(bool)=0.9*min(Wup(not(bool)));
Eup(bool)=0.9*min(Eup(not(bool)));
t(bool)=0.9*min(t(not(bool)));
E(bool)=0.9*min(E(not(bool)));

Fdown=Edown./(Xa-Xamin);
Fdown(bool)=2*(M+m)*10;

bool=Fdown>=2*(M+m)*10;
Fdown(bool)=0.9*min(Fdown(not(bool)));


[x,y]=meshgrid(Vao,F);

figure;

subplot(2,2,1);
surf(x,y,t);
title('Время ухода, с');
view([0,90]);
colorbar;

subplot(2,2,2);
surf(x,y,Xa);
title('Высота ЦМ атлета, м');
view([0,90]);
colorbar;

subplot(2,2,3);
surf(x,y,V);
title('Скорость общего ЦМ, м/с');
view([0,90]);
colorbar;

subplot(2,2,4);
surf(x,y,E);
title('Энергия (уход+торможение), Дж');
view([0,90]);
colorbar;

figure;
surf(x,y,Fdown);
title('Средняя сила торможения, Н');
view([0,90]);
colorbar;
