function f=density_plot_rxyten(rxyten)
Rdia=7.85;

Rdia=Rdia*10^(round(log10(max(rxyten(:,1))))-round(log10(Rdia)));
theta=linspace(0,2*pi,361);
n=size(rxyten,1);

f=figure;
cm=colormap(jet(n));
if size(rxyten,2)>5&&range(rxyten(:,6))>0   
    cm=cm(round((rxyten(:,6)-min(rxyten(:,6)))/range(rxyten(:,6))*(n-1))+1,:);
end;
grid on; hold on;
for i=1:n
    x=rxyten(i,2)+rxyten(i,1)*(cos(theta)-rxyten(i,4)*sin(theta).^2);
    y=rxyten(i,3)+rxyten(i,1)*rxyten(i,5)*sin(theta);
    plot(x,y,'Color',cm(i,:),'LineWidth',1,'Tag','rcn');
end
axis(gca,'equal');
plot(rxyten(:,2),rxyten(:,3),'r','LineWidth',2);
plot(cos(theta)*Rdia,sin(theta)*Rdia,'k','LineWidth',3,'Tag','Dia');