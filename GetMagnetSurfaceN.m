function [R,delta]=GetMagnetSurfaceN(x,y,X,Y,shafrShift)
Rdia=78;
Rmax=Rdia-sqrt(X^2+Y^2);

if numel(x)~=numel(y)
    if numel(x)==1
        x=ones(size(y))*x;
    elseif numel(y)==1
        y=ones(size(x))*y;
    else
        error('x and y must by consistent');
    end;
end;
        
if numel(shafrShift)==1    
    A=-shafrShift/Rmax;
    B=X+shafrShift;
    R(1,:)=(-A*(B-x)+sqrt((B-x).^2-(y-Y).^2*(A^2-1)))/(A^2-1);
    R(2,:)=(-A*(B-x)-sqrt((B-x).^2-(y-Y).^2*(A^2-1)))/(A^2-1);
    R=sort(R);
    R=R(2,:)';
    delta=shafrShift*(Rmax-R)/Rdia;
elseif min(size(shafrShift))==2
    if size(shafrShift,1)<size(shafrShift,2)
        shafrShift=shafrShift';
    end;
    d2=(x-X).^2+(y-Y).^2;
    r2=shafrShift(:,1).^2;
    for i=1:length(d2)
        R(i)=interp1(2*(x(i)-X)*shafrShift(:,2)+d2(i)-r2,shafrShift(:,1),0,'PCHIP');
        if R(i)>Rmax          
            R(i)=Rmax;
        elseif R(i)<0
            R(i)=0;
        end;
        delta(i)=interp1(shafrShift(:,1),shafrShift(:,2),R(i));
    end
end