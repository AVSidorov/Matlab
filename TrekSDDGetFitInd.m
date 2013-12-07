function FIT=TrekSDDGetFitInd(TrekSet,FIT)

StpN=TrekSet.STP.size;
maxI=TrekSet.STP.MaxInd;

TailInd=TrekSet.STP.TailInd;
FrontN=TrekSet.STP.FrontN;
%TODO introduce point into STP (where is min of diff on Pulse front)
%for coorect min length determination
MinPartLength=20; %This is better




MinSpace=1;
BckgFitN=5;

Ind=FIT.MaxInd;

FitInd=[1:StpN]'+Ind-maxI;
FitInd=FitInd(FitInd<=TrekSet.size&FitInd>=1);
FitIndPulse=FitInd-Ind+maxI;

%!!!That's may be bad for PeakOnFront
% if Ipulse<numel(TrekSet.SelectedPeakInd)
%     FitInd=FitInd(FitInd<=TrekSet.SelectedPeakInd(Ipulse+1)-FrontN);
%     FitIndPulse=FitInd-Ind+maxI;
% end;


FitPulse=FIT.FitPulse*FIT.A+FIT.B;
% BGLine=polyval(FIT.BGLineFit,FitInd);
BGLine=zeros(numel(FitInd),1);

%% StrictInd determination

if isfield(FIT,'FitIndStrict')&&~isempty(FIT.FitIndStrict)
    FitIndStrict=FIT.FitIndStrict;
else
    %!!!That's may be bad for PeakOnFront
    %FitIndStrict=FitInd(1):Ind;
    FitIndStrict=[];
end;

if isfield(FIT,'FitIndPulseStrict')&&~isempty(FIT.FitIndPulseStrict)
    FitIndPulseStrict=FIT.FitIndPulseStrict;
else
    FitIndPulseStrict=[];
end;
FitIndPulseStrict(FitIndPulseStrict+Ind-maxI<1&FitIndPulseStrict+Ind-maxI>TrekSet.size)=[];


%% Main FitInd determination by StdVal

bool=abs(TrekSet.trek(FitInd)-BGLine-FitPulse(FitIndPulse))<TrekSet.OverSt*TrekSet.StdVal;
%adding points over limits
if any(TrekSet.trek(FitInd)>=TrekSet.MaxSignal)
    if find(TrekSet.trek(FitInd)>=TrekSet.MaxSignal,1,'first')>1&&... %to avoid adding points on interval ends
        find(TrekSet.trek(FitInd)>=TrekSet.MaxSignal,1,'last')<FitIndPulse(end) 
        bool(TrekSet.trek(FitInd)>=TrekSet.MaxSignal)=true;
    end;
end;
% map FitIndPulseStrict on to bool(=FitInd) adding
FitIndPulseStrict=FitIndPulseStrict(FitIndPulseStrict>=1&FitIndPulseStrict<=numel(FitInd)); % to avoid indexing error
bool(FitIndPulseStrict)=true; %map
%map FitIndStrict to bool 
FitIndPulseStrict=FitIndStrict-Ind+maxI;  %transform FitIndStrict to indexes in short (FitInd) space 
FitIndPulseStrict=FitIndPulseStrict(FitIndPulseStrict>=1&FitIndPulseStrict<=numel(FitInd)); % to avoid indexing error
bool(FitIndPulseStrict)=true; %map

FitInd=FitInd(bool);
FitIndPulse=FitIndPulse(bool);


%% Searching spaces in Fit indexes

%if FitPulse is continious this arrays contains only 1
dAfter=circshift(FitIndPulse,-1)-FitIndPulse; %dist to next
dAfter(end)=0;
dBefore=FitIndPulse-circshift(FitIndPulse,1); %dist to previous
dBefore(1)=0;

%filling small holes
SmallHole=find(dAfter>1&dAfter<=MinSpace);
for i=1:numel(SmallHole)
    FitInd=[FitInd;[FitInd(SmallHole(i))+1:FitInd(SmallHole(i))+dAfter(SmallHole(i))-1]'];
end;    

FitInd=sortrows(FitInd);
FitIndPulse=FitInd-Ind+maxI;

%to make same size
dAfter=circshift(FitIndPulse,-1)-FitIndPulse; %dist to next
dAfter(end)=0;
dBefore=FitIndPulse-circshift(FitIndPulse,1); %dist to previous
dBefore(1)=0;

%take first not short part after maximum
HoleStart=find(dAfter>MinSpace);    % search for breaks 
HoleEnd=find(dBefore>MinSpace);     % very small breaks is not important and take breaks more than 
   
HoleStart=[HoleStart;numel(FitInd)]; %to make equal quantity PartLength and HoleStart
HoleEnd=[1;HoleEnd];
PartLength=FitInd(HoleStart)-FitInd(HoleEnd)+1;

PartLength(HoleEnd>TailInd)=[]; %remove parts after TailInd 
                                                        %HoleEnd is before HoleStart with same number

% This is till TailFit is not introduced

if ~isempty(FitIndPulseStrict)
    PartInd=find(FitIndPulse(HoleStart)>=FitIndPulseStrict(end),1,'first');
elseif ~isempty(FitIndPulse)
    PartInd=find(FitInd(HoleStart)>=FitIndStrict(end),1,'first');
else
    PartInd=find(PartLength>=MinPartLength,1,'first'); %take first longenough part
end;
if ~isempty(PartInd)
    FitIndPulse=FitIndPulse(HoleStart(PartInd)-PartLength(PartInd)+1:HoleStart(PartInd));
end;
FitInd=FitIndPulse+Ind-maxI;

%% Reducing last points in case PeakOnFront
if FitInd(end)<TrekSet.size&&FitIndPulse(end)<FIT.FitPulseN&&(TrekSet.trek(FitInd(end)+1)-FitPulse(FitIndPulse(end)+1))>=TrekSet.OverSt*TrekSet.StdVal
    tr=diff(TrekSet.trek(FitInd));
    trL=circshift(tr,-1);
    trL(end)=max(tr);
    trR=circshift(tr,1);
    trR(1)=0;
    MinIndBool=tr<=trL&tr<=trR;
    MinInd=find(MinIndBool);
    if ~isempty(MinInd)
        FitInd=FitInd(1:MinInd(end));
        FitIndPulse=FitIndPulse(1:MinInd(end));
    end;
end;
%% Final
FIT.FitInd=FitInd;
FIT.FitIndPulse=FitIndPulse;
FIT.N=numel(FitInd);
% FIT.BGLineFit=polyfit(FIT.FitInd,TrekSet.trek(FIT.FitInd)-FIT.FitPulse(FitIndPulse)*FIT.A,1);
FIT.BGLineFit=[0,0];

