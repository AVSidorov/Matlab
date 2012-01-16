function [TrekSet,isGood]=TrekSubtract(TrekSet,I,StpStruct);

if nargin<3
    StpStruct=StpStruct(TrekSet.StandardPulse);
end;

PulseN=StpStruct.size;
MaxInd=StpStruct.MaxInd;

SubtractInd=[1:PulseN]+TrekSet.SelectedPeakInd(I)-MaxInd;
SubtractInd=SubtractInd(SubtractInd<=TrekSet.size&SubtractInd>=1);
SubtractIndPulse=SubtractInd-TrekSet.SelectedPeakInd(I)+MaxInd;
                        
    