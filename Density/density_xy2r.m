function r=density_xy2r(x,y,rxy)
if any(abs(size(x)-size(y))>eps)
    error('x and y must have same size');
end;
r=zeros(size(x));
for i=1:numel(x)
    dist2Centr=sqrt((rxy(:,2)-x(i)).^2+(rxy(:,3)-y(i)).^2);
    [~,maxRind]=max(rxy(:,1));
    [~,minRind]=min(rxy(:,1));
    if all(dist2Centr-rxy(:,1)>0)
        r(i)=sqrt((rxy(maxRind,2)-x(i)).^2+(rxy(maxRind,3)-y(i)).^2);
    elseif all(dist2Centr-rxy(:,1)<0)
        r(i)=sqrt((rxy(minRind,2)-x(i)).^2+(rxy(minRind,3)-y(i)).^2);
    else
        r(i)=interp1(rxy(:,1)-dist2Centr,rxy(:,1),0);

    end
end