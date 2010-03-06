function TrekSet=TrekStPLoad(TrekSetIn);
TrekSet=TrekSetIn;

if exist(TrekSet.StandardPulseFile,'file');
     TrekSet.StandardPulse=load(TrekSet.StandardPulseFile);
end;