function K=CfitByPoisson(TrekSet);
dC=0.005;

peaks=TrekPeaks2keV(TrekSet,-0.19/5.9);
HistSet=HistPick(peaks,5);
[PSet,INs]=Poisson(HistSet.Hist);
INs(1)=PSet.W1;
INs(2)=PSet.Sigma1;
INs(5)=PSet.W41;
K(1,1)=0.19/5.9;
K(1,2)=PSet.Chi2;
K(1,3)=PSet.Khi2;
K(1,4)=PSet.SigmaMainP;
K(1,5)=PSet.FWHMp;
K(1,6)=PSet.Wmain;
ch=[];
C=-dC;
while isempty(ch)
    close(gcf);
    C=C+dC;
    peaks=TrekPeaks2keV(TrekSet,-C);
    Hist=sid_hist(peaks,5,HistSet.HS,HistSet.HI);
    [PSet,INS]=Poisson(Hist,INs);
    INs(1)=PSet.W1;
    INs(2)=PSet.Sigma1;
    INs(5)=PSet.W41;
    K(end+1,1)=C;
    K(end,2)=PSet.Chi2;
    K(end,3)=PSet.Khi2;
    K(end,4)=PSet.SigmaMainP;
    K(end,5)=PSet.FWHMp;
    K(end,6)=PSet.Wmain;
    
    figure;

    subplot(3,1,1); grid on; hold on;
        plot(K(2:end,1),K(2:end,2),'*r-');
        plot(K(2:end,1),K(2:end,3),'*b-');
        title('Chi2 and Khi2');
    
    subplot(3,1,2); grid on; hold on;
        plot(K(2:end,1),K(2:end,4),'*r-');
        title('Sigma Main, %');
        
    subplot(3,1,3);  grid on; hold on;
        plot(K(2:end,1),K(2:end,5),'*b-');
        title('FWHM Main, %');
    
    ch=input('Continue? \n','s');
    close(gcf);
end;
    close(gcf);