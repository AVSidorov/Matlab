function TrekSet=TrekSDDGetPeaksFilter(TrekSet)
BckgFitN=5;
StartSearchTime=14500;
TrekSetIn=TrekSet;
TrekSet.peaks=[];
STP=TrekSet.STP;
MinFrontN=STP.MinFitPoint-STP.BckgFitN;

FIT0.Shift=0;
FIT0.FitPulse=TrekSet.STP.Stp;
FIT0.FitPulseN=TrekSet.STP.size;
FIT0.B=0;
FIT0.Khi=inf;
FIT0.ShiftRangeL=2;
FIT0.ShiftRangeR=2;
FIT0.FitFast=false;
FIT0.BGLineFit=[0,0];

FIT0.FitIndPulseStrict=[STP.BckgFitN-BckgFitN+1:TrekSet.STP.MinFitPoint]';



for i=1:size(TrekSetIn.peaks,1)
        FIT=FIT0;
%% regular fit        
        FIT.MaxInd=TrekSetIn.peaks(i,1);
        if TrekSet.trek(FIT.MaxInd)<TrekSet.Threshold
            continue;
        end;
        StartInd=find(TrekSet.trek(1:FIT.MaxInd)<TrekSet.StdVal*TrekSet.OverSt,1,'last')-BckgFitN;
        FIT.A=TrekSetIn.peaks(i,5);        
        FIT.FitIndStrict=[StartInd:FIT.MaxInd]'; 
        FIT=TrekSDDGetFitInd(TrekSet,FIT);      
        
        FIT.Good=all((TrekSet.trek(FIT.FitInd)-FIT.A*FIT.FitPulse(FIT.FitIndPulse)-FIT.B)<TrekSet.OverSt*TrekSet.StdVal);

        FIT=TrekSDD2FitFunctions(TrekSet,FIT);
        [TrekSet,TrekSet1]=TrekSDDSubtract(TrekSet,FIT);
        [ExcelentFit,TrekSet]=TrekSDDisGoodSubtractFilter(TrekSet,TrekSet1,FIT,false);
        if not(ExcelentFit)&&FIT.A>TrekSet.Threshold&&FIT.A<TrekSet.MaxSignal&&FIT.MaxInd>1.1e6
           FIT.FitInd=[StartInd:FIT.MaxInd]';
           [FIT1,FIT2]=TrekSDD2FitFunctionsDouble(TrekSet,FIT);
           [TrekSet,TrekSet1]=TrekSDDSubtract(TrekSet,FIT1);
           [TrekSet1,TrekSet2]=TrekSDDSubtract(TrekSet1,FIT2);
           if FIT1.A>0&&FIT2.A>0
            [ExcelentFit,TrekSet]=TrekSDDisGoodSubtractFilter(TrekSet,TrekSet2,FIT1,true);
           end;
        end;
        assignin('base','TrekSet',TrekSet);
end;