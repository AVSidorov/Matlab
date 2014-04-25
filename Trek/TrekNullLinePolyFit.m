function NullLine=TrekNullLinePolyFit(TrekSet)
Nold=TrekSet.size;
if isempty(TrekSet.MeanVal)
    NoiseSet=NoiseFit(TrekSet.trek);
    TrekSet.MeanVal=NoiseSet.MeanVal;
end;
bool=abs(TrekSet.trek-TrekSet.MeanVal)<TrekSet.Threshold;
Ind=find(bool);
N=numel(Ind);
i=1;
while Nold~=N
  [fit,s,m]=polyfit(Ind,TrekSet.trek(Ind),i);
  NullLine=polyval(fit,[1:TrekSet.size]',s,m);
  bool=abs(TrekSet.trek-NullLine)<TrekSet.Threshold;
  Ind=find(bool);
  Nold=N;
  N=numel(Ind);
  i=i+1;
end;
