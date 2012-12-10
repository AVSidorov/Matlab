function TrekSet=TrekSDD(TrekSet,varargin)

tic;
fprintf('>>>>>>>>>>>>>>>>>>>>> TrekSDD started\n');




%% Checking for existing and initialization
TrekSet=TrekRecognize(TrekSet,varargin{:});
if TrekSet.type==0 
    return; 
end;
TrekSet.Plot=false;
TrekSet=TrekLoad(TrekSet);
TrekSet.Threshold=6;
TrekSet.StdVal=1.4;
TrekSet=TrekSDDStdVal(TrekSet);
assignin('base','Tin',TrekSet);
TrekSet.Threshold=6;
TrekSet.StdVal=1.4;
% TrekSet=TrekMerge(TrekSet);
%Loading Standard Pulse
TrekSet.STP=StpStruct('D:\!SCN\StandPeakAnalys\StPeakSDD_20ns_2.dat'); 

 WorkSize=pow2(23);
 for i=1:fix(TrekSet.size/WorkSize)
    TrekSet1=TrekPickTime(TrekSet,(i-1)*WorkSize*TrekSet.tau,WorkSize*TrekSet.tau);
    TrekSet1.SelectedPeakInd=[];
    TrekSet1=TrekSDDPeakSearch(TrekSet1);
    TrekSet1=TrekBreakPoints(TrekSet1);
    TrekSet1=TrekSDDGetPeaks(TrekSet1,1);
    TrekSet.trek(1+(i-1)*WorkSize:TrekSet1.size+(i-1)*WorkSize)=TrekSet1.trek;
    TrekSet.peaks=TrekSet1.peaks;
    assignin('base','T',TrekSet);
 end;
    TrekSet=TrekPickTime(TrekSet,7340,46000);
    TrekSet.Plot=true;
    TrekSet=TrekSDDPeakSearch(TrekSet);
    TrekSet.Plot=false;
    TrekSet=TrekBreakPoints(TrekSet);
    TrekSet=TrekSDDGetPeaks(TrekSet,1);
