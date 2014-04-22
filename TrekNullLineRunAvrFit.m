function NullLine=TrekNullLineRunAvrFit(TrekSet)
Inds=[1:TrekSet.size];
if isempty(TrekSet.MeanVal)
    NoiseSet=NoiseFit(TrekSet.trek);
    TrekSet.MeanVal=NoiseSet.MeanVal;
end;
bool=abs(TrekSet.trek-TrekSet.MeanVal)<TrekSet.Threshold;
Ind=find(bool);
NullLine=interp1(Ind,TrekSet.trek(Ind),Inds,'linear','extrap');
NullLine=smooth(NullLine,111);
for i=1:10
  bool=abs(TrekSet.trek-NullLine)<TrekSet.Threshold;
  Ind=find(bool);
  NullLine=interp1(Ind,NullLine(Ind),Inds,'linear','extrap');
  NullLine=smooth(NullLine,111);
end;
