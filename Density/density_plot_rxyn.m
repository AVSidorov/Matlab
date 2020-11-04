function f=density_plot_rxyten(rxyte)
Rdia=7.79;

Rdia=Rdia*10^(round(log10(max(rxyte(:,1))))-round(log10(Rdia)));
theta=linspace(0,2*pi,361);
n=size(rxyte,1);

f=figure;
cm=colormap(jet(n));
if size(rxyte,2)>3&&range(rxyte(:,4))>0   
    cm=cm(round((rxyte(:,4)-min(rxyte(:,4)))/range(rxyte(:,4))*(n-1))+1,:);
end;
grid on; hold on;
for i=1:n
    plot(cos(theta)*rxyte(i,1)+rxyte(i,2),sin(theta)*rxyte(i,1)+rxyte(i,3),'Color',cm(i,:),'LineWidth',1,'Tag','rcn');
end
axis(gca,'equal');
plot(rxyte(:,2),rxyte(:,3),'r','LineWidth',2);
plot(cos(theta)*Rdia,sin(theta)*Rdia,'k','LineWidth',3,'Tag','Dia');