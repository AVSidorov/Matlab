function XYRV=density_chord_By_rxyV(slope,intercpt,rxy,V)
if nargin<4&&size(rxy,2)==4
    V=rxy(:,4);
elseif nargin<4||isempty(V)
    V=zeros(size(rxy,1),1);
end
bool=rxy(:,1)<=0|isnan(rxy(:,1));
rxy(bool,:)=[];
V(bool,:)=[];
n=size(rxy,1);
XYRV=zeros(n*2,4);
for i=1:n
    [xi,yi]=linecirc(slope,intercpt,rxy(i,2),rxy(i,3),rxy(i,1));
    XYRV([1:2]+(i-1)*2,1)=xi;
    XYRV([1:2]+(i-1)*2,2)=yi;    
    XYRV([1:2]+(i-1)*2,3)=rxy(i,1);
    XYRV([1:2]+(i-1)*2,4)=V(i);
end
XYRV=sortrows(XYRV,[1 2]);