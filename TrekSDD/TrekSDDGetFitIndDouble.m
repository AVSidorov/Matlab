function FitInd=TrekSDDGetFitIndDouble(TrekSet,TrekSet2)
bool=(TrekSet2.trek~=TrekSet.trek);
PSet=PartsSearch(bool,3,100);
SubtractInd=find(bool);
bool=abs(TrekSet2.trek(bool))<TrekSet.StdVal*TrekSet.OverSt;
PSet=PartsSearch(bool,3,TrekSet.STP.MinFitPoint-TrekSet.STP.BckgFitN+5);
if numel(PSet.SpaceStart)>=1
    FitInd=[SubtractInd(1)-5:SubtractInd(1)+PSet.SpaceStart(1)-1]'; %-5 To avoid bad check after fiting and final subtraction
else
    FitInd=[];
end;
   

%TODO add checking for FitInd Length (may by larger than STP