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
        Npoints=BckgFitN+TrekSetIn.peaks(i+1,1)-TrekSetIn.peaks(i,1);
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

        FIT=TrekSDDFitTime(TrekSet,FIT);
        [TrekSet,TrekSet1]=TrekSDDSubtract(TrekSet,FIT);
        [ExcelentFit,TrekSet,FIT1,Istart]=TrekSDDisGoodSubtract(TrekSet,TrekSet1,FIT,FIT);
%          if not(ExcelentFit)&&FIT.A>TrekSet.Threshold&&FIT.A<TrekSet.MaxSignal
%              TrekSet1=TrekSet1;
%          end;
        assignin('base','TrekSet',TrekSet);
end;