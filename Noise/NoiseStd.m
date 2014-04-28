function NoiseSet=NoiseStd(trek)
%simplest function for noise determination
%It must goog work in case of no or small fraction of signal in trek
%and almost flat background
%NoiseSet standart out for any Noise function
%trek is vector (Nx1) if row it will be trasnsposed.
if size(trek,2)>size(trek,1) trek=trek'; end;
trek=trek(:,1);
trSize=numel(trek);

BoolNoise=true(trSize,1);
NoiseTrek=trek(BoolNoise);
Mean0=mean(NoiseTrek);
Std0=std(NoiseTrek);
Median0=median(NoiseTrek);

dStd=1;
dMean=1;
dMedian=1;
 while (dStd+dMean+dMedian)>0.01 
    BoolNoise=abs(trek-Mean0(end))<4*Std0(end);
    NoiseTrek=trek(BoolNoise);
    Std0(end+1)=std(NoiseTrek);  
    Mean0(end+1)=mean(NoiseTrek);
    Median0(end+1)=median(NoiseTrek);
    if numel(Mean0)>2
        dMean=diff(Mean0);
        dMean=abs(dMean(end)/dMean(end-1));
        dMedian=diff(Median0);
        dMedian=abs(dMedian(end)/dMedian(end-1));
        dStd=diff(Std0);
        dStd=abs(dStd(end)/dStd(end)-1);
    end;
end;
NoiseSet.MeanVal=Mean0(end);
NoiseSet.StdVal=Std0(end);
NoiseSet.MedianVal=Median0(end);
NoiseSet.NoiseInd=find(BoolNoise);
NoiseSet.NoiseBool=BoolNoise;