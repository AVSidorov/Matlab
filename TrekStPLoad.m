function TrekSet=TrekStPLoad(TrekSetIn);
TrekSet=TrekSetIn;

if isempty(TrekSet.StandardPulse)
    if exist(TrekSet.StandardPulseFile,'file');
         TrekSet.StandardPulse=load(TrekSet.StandardPulseFile);
    end;
end;