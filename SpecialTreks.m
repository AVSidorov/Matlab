function STSet=SpecialTreks(trek)
% This function searchs local Minima and Maxima of given trek
% and calculates additional stat such as FrontHigh, FrontN (front length in
% points) etc.
% First Minimum is always before first Maximum
% Quantity of MinInd, MaxInd, Fronts and Tails are equal
% Front is part from minimum to maximum
% Tail is part from maximum to minimum
trSize=numel(trek);


MaxBool=false(trSize,1);
MaxBool(2:end-1)=trek(2:end-1)>trek(1:end-2)&trek(2:end-1)>=trek(3:end);
MaxInd=find(MaxBool);
MaxN=numel(MaxInd);

MinBool=false(trSize,1);
MinBool(2:end-1)=trek(2:end-1)<=trek(1:end-2)&trek(2:end-1)<trek(3:end);
MinInd=find(MinBool);
MinN=numel(MinInd);

if ~isempty(MaxInd)
    if isempty(MinInd)||MinInd(1)>MaxInd(1) % MinInd always first
        MinInd=[1;MinInd];    
        MinN=MinN+1;
    end;
end;

 
%making equal quantity of maximums and minimums
 if MinN>MaxN
      MaxInd=[MaxInd;trSize]; %earlier was removing MinInd, by this causes errors in HighPeak Search
      MaxN=MaxN+1;
 end;
 if MinN==0
     STSet=[];
     return;
 end;
 MaxBool=false(trSize,1);
 MaxBool(MaxInd)=true;
 MinBool=false(trSize,1);
 MinBool(MinInd)=true;

 FrontN=MaxInd-MinInd;
 TailN=MinInd(2:end)-MaxInd(1:end-1);
 if MaxInd(end)==trSize
     TailN=[TailN;0];
 else
     TailN=[TailN;trSize-MaxInd(end)];
 end
 DoubleFrontN=MaxInd-circshift(MinInd,1);
 DoubleFrontN(1)=FrontN(1);
 
 FrontHigh=trek(MaxInd)-trek(MinInd);
 DoubleFrontHigh=trek(MaxInd)-trek(circshift(MinInd,1));
 DoubleFrontHigh(1)=FrontHigh(1);
%  TripleFrontHigh=trek(MaxInd)-trek(circshift(MinInd,2));
%  TripleFrontHigh(1:2)=DoubledFrontHigh(1:2);
%  QuadFrontHigh=trek(MaxInd)-trek(circshift(MinInd,3));
%  QuadFrontHigh(1:3)=TripleFrontHigh(1:3);
 TailHigh=trek(MaxInd(1:end-1))-trek(MinInd(2:end));
 % MakeEqual FrontHigh and TailHigh
 if MaxInd(end)==trSize
     TailHigh=[TailHigh;0];
 else
    TailHigh=[TailHigh;trek(MaxInd(end))-trek(end)];
 end
%  for i=0:5
%      tt(i+1,:)=trek(circshift(MaxInd,-i))-trek(MinInd);
%  end;

 
 
 STSet.MinInd=MinInd;
 STSet.MaxInd=MaxInd;
 STSet.N=MinN;
 STSet.MaxBool=MaxBool;
 STSet.MinBool=MinBool;
 STSet.FrontHigh=FrontHigh;
 STSet.TailHigh=TailHigh;
 STSet.FrontN=FrontN;
 STSet.TailN=TailN;
 STSet.DoubleFrontHigh=DoubleFrontHigh;
 STSet.DoubleFrontN=DoubleFrontN;
 