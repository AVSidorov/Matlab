function SpecSM=Poisson_smooth(SpectrR,K);

dEw=max(SpectrR(:,1)-circshift(SpectrR(:,1),1));
SpecSM=zeros(max(size(SpectrR)),1);
for i=1:max(size(SpectrR))
    S(:,i)=SpectrR(i,2)*dEw*Poisson_distr(K,SpectrR(i,1),SpectrR(:,1));
    SpecSM=SpecSM+S(:,i);
    %    plot(SpectrR(:,1),S(:,i)); hold on; grid on;
end;
%SpecSM=sum(S);