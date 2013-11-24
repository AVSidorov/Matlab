 function FIT=TrekSDDFitByMove(TrekSetIn,Ind)
% function TrekSet=TrekSDDFitByMove(TrekSetIn,Ind)
timeId=tic;
disp('>>>TrekSDDFitByMove Started');
T=0;
Tmax=120;

TrekSet=TrekSetIn;

if ~isempty(TrekSet.STP)
    STP=TrekSet.STP;
else
    STP=StpStruct;
end;

if nargin<2
    Ind=1;
end;

IndInitial=Ind;



FitIndPulse=[1:STP.MinFitPoint]';
N=numel(FitIndPulse);
FitIndPulseL=[1:STP.MaxInd]';
%%

FitPulse=TrekSet.STP.Stp(FitIndPulse);
FitPulseL=TrekSet.STP.Stp(FitIndPulseL);

IndStart=1;
FIT=[];

while T<Tmax&&Ind<TrekSetIn.size-STP.MaxInd;
IndStart=IndStart-1+Ind;
Ind=1;
TrekSet.trek=TrekSetIn.trek(IndStart:IndStart+STP.size);
TrekSet.size=numel(TrekSet.trek);
A=zeros(TrekSet.size,3);
B=zeros(TrekSet.size,3);
good=false(TrekSet.size,2);

Flag=false(4,1);
I=zeros(2,1);


while T<Tmax&&Ind<TrekSet.size-STP.MaxInd;
FitInd=FitIndPulse+Ind-1;
p=polyfit(FitPulse,TrekSet.trek(FitInd),1);
khi=sqrt(sum(((TrekSet.trek(FitInd)-p(1)*FitPulse-p(2))/TrekSet.StdVal).^2)/N);
good(Ind,1)=all(TrekSet.trek(FitInd)-p(1)*FitPulse-p(2)<TrekSet.StdVal*TrekSet.OverSt);
A(Ind,1:2)=p;
A(Ind,3)=khi;

FitInd=FitIndPulseL+Ind-1;
p=polyfit(FitPulseL,TrekSet.trek(FitInd),1);
khi=sqrt(sum(((TrekSet.trek(FitInd)-p(1)*FitPulseL-p(2))/TrekSet.StdVal).^2)/N);
good(Ind,2)=all(TrekSet.trek(FitInd)-p(1)*FitPulseL-p(2)<TrekSet.StdVal*TrekSet.OverSt);
B(Ind,1:2)=p;
B(Ind,3)=khi;


if A(Ind,1)>TrekSet.Threshold
    Flag(1)=true;
else
    Flag(1)=false;
end;
if B(Ind,1)>TrekSet.Threshold
    Flag(2)=true;
else
    Flag(2)=false;    
end;

if  Ind>2&&Flag(1)&&A(Ind,1)<A(Ind-1,1)&&A(Ind-2,1)<A(Ind-1,1)
    Flag(4)=true;
end;

if  Ind>2&&Flag(2)&&B(Ind,1)<B(Ind-1,1)&&B(Ind-2,1)<B(Ind-1,1)
    Flag(3)=true;
end;

