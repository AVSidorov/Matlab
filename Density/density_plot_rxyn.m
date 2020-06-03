function f=density_plot_rxyn(rxy)
theta=linspace(0,2*pi,360);
n=size(rxy,1);

f=figure;
cm=colormap(jet(n));
if size(rxy,2)>3   
    cm=cm(round((rxy(:,4)-min(rxy(:,4)))/range(rxy(:,4))*(n-1))+1,:);
end;
grid on; hold on;
for i=1:n
    plot(cos(theta)*rxy(i,1)+rxy(i,2),sin(theta)*rxy(i,1)+rxy(i,3),'Color',cm(i,:),'LineWidth',1,'Tag','rcn');
end
axis(gca,'equal');
plot(rxy(:,2),rxy(:,3),'r','LineWidth',2);