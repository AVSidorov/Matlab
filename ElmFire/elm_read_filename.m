function filename=elm_read_filename(filename)
% function searches file with given name in several subfolders
if ~ischar(filename)
    error('elm_apps:err:wrong_in','The file name must be string');
end;

if exist(['.\out\',filename],'file')==2
    filename=['.\out\',filename];
end;

if exist(['.\3D\',filename],'file')==2
    filename=['.\out\',filename];
end;

if exist(filename,'file')~=2
    error('elm_apps:err:FileNotFound','The file is not found');
end;
