function r=density_xy2r(x,y,rxy)
dist2Centr=sqrt((rxy(:,2)-x).^2+(rxy(:,3)-y).^2);
[~,maxRind]=max(rxy(:,1));
[~,minRind]=min(rxy(:,1));
if all(dist2Centr-rxy(:,1)>0)
    r=sqrt((rxy(maxRind,2)-x).^2+(rxy(maxRind,3)-y).^2);
elseif all(dist2Centr-rxy(:,1)<0)
    r=sqrt((rxy(minRind,2)-x).^2+(rxy(minRind,3)-y).^2);
else
    r=interp1(rxy(:,1)-dist2Centr,rxy(:,1),0);
    
end