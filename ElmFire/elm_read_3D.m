function elm_read_3D(filename)
MainTimer=tic;
%% filename check
filename=elm_read_filename(filename);

%% preparing for read
FileInfo=dir(filename);
MemInfo=memory;
fid=fopen(filename);
% determination a number of columns
[InputString,pos]=textscan(fid,'%s',1,'Delimiter','\n');
FileStringLength=pos;
Nrows=FileInfo.bytes/pos;
if mod(FileInfo.bytes,pos)~=0
    error('elm_apps:err:error_size','The file size is not consistent with first string')
end;
NbytesInString=pos;

% format (number of columns) determination
InputVector=textscan(InputString{1,1}{1},'%f');
Ncolumns=numel(cell2mat(InputVector));
formatSpec=repmat('%f',1,Ncolumns);

clear FileInfo InputVector InputString;

%% reading
fseek(fid,0,'bof');
MatFile=matfile([filename,'.mat'],'Writable',true);
MatFile.tbl=zeros(Nrows,Ncolumns);

PartK=4; %this coefficent determines the ratio of part size in bytes to full available memory
rowInd=1;
while ~feof(fid)
    MemInfo=memory;
    Nread=round(MemInfo.MaxPossibleArrayBytes/NbytesInString/PartK);
    %    Nread=min([round(MemInfo.MaxPossibleArrayBytes/NbytesInString/PartK),Nrows-rowInd]);
    
    t=tic;
        InputArray=textscan(fid,formatSpec,Nread,'Delimiter',{'\n','c'},'MultipleDelimsAsOne',1);
    fprintf('Reading file time is %7.2f sec\n',toc(t));
    
    t=tic;
        tmp=cell2mat(InputArray);   
    fprintf('Conversion to numeric array time is %7.2f sec\n',toc(t));
    clear InputArray;
    
    t=tic;
        MatFile.tbl(rowInd:rowInd+length(tmp)-1,:)=tmp;
    fprintf('Writing to MAT file time is %7.2f sec\n',toc(t));
    rowInd=rowInd+length(tmp);
    clear tmp;        
end
fclose(fid);

%% Reducing first column with grid point index if it exists
%TODO make this checking before writing whole file.

Nchk=5*10*100*1000; 
    %it's estimation for five time blocks. The exact values could be taken
    %from input files, but this requires additional arguments in the function input,
    %that can be inconvenient in use
chk=MatFile.tbl(1:Nchk,1);


if all(chk-fix(chk)==0)&&...% check first column values are integer  
    all(diff(chk)==1|diff(chk)==-range(chk))% check step is unity or jump from max value to 1 (min value)
    %check periodicity    
    acf=autocorr(chk,Nchk-1);
    [pks,locs]=findpeaks(acf);
      if all(diff(locs)==range(chk)+1)
          tic; MatFile.tbl=MatFile.tbl(:,2:end); toc;
          MatFile.Ngrid=range(chk)+1;
      end;
end
toc(MainTimer);
