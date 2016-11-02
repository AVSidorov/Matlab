function TrekSet=TrekSDDRecognize(TrekSetIn,varargin)
%This function inits TrekSet and check existense of file (if file name
%inputed)



%TrekSet.FileType='int16';      %choose file type for precision in fread function 
%% Trek Structure Definition
TrekSet.FileType='single';      %choose file type for precision in fread function 
TrekSet.tau=0.02;               %ADC period

TrekSet.StartOffset=[];       %in us old system was Tokamak delay + 1.6ms
TrekSet.StartTime=TrekSet.StartOffset;
TrekSet.StartPlasma=15000;      %Common value may change in calibration treks

TrekSet.MeanVal=[];
TrekSet.OverSt=3.5;               %uses in StdVal
TrekSet.StdVal=0;
TrekSet.Threshold=[];
TrekSet.ThresholdLD=[];
TrekSet.PeakPolarity=1;
TrekSet.NoiseSet=[];

TrekSet.STP=StpStruct('D:\!SCN\StandPeakAnalys\StPeakSDD_20ns_3.dat');
% TrekSet.StandardPulseFile='D:\!SCN\EField\StandPeakAnalys\StPeak20ns_1.dat';
%TrekSet.StandardPulseFile='D:\!SCN\EField\StandPeakAnalys\StPeak.dat';

% TrekSet.StartTime=3e4;

TrekSet.type=[];              

TrekSet.FileName=[];
TrekSet.name=[];
TrekSet.Channel=[]; 
TrekSet.Date=[];
TrekSet.Shot=[];
TrekSet.Amp=[];

TrekSet.trek=[];
TrekSet.size=[];
TrekSet.MaxSignal=4095;
TrekSet.MinSignal=0;

TrekSet.Merged=false; %This field is neccessary to avoid repeat merging and Max/MinSignal level changing 
TrekSet.Plot=true;
TrekSet.Nfit=10;

TrekSet.peaks=[];

%%

nargsin=size(varargin,2);
if ~isempty(varargin)&&mod(nargsin,2)~=0
    disp('incorrect number of input arguments');
    TrekSet.type=0;
    return;
end;

if nargin<1||isempty(TrekSetIn)
    disp('Empty TrekSet structure created');
    return;
end;

if isstr(TrekSetIn); 
    TrekSet.type=exist(TrekSetIn); 
else
    TrekSet.type=1;
end;



 switch TrekSet.type
    case 0
        disp('File not found');
        return;
    case 1;
        disp('Variable');
        if isstruct(TrekSetIn)
            TrekSet=TrekSetIn;            
        else %in case FileName is trek array
            TrekSet.name=inputname(1);
            TrekSet.FileName='unknown';
            TrekSet.trek=TrekSetIn;
            if min(size(TrekSetIn))>2 % if in trek there are not only signal and time
                disp('Wrong array size');
                TrekSet.type=0;
                return;
            else
                TrekSet.size=max(size(TrekSetIn));
            end;
        end;
    case 2
        fprintf('File %s\n',TrekSetIn);
        TrekSet.FileName=TrekSetIn;
        s=dir(TrekSetIn);
        TrekSet.size=s.bytes;
        switch TrekSet.FileType
            case 'single'
                TrekSet.size=TrekSet.size/4;
            case 'int16'
                TrekSet.size=TrekSet.size/2;
        end;
        [pathstr, name, ext]=fileparts(TrekSetIn);
        if not(isempty(regexp(name,'^(\d{2,3})(sxr)([2,3,4])?$')))
            TrekSet.Shot=str2num(regexprep(name,'^(\d{2,3})(sxr)([2,3,4])?$','$1'));
            TrekSet.name=regexprep(name,'^(\d{2,3})(sxr)([2,3,4])?$','$2');
            TrekSet.Channel=str2num(regexprep(name,'^(\d{2,3})(sxr)([2,3,4])?$','$3'));
            if isempty(TrekSet.Channel)
                TrekSet.Channel=1;
            end;
        end;            
     otherwise
        disp('Not supported type');
        TrekSet.type=0;
        return;
  end;

  
    for i=1:fix(nargsin/2) 
        eval(['TrekSet.',varargin{1+2*(i-1)},'=varargin{2*i};']);
    end;


    if isempty(TrekSet.Date)
        TrekSet.Date=input('input Date of file in format yymmdd\n');
    end;

    if isempty(TrekSet.Shot)
        TrekSet.Shot=input('input Shot number\n');
    end;

    if isempty(TrekSet.Amp)
        TrekSet.Amp=input('input Amplification number(1-6) or value 1,1.123,3.3333,10.3333,32.85,94.3333\n');
        if isempty(TrekSet.Amp) TrekSet.Amp=1; end;
    end;
    
    if isempty(TrekSet.StartOffset)
        TrekSet.StartOffset=input('input StartOffset in us\n');
        if isempty(TrekSet.StartOffset) TrekSet.StartOffset=0; end;
    end;
    
    

    
      
 
 

 
