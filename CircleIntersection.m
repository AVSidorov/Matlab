function IntersectionPoints=CircleIntersection(C1,R1,C2,R2)

d=norm(C1-C2);
a=(R1^2-R2^2+d^2)/(2*d);
b=d-a;
h=sqrt(R1^2-a^2);

DPoint=C1+(C2-C1)*a/d;

IntersectionPoint(1,1)=DPoint(1)-h*(C1(2)-C2(2))/d;
IntersectionPoint(1,2)=DPoint(1)+h*(C1(2)-C2(2))/d;
IntersectionPoint(2,1)=DPoint(2)+h*(C1(1)-C2(1))/d;
IntersectionPoint(2,2)=DPoint(2)-h*(C1(1)-C2(1))/d;
