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
        MaxIndNext=TrekSetIn.peaks(i+1,1);
        MaxIndNextGood=TrekSetIn.peaks(find(TrekSetIn.peaks(:,1)>FIT.MaxInd&TrekSetIn.peaks(:,7)==0,1,'first'),1);
        StartInd=find(TrekSet.trek(1:FIT.MaxInd)<TrekSet.StdVal*TrekSet.OverSt,1,'last')-BckgFitN;
        MaxIndByStartInd=StartInd+STP.FrontN;
        
        
        FIT.FitIndStrict=[StartInd:FIT.MaxInd]';
        FIT.A=TrekSetIn.peaks(i,5);
        
        FIT=TrekSDDGetFitInd(TrekSet,FIT);      
                
        FIT=TrekSDD2FitFunctions(TrekSet,FIT);
        [TrekSet,TrekSet1]=TrekSDDSubtract(TrekSet,FIT);
        [ExcelentFit,TrekSet]=TrekSDDisGoodSubtractFilter(TrekSet,TrekSet1,FIT,false);

        ShStart=[];
        shMin=MaxIndByStartInd-FIT.MaxInd;
        while ~ExcelentFit
            [FIT,ShStart]=NewShift(FIT,MaxIndNext,MaxIndNextGood,shMin,ShStart);
            FIT.FitInd=[StartInd:round(FIT.MaxInd+max(FIT.Shift))]';         
            FIT=TrekSDD2FitFunctionsN(TrekSet,FIT);
            [TrekSet,TrekSet1]=TrekSDDSubtractN(TrekSet,FIT);
            [ExcelentFit,TrekSet]=TrekSDDisGoodSubtractFilter(TrekSet,TrekSet1,FIT,false);
        end;
        assignin('base','TrekSet',TrekSet);
end;

function [FIT,ShStart]=NewShift(FIT,MaxIndNext,MaxIndNextGood,shMin,ShStart)
if size(ShStart,2)==4
    ShStart=[];
end;

FIT.Shift=sort(FIT.Shift);

if numel(FIT.Shift)==1    
    FIT.Shift=[min([FIT.Shift;shMin])-1;max([FIT.Shift;shMin])+1];
elseif isempty(ShStart)
    FIT.Shift=[min([FIT.Shift;shMin])-1;max([FIT.Shift;shMin])+1];
    FIT.Shift=[FIT.Shift;mean(FIT.Shift)];        
elseif size(ShStart,2)==1
    FIT.Shift=2*FIT.Shift-ShStart(:,end);    
elseif size(ShStart,2)==2
    c=FIT.Shift-ShStart(:,1);
    FIT.Shift(1:2)=FIT.Shift(1:2)+[-c(2);c(1)];
elseif size(ShStart,2)==3
    FIT.Shift=2*FIT.Shift-ShStart(:,end);
end

FIT.Shift=sort(FIT.Shift);
   
ShStart=[ShStart,FIT.Shift];

