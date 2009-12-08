function PeakSet=SearchByFront(trek);

tic;
disp('>>>>>>>>Search by Front started');

OverSt=1.5;
tau=0.020;
BckgFitN=2;
OnTailBorder=0.1;

% SmoothPar=5;

StandardPulseFile='D:\!SCN\EField\StandPeakAnalys\StPeak20ns_2.dat';

if exist(StandardPulseFile,'file');
     StandardPulse=load(StandardPulseFile);
end;

[StPMax,StPMaxInd]=max(StandardPulse);
FirstNonZero=find(StandardPulse,1,'first');
LastNonZero=find(StandardPulse,1,'last');
MaxFrontN=StPMaxInd-FirstNonZero+1;
MaxTailN=LastNonZero-StPMaxInd+1;
OnTailN=StPMaxInd+find(StandardPulse(StPMaxInd+1:end)<OnTailBorder,1,'first');





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



trR(:,1)=circshift(trek,1);
trL(:,1)=circshift(trek,-1);

FrontBool(:,1)=trek>=trR(:,1);
TailBool(:,1)=trek>=trL(:,1);
MaxBool=trek>trR(:,1)&trek>=trL(:,1);
MaxBool(1)=false;    MaxBool(end)=false;
MaxInd=find(MaxBool);
MaxN=size(MaxInd);

i=1;
while N>0
 i=i+1;
 trR(:,i)=circshift(trek,i);
 trL(:,i)=circshift(trek,-i);
   FrontBool(:,i)=FrontBool(:,i-1)&trR(:,i-1)>=trR(:,i);
   FrontInd=find(FrontBool(:,i));
   FrontN(i)=size(FrontInd,1);

   NFrontEndBool(:,i-1)=MaxBool&xor(FrontBool(:,i-1),FrontBool(:,i));
   NFrontInd=find(NFrontEndBool(:,i-1));
   NFrontStartBool(:,i-1)=circshift(NFrontEndBool(:,i-1),-(i-1));
   NFrontN(i-1)=size(NFrontInd,1);
   FrontHigh(NFrontEndBool(:,i-1))=trek(NFrontEndBool(:,i-1))-trR(NFrontEndBool(:,i-1),i-1);

   TailBool(:,i)=TailBool(:,i-1)&trL(:,i-1)>=trL(:,i);
   TailInd=find(TailBool(:,i));
   TailN(i)=size(TailInd,1);

   N=max([FrontN(i),TailN(i)]);
end;
toc
tic
trD=diff(trek,1);
trD(end+1)=0;
MaxFrontFounded=i-1;
for i=1:MaxFrontFounded
    trD(find(NFrontEndBool(:,i)))=0;
    trD(find(NFrontStartBool(:,i)))=0;
end;
trDR=circshift(trD,1);
trDL=circshift(trD,-1);
trDMinBool=trD<trDL&trD<=trDR;
trDMinInd=find(trDMinBool);

PeakOnFrontInd=[];
for i=MaxFrontN:MaxFrontFounded
FrontStartInd=find(NFrontStartBool(:,i));
FrontEndInd=find(NFrontEndBool(:,i));
    for ii=1:NFrontN(i)
        Ind=trDMinInd(find(trDMinInd>FrontStartInd(ii)&trDMinInd<FrontEndInd(ii)));
        bool=(trek(Ind)-trek(FrontStartInd(ii)))>StdVal;
        Ind=Ind(bool);
        PeakOnFrontInd=[PeakOnFrontInd;Ind];
    end;
end;

PeakSet.PeakOnFrontInd=PeakOnFrontInd;
PeakOnFrontN=size(PeakOnFrontInd,1);
PeakOnFrontBool=false(trSize,1);
PeakOnFrontBool(PeakOnFrontInd)=true;


trDD=diff(trek,2);

IntervalBefore=MaxInd-circshift(MaxInd,1);
IntervalBefore(1)=MaxInd(1);
A=zeros(trSize,1);
A(MaxInd)=IntervalBefore;
IntervalBefore=A;

weightF=sum(FrontBool');
weightT=sum(TailBool');
weight=weightF+weightF;

ByFrontBool=FrontHigh>=Threshold&weightF'>=2;
ByFrontInd=find(ByFrontBool);
ByFrontN=size(ByFrontInd,1);

MaxIndSh=circshift(MaxInd,-1);
IndMaxAfter=zeros(trSize,1);
IndMaxAfter(MaxInd)=MaxIndSh;
IndMaxAfterByFront=IndMaxAfter(ByFrontBool);

A=zeros(trSize,1);
A(IndMaxAfterByFront)=IndMaxAfterByFront-ByFrontInd;
IntervalAfterByFront=A;

OnTailBool=IntervalAfterByFront<OnTailN&IntervalAfterByFront>0&FrontHigh>StdVal&not(ByFrontBool);
OnTailInd=find(OnTailBool);
OnTailN=size(OnTailInd,1);

SelectedBool=ByFrontBool|OnTailBool|PeakOnFrontBool;
SelectedInd=find(SelectedBool);
SelectedN=size(SelectedInd,1);

PeakSet.SelectedPeakInd=SelectedInd;
PeakSet.Threshold=Threshold;
%search of PeakOnFront

if not(isempty(PeakSet.SelectedPeakInd))
%     IntervalBefore=SelectedInd-circshift(SelectedInd,1);
%     IntervalBefore(1)=SelectedInd(1);
    IntervalAfter=circshift(SelectedInd,-1)-SelectedInd;
    IntervalAfter(end)=trSize-SelectedInd(end);
    PeakOnFrontBool=PeakOnFrontBool(SelectedInd);
    PeakOnFrontBool=(IntervalAfter<MaxFrontN)|PeakOnFrontBool;
    PeakOnFrontN=size(find(PeakOnFrontBool),1);
    PeakSet.PeakOnFrontInd=SelectedInd(PeakOnFrontBool);
end;

toc
fprintf('=====  Search of peak tops      ==========\n');
fprintf('The number of measured points  = %7.0f during %7.0f us \n',trSize,trSize*tau);
fprintf('Threshold is %3.1f*%5.3f = %5.3f \n',OverSt,StdVal,Threshold);
fprintf('The total number of maximum = %7.0f \n',MaxN);
fprintf('The number peaks selected by FrontHigh = %7.0f \n',ByFrontN);
fprintf('The number peaks selected on tail= %7.0f \n',OnTailN);
fprintf('The number peaks selected on Front= %7.0f \n',PeakOnFrontN);
fprintf('The number of selected peaks = %7.0f \n',SelectedN);
fprintf('>>>>>>>>>>>>>>>>>>>>>>\n');


figure;
plot(trek);
grid on; hold on;
plot(SelectedInd,trek(SelectedInd),'.r');
plot(find(OnTailBool),trek(OnTailBool),'or');






