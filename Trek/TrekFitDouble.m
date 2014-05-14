function [TrekSet,isGood,TrekSet1,FIT,STPC]=TrekFitDouble(TrekSetIn,Ind,STP)

if nargin<3
    STP=StpStruct(TrekSetIn.StandardPulse);
end;
i=find(TrekSetIn.SelectedPeakInd==Ind);
PeakN=numel(TrekSetIn.SelectedPeakInd);
StartKhiInd=find(TrekSetIn.trek(1:Ind)<=TrekSetIn.Threshold,1,'last');
EndKhiInd=Ind-1+find(TrekSetIn.trek(Ind:TrekSetIn.size)<=TrekSetIn.Threshold,1,'first');
if isempty(EndKhiInd)
    EndKhiInd=TrekSetIn.size;
end;
if i<PeakN
    EndKhiInd=min([EndKhiInd,TrekSetIn.SelectedPeakInd(i+1)-STP.FrontN,TrekSetIn.SelectedPeakInd(i+1)-TrekSetIn.SelectedPeakFrontN(i+1)]);
    EndKhiInd=max([EndKhiInd,Ind]);
end;
KhiInd=[StartKhiInd:EndKhiInd];
if EndKhiInd-Ind>2
    RSKhi=TrekDoubleFitFrontTail(TrekSetIn,Ind,STP,KhiInd);
else
   RSKhi=TrekDoubleFitFront(TrekSetIn,Ind,STP,KhiInd); 
end;
if size(RSKhi,1)>=3
    [TrekSet,isGood,TrekSet1,FIT,STPC]=TrekFitSimplex(TrekSetIn,Ind,STP,RSKhi,KhiInd);
else
    TrekSet=TrekSetIn;
    TrekSet1=TrekSetIn;
    STPC=STP;
    FIT=TrekFitTime(TrekSetIn,Ind,STP);
    [TrekSet,isGood,TrekSet1]=TrekSubtract(TrekSetIn,STP,FIT);
end;
