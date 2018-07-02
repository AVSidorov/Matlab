function elm_grid_draw(Grid,icri)

th=[0:2*pi/max(Grid.Npoloidal):2*pi];
figure;
grid on; hold on;
cm=colormap(lines(length(Grid.r)));
haxes=gca;
for i=1:length(Grid.r)
    plot(haxes,Grid.r(i)*cos(th),Grid.r(i)*sin(th),'Color',cm(i,:));
    Theta=2*pi/Grid.Npoloidal(i)*[0:Grid.Npoloidal(i)-1];    
    if nargin>1
        theta=elm_grid_Theta2theta(Theta,icri);
    else
        theta=Theta;
    end;
       
    plot(haxes,Grid.r(i)*cos(theta),Grid.r(i)*sin(theta),'.','Color',cm(i,:));

end;
set(haxes,'DataAspectRatio',[1 1 1]);

figure;
h1=subplot(2,1,1);
grid on; hold on;
plot(h1,Grid.r,Grid.Npoloidal,'LineWidth',2);
h2=subplot(2,1,2);
grid on; hold on;
plot(h2,Grid.r(1:end-1),diff(Grid.r),'r','LineWidth',2);
linkaxes([h1,h2],'x');