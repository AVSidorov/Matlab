function density_plot(rxyn,color)


hfig=findobj('Type','figure','Tag','rxyn_plots');
if isempty(hfig)||~ishandle(hfig)
    figure('Tag','rxyn_plots');
    i=1;
else
    figure(hfig);
    i=2;
end;

if nargin<2||isempty(color)
    cm=colormap(lines(10));
    color=cm(i,:);
end


subplot(2,2,1);
grid on; hold on;
plot(rxyn(:,1),rxyn(:,4),'LineWidth',2,'Color',color);
title('N(r)');
xlabel('r,cm');
ylabel('N_e, cm^{-3}');

subplot(2,2,2);
grid on; hold on;
plot(rxyn(:,1),rxyn(:,2),'LineWidth',2,'Color',color);
title('c(r)');
xlabel('r,cm');
ylabel('c(r), cm');


subplot(2,2,3);
grid on; hold on;
nx=[[-rxyn(:,1)+rxyn(:,2);rxyn(:,1)+rxyn(:,2)],[rxyn(:,4);rxyn(:,4)]];
nx=sortrows(nx);
plot(nx(:,1),nx(:,2),'LineWidth',2,'Color',color);
plot([1.5,1.5],[0,max(nx(:,2))],'k','LineWidth',1);
title('N(x)');
xlabel('x,cm');
ylabel('N_e, cm^{-3}');

subplot(2,2,4);
grid on; hold on;
xyrn=density_chord_By_rxyV(inf,1.5,rxyn);
xyrn=xyrn(isfinite(xyrn(:,1))&isfinite(xyrn(:,2)),:);
plot(xyrn(:,2),xyrn(:,4),'LineWidth',2,'Color',color);
title('laser chord N(y),x=1.5 cm');
xlabel('y,cm');
ylabel('N_e, cm^{-3}');

end