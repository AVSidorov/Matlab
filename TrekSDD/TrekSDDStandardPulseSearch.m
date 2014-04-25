function TrekSDDStandardPulseSearch(TrekSet,varargin)
%
%
%
tic;
fprintf('>>>>>>>>>>>>>>>>>>>>> Trek started\n');

%Checking for existing and initialization
TrekSet=TrekRecognize(TrekSet,varargin{:});

if TrekSet.type==0 return; end;

TrekSet=TrekLoad(TrekSet);
TrekSet=TrekSDDStdVal(TrekSet);
TrekSet.Threshold=18;   
            
%Searching for Indexes of potential Peaks
for i=1:fix(TrekSet.size/2^23)  
    T=TrekSet;
    T.trek=TrekSet.trek(1+(i-1)*2^23:i*2^23);
    T.size=numel(T.trek);
    T=TrekSDDPeakSearch(T,false);
    TrekSDDAlonePeakSearch(T);
end;




