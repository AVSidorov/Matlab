function [SurfaceChord,xb,yb]=Chord2MagnetSurfase(StudLength,RC,PlasmaCoreCenterX,PlasmaCoreCenterY)
if nargin<2
    ShafrShift=3;
else
    ShafrShift=RC;
end;
step=1;
Rdia=78;
Rmax=Rdia-sqrt(PlasmaCoreCenterX^2+PlasmaCoreCenterY^2);

if nargin<3
    PlasmaCoreCenterX=0;
end;
if nargin<4
    PlasmaCoreCenterY=0;
end;


[Vec,angle,Points]=ChordVec(StudLength);
[xb,yb]=linecirc(Vec(2)/Vec(1),Points.DetectorPoint(2)-Points.DetectorPoint(1)*Vec(2)/Vec(1),PlasmaCoreCenterX,PlasmaCoreCenterY,Rmax);
L=norm([range(xb);range(yb)]);
Vec=[xb(2)-xb(1);yb(2)-yb(1)];
Vec=Vec/norm(Vec);
x=xb(1)+[0:step:L].*Vec(1);
y=yb(1)+[0:step:L].*Vec(2);
if x(end)~=xb(2)||y(end)~=yb(2)
    x(end+1)=xb(2);
    y(end+1)=yb(2);
end;
    
[R,d]=GetMagnetSurfaceN(x,y,PlasmaCoreCenterX,PlasmaCoreCenterY,ShafrShift);
[Rmin,RminInd]=min(R);

SurfaceChord(:,1)=sqrt((x-xb(1)).^2+(y-yb(1)).^2);
SurfaceChord(:,2)=R;

lenMin=fminsearch(@(len)GetMagnetSurfaceN(xb(1)+Vec(1)*len,yb(1)+Vec(2)*len,PlasmaCoreCenterX,PlasmaCoreCenterY,ShafrShift),(RminInd-2)*step,RminInd*step);
Rmin=GetMagnetSurfaceN(xb(1)+Vec(1)*lenMin,yb(1)+Vec(2)*lenMin,PlasmaCoreCenterX,PlasmaCoreCenterY,ShafrShift);

if lenMin>(RminInd-1)*step
    ind=RminInd;
else 
    ind=RminInd-1;
end;
SurfaceChord=[SurfaceChord(1:ind,:);[lenMin,Rmin];SurfaceChord(ind+1:end,:)];
    