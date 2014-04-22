function NullLine=TrekNullLineMinMaxFit(TrekSet)
Inds=[1:TrekSet.size];
Nold=TrekSet.size;
if isempty(TrekSet.MeanVal)
    NoiseSet=NoiseFit(TrekSet.trek);
    TrekSet.MeanVal=NoiseSet.MeanVal;
end;
bool=abs(TrekSet.trek-TrekSet.MeanVal)<TrekSet.Threshold;
Ind=find(bool);
N=numel(Ind);
NullLine=interp1(Ind,TrekSet.trek(Ind),Inds,'linear','extrap');
i=1;
while Nold~=N
  STSet=SpecialTreks(NullLine);
  MaxTrek=interp1(STSet.MaxInd,NullLine(STSet.MaxInd),Inds,'linear','extrap');
  MinTrek=interp1(STSet.MinInd,NullLine(STSet.MinInd),Inds,'linear','extrap');
  NullLine=(MaxTrek+MinTrek)/2;
  NullLine=NullLine';  
  bool=abs(TrekSet.trek-NullLine)<TrekSet.Threshold;
  Ind=find(bool);
  Nold=N;
  N=numel(Ind);
  i=i+1;
end;
