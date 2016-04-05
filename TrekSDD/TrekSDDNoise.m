function TrekSet=TrekSDDNoise(TrekSet,varargin)
%% time/ind interval for noise determination
if isfield(TrekSet,'StartTime')&&~isempty(TrekSet.StartTime)
    StartTime=TrekSet.StartTime;
else
    StartTime=0;
end;    
if isfield(TrekSet,'StartPlasma')&&~isempty(TrekSet.StartPlasma)&&TrekSet.StartPlasma>StartTime
    EndTime=TrekSet.StartPlasma;
else
    EndTime=TrekSet.StartTime+(TrekSet.size-1)*TrekSet.tau;
end;
    
nargsin=size(varargin,2);
if ~isempty(varargin)&&mod(nargsin,2)~=0
    disp('incorrect number of input arguments');
    TrekSet.type=0;
    return;
else
    for i=1:fix(nargsin/2) 
        eval([varargin{1+2*(i-1)},'=varargin{2*i};']);
    end;
end;

if isfield(TrekSet,'StartTime')&&~isempty(TrekSet.StartTime)
    StartInd=round((TrekSet.StartTime-StartTime)/TrekSet.tau)+1;
    EndInd=round((EndTime-TrekSet.StartTime)/TrekSet.tau)+1;
else
    StartInd=round(StartTime/TrekSet.tau)+1;
    EndInd=round(EndTime/TrekSet.tau)+1;
end;

%% Initial Noise determination
Ind=StartInd:EndInd;
trek=TrekSet.trek(Ind);
NoiseSet=NoiseStd(trek);
%% Search Long enough parts
bool=abs(trek)<NoiseSet.Thr;
PSet=PartsSearch(bool,3,1000);
Ind=Ind(PSet.bool);
trek=TrekSet.trek(Ind);
NoiseSet=NoiseStd(trek);
%% Search noise using assumpition that noise is normal distibuted
% NoiseSet=NoiseHist(trek,NoiseSet);
%% Correction Threshold due to full size of trek
% TODO

%% Output
TrekSet.NoiseSet=NoiseSet;
%recalculate indexes to TrekSet.trek indexes
TrekSet.NoiseSet.NoiseInd=Ind(TrekSet.NoiseSet.NoiseInd);
TrekSet.trek=TrekSet.trek-NoiseSet.MeanVal;
TrekSet.MeanVal=0;
TrekSet.MaxSignal=TrekSet.MaxSignal-NoiseSet.MeanVal;
TrekSet.MinSignal=TrekSet.MinSignal-NoiseSet.MeanVal;
TrekSet.Threshold=NoiseSet.Thr;
TrekSet.StdVal=NoiseSet.StdVal;

if isfield(TrekSet,'STP')&&~isempty(TrekSet.STP)&&isstruct(TrekSet.STP)
    longD=trek-circshift(trek,TrekSet.STP.FrontN);    
    NoiseSet=NoiseStd(longD);
    %NoiseSet=NoiseHist(LongD,NoiseSet);
    TrekSet.ThresholdLD=NoiseSet.Thr;
end;
