function FitSet=TrekSDDFitTreks(TrekSet1,TrekSet2)

OverSt=3.5;
%% determination Overload, Signal, and Noise
boolNotOverload=TrekSet1.trek>TrekSet1.MinSignal&TrekSet1.trek<TrekSet1.MaxSignal&...
                TrekSet2.trek>TrekSet2.MinSignal&TrekSet2.trek<TrekSet2.MaxSignal;
boolSignal=boolNotOverload&...
     abs(TrekSet1.trek)>TrekSet1.Threshold&abs(TrekSet2.trek)>TrekSet2.Threshold;

Pset=PartsSearch(boolSignal,100,10); %to avoid adding to noise zero crossing points in signal
                                     %TODO parts length automation
boolSignal=Pset.bool;
boolNoise=boolNotOverload&~boolSignal;
Pset=PartsSearch(boolNoise,100,250);
boolNoise=Pset.bool;

%%
Ind=find(boolSignal);
Ind1=[];
ex=[];
if isfield(TrekSet1,'StartPlasma')&&~isempty(TrekSet1.StartPlasma)&&round((TrekSet1.StartPlasma-TrekSet1.StartTime)/TrekSet1.tau)>100;
    EndI=round((TrekSet1.StartPlasma-TrekSet1.StartTime)/TrekSet1.tau);
else
    EndI=TrekSet1.size;
end;
% NoiseDif.MeanVal=0;
% NoiseDif.MedianVal=0;
% NoiseDif.StdVal=TrekSet1.StdVal;
% NoiseDif.Thr=TrekSet1.Threshold;
% NoiseDif.NoiseBool=true(EndI,1);
% NoiseDif.NoiseInd=NoiseDif.NoiseBool;
% NoiseDif.MinStep=TrekSet1.NoiseSet.MinStep;
%% fitting
while isempty(ex)
    fit=polyfit(TrekSet2.trek(boolSignal),TrekSet1.trek(boolSignal),1);
    dif=TrekSet1.trek-TrekSet2.trek*fit(1)-fit(2);
    
    NoiseDif=NoiseStd(dif(boolSignal));
    boolSignal=boolSignal&abs(dif-NoiseDif.MeanVal)<NoiseDif.Thr;
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




   