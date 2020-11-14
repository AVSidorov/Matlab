function Out=astra_readAstraOut(filename)
Out=struct;
if isstr(filename)
    [fid,errmsg]=fopen(filename);
    if ~isempty(errmsg)
        error('geqdsk:err:wrongfileopen',errmsg);
    end
else
    error('geqdsk:err:wrongfilename','Input must be String filename');
end
DescString=textscan(fid,'%s',1,'Delimiter','\n');
%TODO string check
DescSplit=textscan(DescString{1,1}{1},'%s','Delimiter',' ','MultipleDelimsAsOne',1);
N=numel(DescSplit{1,1});
% Get params from Header
Out.Desc='';
for i=1:N
    param=textscan(DescSplit{1,1}{i},['%s','%f'],'Delimiter',{'=',' '},'MultipleDelimsAsOne',1);
    if isempty(param{2})
        Out.Desc=[Out.Desc,param{1}{1},' '];
    else
        FromTextToStruct(param{1}{1},param{2},'Out');
    end
end
stP=ftell(fid);
Values=textscan(fid,'%f','Delimiter',' ','MultipleDelimsAsOne',1,'HeaderLines',1);
endP=ftell(fid);
fseek(fid,stP,'bof');
Names=textscan(fid,'%s',length(Values{1}),'Delimiter',' ','MultipleDelimsAsOne',1);
for i=1:length(Values{1})
        FromTextToStruct(Names{1}{i},Values{1}(i));
end;
fseek(fid,endP,'bof');
Names=textscan(fid,'%s',1,'Delimiter','\n');
Names=textscan(Names{1}{1},'%s','Delimiter',{' ','\t'},'MultipleDelimsAsOne',1);
formatSpec=repmat('%s',1,length(Names{1}));
tbl=textscan(fid,formatSpec,'Delimiter',{' ','\n'},'MultipleDelimsAsOne',1);
rows=length(tbl{1});
for i=1:length(tbl)
    tbl{i}=str2double(regexprep(tbl{i},'-(?=[0-9]+$)','E-'));
    rows=min([rows,find(isnan(tbl{i}),1,'first')]);
end
for i=1:length(tbl)
    tbl{i}=tbl{i}(1:rows-1);
end
tbl=cell2mat(tbl);
for i=1:length(Names{1})
    FromTextToStruct(Names{1}{i},tbl(:,i));
end
fclose(fid);
function FromTextToStruct(name,val,StructName)
        name=regexprep(name,'\W','_');
        name=regexprep(name,'^_*','');
        if nargin>2&&ischar(StructName)
            if eval(['isfield(',StructName,',name)'])
                name=[name,'_'];
            end
            eval([StructName,'.',name,'=',num2str(val),';']);
        else
            if isfield(Out,name)
                name=[name,'_'];
            end
            Out.(name)=val;
        end
end    
end