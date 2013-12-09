function TrekSet=TrekSDDSTPLoad(TrekSet,filename)
if nargin<2
    filename='D:\!SCN\StandPeakAnalys\StPeakSDD_20ns_2.dat';
end;
TrekSet.STP=StpStruct(filename);
if isfield(TrekSet,'Nfit')&&~isempty(TrekSet.Nfit)
    Nfit=TrekSet.Nfit;
    TrekSet.STP.FinePulse=interp1(TrekSet.STP.TimeInd,TrekSet.STP.FinePulse,[TrekSet.STP.TimeInd(1):1/Nfit:TrekSet.STP.TimeInd(end)]','spline',0);
    TrekSet.STP.TimeInd=[TrekSet.STP.TimeInd(1):1/Nfit:TrekSet.STP.TimeInd(end)]';
else
    Nfit=round(1/min(diff(TrekSet.STP.TimeInd)));
end;
    