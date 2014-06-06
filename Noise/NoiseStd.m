function NoiseSet=NoiseStd(trek)
%simplest function for noise determination
%It must goog work in case of no or small fraction of signal in trek
%and almost flat background
%NoiseSet standart out for any Noise function
%trek is vector (Nx1) if row it will be trasnsposed.
OverSt=4;
if size(trek,2)>size(trek,1) trek=trek'; end;
trek=trek(:,1);
trSize=numel(trek);

BoolNoise=true(trSize,1);
Mean0=mean(trek);
Mean1=Mean0;
Std0=std(trek);
Std1=Std0;
Median0=median(trek);
Median1=Median0;

dStd=1;
dMean=1;
dMedian=1;
 while numel(Mean0)<11%(dStd+dMean+dMedian)>0.01 
    BoolNoise=abs(trek-Mean0(end))<OverSt*Std0(end);
        Std0(end+1)=std(trek(BoolNoise)-Mean0(end));  
        Mean0(end+1)=mean(trek(BoolNoise));  
        Median0(end+1)=median(trek(BoolNoise));

    BoolNoise=abs(trek-Median1(end))<OverSt*Std1(end);
        Std1(end+1)=std(trek(BoolNoise)-Median1(end));  
        Mean1(end+1)=mean(trek(BoolNoise));  
        Median1(end+1)=median(trek(BoolNoise));
 
    
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
NoiseSet.OverSt=OverSt;