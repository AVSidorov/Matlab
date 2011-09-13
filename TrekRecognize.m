function TrekSet=TrekRecognize(FileName,TrekSetIn);

TrekSet=TrekSetIn;

if not(isstr(FileName)); 
     TrekSet.type=8;
 else
     TrekSet.type=exist(FileName);
 end;



 switch TrekSet.type
    case 0
        disp('File not found');
        return;
    case 8,1;
        disp('Variable');
        TrekSet.name=inputname(1);
        TrekSet.FileName='unknown';
        if min(size(FileName))>2
            disp('Wrong array size');
            TrekSet.type=0;
        else
            TrekSet.size=max(size(FileName));
            TrekSet.Shot=input('input shot(file) number\n');
       end;
    case 2
        fprintf('File %s\n',FileName);
        TrekSet.FileName=FileName;
        s=dir(FileName);
        TrekSet.size=s.bytes;
        switch TrekSet.FileType
            case 'single'
                TrekSet.size=TrekSet.size/4;
            case 'int16'
                TrekSet.size=TrekSet.size/2;
        end;
        [pathstr, name, ext, versn]=fileparts(FileName);
        TrekSet.name=name;
        if not(isempty(regexp(name,'^(\d{2})+(sxr|sxr2)$')))
            TrekSet.Shot=str2num(name(1:2));
        else
            TrekSet.Shot=input('input shot(file) number\n');
        end;
            
     otherwise
        disp('Not supported type');
        TrekSet.type=0;
        return;
  end;

    if isempty(TrekSet.Date)
        TrekSet.Date=input('input Date of file in format yymmdd\n');
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

    
      
 
 

 
