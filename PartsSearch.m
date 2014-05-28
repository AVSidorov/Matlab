function PartsSet=PartsSearch(bool,MinSpace)

if nargin<2
    MinSpace=2;
end;


Ind=find(bool);

%if bool array is continious this arrays contains only 1
dAfter=circshift(Ind,-1)-Ind; %dist to next
dAfter(end)=0;
dBefore=Ind-circshift(Ind,1); %dist to previous
dBefore(1)=0;

%filling small Spaces
SmallSpace=find(dAfter>1&dAfter<=MinSpace);
for i=1:numel(SmallSpace)
    Ind=[Ind;[Ind(SmallSpace(i))+1:Ind(SmallSpace(i))+dAfter(SmallSpace(i))-1]'];
end;    

Ind=sortrows(Ind);
bool=false(size(bool));
bool(Ind)=true;


%to make same size
dAfter=circshift(Ind,-1)-Ind; %dist to next
dAfter(end)=0;
dBefore=Ind-circshift(Ind,1); %dist to previous
dBefore(1)=0;


SpaceStart=find(dAfter>MinSpace);    % search for breaks 
SpaceEnd=find(dBefore>MinSpace);     % very small breaks is not important and take breaks more than 
   
SpaceStart=[SpaceStart;numel(Ind)]; %to make equal quantity PartLength and SpaceStart
SpaceEnd=[1;SpaceEnd];
PartLength=Ind(SpaceStart)-Ind(SpaceEnd)+1;
SpaceStart=Ind(SpaceStart);
SpaceEnd=Ind(SpaceEnd);

PartsSet.SpaceStart=SpaceStart;
PartsSet.SpaceEnd=SpaceEnd;
PartsSet.PartLength=PartLength;
PartsSet.bool=bool;

