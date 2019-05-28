function filename=FileSearchInDeep(filename,basedir)
% function searches file with given name in current directory and subfolders
if ~ischar(filename)
    error('File_apps:err:wrong_in','The file name must be string');
end;
if nargin<2||isempty(basedir)
    basedir=pwd;
end;
Path=genpath(basedir);
Inds=[0,strfind(Path,pathsep)];
ExCode=0;
DirInd=1;
while ExCode~=2&&DirInd<numel(Inds)   
    ExCode=exist(fullfile(Path(Inds(DirInd)+1:Inds(DirInd+1)-1),filename),'file');
    DirInd=DirInd+1;
end
if ExCode==2
    filename=fullfile(Path(Inds(DirInd-1)+1:Inds(DirInd)-1),filename);
else
    filename='';
end;
