function TrekSet=TrekLoad(TrekSetIn)
%% Make field TrekSet.trek not empty
tic;
TrekSet=TrekSetIn;
if not(isfield(TrekSet,'trek'))
   TrekSet.trek=[];
end;

if isempty(TrekSet.trek)
    TrekSet.type=exist(TrekSet.FileName,'file');
    if TrekSet.type==2
        if not(isfield(TrekSet,'StartTime'))
            TrekSet.StartTime=[];
        end;
        if isempty(TrekSet.StartTime)
            TrekSet.StartTime=TrekSet.StartOffset; %StartOffset init in TrekRecognize
        end;
        switch TrekSet.FileType;
         case 'single';
            fid=fopen(TrekSet.FileName);
            StartPosition=round((TrekSet.StartTime-TrekSet.StartOffset)/TrekSet.tau);
            StartPosition=StartPosition*4;
            fseek(fid,StartPosition,'bof');
            [TrekSet.trek,count]=fread(fid,TrekSet.size,TrekSet.FileType);
            fclose(fid);
            TrekSet.size=count;
         case 'int16';
            fid=fopen(TrekSet.FileName);
            StartPosition=round((TrekSet.StartTime-TrekSet.StartOffset)/TrekSet.tau);
            StartPosition=StartPosition*2;
            fseek(fid,StartPosition,'bof');
            [TrekSet.trek,count]=fread(fid,TrekSet.size,TrekSet.FileType);
            fclose(fid);
            TrekSet.size=count;
        end;
        fprintf('Loading time of %3.0f points=                               %7.4f  sec\n',count ,toc); 
%       TrekSet.trek=TrekSet.trek(1:pow2(fix(log2(TrekSet.size)))); %make number of points pow of 2
        TrekSet.size=numel(TrekSet.trek);
        if range(TrekSet.trek)<5    
            fprintf('Trek is probably in volts.\n Converting to counts will be performed common with base line determination\n');
        else
            bool=(TrekSet.trek(:)>4095)|(TrekSet.trek(:)<0); OutRangeN=size(find(bool),1); 
            if OutRangeN>0; fprintf('%7.0f  points out of the ADC range  \n',OutRangeN); end; 
            TrekSet.trek(bool,:)=[];  clear bool
        end;

        i=find(TrekSet.trek,1,'last'); %remove zero points from end of trek
        if i==TrekSet.size-8
            TrekSet.trek(i+1:end)=[];
        end;
    else
        return;
    end;
end;



TrekSet.size=numel(TrekSet.trek);


fprintf('Trek size is %3.0f points\n',TrekSet.size); 

if size(TrekSet.trek,1)<size(TrekSet.trek,2)
    TrekSet.trek=TrekSet.trek'; %all arrays are vertical
end;
 

