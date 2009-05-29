function [jb,jr]=J_calc(ne,ni,Z,Te,Ew);
Ry=13.6;

N=1;
RecH=[];
while 2*Z^2*Ry/(N^3*Te)*exp(Z^2*Ry/(N^2*Te))>0.01
    RecH(N)=2*Z^2*Ry/(N^3*Te)*exp(Z^2*Ry/(N^2*Te));
    N=N+1;
end;
N=N-1;
i=1;
jb=zeros(size(Ew));
jr=zeros(size(Ew));

jb(:)=8e-55*ne*ni*Z^2*(1/sqrt(Te))*exp(-Ew(:)/Te);       

for i=1:max(size(Ew))
     if round(sqrt(Z^2*Ry/Ew(i)))<=N
         jr(i)=8e-55*ne*ni*Z^2*(1/sqrt(Te))*exp(-Ew(i)/Te)*sum(RecH(max([1,ceil(sqrt(Z^2*Ry/Ew(i)))]):N));       
     end;
end;
