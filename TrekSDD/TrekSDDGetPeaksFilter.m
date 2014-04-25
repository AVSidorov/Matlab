function TrekSet=TrekSDDGetPeaksFilter(TrekSet)
BckgFitN=5;
StartSearchTime=14500;
NoiseTime=[2000,13000];
NoiseInd=[fix((NoiseTime(1)-TrekSet.StartTime)/TrekSet.tau):fix((NoiseTime(end)-TrekSet.StartTime)/TrekSet.tau)];
StartSearchInd=fix((StartSearchTime-TrekSet.StartTime)/TrekSet.tau);
NoiseSet=NoiseFitAuto(TrekSet.trek(NoiseInd));
% NoiseSet.MeanVal=median(TrekSet.trek(NoiseInd));
% NoiseSet.StdVal=std(TrekSet.trek(NoiseInd));
% NoiseSet.Threshold=5*NoiseSet.StdVal;
TrekSet.trek=TrekSet.trek-NoiseSet.MeanVal;
TrekSet.MeanVal=0;
TrekSet.StdVal=NoiseSet.StdVal;
TrekSet.MaxSignal=TrekSet.MaxSignal-NoiseSet.MeanVal;
TrekSet.MinSignal=TrekSet.MinSignal-NoiseSet.MeanVal;
TrekSet.Threshold=ceil(NoiseSet.Threshold);
TrekSet.OverSt=3.5;

STP=TrekSet.STP;
[TrekSet,trek]=TrekSDDPeakSearchFilter(TrekSet,NoiseInd);
TrekSet.SelectedPeakInd(TrekSet.SelectedPeakInd<StartSearchInd)=[];
for i=1:numel(TrekSet.SelectedPeakInd-1)
        FIT.Shift=0;
        FIT.FitPulse=TrekSet.STP.Stp;
        FIT.FitPulseN=TrekSet.STP.size;
        FIT.MaxInd=TrekSet.SelectedPeakInd(i);
        FIT.A=trek(TrekSet.SelectedPeakInd(i));
        FIT.B=0;
        FIT.Khi=inf;
        Npoints=BckgFitN+TrekSet.SelectedPeakInd(i+1)-TrekSet.SelectedPeakInd(i);
        %not neccesary add FrontN because we add Front for first pulse, and
        %resiude front of next
        Npoints=min([Npoints,STP.size-(STP.BckgFitN-BckgFitN)]);
        %don't check for trek size, because work till previouse for last
        %marker
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
        if not(ExcelentFit)&&FIT.A>TrekSet.Threshold&&FIT.A<TrekSet.MaxSignal
            TrekSet=TrekSet1;
        end;
        assignin('base','TrekSet',TrekSet);
end;