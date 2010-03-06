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
     otherwise
        disp('Not supported type');
        TrekSet.type=0;
  end;
  
 
 

 
