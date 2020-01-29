function density_plot_rxy(rxy)

h=findobj('Type','figure','Tag','FT2fig');
if ~isempty(h)&&ishandle(h)
    figFT2=h;
else   
    figFT2=figure('Tag','FT2fig');
end;

h=findobj(figFT2,'Type','axes');
if isempty(h)||~ishandle(h)
    figure(figFT2);
    axesFT2=axes;
    grid(axesFT2,'on');
    hold(axesFT2,'on');
else
    axesFT2=h;
end;

theta=linspace(0,2*pi,360);

h=findobj('Tag','rcn');
if ~isempty(h)&&all(ishandle(h))
    delete(h)
end;

for i=1:length(rxy)
    plot(axesFT2,cos(theta)*rxy(i,1)+rxy(i,2),sin(theta)*rxy(i,1)+rxy(i,3),'k','LineWidth',1,'Tag','rcn');
end
axis(axesFT2,'equal');
plot(axesFT2,rxy(:,2),rxy(:,3),'r','LineWidth',2);
