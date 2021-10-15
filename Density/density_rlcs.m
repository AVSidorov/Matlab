function [Rlcs,ld,xmax,xmin,ymax,ymin]=density_rlcs(cxy,lx,Rdia)
Rdia=7.79;
lx=1.5;
Rlcs=Rdia-sqrt(cxy(:,1).^2+cxy(:,2).^2);
ld=sqrt(Rlcs.^2-(lx-cxy(:,1)).^2);
ymax=cxy(:,2)+ld;
ymin=cxy(:,2)-ld;
xmax=cxy(:,1)+Rlcs;
xmin=cxy(:,1)-Rlcs;

