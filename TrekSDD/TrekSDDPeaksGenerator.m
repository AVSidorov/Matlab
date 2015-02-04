function TrekSet=TrekSDDPeaksGenerator(TrekSet,varargin)
% This function generates peaks array in same format as TrekSDDGetPeaks
% This peaks array can be used in TrekSDDMakeTrek
N=1000;
Amp=1000;
TimeStep=TrekSet.STP.size*TrekSet.tau;
AmpNoise=0.0;
AmpNoiseType='unif'; % see random function. Assumes using  'unif' and 'norm'
TimeStepNoise=0.0;
TimeStepType='unif';
TimeStart=TrekSet.STP.size*TrekSet.tau;
if isfield(TrekSet,'StartPlasma')&&~isempty(TrekSet.StartPlasma)
    TimeStart=TimeStart+TrekSet.StartPlasma;
end;

nargsin=size(varargin,2);
if ~isempty(varargin)&&mod(nargsin,2)~=0
    disp('incorrect number of input arguments');
    return;
end;

for i=1:fix(nargsin/2) 
    eval([varargin{1+2*(i-1)},'=varargin{2*i};']);
end;
TrekSet.StartPlasma=TimeStart-TrekSet.STP.size*TrekSet.tau;
TrekSet.peaks=zeros(N,7);

if TimeStepType=='trek'
    t=random('unif',0,TimeStep*N,N,1);
    t=sortrows(t);
    TrekSet.peaks(:,2)=TimeStart+t;
    TrekSet.peaks(:,5)=random('norm',Amp,AmpNoise,N,1);
else   
    TrekSet.peaks(:,2)=TrekSet.STP.size*TrekSet.tau+[1:N]'*TimeStep+random(TimeStepType,0.0,TimeStepNoise,N,1);
    TrekSet.peaks(:,5)=Amp+random(AmpNoiseType,0.0,AmpNoise,N,1);
end;
