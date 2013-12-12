function [isNoise,NoiseSet]=TrekSDDisNoise(TrekSet)

MinSpace=2;

noise=abs(TrekSet.trek)<TrekSet.OverSt*TrekSet.StdVal;
noiseInd=find(noise);

if ~isempty(noiseInd)
%% searching spaces

%if noise is continious this arrays contains only 1
dAfter=circshift(noiseInd,-1)-noiseInd; %dist to next
dAfter(end)=0;
dBefore=noiseInd-circshift(noiseInd,1); %dist to previous
dBefore(1)=0;

%filling small holes
SmallHole=find(dAfter>1&dAfter<=MinSpace);
for i=1:numel(SmallHole)
    noiseInd=[noiseInd;[noiseInd(SmallHole(i))+1:noiseInd(SmallHole(i))+dAfter(SmallHole(i))-1]'];
end;    

noiseInd=sortrows(noiseInd);


%to make same size
dAfter=circshift(noiseInd,-1)-noiseInd; %dist to next
dAfter(end)=0;
dBefore=noiseInd-circshift(noiseInd,1); %dist to previous
dBefore(1)=0;


HoleStart=find(dAfter>MinSpace);    % search for breaks 
HoleEnd=find(dBefore>MinSpace);     % very small breaks is not important and take breaks more than 
   
HoleStart=[HoleStart;numel(noiseInd)]; %to make equal quantity PartLength and HoleStart
HoleEnd=[1;HoleEnd];
PartLength=noiseInd(HoleStart)-noiseInd(HoleEnd)+1;
HoleStart=noiseInd(HoleStart);
HoleEnd=noiseInd(HoleEnd);


isNoise=numel(noiseInd)==TrekSet.size;
else
  isNoise=false;
end;
NoiseSet.noise=false(TrekSet.size,1);
NoiseSet.noise(noiseInd)=true;
NoiseSet.noiseInd=noiseInd;
if ~isempty(noiseInd)
    NoiseSet.nParts=numel(PartLength);
    NoiseSet.PartLength=PartLength;
    NoiseSet.HoleStart=HoleStart;
    NoiseSet.HoleEnd=HoleEnd;
else
    NoiseSet.nParts=1;
    NoiseSet.PartLength=TrekSet.size;
    NoiseSet.HoleStart=TrekSet.size;
    NoiseSet.HoleEnd=1;
end;