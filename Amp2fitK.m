function Koeffs=Amp2fitK(Amp);
A00=-0.017*1e-1;
A01=-0.513*1e-1;
A02=0.517*1e-1;
A10=0.371*1e-3;
A11=-0.0827*1e-3;
A20=-0.102*1e-5;
A30=0.167*1e-8;
A40=-0.998*1e-12;
B00=-0.626*1e-5;
F=0.1;

a=0.0025; 
b=0.9;
k=628;

Date=Amp(1,1);
Po=Amp(:,2)+1;
Vo=Amp(:,3);
Qo=Amp(:,4);
G=Amp(:,5)*k;

E=Vo/log(b/a)/a;
K=E*a;

So=(Po*760)*a;
Xo=E./(Po*760);
FITo=(A00+F*A01+F^2*A02)+(A10+F*A11)*Xo+A20*Xo.^2+A30*Xo.^3+A40*Xo.^4+B00*Xo./So;
Gfit=exp(K.*FITo);

figure;
plot(Qo,Amp(:,5),'*r-');
grid on; hold on;

p1=polyfit(Qo,log(Amp(:,5)),2);
p2=polyfit(Qo,log(Amp(:,5)),1);
p3=polyfit(Qo,Amp(:,5),1);
p4=polyfit(Qo,Amp(:,5),2);

plot(Qo,Gfit/k,'c');
plot([0;Qo],exp(polyval(p1,[0;Qo])),'b');
plot([0;Qo],exp(polyval(p2,[0;Qo])),'m');
plot([0;Qo],polyval(p3,[0;Qo]),'k');
plot([0;Qo],polyval(p4,[0;Qo]),'g');

fprintf('Blue       is %6.3f\n',exp(polyval(p1,0)));
fprintf('Magenta    is %6.3f\n',exp(polyval(p2,0)));
fprintf('Black      is %6.3f\n',polyval(p3,0));
fprintf('Green      is %6.3f\n',polyval(p4,0));

Go=input('Input Go. Default is blue \n');
if isempty(Go) Go=exp(polyval(p1,0)); end;
close(gcf);


Go=Go*k;
[C1o,C2o,C3o,C4o]=Gseries(Xo(1),So(1));
dXfit=roots([C4o,C3o,C2o,C1o,FITo(1)-log(Go)/K(1)]);
dXfit=dXfit(imag(dXfit)==0);
dXfit=dXfit(abs(dXfit)<Xo(1)/2);

Xfit=Xo+dXfit;
Pfit=E./Xfit/760;
dP=Pfit-Po;
Sfit=(Pfit*760)*a;

fprintf('dP is %7.4f\n',dP(1));

 Koeffs(1,1)=Date;
 Koeffs(1,2)=Po(1);
 Koeffs(1,3)=Vo(1);
 Koeffs(1,4)=Go/k;
 Koeffs(1,5)=Gfit(1)/k; 
 Koeffs(1,6)=dP(1);
 Koeffs(1,7:9)=p1;
 Koeffs(1,10:12)=p4;
 
 
 assignin('base','Koeffs1',Koeffs);
 evalin('base','Koeffs=[Koeffs;Koeffs1];');
 


















