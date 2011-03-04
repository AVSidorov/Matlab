function K=CfitByPoisson(TrekSet);
dC=0.005;

Fs=8192;
s=(sin([1:3*Fs]/Fs*3500).*exp(-[1:3*Fs]/Fs/0.05).*([1:3*Fs]/Fs).^2)';
s=s/max(s);

peaks=TrekPeaks2keV(TrekSet,-0.19/5.9);
HistSet=HistPick(peaks,5);
IN=zeros(7,1);
IN(3)=4.5;
IN(4)=7;
IN(6)=2;
IN(7)=4.3;
[PSet,IN]=Poisson(HistSet.Hist,IN);
INs(1)=PSet.W1;
INs(2)=PSet.Sigma1;
INs(5)=PSet.W41;
K(1,1)=0.19/5.9;
K(1,2)=PSet.Chi2;
K(1,3)=PSet.Khi2;
K(1,4)=PSet.SigmaMainP;
K(1,5)=PSet.FWHMp;
K(1,6)=PSet.Wmain;
K(1,7)=TrekSet.Date;
K(1,8)=TrekSet.Shot;
K(1,9)=TrekSet.P;
K(1,10)=TrekSet.HV;
K(1,11)=TrekSet.Amp;
K(1,12)=mean(TrekSet.charge);
ch=[];
C=-dC;
while isempty(ch)
    close(gcf);
    C=C+dC;
    peaks=TrekPeaks2keV(TrekSet,-C);
    Hist=sid_hist(peaks,5,HistSet.HS,HistSet.HI);
    [PSet,IN]=Poisson(Hist,IN);
    IN(1)=PSet.W1;
    IN(2)=PSet.Sigma1;
    IN(5)=PSet.W41;
    K(end+1,1)=C;
    K(end,2)=PSet.Chi2;
    K(end,3)=PSet.Khi2;
    K(end,4)=PSet.SigmaMainP;
    K(end,5)=PSet.FWHMp;
    K(end,6)=PSet.Wmain;
    K(end,7)=TrekSet.Date;
    K(end,8)=TrekSet.Shot;
    K(end,9)=TrekSet.P;
    K(end,10)=TrekSet.HV;
    K(end,11)=TrekSet.Amp;    
    K(end,12)=mean(TrekSet.charge);

    
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

    sound(s,Fs);
    ch=input('Continue? \n','s');
    close(gcf);
end;
    close(gcf);
    
    assignin('base','K1',K);
    evalin('base','if exist(''K'')~=1 K=[]; end;');
    evalin('base','K=[K;K1];');
    
    CfitByK(K);