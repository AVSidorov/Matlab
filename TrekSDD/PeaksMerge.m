function peaks=PeaksMerge(peaks1,peaks2)
space=2;
if peaks2.Threshold>peaks1.Threshold
    peaks=peaks2;
    peaks2=peaks1;
    peaks1=peaks;
    clear peaks;
end;
fwhm=[];
if isfield(peaks2,'fwhm')&&~isempty(peaks2.fwhm)
    fwhm=peaks2.fwhm;
end;
if isempty(fwhm)&&isfield(peaks2,'sigma')&&~isempty(peaks2.sigma)
    fwhm=peaks2.sigma*2*sqrt(2*log(2))/0.02;
end;

%% remove old noise marks
Ind=find(peaks2.trek(peaks1.Ind(:,1))<peaks2.Threshold);
peaks1.Ind(Ind,:)=[];
fprintf('removed %3.0f noise marks\n',numel(Ind));



%% finding peaks to remove
boolDoubled=false(peaks1.size,1);
boolCombine=false(peaks1.size,1);
boolDoubledDouble=false(peaks1.size,1);


bool=false(peaks1.size,1);

bool1=bool;
bool2=bool;

bool1(peaks1.Ind(:,1))=true;
bool2(peaks2.Ind)=true;

bool=bool1|bool2;

Ind=find(bool);
IndL=circshift(Ind,-1);
IndR=circshift(Ind,1);

origin=zeros(peaks1.size,1);
origin(bool1)=origin(bool1)+1;
origin(bool2)=origin(bool2)+2;



% remove peaks with small distance (different markers for same pulse)

dAfter=Ind(1:end-1)-Ind(2:end);
dBefore=Ind(2:end)-Ind(1:end-1);
dAfter=[dAfter;peaks1.size-Ind(end)];
dBefore=[Ind(1);dBefore];
dAfter=abs(dAfter);
IndDoubled=Ind((origin(Ind)==2)&((origin(IndL)==1&dAfter<=space)|(origin(IndR)==1&dBefore<=space)));
boolDoubled(IndDoubled)=true;

IndDoubledDouble=Ind(origin(Ind)==2&origin(IndL)==1&origin(IndR)==1&dAfter<=space&dBefore<=space);
boolDoubledDouble(IndDoubledDouble)=true;

% find combined marks
IndCombine=Ind(origin(Ind)==2&origin(IndL)==1&origin(IndR)==1&(IndL-IndR)<2*fwhm);
boolCombine(IndCombine)=true;


IndRemove=find(boolDoubled|boolCombine);
IndPairL=find((origin(Ind)==1)&(origin(IndR)==2&dBefore<=space)); %indexes in space(size) Ind
IndPairR=find((origin(Ind)==1)&(origin(IndL)==2&dAfter<=space));
Ind(:,2)=Ind;
Ind(IndPairL,2)=IndR(IndPairL);
Ind(IndPairR,2)=IndL(IndPairR);

[C,ia,ib]=intersect(Ind(:,1),IndRemove);
Ind(ia,:)=[];



[C,ia,ib]=intersect(peaks1.Ind(:,1),Ind(:,1));
IndFinal=peaks1.Ind(ia,:);
StepMarker=peaks1.StepMarker(ia);
IndFinal(:,end+1)=Ind(ib,2);
[C,ia]=setdiff(Ind(:,1),IndFinal(:,1));
IndAdd=zeros(numel(ia),size(IndFinal,2));
IndAdd(:,1)=Ind(ia,1);
IndAdd(:,end)=Ind(ia,2);
IndFinal=[IndFinal;IndAdd];
StepMarker=[StepMarker;ones(numel(ia),1)*peaks2.step];
[IndFinal,ia]=sortrows(IndFinal);
StepMarker=StepMarker(ia);

for i=2:size(IndFinal,2)
   idx=find(IndFinal(:,i)==0);
   IndFinal(idx,i)=IndFinal(idx,i-1);
end;


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
peaks.Ind=IndFinal;
peaks.StepMarker=StepMarker;
