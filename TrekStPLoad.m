function TrekSet=TrekStPLoad(TrekSetIn);
TrekSet=TrekSetIn;

if isempty(TrekSet.StandardPulse)
    if exist(TrekSet.StandardPulseFile,'file');
         TrekSet.StandardPulse=load(TrekSet.StandardPulseFile);
    end;
end;
if size(TrekSet.StandardPulse,1)<size(TrekSet.StandardPulse,2)
    TrekSet.StandardPulse=TrekSet.StandardPulse'; %all arrays are horizontal
end;
    