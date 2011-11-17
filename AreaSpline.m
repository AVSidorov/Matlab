function [Spline,FitStruct]=AreaSpline(A);
Plot=false;

if numel(A)<3 
    disp('Too few elements');
    return;
end;
y=[];
while isempty(y)
    if size(A,1)>size(A,2)
        if size(A,2)>1
            x=A(:,1);
            y=A(:,2);
            n=size(A,1);
        else
            n=numel(A);
            x=[1:n];
            y=A;
        end;
    else
       A=A'; 
    end;
end;
Sy=sum(y);
S2=sum(x.^2);
S1=sum(x);
a=(Sy*(x(end)-x(1))-S1*(y(end)-y(1))+n*(x(1)*y(end)-x(end)*y(1)))/((x(end)-x(1))*(S2-S1*(x(1)+x(end))+n*x(1)*x(end)));
b=(y(end)-y(1))/(x(end)-x(1))-a*(x(1)+x(end));
c=a*x(1)*x(end)+(x(end)*y(1)-x(1)*y(end))/(x(end)-x(1));
Y=(a*x.^2+b*x+c)';

if size(A,2)>1
    Spline(:,1)=x;
    Spline(:,2)=Y;
else
    Spline=Y;
end;

FitStruct.AreaDiff=Sy-sum(Y);
FitStruct.Khi2=sum((y-Y).^2)/n;
FitStruct.Khi2r=sum(((y-Y)./y).^2)/n;
FitStruct.a=a;
FitStruct.b=b;
FitStruct.c=c;

    fprintf('Integral difference is %7.3f\n',FitStruct.AreaDiff);
    fprintf('Khi2  is %7.3e\n',FitStruct.Khi2);
    fprintf('Khi2 relative  is %7.3e\n',FitStruct.Khi2r);
    
if Plot
    figure;
    plot(x,y,'*b-');
    grid on; hold on;
    plot(x,Y,'.r-');

end;

