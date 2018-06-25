function icri=elm_read_icri
% This function reads icri file to obtain structure with modelling settings
icri=struct;
fid=fopen('icri.inp','r');
BlockName=[];
while (~feof(fid))
  if isempty(BlockName)
    BlockTitle=textscan(fid,'&%s',1,'delimiter','\n');
    BlockName=BlockTitle{1,1}{1};
  end
  ParamName='';
  while ~strcmpi(ParamName,'/')
    parameter=textscan(fid,'%q',2,'Delimiter',{', ','=',',\n'});
    ParamName=parameter{1,1}{1};
    if numel(parameter{1,1})>1
        ParamValue=parameter{1,1}{2};
    end
    if ~isempty(strfind(ParamValue,','))
        ParamValue=['[',ParamValue,']'];
    end;
    if strcmpi(ParamValue,'.TRUE.')
        ParamValue='true';
    end;
    if ~strcmpi(ParamName,'/')
        eval(['icri.',BlockName,'.',ParamName,'=',ParamValue,';']);
    end
  end;
  BlockName=ParamValue(2:end);
end;
fclose(fid);