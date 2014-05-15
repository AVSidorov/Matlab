function FitSet=TrekSDDFitTreks(TrekSet1,TrekSet2)

bool=TrekSet1.trek>TrekSet1.MinSignal&TrekSet1.trek<TrekSet1.MaxSignal&...
     TrekSet2.trek>TrekSet2.MinSignal&TrekSet2.trek<TrekSet2.MaxSignal&...
     abs(TrekSet1.trek)>TrekSet1.Threshold&abs(TrekSet2.trek)>TrekSet2.Threshold;

Ind=find(bool);
Ind1=[];
ex=[];
while isempty(ex)
    fit=polyfit(TrekSet2.trek(bool),TrekSet1.trek(bool),1);
    dif=TrekSet1.trek-TrekSet2.trek*fit(1)-fit(2);
    NoiseDif=NoiseHist(dif);
    bool=bool&abs(dif)<NoiseDif.StdVal;
    Ind1=find(bool);
    if numel(Ind)==numel(Ind1)&&numel(intersect(Ind,Ind1))==numel(Ind)
        ex=1;
    end;
    Ind=Ind1;
end;
FitSet.fit=fit;
FitSet.bool=bool;
FitSet.DifNoise=NoiseDif;


   