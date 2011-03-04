function CfitByK(K,N);

p1=polyfit(K(2:end,1),K(2:end,4),2);
Csigma=-p1(2)/2/p1(1);
Ind=find(not(isnan(K(2:end,5))))+1;
p2=polyfit(K(Ind,1),K(Ind,5),2);
Cfwhm=-p2(2)/2/p2(1);
C(1,1)=K(1,7);
C(1,2)=K(1,8);
C(1,3)=K(1,9);
C(1,4)=K(1,10);
C(1,5)=K(1,12);
C(1,6)=Csigma;
C(1,7)=Cfwhm;
C(1,8)=min(K(:,4));
C(1,9)=min(K(:,5));
C(1,10)=polyval(p1,Csigma);
C(1,11)=polyval(p2,Cfwhm);
 figure;

    subplot(3,1,1); grid on; hold on;
        plot(K(2:end,1),K(2:end,2),'*r-');
        plot(K(2:end,1),K(2:end,3),'*b-');
        title('Chi2 and Khi2');
    
    subplot(3,1,2); grid on; hold on;
        plot(K(2:end,1),K(2:end,4),'*r-');
        plot([0:0.001:K(end,1)],polyval(p1,[0:0.001:K(end,1)]),'b');
        plot([Csigma,Csigma],[min(K(2:end,4)),max(K(2:end,4))],'r','linewidth',2);
        title('Sigma Main, %');
        
    subplot(3,1,3);  grid on; hold on;
        plot(K(2:end,1),K(2:end,5),'*b-');
        plot([0:0.001:K(end,1)],polyval(p2,[0:0.001:K(end,1)]),'r');
        plot([Cfwhm,Cfwhm],[min(K(2:end,5)),max(K(2:end,5))],'r','linewidth',2);
        title('FWHM Main, %');

        assignin('base','C1',C);
        evalin('base','if exist(''C'')~=1 C=[]; end;');
        evalin('base','C=[C;C1];');
        figure(gcf);
        pause;
        close(gcf);
