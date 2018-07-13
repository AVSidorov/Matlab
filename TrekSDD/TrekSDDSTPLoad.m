function TrekSet=TrekSDDSTPLoad(TrekSet,filename)
if nargin<2
    filename='D:\!SCN\StandPeakAnalys\StPeakSDD_20ns_3.dat';
end;
TrekSet.STP=StpStruct(filename);
if isfield(TrekSet,'Nfit')&&~isempty(TrekSet.Nfit)
    Nfit=TrekSet.Nfit;
else
    Nfit=round(1/TrekSet.STP.TimeStep);
    TrekSet.Nfit=Nfit;
end;
TrekSet.STP.FinePulse=interp1(TrekSet.STP.TimeInd,TrekSet.STP.FinePulse,[1:1/Nfit:TrekSet.STP.size]','spline',0);
TrekSet.STP.TimeInd=[1:1/Nfit:TrekSet.STP.size]';
TrekSet.STP.TimeStep=1/Nfit;
    