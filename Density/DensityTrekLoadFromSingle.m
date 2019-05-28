function [trek,FileName,PathName]=DensityTrekLoadFromSingle

[FileName,PathName,FilterIndex]=uigetfile('*.dat','Pick .dat file of single with video signal','MultiSelect','on');
trek=[];
if isnumeric(FileName)&&FileName==0       
    return;
end;

if ischar(FileName)
    FileName=cellstr(FileName);
end;

for i=1:numel(FileName)
    fid=fopen(fullfile(PathName,FileName{i}),'r');
    trek(:,i)=fread(fid,inf,'single');
    fclose(fid);    
    trek(:,i)=trek(:,i)-mean(trek(1:end-8,i));
end;
trek(end-7:end,:)=[];
%make length trek even
if mod(length(trek),2)==1
    trek(end,:)=[];
end;

    
    