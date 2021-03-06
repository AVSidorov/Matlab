function TrekSet=TrekRecognize(TrekSetIn,varargin)
%This function inits TrekSet and check existense of file (if file name
%inputed)



%TrekSet.FileType='int16';      %choose file type for precision in fread function 
TrekSet.FileType='single';      %choose file type for precision in fread function 
TrekSet.tau=0.02;               %ADC period
TrekSet.StartOffset=[];       %in us old system was Tokamak delay + 1.6ms
TrekSet.OverSt=3;               %uses in StdVal
TrekSet.STP=[];
% TrekSet.StandardPulseFile='D:\!SCN\EField\StandPeakAnalys\StPeak20ns_1.dat';
%TrekSet.StandardPulseFile='D:\!SCN\EField\StandPeakAnalys\StPeak.dat';
TrekSet.MaxSignal=4095;
TrekSet.MinSignal=0;
TrekSet.peaks=[];
TrekSet.StdVal=0;
TrekSet.Threshold=[];
TrekSet.StartTime=TrekSet.StartOffset;
% TrekSet.StartTime=3e4;
TrekSet.Plot=true;
TrekSet.type=[];              
TrekSet.FileName=[];
TrekSet.size=[];
TrekSet.name=[];
TrekSet.StandardPulse=[];
TrekSet.MeanVal=[];
TrekSet.PeakPolarity=-1;
TrekSet.charge=[];
TrekSet.Date=[];
TrekSet.Shot=[];
TrekSet.Amp=[];
TrekSet.HV=[];
TrekSet.P=[];
TrekSet.Merged=false; %This field is neccessary to avoid repeat merging and Max/MinSignal level changing 
TrekSet.trek=[];


nargsin=size(varargin,2);
if ~isempty(varargin)&&mod(nargsin,2)~=0
    disp('incorrect number of input arguments');
    TrekSet.type=0;
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
        TrekSet.name=name;
        if not(isempty(regexp(name,'^(\d{2,3})(sxr)([2,3,4])?$')))
            TrekSet.Shot=str2num(regexprep(name,'^(\d{2,3})(sxr)([2,3,4])?$','$1'));
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

    if isempty(TrekSet.P)
        TrekSet.P=input('input Pressure in atm\n');
        if isempty(TrekSet.P)  TrekSet.P=1; end;
    end;

    if isempty(TrekSet.HV)
        TrekSet.HV=input('input HighVoltage(HV)value in Volts\n');
        if isempty(TrekSet.HV) TrekSet.HV=1700; end;
    end;
    
    
    if isempty(TrekSet.Amp)
        TrekSet.Amp=input('input Amplification number(1-6) or value 1,1.123,3.3333,10.3333,32.85,94.3333\n');
        if isempty(TrekSet.Amp) TrekSet.Amp=1; end;
    end;
    
    if isempty(TrekSet.StartOffset)
        TrekSet.StartOffset=input('input StartOffset in us\n');
        if isempty(TrekSet.StartOffset) TrekSet.StartOffset=0; end;
    end;
    
    
    switch TrekSet.Amp
        case 2
            TrekSet.Amp=1.123;
        case 3
            TrekSet.Amp=3.3333;
        case 4
            TrekSet.Amp=10.3333;
        case 5
            TrekSet.Amp=32.85;
        case 6
            TrekSet.Amp=94.3333;
    end;          

    
      
 
 

 
