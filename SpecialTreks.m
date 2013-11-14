function STSet=SpecialTreks(trek)
trSize=numel(trek);

FrontHigh=zeros(trSize,1);



trR=circshift(trek,1); %circshift works on vectors (vertical arrays)
trL=circshift(trek,-1);

FrontBool=trek>=trR&trek<=trL;
TailBool=trek>=trL&trek<=trR;
MaxBool=trek>trR&trek>=trL;
MinBool=trek<=trR&trek<trL;
MaxBool(1)=false;    MaxBool(end)=false;
MaxInd=find(MaxBool);
MaxN=numel(MaxInd);

MinBool(1)=false;    MinBool(end)=false;
MinInd=find(MinBool);
MinN=numel(MinInd);

if ~isempty(MaxInd)
    if isempty(MinInd)||MinInd(1)>MaxInd(1)
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
%  for i=0:5
%      tt(i+1,:)=trek(circshift(MaxInd,-i))-trek(MinInd);
%  end;
 clear trL trR;
 
 
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
 