function tbl=elm_read_outtable(filename)
if ~ischar(filename)
    error('elm_apps:err:wrong_in','The file name must be string');
end;

if exist(['.\out\',filename],'file')==2
    filename=['.\out\',filename];
end;
if exist(filename,'file')~=2
    error('elm_apps:err:FileNotFound','The file is not found');
end;
fid=fopen(filename);
% determination a number of columns
InputString=textscan(fid,'%s',1,'Delimiter','\n');
InputVector=textscan(InputString{1,1}{1},'%f');
N=numel(cell2mat(InputVector));
formatSpec=repmat('%f',1,N);
fseek(fid,0,'bof');
InputArray=textscan(fid,formatSpec,'Delimiter',{'\n','c'},'MultipleDelimsAsOne',1);
tbl=cell2mat(InputArray);
fclose(fid);
