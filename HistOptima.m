function HistSet=HistOptima(A,X);

[Hist1,HI,HS,HistSet1]=sid_hist(A,X,'max');
[Hist10,HI,HS,HistSet10]=sid_hist(A,X,HS/1.1,HI);

delta=1;
delta1=0;
figure;

while delta<1000
    [Hist1,HI,HS,HistSet1]=sid_hist(A,X,HI,HI);
    if HistSet10.HistN==HistSet1.HistN
        delta1(end+1)=sum((Hist1(:,2)-Hist10(:,2)).^2)/HistSet10.HistN;
    end;
    subplot(4,1,1);
    plot(Hist1(:,1),Hist1(:,2)/HistSet1.HI,'-b.');
    grid on; hold on;
    plot(Hist10(:,1),Hist10(:,2)/HistSet10.HI,'-r.');
    hold off;

    [Hist10,HI,HS,HistSet10]=sid_hist(A,X,HS/1.1,HI);
%     HistInt(:,1)=Hist10(:,1);
%     HistInt(:,2)=interp1(Hist1(:,1),Hist1(:,2),Hist10(:,1),'pchip');
%     HistInt(:,3)=sqrt(HistInt(:,2));
%     delta(end+1)=sum((Hist10(:,2)-HistInt(:,2)).^2)/HistSet10.HistN;
  Hist1D=diff(Hist1(:,2));
  Hist1DSh=circshift(Hist1D,1);
  F=Hist1D.*Hist1DSh;
  delta(end+1)=size(find(F<=0),1);

  subplot(4,1,2);
    plot(Hist1(:,1),Hist1(:,2)/HI);
    grid on; hold on;
%     plot(Hist10(:,1),Hist10(:,2),'-r.');
%     plot(HistInt(:,1),HistInt(:,2),'-k');
    subplot(4,1,3);
        plot(delta,'-dr');
        grid on; 
        set(gca,'yscale','log');
    subplot(4,1,4);
        plot(delta1,'-dr');
        grid on; 


    pause;
%     close(gcf);
    HI=HI/1.1;
end;
