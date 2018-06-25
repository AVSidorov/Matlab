function [Vec,angle,Points]=ChordVec(StudLength)
% This function gives geometry params for chord given by length of table
% stud

TurnPoint=[796.5;0;0];
LowStudPoint=[1411.4;-938.8;0];
UpStudPointBase=[1412.4;-269;0];
DetectorPointBase=[1395;0;0];
Points.TurnPoint=TurnPoint;
Points.LowStudPoint=LowStudPoint;
Points.UpStudPointBase=UpStudPointBase;
Points.DetectorPointBase=DetectorPointBase;

% VecBase=(TurnPoint-UpStudPointBase);
% VecBase=VecBase/norm(VecBase);
VecBase=[-1;0;0];

r2base=norm(UpStudPointBase-LowStudPoint);

r1=norm(TurnPoint-UpStudPointBase);
r2=r2base+StudLength;


[UpStudPoint(1,:),UpStudPoint(2,:)]=circcirc(TurnPoint(1),TurnPoint(2),r1,LowStudPoint(1),LowStudPoint(2),r2);
if ~isnan(UpStudPoint)
    UpStudPoint=sortrows(UpStudPoint')';
    UpStudPoint=UpStudPoint(:,2);
    UpStudPoint=[UpStudPoint;0];
    Points.UpStudPoint=UpStudPoint;
    
    r1=norm(TurnPoint-DetectorPointBase);
    r2=norm(UpStudPointBase-DetectorPointBase);
    [DetectorPoint(1,:),DetectorPoint(2,:)]=circcirc(TurnPoint(1),TurnPoint(2),r1,UpStudPoint(1),UpStudPoint(2),r2);    
    DetectorPoint=[DetectorPoint;0 0];
    VecProd=cross((UpStudPoint-TurnPoint),(DetectorPoint(:,1)-TurnPoint));
    if VecProd(3)>0
        DetectorPoint=DetectorPoint(:,1);
    else
        DetectorPoint=DetectorPoint(:,2);
    end;
    
    Points.DetectorPoint=DetectorPoint;
    
    Vec=(TurnPoint-DetectorPoint);
    Vec=Vec/norm(Vec);
    angle=180*acos(dot(Vec,VecBase))/pi;
else
    Vec=NaN;
    angle=NaN;
end;