if all(Flag(1:2))&&all(Flag(3:4))
    S1=SpecialTreks(A(:,3));
    S2=SpecialTreks(B(:,3));
    S3=SpecialTreks(A(:,1));
    S4=SpecialTreks(B(:,1));
    if ~isempty(S1)
        MaxInd=S3.MaxInd(find(A(S3.MaxInd,1)>TrekSet.Threshold,1,'first'));
        MinInd=S1.MinInd(A(S1.MinInd,1)>TrekSet.Threshold&good(S1.MinInd,1));
        if isempty(MinInd)
            MinInd=S1.MinInd(A(S1.MinInd,1)>TrekSet.OverSt*TrekSet.StdVal&good(S1.MinInd,1));
        end;
        if isempty(MinInd)
            MinInd=S1.MinInd(A(S1.MinInd,1)>TrekSet.Threshold);
        end;
        if isempty(MinInd)
            MinInd=S1.MinInd;
        end;
        
        II=MinInd(find(MinInd<MaxInd,1,'last'));
        if isempty(II)
            I(1)=MinInd(find(MinInd>=MaxInd,1,'first'));
        else
            I(1)=II;
        end;
    end;
    if ~isempty(S2)
        MaxInd=S4.MaxInd(find(B(S4.MaxInd,1)>TrekSet.Threshold,1,'first'));
        MinInd=S2.MinInd(B(S2.MinInd,1)>TrekSet.Threshold&good(S2.MinInd,2));
        if isempty(MinInd)
            MinInd=S2.MinInd(B(S2.MinInd,1)>TrekSet.OverSt*TrekSet.StdVal&good(S2.MinInd,2));
        end;            
        if isempty(MinInd)
            MinInd=S2.MinInd(B(S2.MinInd,1)>TrekSet.Threshold);
        end;            
        if isempty(MinInd)
            MinInd=S2.MinInd;
        end;            
        II=round(mean(MinInd(abs(MinInd-I(1))<2))); %mean to obtain one index
        if isempty(II)||isnan(II)
            II=MinInd(find(MinInd<MaxInd,1,'last'));
            if isempty(II)
                II=MinInd(find(MinInd>=MaxInd,1,'first'));
            end;
        end;
            I(2)=II;
    end;
    FIT.Shift=0;
    FIT.FitPulse=TrekSet.STP.Stp;
    FIT.FitPulseN=TrekSet.STP.size;
    FIT.BGLineFit=[0,0];
    if  I(1)>0&&I(2)>0&&good(I(1),1)&&good(I(2),2)&&range(I)<3&&abs(A(I(1),1)-B(I(1),1))<TrekSet.OverSt*TrekSet.StdVal
        FIT.MaxInd=round(mean(I(I>0))-1+TrekSet.STP.MaxInd)+IndStart-1;
        FIT.A=A(I(1),1);
        FIT.B=A(I(1),2);
        FIT.Khi=A(I(1),3);
        FIT.FitIndPulseStrict=FitIndPulse;
        FIT.FitIndStrict=FitIndPulse+FIT.MaxInd+1-TrekSet.STP.MaxInd;
        FIT.N=N;
    elseif I(1)>0&&A(I(1))-B(I(1))<TrekSet.Threshold
        FIT.MaxInd=I(1)-1+TrekSet.STP.MaxInd+IndStart-1;
        FIT.A=A(I(1),1);
        FIT.B=A(I(1),2);
        FIT.Khi=A(I(1),3);
        FIT.FitIndPulseStrict=FitIndPulse;
        FIT.FitIndStrict=FitIndPulse+FIT.MaxInd+1-TrekSet.STP.MaxInd;
        FIT.N=N;
    elseif I(2)>0
        FIT.MaxInd=I(2)-1+TrekSet.STP.MaxInd+IndStart-1;
        FIT.A=B(I(2),1);
        FIT.B=B(I(2),2);
        FIT.Khi=B(I(2),3);
        FIT.N=TrekSet.STP.MaxInd;
        FIT.FitIndPulseStrict=FitIndPulseL;
        FIT.FitIndStrict=FitIndPulseL+FIT.MaxInd+1-TrekSet.STP.MaxInd; 
    else
        FIT.MaxInd=Ind+IndStart-1;
        FIT.A=0;
        FIT.B=0;
        FIT.Khi=inf;
        FIT.N=0;
        FIT.FitIndPulseStrict=FitIndPulse;
        FIT.FitIndStrict=FitIndPulse+FIT.MaxInd+1-TrekSet.STP.MaxInd; 
    end;        
    FIT.Good=all((TrekSetIn.trek(FIT.FitIndStrict-1)-FIT.A*FIT.FitPulse(FIT.FitIndPulseStrict)-FIT.B)<TrekSet.OverSt*TrekSet.StdVal);
    if FIT.Good
        FIT.ShiftRangeR=5;
        FIT.ShiftRangeL=5;
    else
        FIT.ShiftRangeR=10;
        FIT.ShiftRangeL=10;
    end;
    FIT=TrekSDDGetFitInd(TrekSetIn,FIT);
    FIT.FitFast=false;
    FIT.BGLineFit=[0,0];
    break;
end;
Ind=Ind+1;
T=toc(timeId);
end; %while Short
    if ~isempty(FIT)
        break;
    end;
end;%while Long
    
fprintf('Fit by move time %3.2f\n',toc(timeId));

