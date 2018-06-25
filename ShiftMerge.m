function [TrekMerged,trek,sh]=ShiftMerge(TrekIn,shifts)
Type='single';
if ischar(TrekIn)    
    if ~isempty(regexp(TrekIn,'^(\d{2,3}sxr)([2,3,4])?(.dat)$'))
        FileBase=regexprep(TrekIn,'^(\d{2,3}sxr)([2,3,4])?(.dat)$','$1');
        FileSufix=regexprep(TrekIn,'^(\d{2,3}sxr)([2,3,4])?(.dat)$','$2');
    end;
end;

for i=1:4
 if i==1 Ch=''; else Ch=num2str(i); end;
   FileName=[FileBase,Ch,'.dat'];   
   if exist(FileName,'file')==2
        switch Type;
             case 'single';
                fid=fopen(FileName);
                trek(:,i)=fread(fid,inf,Type);
                fclose(fid);
             case 'int16';
                fid=fopen(FileName);
                trek(:,i)=fread(fid,inf,FileType);
                fclose(fid);
        end;
   end; 
end;

N=size(trek,1);
n=size(trek,2);
for i=1:n
    trek(:,i)=trek(:,i)-mean(trek(:,i));
end;
if nargin<2
    for i=2:n
        sh(i,1)=fminbnd(@(sh)FitMoved(trek(:,1),trek(:,i),[1:N],[5:N-5],100,100,sh,@FitShift,@FitNoFit),-2,2);
    end;
else
    sh=shifts;
end;
for i=1:n
    TrekMerged((i-1)*N+1:i*N,1)=[1:N]+sh(i);
    TrekMerged((i-1)*N+1:i*N,2)=trek(:,i);
end;
TrekMerged=sortrows(TrekMerged);

