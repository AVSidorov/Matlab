function Schtanga;
g=9.81;
t=[0.15:0.01:0.33];
xo=1;
dx=1;
Vso=1.93;
m=77;
M=125;
Xamin=0.3;

for i=1:numel(t)
Vao=[Vso-dx/t(i):0.001:Vso];
F=2*m*M*(dx-(Vso-Vao)*t(i))/(t(i)^2*(m+M));
Vo=(m*Vao(:)+M*Vso)/(m+M);
Xa=xo+Vao*t(i)+(-g-F/m)*t(i)^2/2;
Xs=xo+Vso*t(i)+(-g+F/M)*t(i)^2/2;
X=(m*Xa+M*Xs)/(M+m);
Va=Vao+(-g-F/m)*t(i);
Vs=Vso+(-g+F/m)*t(i);
V=Vo-g*t(i);

bool=Xa<0;
F(bool)=[];
Xa(bool)=[];
Xs(bool)=[];
X(bool)=[];
Vao(bool)=[];
Va(bool)=[];
Vs(bool)=[];
V(bool)=[];
Ind=find(Xa>Xamin,1,'first');
Vaomin(i)=Vao(Ind);
Fmin(i)=F(Ind);
Vkomp(i)=V(Ind);
end;

subplot(3,1,1)
grid on; hold on;
plot(Fmin/10,t);
subplot(3,1,2)
grid on; hold on;
plot(t,Vaomin);
subplot(3,1,3)
grid on; hold on;
plot(t,Vkomp);



% 
% % figure;
% subplot(3,1,1)
% grid on; hold on;
% title('Средняя сила прикладываемая к штанге в безопорном уходе');
% plot(Vao,F/10);
% xlabel('Начальная скорость атлета, м/с');
% ylabel('Сила, кгс');
% 
% subplot(3,1,2)
% title('Положение центров масс в конце фазы безопорного ухода');
% grid on; hold on;
% xlabel('Начальная скорость атлета, м/с');
% ylabel('Положение ЦМ, м');
% plot(Vao,Xa,'-r>','LineWidth',2);
% plot(Vao,Xs,'-b>','LineWidth',2);
% plot([Vao(1),Vao(end)],[xo,xo],'--b');
% plot([Vao(1),Vao(end)],[Xamin,Xamin],'--m');
% legend('ЦМ атлета','ЦМ штанги','стартовое положение ЦМ','минимально возможное положение ЦМ атлета');
% 
% subplot(3,1,3)
% title('Скорости центров масс после фазы безопорного ухода');
% grid on; hold on;
% xlabel('Начальная скорость атлета, м/с');
% ylabel('Скорость ЦМ, м/с');
% plot(Vao,Va,'-r>','LineWidth',2);
% plot(Vao,Vs,'-b>','LineWidth',2);
% plot(Vao,V,'-k>','LineWidth',2);
% plot([Vao(1),Vao(end)],[Vso,Vso],'--m');
% legend('скорость ЦМ атлета','скорость ЦМ штанги','скорость общего ЦМ','Начальная скорость штанги');

