function TrekSet = TrekGetPeaksByPeaks(TrekSet,TrekSetBase)
tau=TrekSet.tau;
t=0:1/5000:0.5;
B=500*t.^2.*exp(-t/0.05).*sin(2*pi*1000*t);

i=find(TrekSetBase.peaks(:,2)>=TrekSet.StartTime,1,'first');
I=find(TrekSetBase.peaks(:,2)<=TrekSet.StartTime+TrekSet.size*tau,1,'last');
TrekSet.SelectedPeakInd=round((TrekSetBase.peaks(i:I,2)-TrekSet.StartTime)/tau);
TrekSet.SelectedPeakFrontN=zeros(I-i+1,1);
TrekSet.SelectedPeakFrontN(:)=TrekSet.STP.FrontN;

FIT=[];
while i<=size(TrekSetBase.peaks,1)&&TrekSetBase.peaks(i,2)<=TrekSet.StartTime+TrekSet.size*tau;
    Ind=round((TrekSetBase.peaks(i,2)-TrekSet.StartTime)/tau);
%     ExcelentFit=false;
%      while ~ExcelentFit
        FIT=TrekFitTime(TrekSet,Ind,FIT);
        FIT.ShiftRangeL=3;
        FIT.ShiftRangeR=3;
        [TrekSet,ExcelentFit,TrekSet1]=TrekSubtract(TrekSet,FIT);
%         if ~ExcelentFit
%                sound(B,5000);
%                [TrekSet,ExcelentFit]=TrekSubtractManual(TrekSet,TrekSet1,FIT);
%            end;
%            if ~ExcelentFit    
%                     TrekSet.Plot=true;                
%                     [TrekSet,Ind,FIT,Ch]=TrekSDDManualPeakSearch(TrekSet,Ind,FIT);
%                     if Ch==1
%                         break;
%                     end;
%            end;
%      end
%      TrekSet.Plot=false;
     i=i+1;
end
end

