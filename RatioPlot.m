function RatioPlot(N,N50);
ns=num2str(N);
ns50=num2str(N50);
figure;
grid on;
hold on;
set(gca,'YScale','log');
evalin('base',['KInd=find(K(:,1)==',ns,');']);
evalin('base',['KInd50=find(K(:,1)==',ns50,');']);
evalin('base',['plot(5.9*Specs(',ns,').Hist(:,1)/AllPrms(',ns,',12),Specs(',ns,').Hist(:,2),''.r-'');']);
evalin('base',['plot(5.9*Specs(',ns50,').Hist(:,1)/AllPrms(',ns50,',12),Specs(',ns50,').Hist(:,2),''.b-'');']);
evalin('base',['k=K(KInd,3)/AllPrms(',ns,',11)*AllPrms(',ns,',12);']);
evalin('base',['k50=K(KInd50,3)/AllPrms(',ns50,',11)*AllPrms(',ns50,',12);']);
evalin('base',['plot(K(KInd,3)*5.9*Specs(',ns,').Hist(:,1)/AllPrms(',ns,',11),Specs(',ns,').Hist(:,2)/k,''*r-'');']);
evalin('base',['plot(K(KInd50,3)*5.9*Specs(',ns50,').Hist(:,1)/AllPrms(',ns50,',11),Specs(',ns50,').Hist(:,2)/k50,''*b-'');']);

figure;
grid on;
hold on;
set(gca,'YScale','log');

evalin('base','E=[0.7:0.01:4.7];');

evalin('base',['S1=interp1(5.9*Specs(',ns,').Hist(:,1)/AllPrms(',ns,',12),Specs(',ns,').Hist(:,2),E);']);
evalin('base',['S2=interp1(5.9*Specs(',ns50,').Hist(:,1)/AllPrms(',ns50,',12),Specs(',ns50,').Hist(:,2),E);']);
evalin('base',['S3=interp1(K(KInd,3)*5.9*Specs(',ns,').Hist(:,1)/AllPrms(',ns,',11),Specs(',ns,').Hist(:,2)/k,E);']);
evalin('base',['S4=interp1(K(KInd50,3)*5.9*Specs(',ns50,').Hist(:,1)/AllPrms(',ns50,',11),Specs(',ns50,').Hist(:,2)/k50,E);']);
evalin('base','plot(Be50um2(:,1)/1e3,Be50um2(:,2),''k'');');
evalin('base','plot(Spec04Sm(:,1),Spec04Sm100(:,2)./Spec04Sm(:,2),''m'');');
evalin('base','plot(E,S2./S1,''.r-'');');
evalin('base','plot(E,S4./S3,''*b-'');');
legend('Be50','Ratio Calc Smooth', 'Fit by Charge', 'Fit by Maxw');
