function HistSet=HistOptima(A,X)

[Hist1,HI,HS,HistSet1]=sid_hist(A,X,'max');

delta=1;
delta1=0;

HIST=[];
delta1=[];
delta2=[];
delta3=[];
delta4=[];
delta5=[];
delta6=[];
delta7=[];

figure;
while HS<=HI

[Hist1,HI,HS,HistSet1]=sid_hist(A,X,HI,HI);
Hist1(:,2)=Hist1(:,2)/HI;

[Hist10,HI,HS,HistSet10]=sid_hist(A,X,HistSet1.Range/200,HI);
Hist10(:,2)=Hist10(:,2)/HI;

% HistSm=smooth(Hist10(:,2),round(HI/HS));
 HistSm=smooth(Hist10(:,2),10);

HistInt=interp1(Hist1(:,1),Hist1(:,2),Hist10(:,1),'pchip');

Hist1D=diff(Hist1(:,2));
Hist1DSh=circshift(Hist1D,1);
F1=Hist1D.*Hist1DSh;

Hist10D=diff(Hist10(:,2));
Hist10DSh=circshift(Hist10D,1);
F10=Hist10D.*Hist10DSh;

M1=HistInt-Hist10(:,2);
M1Sh=circshift(M1,1);
F2=M1.*M1Sh;

M2=HistSm-Hist10(:,2);
M2Sh=circshift(M2,1);
F3=M2.*M2Sh;

if isempty(delta1)
    HIST(:,1)=Hist10(:,2);
    HistM=mean(HIST,2);
    
    delta1=size(find(F1<=0),1);
    delta2=size(find(F10<=0),1);
    delta3=sum((HistInt-Hist10(:,2)).^2)/HistSet10.HistN;
    delta4=sum((HistM-Hist10(:,2)).^2)/HistSet10.HistN;
    delta5=sum((HistSm-Hist10(:,2)).^2)/HistSet10.HistN;
    delta6=size(find(F2<=0),1);
    delta7=size(find(F3<=0),1);
else
    HIST(:,end+1)=Hist10(:,2);
    HistM=mean(HIST,2);

    delta1(end+1)=size(find(F1<=0),1);
    delta2(end+1)=size(find(F10<=0),1);
    delta3(end+1)=sum((HistInt-Hist10(:,2)).^2)/HistSet10.HistN;
    delta4(end+1)=sum((HistM-Hist10(:,2)).^2)/HistSet10.HistN;
    delta5(end+1)=sum((HistSm-Hist10(:,2)).^2)/HistSet10.HistN;
    delta6(end+1)=size(find(F2<=0),1);
    delta7(end+1)=size(find(F3<=0),1);
end;

    

  subplot(3,1,1)
    plot(Hist1(:,1),Hist1(:,2),'-b.');
    grid on; hold on;
    plot(Hist10(:,1),Hist10(:,2),'-r.');
    plot(Hist10(:,1),HistSm,'-m.');
    plot(Hist10(:,1),HistM,'-g.');
    plot(Hist10(:,1),HistInt,'-k');
    hold off;
  subplot(3,1,2)
     plot(delta3,'-k.');
     grid on; hold on;
     plot(delta4,'-g.');
     plot(delta5,'-m.');
     hold off;

  subplot(3,1,3)
     plot(delta1,'-b.');
     grid on; hold on;
     plot(delta2,'-r.');
     plot(delta6,'-k.');
     plot(delta7,'-m.');
     hold off;

    pause;
    HI=HI/1.1;
    clear HistInt;
end;
