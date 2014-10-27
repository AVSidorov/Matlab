function FitSet=TrekSDDFitTreks(TrekSet1,TrekSet2)

OverSt=3.5;
%% Determination Overload, Signal, Noise etc.
% boolNotOverload - all points in ADC Range
% boolOverload - points out of bound ADC Range and probably disturbed
% boolDisturbed - points in ADC Range and probably disturbed
% boolSignal - points whithin ADC range, isn't disturbed and above noise
%               level
% boolNoise=~boolSignal 

%% determination Overload, Signal, Noise etc. 
boolNotOverload=TrekSet1.trek>TrekSet1.MinSignal&TrekSet1.trek<TrekSet1.MaxSignal&...
                TrekSet2.trek>TrekSet2.MinSignal&TrekSet2.trek<TrekSet2.MaxSignal;

boolOverload=~boolNotOverload;            
PSet=PartsSearch(boolOverload,1,1);

% search parts after overloading (may be disturbed)
boolDisturbed = false(TrekSet1.size,1);
for i=1:numel(PSet.PartLength) 
    IndStart=max([1,PSet.SpaceStart(i)+1]);
    IndStart=min([TrekSet1.size,IndStart]);
    IndEnd=min([TrekSet1.size,IndStart-1+TrekSet1.STP.size-TrekSet1.STP.MaxInd]);
    if ~isempty([IndStart:IndEnd])
        boolDisturbed(IndStart:IndEnd)=true;
    end;
end;

boolOverload=~boolNotOverload|boolDisturbed;            

% boolSignal=boolNotOverload&...

  boolSignal=~boolOverload&...            
      abs(TrekSet1.trek)>TrekSet1.Threshold&abs(TrekSet2.trek)>TrekSet2.Threshold;

Pset=PartsSearch(boolSignal,100,1); %to avoid adding to noise zero crossing points in signal
                                     %TODO parts length automation
boolSignal=Pset.bool;
boolNoise=boolNotOverload&~boolSignal;


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

FitSet.fit=fit;
FitSet.boolSignal=boolSignal; % points where was fitting done
FitSet.boolNoise=boolNoise;
FitSet.boolNotOverload=boolNotOverload;
FitSet.boolOverload=boolOverload;
FitSet.boolDisturbed=boolDisturbed;


FitSet.dif=dif;
FitSet.DifNoise=NoiseDif;




   