function [IP,IP_e,IP_n,IP_z]=Ioniz_Potenz_Hlike_ions;
IP=[];
for Z=1:100
    for n=1:Z 
     IP(end+1,1)=13.6*Z^2/n^2;
     IP(end,2)=Z;
     IP(end,3)=n;
    end;
end;
bool=find(IP(:,1)<1000|IP(:,1)>3000);
IP1=IP;
IP1(bool,:)=[];
IP_e=sortrows(IP1,1);
IP_z=sortrows(IP1,2);
IP_n=sortrows(IP1,3);