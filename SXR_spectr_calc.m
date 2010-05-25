function [Spectr,Ni]=SXR_spectr_calc(ne,Te,Ni);

Ew_arr=100:39.8:10000;

if nargin<3
    %[Ni,Zeff]=Zeff_calc_manual(ne);
    Ni=Species_by_Zeff;
end;

Jb=zeros(size(Ew_arr));
Jr=zeros(size(Ew_arr));
for i=1:max(size(Ni))
    Z=Ni(i,1);
    ni=Ni(i,2)*ne;
    [jb(:,i),jr(:,i)]=J_calc(ne,ni,Z,Te,Ew_arr);
    Jb(:)=Jb(:)+jb(:,i);
    Jr(:)=Jr(:)+jr(:,i);
end;    

figure;
    semilogy(Ew_arr,Jb(:),'-g','LineWidth',2);
    hold on; grid on;
    semilogy(Ew_arr,Jr(:),'-b','LineWidth',2);
    semilogy(Ew_arr,Jb(:)+Jr(:),'-r','LineWidth',3);
    semilogy(Ew_arr,jb(:,find(Ni(:,1)==1)),'-c','LineWidth',2);
        
Spectr(:,1)=Ew_arr;
Spectr(:,2)=Jb(:)+Jr(:);