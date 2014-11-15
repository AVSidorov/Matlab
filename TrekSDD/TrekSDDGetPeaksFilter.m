function TrekSet=TrekSDDGetPeaksFilter(TrekSet)
BckgFitN=5;
StartSearchTime=14500;
TrekSetIn=TrekSet;
TrekSet.peaks=[];
STP=TrekSet.STP;
for i=1:size(TrekSetIn.peaks,1)
        FIT.Shift=0;
        FIT.FitPulse=TrekSet.STP.Stp;
        FIT.FitPulseN=TrekSet.STP.size;
        FIT.MaxInd=TrekSetIn.peaks(i,1);
        FIT.A=TrekSetIn.peaks(i,5);
        FIT.B=0;
        FIT.Khi=inf;
        I=find(TrekSetIn.peaks(:,1)>TrekSetIn.peaks(i,1)&TrekSetIn.peaks(:,7)==0,1,'first');
        if ~isempty(I)
            Npoints=BckgFitN+TrekSetIn.peaks(I,1)-TrekSetIn.peaks(i,1);
        else
            Npoints=STP.MinFitPoint-STP.BckgFitN+BckgFitN;
        end;
        %not neccesary add FrontN because we add Front for first pulse, and
        %resiude front of next
     
        Npoints=min([Npoints,STP.size-(STP.BckgFitN-BckgFitN),STP.FrontN+BckgFitN]);
        
        %don't check for trek size, because work till previouse for last
        %marker
        %last number is neccessary in case of lost peaks on tail. Filter
        %noise is high :( 
        FIT.N=Npoints;
        FIT.FitIndPulseStrict=[STP.BckgFitN-BckgFitN+1:STP.BckgFitN-BckgFitN+Npoints]';
        if FIT.FitIndPulseStrict(end)<STP.MinFitPoint-BckgFitN
            continue;
        end;
        FIT.FitIndStrict=FIT.FitIndPulseStrict+FIT.MaxInd-STP.MaxInd;
        FIT.ShiftRangeL=2;
        FIT.ShiftRangeR=2;
        FIT=TrekSDDGetFitInd(TrekSet,FIT);
        FIT.FitFast=false;
        FIT.BGLineFit=[0,0];
        FIT.Good=all((TrekSet.trek(FIT.FitIndStrict)-FIT.A*FIT.FitPulse(FIT.FitIndPulseStrict)-FIT.B)<TrekSet.OverSt*TrekSet.StdVal);

        FIT=TrekSDD2FitFunctions(TrekSet,FIT);
        [TrekSet,TrekSet1]=TrekSDDSubtract(TrekSet,FIT);
        [ExcelentFit,TrekSet]=TrekSDDisGoodSubtractFilter(TrekSet,TrekSet1,FIT);
        if not(ExcelentFit)&&FIT.A>TrekSet.Threshold&&FIT.A<TrekSet.MaxSignal
           FIT.FitInd=[find(TrekSet.trek(1:FIT.FitInd(end))<TrekSet.StdVal,1,'last')-BckgFitN:FIT.MaxInd]';
           [FIT1,FIT2]=TrekSDD2FitFunctionsDouble(TrekSet,FIT);
           [TrekSet,TrekSet1]=TrekSDDSubtract(TrekSet,FIT1);
           [TrekSet1,TrekSet2]=TrekSDDSubtract(TrekSet1,FIT2);
           if FIT1.A>0&&FIT2.A>0
            [ExcelentFit,TrekSet]=TrekSDDisGoodSubtractFilter(TrekSet,TrekSet2,FIT1);
           end;
        end;
        assignin('base','TrekSet',TrekSet);
end;