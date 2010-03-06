function TreksDir(Directory);
if nargin<1||isempty(Directory);
    Directory=pwd;
end;
s=dir([Directory,'\*sxr.dat']);
% s=dir('*sxr.dat');
for i=1:size(s,1)
    Trek(s(i).name)
end;