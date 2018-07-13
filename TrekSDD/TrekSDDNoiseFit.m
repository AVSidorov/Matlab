function TrekSet=TrekSDDNoiseFit(TrekSet,varargin)
StartTime=0;
EndTime=(TrekSet.size-1)*TrekSet.tau;
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
StartInd=round(StartTime/TrekSet.tau)+1;
EndInd=round(EndTime/TrekSet.tau)+1;

trek=TrekSet.trek(StartInd:EndInd);
NoiseSet=NoiseFit(trek);

TrekSet.NoiseSet=NoiseSet;
TrekSet.trek=TrekSet.trek-NoiseSet.MeanVal;
TrekSet.MeanVal=0;
TrekSet.MaxSignal=TrekSet.MaxSignal-NoiseSet.MeanVal;
TrekSet.MinSignal=TrekSet.MinSignal-NoiseSet.MeanVal;
TrekSet.Threshold=NoiseSet.Threshold;
TrekSet.StdVal=NoiseSet.StdVal;

