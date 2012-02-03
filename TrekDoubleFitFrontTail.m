function [TrekSet,isGood]=TrekDoubleFitFrontTail(TrekSetIn,Ind,STP)
if nargin<3
    STP=StpStruct(TrekSet.StandardPulse);
end;

IndTail=Ind;
IndFront=Ind;
ExFront=false;
ExTail=false;
TrekSetF=TrekSetIn;
TrekSetT=TrekSetIn;

while not(ExFront&ExTail)
     FITfront=TrekFitTime(TrekSetT,IndFront,STP)
    [TrekSetF,ExFront,TrekSet]=TrekSubtract(TrekSetT,STP,FITfront);
     TrekSet=TrekPeakReSearch(TrekSet,STP,FITfront);
     IndTail=TrekSet.SelectedPeakInd(find(TrekSet.SelectedPeakInd>=FITfront.MaxInd,1,'first'));

    if ExFront&not(ExTail)
        FITtail=TrekFitTime(TrekSetF,IndTail,STP);
    end;
    if not(ExFront)&not(ExTail)
        IndTail=Ind;
        FITtail=TrekFitTail(TrekSetF,IndTail,STP);
    end;
    if not(ExFront)&ExTail
        ExTail=false;
        TrekSetT=TrekSetIn;
    
        if IndFront~=Ind
            continue;
        else
            [TrekSetF,ExFront,TrekSet]=TrekSubtract(TrekSetT,STP,FITfront);
             TrekSet=TrekPeakReSearch(TrekSet,STP,FITfront);
             IndTail=TrekSet.SelectedPeakInd(find(TrekSet.SelectedPeakInd>=FITfront.MaxInd,1,'first'));
        end;
    end;
    if ExFront&ExTail
        continue;
    end;

    [TrekSetT,ExTail,TrekSet]=TrekSubtract(TrekSetF,STP,FITtail);
     TrekSet=TrekPeakReSearch(TrekSet,STP,FITtail);
     IndFront=TrekSet.SelectedPeakInd(find(TrekSet.SelectedPeakInd<=FITtail.MaxInd,1,'last'));
     


end;
