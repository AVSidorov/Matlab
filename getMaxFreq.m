function freq=getMaxFreq(trek,NFFT)
if nargin<2
    NFFT=numel(trek);
end;
Y=fft(trek,NFFT);
[m,mi]=max(abs(Y(1:NFFT/2+1)));
stI=max([1,mi-1]);
endI=min([NFFT/2+1,mi+1]);
[fit,s,mu]=polyfit([mi-1:mi+1]',abs(Y(stI:endI)),2);
maxInd=((-fit(2)/2/fit(1))*mu(2)+mu(1));
f=linspace(0,1,NFFT/2+1);
freq=interp1(1:NFFT/2+1,f,maxInd);