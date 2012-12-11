function FIT=TrekGetFitInd(TrekSet,Ind,FIT)

Ipulse=find(TrekSet.SelectedPeakInd==Ind);
StpN=TrekSet.STP.size;
maxI=TrekSet.STP.MaxInd;

TailInd=TrekSet.STP.TailInd;
FrontN=TrekSet.STP.FrontN;




MinSpace=1;


FitInd=[1:StpN]'+Ind-maxI;
FitInd=FitInd(FitInd<=TrekSet.size&FitInd>=1);
FitIndPulse=FitInd-Ind+maxI;

if Ipulse<numel(TrekSet.SelectedPeakInd)
    FitInd=FitInd(FitInd<=TrekSet.SelectedPeakInd(Ipulse+1)-FrontN);
    FitIndPulse=FitInd-Ind+maxI;
end;
Amax=max(TrekSet.trek(FitInd));
if abs(FIT.A+FIT.B-Amax)>TrekSet.StdVal*TrekSet.OverSt
    FIT.A=Amax;
    FIT.B=0;
end;
FitPulse=FIT.FitPulse*FIT.A+FIT.B;
%  FitIndStrict=[FitInd(1):Ind];
%  FitIndPulseStrict=FitIndStrict-Ind+maxI;

if isfield(FIT,'FitIndStrict')&&~isempty(FIT.FitIndStrict)
    FitIndStrict=FIT.FitIndStrict;
else
    FitIndStrict=FitInd(1):Ind;
end;


dPulse=diff(TrekSet.STP.FinePulse);
[md,mdInd]=max(dPulse);
maxId=find(dPulse(mdInd:end)*FIT.A<TrekSet.StdVal*TrekSet.OverSt,1,'first');
maxId=TrekSet.STP.TimeInd(mdInd+maxId);
if isfield(FIT,'FitIndPulseStrict')&&~isempty(FIT.FitIndPulseStrict)
    FitIndPulseStrict=FIT.FitIndPulseStrict;
else
    FitIndPulseStrict=1:round(maxId-FIT.Shift);
end;
FitIndPulseStrict(FitIndPulseStrict+Ind-maxI<1&FitIndPulseStrict+Ind-maxI>TrekSet.size)=[];




bool=abs(TrekSet.trek(FitInd)-FitPulse(FitIndPulse))<TrekSet.Threshold;
FitIndPulseStrict=FitIndPulseStrict(FitIndPulseStrict>=1&FitIndPulseStrict<=numel(FitInd));
bool(FitIndPulseStrict)=true;
FitIndPulseStrict=FitIndStrict-Ind+maxI;
FitIndPulseStrict=FitIndPulseStrict(FitIndPulseStrict>=1&FitIndPulseStrict<=numel(FitInd));
bool(FitIndPulseStrict)=true;

FitInd=FitInd(bool);
FitIndPulse=FitIndPulse(bool);


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

PartInd=find(PartLength>=FrontN,1,'first'); %take first longenough part
if ~isempty(PartInd)
    FitIndPulse=FitIndPulse(HoleStart(PartInd)-PartLength(PartInd)+1:HoleStart(PartInd));
end;
FitInd=FitIndPulse+Ind-maxI;

FIT.FitInd=FitInd;
FIT.FitIndPulse=FitIndPulse;
FIT.N=numel(FitInd);


