function TrekSet=TrekSDD(TrekSetIn,varargin)
TrekSet=TrekSetIn;
tic;
fprintf('>>>>>>>>>>>>>>>>>>>>> TrekSDD started\n');




%% Checking for existing and initialization
TrekSet=TrekRecognize(TrekSet,varargin{:});
if TrekSet.type==0 
    return; 
end;
TrekSet.Plot=false;
 TrekSet=TrekLoad(TrekSet);

% TrekSet=TrekStdByHist(TrekSet);
% return;
% TrekSet.Threshold=50;
%  TrekSet.StdVal=[];
%  TrekSet=TrekSDDStdVal(TrekSet);
% TrekSet.Threshold=25;
% TrekSet.StdVal=2;
% TrekSet=TrekMerge(TrekSet);

%Loading Standard Pulse
TrekSet.STP=StpStruct('D:\!SCN\StandPeakAnalys\StPeakSDD_20ns_2.dat'); 
% WorkSize=pow2(23); 
%    for i=3:fix(TrekSet.size/WorkSize)
%       TrekSet1=TrekPickTime(TrekSet,(i-1)*WorkSize*TrekSet.tau,WorkSize*TrekSet.tau);
% %       TrekSet1=TrekSDDStdVal(TrekSet1);
% %      TrekSet1=TrekPickTime(TrekSet,1.5e7*TrekSet.tau,2e6*TrekSet.tau);
%      TrekSet1.SelectedPeakInd=[];
%      if isstruct(TrekSetIn)
%         TrekSet1.Plot=TrekSetIn.Plot;
%      end;
%      TrekSet1=TrekSDDPeakSearch(TrekSet1);     
%      TrekSet1=TrekBreakPoints(TrekSet1);
%      TrekSet1=TrekSDDGetPeaks(TrekSet1,1);
%      TrekSet.trek(1+WorkSize*(i-1):TrekSet1.size+WorkSize*(i-1))=TrekSet1.trek;
%      TrekSet.Threshold=TrekSet1.Threshold;
%      TrekSet.ThresholdFront=TrekSet1.ThresholdFront;
%      TrekSet.ThresholdN=TrekSet1.ThresholdN;
%      TrekSet.ThresholdD=TrekSet1.ThresholdD;
%      TrekSet.ThresholdFrontD=TrekSet1.ThresholdFrontD;
%      TrekSet.ThresholdND=TrekSet1.ThresholdND;
%      TrekSet.peaks=TrekSet1.peaks;
%      assignin('base','T',TrekSet);
%   end;
% return;
    TrekSet=TrekPickTime(TrekSet,18900,31100);
    TrekSet.Plot=true;
     TrekSet=TrekSDDPeakSearch(TrekSet);
%     TrekSet.SelectedPeakInd=TrekSet.SelectedPeakInd(TrekSet.SelectedPeakInd>7e5);
    TrekSet.Plot=TrekSetIn.Plot;
    TrekSet=TrekBreakPoints(TrekSet);
    TrekSet=TrekSDDGetPeaks(TrekSet,1);
