function [TrekSet,TrekSet1]=TrekSDDSubtractN(TrekSet,FIT)
    TrekSet1=TrekSet;
    for i=1:size(FIT.A,1)-1
        FIT1=FIT;
        FIT1.A=FIT.A(i);
        FIT1.B=FIT.A(end);
        FIT1.Shift=FIT.Shift(i,1);
        FIT1.FitPulse=FIT.FitPulse(:,i);
        FIT1.BGLineFit=[0,0];
        FIT1.Khi=sum(((FIT.Y-FIT.Yfit)/TrekSet.StdVal).^2)/FIT.N;
        [TrekSet2,TrekSet1]=TrekSDDSubtract(TrekSet1,FIT1);
    end;