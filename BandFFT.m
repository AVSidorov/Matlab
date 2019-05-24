function [trek,Y,Filter]=BandFFT(trek,freq,bandwidth,zerolvl,NFFT)
if nargin<4
    zerolvl=1e-10;
end;
if nargin<5
    %NFFT=nextpow2(length(trek));
    NFFT=numel(trek);
end;
Y=fft(trek,NFFT);
Filter=ones(size(Y))*zerolvl;
bandInd=round(NFFT/2*(freq-bandwidth/2)):round(NFFT/2*(freq+bandwidth/2));
bandInd=bandInd(bandInd>=1&bandInd<=NFFT/2+1);
Filter(bandInd)=1;
Filter(numel(Filter)-bandInd+2)=1;
trek=ifft(Y.*Filter);