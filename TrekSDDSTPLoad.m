function TrekSet=TrekSDDSTPLoad(TrekSet,filename)
if nargin<2
    filename='D:\!SCN\StandPeakAnalys\StPeakSDD_20ns_2.dat';
end;
TrekSet.STP=StpStruct(filename);
if isfield(TrekSet,'Nfit')&&~isempty(TrekSet.Nfit)
    Nfit=TrekSet.Nfit;
else
    Nfit=round(1/TrekSet.STP.TimeStep);
end;
if numel([TrekSet.STP.TimeInd(1):1/Nfit:TrekSet.STP.TimeInd(end)]')==numel(TrekSet.STP.TimeInd)&&...
   all(TrekSet.STP.TimeInd-[TrekSet.STP.TimeInd(1):1/Nfit:TrekSet.STP.TimeInd(end)]'<1e-3)
   TrekSet.STP.TimeInd=[TrekSet.STP.TimeInd(1):1/Nfit:TrekSet.STP.TimeInd(end)]';  
elseif Nfit>(1/TrekSet.STP.TimeStep)
    TrekSet.STP.FinePulse=interp1(TrekSet.STP.TimeInd,TrekSet.STP.FinePulse,[TrekSet.STP.TimeInd(1):1/Nfit:TrekSet.STP.TimeInd(end)]','spline',0);
    TrekSet.STP.TimeInd=[TrekSet.STP.TimeInd(1):1/Nfit:TrekSet.STP.TimeInd(end)]';
else
    TrekSet.STP.FinePulse=interp1(TrekSet.STP.TimeInd,TrekSet.STP.FinePulse,[TrekSet.STP.TimeInd(1):TrekSet.STP.TimeStep:TrekSet.STP.TimeInd(end)]','spline',0);
    TrekSet.STP.TimeInd=[TrekSet.STP.TimeInd(1):TrekSet.STP.TimeStep:TrekSet.STP.TimeInd(end)]';    
end;
TrekSet.STP.TimeStep=1/Nfit;
    