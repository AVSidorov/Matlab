function TrekStandardPulseSearch(TrekSet)
%
%
%
tic;
fprintf('>>>>>>>>>>>>>>>>>>>>> Trek started\n');

%Checking for existing and initialization
TrekSet=TrekRecognize(TrekSet);

if TrekSet.type==0 return; end;

TrekSet=TrekLoad(TrekSet);

%Loading Standard Pulse
TrekSet.STP=StpStruct;

TrekSet=TrekStdVal(TrekSet);
TrekSet.Threshold=50;   
            
%Searching for Indexes of potential Peaks
   
TrekSet=TrekPeakSearch(TrekSet,false);
TrekAlonePeakSearch(TrekSet);




