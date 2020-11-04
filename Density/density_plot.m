function density_plot(rxyn,color)
xLaser=1.5;

hfig=findobj('Type','figure','Tag','rxyn_plots');
if isempty(hfig)||~ishandle(hfig)
    figure('Tag','rxyn_plots');
    i=1;
else
    figure(hfig(1));
    i=2;
end;

if nargin<2||isempty(color)
    cm=colormap(lines(10));
    color=cm(i,:);
end

nplots=size(rxyn,2);
if nplots==4
    rxyn(:,[1,2,3,6])=rxyn;
    rxyn(:,4)=0;
    rxyn(:,5)=1;
end

subplot(2,nplots/2,1);
grid on; hold on;
plot(rxyn(:,1),rxyn(:,end),'LineWidth',2,'Color',color);
title('N(r)');
xlabel('r,cm');
ylabel('N_e, cm^{-3}');

subplot(2,nplots/2,2);
grid on; hold on;
plot(rxyn(:,1),rxyn(:,2),'LineWidth',2,'Color',color);
title('ShiftX(r)=\Delta(r)+ShiftX');
xlabel('r,cm');
ylabel('Shift(r), cm');


subplot(2,nplots/2,3);
grid on; hold on;
nx=[[-rxyn(:,1)+rxyn(:,2);rxyn(:,1)+rxyn(:,2)],[rxyn(:,end);rxyn(:,end)]];
nx=sortrows(nx);
plot(nx(:,1),nx(:,2),'LineWidth',2,'Color',color);
% plot([1.5,1.5],[0,max(nx(:,2))],'k','LineWidth',1);
title('N(x) in middle plane');
xlabel('x,cm');
ylabel('N_e, cm^{-3}');

subplot(2,nplots/2,4);
grid on; hold on;
[~,y,n,X,Y]=density_rxyten2grid(rxyn,200,200,20,20);
n(isnan(n(:)))=0;
laserChord=interp2(X,Y,n,xLaser*ones(length(y),1),y);
plot(y,laserChord,'LineWidth',2,'Color',color);
title('laser chord N(y),x=1.5 cm');
xlabel('y,cm');
ylabel('N_e, cm^{-3}');

if nplots==4
    return;
end

subplot(2,nplots/2,5);
grid on; hold on;
plot(rxyn(:,1),rxyn(:,4),'LineWidth',2,'Color',color);
title('triangularity');
xlabel('r,cm');

subplot(2,nplots/2,6);
grid on; hold on;
plot(rxyn(:,1),rxyn(:,5),'LineWidth',2,'Color',color);
title('elongation');
xlabel('r,cm');


end