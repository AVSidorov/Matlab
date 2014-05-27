function PartsSet=PartsSearch(bool,MinSpace)

if nargin<2
    MinSpace=2;
end;


Ind=find(bool);

%if noise is continious this arrays contains only 1
dAfter=circshift(Ind,-1)-Ind; %dist to next
dAfter(end)=0;
dBefore=Ind-circshift(Ind,1); %dist to previous
dBefore(1)=0;

%filling small holes
SmallHole=find(dAfter>1&dAfter<=MinSpace);
for i=1:numel(SmallHole)
    Ind=[Ind;[Ind(SmallHole(i))+1:Ind(SmallHole(i))+dAfter(SmallHole(i))-1]'];
end;    

Ind=sortrows(Ind);


%to make same size
dAfter=circshift(Ind,-1)-Ind; %dist to next
dAfter(end)=0;
dBefore=Ind-circshift(Ind,1); %dist to previous
dBefore(1)=0;


HoleStart=find(dAfter>MinSpace);    % search for breaks 
HoleEnd=find(dBefore>MinSpace);     % very small breaks is not important and take breaks more than 
   
HoleStart=[HoleStart;numel(Ind)]; %to make equal quantity PartLength and HoleStart
HoleEnd=[1;HoleEnd];
PartLength=Ind(HoleStart)-Ind(HoleEnd)+1;
HoleStart=Ind(HoleStart);
HoleEnd=Ind(HoleEnd);

PartsSet.HoleStart=HoleStart;
PartsSet.HoleEnd=HoleEnd;
PartsSet.PartLength=PartLength;

