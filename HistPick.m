function HistSet=HistPick(A,X);

k=1.2;

[Hist1,HI,HS,HistSet1]=sid_hist(A,X,'max');

answ=[];
h=figure;
while isempty(answ)
    [Hist1,HI,HS,HistSet1]=sid_hist(A,X,HI,HI);
    Hist1(:,2)=Hist1(:,2)/HI;
    [Hist10,HI,HS,HistSet10]=sid_hist(A,X,HI/10,HI);
    Hist10(:,2)=Hist10(:,2)/HI;
    figure(h);  
      subplot(2,1,1)
        plot(Hist10(:,1),Hist10(:,2),'-r.');
        grid on; hold on;
        plot(Hist1(:,1),Hist1(:,2),'-b.');
        hold off;
      subplot(2,1,2)
        plot(Hist1(:,1),Hist1(:,2),'-b.');
        grid on; hold on;
        plot(Hist10(:,1),Hist10(:,2),'-r.');

    answ=input('Continue if input is empty\n','s');
    HI=HI/k;
end;
close(gcf);

answ=[];
h=figure;
HI=HI*(k^2);
HS=HI;
while isempty(answ)
    [Hist1,HI,HS,HistSet1]=sid_hist(A,X,HS,HI);
    Hist1(:,2)=Hist1(:,2)/HI;
    figure(h);  
    subplot(2,1,1)
        plot(Hist1(:,1),Hist1(:,2),'-b.');
        grid on; 
      subplot(2,1,2)
        plot(Hist1(:,1),Hist1(:,2),'-b.');
        grid on; hold on;

    answ=input('Continue if input is empty\n','s');
    HS=HS/k;
end;
[Hist1,HI,HS,HistSet]=sid_hist(A,X,HS*(k^2),HI);
close(gcf);
