function peaks=PeaksMerge(peaks1,peaks2)
space=2;
if peaks2.Threshold>peaks1.Threshold
    peaks=peaks2;
    peaks2=peaks1;
    peaks1=peaks;
    clear peaks;
end;
Ind=find(peaks2.trek(peaks1.Ind(:,1))<peaks2.Threshold);
peaks1.Ind(Ind,:)=[];


bool=false(peaks1.size,1);
bool1=bool;
bool2=bool;

bool1(peaks1.Ind(:,1))=true;
bool2(peaks2.Ind)=true;

bool=bool1|bool2;
boolAlt=bool;
% remove peaks with small distance (different markers for same pulse)
Ind=find(bool);
dInd=diff(Ind);
IndDoubled=sort([Ind(dInd<=space);Ind(dInd<=space)+dInd(dInd<=space)]);
boolDoubled=false(peaks1.size,1);
boolDoubled(IndDoubled)=true;
bool(boolDoubled&bool2)=false;
boolAlt(boolDoubled&bool1)=false; % to save history of marker moving 

origin=zeros(peaks1.size,1);
origin(bool&bool2)=2;
origin(bool&bool1)=1;
origin(bool&(boolDoubled|(bool1&bool2)))=3;
Ind=find(bool);
IndL=circshift(Ind,-1);
IndR=circshift(Ind,1);
boolCombine=origin(Ind)==2&origin(IndL)==1&origin(IndR)==1&peaks2.trek(Ind)>peaks2.trek(IndL)&peaks2.trek(IndR);
IndCombine=Ind(boolCombine);
bool(IndCombine)=false;
boolAlt(IndCombine)=false;
boolFinal1=bool;


% bool=bool1;
% bool2(bool)=false;  
% 
% Amps=zeros(size(bool2));
% Amps(bool2)=peaks2.trek(bool2);
% bool=bool|(Amps>=peaks2.Threshold&Amps<=peaks1.Threshold);
% Ind=find(bool);
% dInd=diff(Ind);
% IndDoubled=sort([Ind(dInd<=space);Ind(dInd<=space)+dInd(dInd<=space)]);
% boolDoubled=false(peaks1.size,1);
% boolDoubled(IndDoubled)=true;
% bool(boolDoubled&bool2)=false;
% boolFinal2=bool;
% 
% bool=xor(boolFinal1,boolFinal2);


peaks=peaks2;
% peaks.Ind=peaks1.Ind;
peaks.Ind=find(boolFinal1);
% peaks.Ind(:,end+1)=find(boolAlt);
peaks.StepMarker=peaks1.StepMarker;
peaks.StepMarker(~boolFinal1)=0;
peaks.StepMarker(boolFinal1&~bool1)=peaks2.step;