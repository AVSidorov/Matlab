function FitInd=TrekSDDGetFitIndDouble(TrekSet,TrekSet2)
bool=(TrekSet2.trek~=TrekSet.trek);
PSet=PartsSearch(bool,3,100);
SubtractInd=find(bool);
bool=TrekSet2.trek(bool)<TrekSet.StdVal*TrekSet.OverSt;
PSet=PartsSearch(bool,3,TrekSet.STP.MinFitPoint-TrekSet.STP.BckgFitN+5);
FitInd=[SubtractInd(1)-5:SubtractInd(1)+PSet.SpaceStart(1)-1]'; %-5 To avoid bad check after fiting and final subtraction

%TODO add checking for FitInd Length (may by larger than STP