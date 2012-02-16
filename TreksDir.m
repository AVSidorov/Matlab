function TreksDir(Directory);
fprintf('>>>>>TreksDir started\n' );
s=clock;
fprintf('Now is %02.0f.%02.0f.%02.0f %02.0f:%02.0f:%4.2f \n',s(3),s(2),s(1),s(4),s(5),s(6));
if nargin<1||isempty(Directory);
    Directory=pwd;
end;
s=dir([Directory,'\*sxr.dat']);
% s=dir('*sxr.dat');
for i=1:size(s,1)
     Trek(s(i).name);
%      TrekStandardPulseSearch(s(i).name)
end;
fprintf('>>>>>TreksDir finished\n' );
s=clock;
fprintf('Now is %02.0f.%02.0f.%02.0f %02.0f:%02.0f:%4.2f\n\n\n',s(3),s(2),s(1),s(4),s(5),s(6));
