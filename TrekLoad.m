function TrekSet=TrekLoad(FileName,TrekSetIn);

tic;
TrekSet=TrekSetIn;

switch TrekSet.FileType;
 case 'single';
    fid=fopen(FileName);
    StartPosition=(TrekSet.StartTime-TrekSet.StartOffset)/TrekSet.tau;
    StartPosition=StartPosition*4;
    fseek(fid,StartPosition,'bof');
    [TrekSet.trek,count]=fread(fid,TrekSet.size,TrekSet.FileType);
    fclose(fid);
    TrekSet.size=count;
 case 'int16';
    fid=fopen(FileName);
    StartPosition=(TrekSet.StartTime-TrekSet.StartOffset)/TrekSet.tau;
    StartPosition=StartPosition*2;
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
