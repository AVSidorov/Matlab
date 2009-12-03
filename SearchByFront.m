function PeakSet=SearchByFront(trek);

tic;
disp('>>>>>>>>Search by Front started');

OverSt=1.5;
tau=0.020;

% SmoothPar=5;

StandardPulseFile='D:\!SCN\EField\StandPeakAnalys\StPeak20ns_2.dat';

if exist(StandardPulseFile,'file');
     StandardPulse=load(StandardPulseFile);
end;

[StPMax,StPMaxInd]=max(StandardPulse);
FirstNonZero=find(StandardPulse,1,'first');
LastNonZero=find(StandardPulse,1,'last');
MaxFrontN=StPMaxInd-FirstNonZero;
MaxTailN=LastNonZero-StPMaxInd;

DeltaM=1;
i=0;
while DeltaM>1e-4
i=i+1;
    [MeanVal,StdVal,PeakPolarity,Noise]=MeanSearch(trek,OverSt,0);
    if i>1
        DeltaM=abs(MeanVal-M);
    end;
    trek=PeakPolarity*(trek-MeanVal);
    M=MeanVal;
end;
trSize=size(trek,1);

Threshold=StdVal*OverSt;

% trekS=smooth(trek,SmoothPar);

FrontInd=[];
i=0;
N=1;
FrontHigh=zeros(trSize,1);
while N>0
 i=i+1;
 trR(:,i)=circshift(trek,i);
 trL(:,i)=circshift(trek,-i);
 if i==1
     FrontBool(:,i)=trek>=trR(:,i);
     TailBool(:,i)=trek>=trL(:,i);
     MaxBool=trek>trR(:,i)&trek>=trL(:,i);
     MaxInd=find(MaxBool);
     MaxN=size(MaxInd);
 else
     FrontBool(:,i)=FrontBool(:,i-1)&trR(:,i-1)>=trR(:,i);
     NFrontBool(:,i-1)=MaxBool&xor(FrontBool(:,i-1),FrontBool(:,i));
     FrontHigh(NFrontBool(:,i-1))=trek(NFrontBool(:,i-1))-trR(NFrontBool(:,i-1),i-1);
     TailBool(:,i)=TailBool(:,i-1)&trL(:,i-1)>=trL(:,i);
 end;
   FrontInd=find(FrontBool(:,i));
   FrontN(i)=size(FrontInd,1);
   TailInd=find(TailBool(:,i));
   TailN(i)=size(TailInd,1);
   N=max([FrontN(i),TailN(i)]);
end;
IntervalBefore=MaxInd-circshift(MaxInd,1);
IntervalBefore(1)=MaxInd(1);
A=zeros(trSize,1);
A(MaxInd)=IntervalBefore;
IntervalBefore=A;

weightF=sum(FrontBool');
weightT=sum(TailBool');
weight=weightF+weightF;

ByFrontBool=FrontHigh>=Threshold;
ByFrontInd=find(ByFrontBool);
ByFrontN=size(ByFrontInd,1);

MaxIndSh=circshift(MaxInd,-1);
IndMaxAfter=zeros(trSize,1);
IndMaxAfter(MaxInd)=MaxIndSh;
IndMaxAfterByFront=IndMaxAfter(ByFrontBool);

A=zeros(trSize,1);
A(IndMaxAfterByFront)=IndMaxAfterByFront-ByFrontInd;
IntervalAfterByFront=A;

OnTailBool=IntervalAfterByFront<(MaxFrontN+MaxTailN)&IntervalAfterByFront>0&FrontHigh>StdVal&not(ByFrontBool);
OnTailInd=find(OnTailBool);
OnTailN=size(OnTailInd,1);

SelectedBool=ByFrontBool|OnTailBool;
SelectedInd=find(SelectedBool);
SelectedN=size(SelectedInd,1);
toc
fprintf('=====  Search of peak tops      ==========\n');
fprintf('The number of measured points  = %7.0f during %7.0f us \n',trSize,trSize*tau);
fprintf('Threshold is %3.1f*%5.3f = %5.3f \n',OverSt,StdVal,Threshold);
fprintf('The total number of maximum = %7.0f \n',MaxN);
fprintf('The number peaks selected by FrontHigh = %7.0f \n',ByFrontN);
fprintf('The number peaks selected on tail= %7.0f \n',OnTailN);
fprintf('The number of selected peaks = %7.0f \n',SelectedN);
fprintf('>>>>>>>>>>>>>>>>>>>>>>\n');

figure;
plot(trek);
grid on; hold on;
plot(SelectedInd,trek(SelectedInd),'.r');
plot(find(OnTailBool),trek(OnTailBool),'or');
PeakSet=1;