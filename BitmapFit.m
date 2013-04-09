function [kx,ky]=BitmapFit(BitMap)
bm=image(BitMap);
X=[];Y=[];ch=[];
while isempty(ch)
[x,y]=ginput(1);
d=input('Input graphs coordinates [x,y]\n');
X(end+1,1)=x;
X(end,2)=d(1);
Y(end+1,1)=y;
Y(end,2)=d(2);
ch=input('If empty then continue\n','s');
end;
kx=polyfit(X(:,1),X(:,2),1);
ky=polyfit(Y(:,1),Y(:,2),1);
close(gcf);
image(polyval(kx,[1,size(BitMap,2)]),polyval(ky,[1,size(BitMap,1)]),BitMap);
set(gca,'YDir','normal');
grid on; hold on;