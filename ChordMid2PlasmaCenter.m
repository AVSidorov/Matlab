function [X,Y]=ChordMid2PlasmaCenter(MidStudLength)
Rdia=78;
[Vec,angle,Points]=ChordVec(MidStudLength);
[xb,yb]=linecirc(Vec(2)/Vec(1),Points.DetectorPoint(2)-Points.DetectorPoint(1)*Vec(2)/Vec(1),0,0,Rdia);

L=norm([range(xb);range(yb)]);
Vec=[xb(2)-xb(1);yb(2)-yb(1)];
Vec=Vec/norm(Vec);
X=xb(1)+L/2.*Vec(1);
Y=yb(1)+L/2.*Vec(2);