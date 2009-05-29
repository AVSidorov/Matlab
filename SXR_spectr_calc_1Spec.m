function SXR_spectr_calc(ne,Zeff,Z,Te);
Ry=13.6;

ni=Ni_by_Zeff(ne,Z,Zeff);
niH=ne-ni;
jH=J_calc(ne,niH,1,Te,300:10:3000);
jZ=J_calc(ne,ni,Z,Te,300:10:3000);
figure;
semilogy(300:10:3000,jH(:));
hold on;
semilogy(300:10:3000,jZ(:));
semilogy(300:10:3000,jH(:)+jZ(:));
