function PartsSet=PartsSearch(bool,MinSpace,MinPart)

if nargin<2
    MinSpace=2;
    MinPart=MinSpace;
end;
if nargin<3
    MinPart=MinSpace;
end;

Space=MinSpace;

for I=1:2 %two times cycle is for separate filling spaces and removing small parts (filling spaces in inverted logic array)
    Ind=find(bool);

    %% if bool array is continious this arrays contains only 1
    dAfter=circshift(Ind,-1)-Ind; %dist to next
    dAfter(end)=0;
    dBefore=Ind-circshift(Ind,1); %dist to previous
    dBefore(1)=0;

    %% filling small Spaces
    SmallSpace=find(dAfter>1&dAfter<=Space);
    for i=1:numel(SmallSpace)
        Ind=[Ind;[Ind(SmallSpace(i))+1:Ind(SmallSpace(i))+dAfter(SmallSpace(i))-1]'];
    end;    

    Ind=sortrows(Ind);
    bool=false(size(bool));
    bool(Ind)=true;
    %% invert bool array for removing small parts
        bool=not(bool); % so this line will be evaluated two times bool is "almost original"
        Space=MinPart; 
end;    

%% Renew distant Arrays make same size
Ind=find(bool);

dAfter=circshift(Ind,-1)-Ind; %dist to next
dAfter(end)=0;
dBefore=Ind-circshift(Ind,1); %dist to previous
dBefore(1)=0;


%% Search for markers of parts
SpaceStart=find(dAfter>MinSpace);    % search for breaks 
SpaceEnd=find(dBefore>MinSpace);     % very small breaks is not important and take breaks more than 
   
%% make equal quantity SpaceStart and SpaceEnd
 %here indexes are in short range 
 %in range of (number true points) = %numel(Ind) = numel(dAfter)

SpaceStart=[SpaceStart;numel(Ind)]; % last point in Ind never be automatic in SpaceStart because dAfter(end)=0 (after circular shift correcting)
                                    % last true point is always SpaceStart 
SpaceEnd=[1;SpaceEnd];  % first point will be never in SpaceEnd because dBefore(1)=0 (after circular shift correction)              

 %come to indexes in full size(bool) range
 % SpaceEnd is before SpaceStart with same index 
 % (so this is PartStart and PartEnd correspondingly)
SpaceStart=Ind(SpaceStart); 
SpaceEnd=Ind(SpaceEnd);

PartLength=SpaceStart-SpaceEnd+1; % one is for correct number of points in part (if distance 1 so this is 2 points

%% Final Output
PartsSet.SpaceStart=SpaceStart;
PartsSet.SpaceEnd=SpaceEnd;
PartsSet.PartLength=PartLength;
PartsSet.bool=bool;

