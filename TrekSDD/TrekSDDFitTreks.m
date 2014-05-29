function FitSet=TrekSDDFitTreks(TrekSet1,TrekSet2)

OverSt=2;
boolNotOverload=TrekSet1.trek>TrekSet1.MinSignal&TrekSet1.trek<TrekSet1.MaxSignal&...
                TrekSet2.trek>TrekSet2.MinSignal&TrekSet2.trek<TrekSet2.MaxSignal;
boolSignal=boolNotOverload&...
     abs(TrekSet1.trek)>TrekSet1.Threshold&abs(TrekSet2.trek)>TrekSet2.Threshold;

Ind=find(boolSignal);
Ind1=[];
ex=[];
NoiseDif.MeanVal=0;
NoiseDif.MedianVal=0;
NoiseDif.StdVal=TrekSet1.StdVal;
NoiseDif.Thr=TrekSet1.Threshold;
NoiseDif.NoiseBool=boolSignal;
NoiseDif.NoiseInd=find(boolSignal);
NoiseDif.MinStep=TrekSet1.NoiseSet.MinStep;
while isempty(ex)
    fit=polyfit(TrekSet2.trek(boolSignal),TrekSet1.trek(boolSignal),1);
    dif=TrekSet1.trek-TrekSet2.trek*fit(1)-fit(2);
    NoiseDif=NoiseHist(dif,NoiseDif);
    boolSignal=boolSignal&abs(dif)<OverSt*NoiseDif.StdVal;
    Ind1=find(boolSignal);
    if numel(Ind)==numel(Ind1)&&numel(intersect(Ind,Ind1))==numel(Ind)
        ex=1;
    end;
    Ind=Ind1;
end;
boolSignal=boolNotOverload&abs(dif)<NoiseDif.Thr;

FitSet.fit=fit;
FitSet.boolSignal=boolSignal;
FitSet.boolNotOverload=boolNotOverload;

FitSet.dif=dif;
FitSet.DifNoise=NoiseDif;




   