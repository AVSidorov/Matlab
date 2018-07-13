function tbl=elm_read_outtable(filename)

filename=elm_read_filename(filename);

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
