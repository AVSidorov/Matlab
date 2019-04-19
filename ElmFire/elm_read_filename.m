function filename=elm_read_filename(filename)
filename=FileSearchInDeep(filename);
if isempty(filename);
    error('elm_apps:err:FileNotFound','The file is not found');   
end;
