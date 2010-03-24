function TrekSet=TrekLoad(FileName,TrekSetIn);

tic;
TrekSet=TrekSetIn;

switch TrekSet.FileType;
 case 'single','int16';
    fid=fopen(FileName);
    StartPosition=(TrekSet.StartTime-TrekSet.StartOffset)/TrekSet.tau;
     switch TrekSet.FileType
       case 'single'
            StartPosition=StartPosition*4;
       case 'int16'
            StartPosition=StartPosition*2;
        end;
    fseek(fid,StartPosition,'bof');
    [TrekSet.trek,count]=fread(fid,TrekSet.size,TrekSet.FileType);
    fclose(fid);
    TrekSet.size=count;
end;


while TrekSet.trek(end)==0
    TrekSet.trek(end)=[];
    TrekSet.size=TrekSet.size-1;
end;

fprintf('Loading time of %3.0f points=                               %7.4f  sec\n',count ,toc); 
