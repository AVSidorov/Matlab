function trap=Trapezia(x,MaxPosition,Width,FlatTop)
% Makes trapezium with unity amplitude
trap=zeros(size(x));
x1=MaxPosition-Width/2;
x2=MaxPosition-FlatTop/2;
x3=MaxPosition+FlatTop/2;
x4=MaxPosition+Width/2;
trap1=interp1([x1,x2],[0,1],x,'linear',0);
trap2=interp1([x2,x3],[1,1],x,'linear',0);
trap3=interp1([x3,x4],[1,0],x,'linear',0);
trap=trap1+trap2+trap3;
trap(trap>1)=1;