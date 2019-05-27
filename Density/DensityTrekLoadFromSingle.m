function [trek,FileName,PathStr]=DensityTrekLoadFromSingle

[FileName,PathName,FilterIndex]=uigetfile('*.dat','Pick .dat file of single with video signal');
trek=[];
if isstr(FileName)
    fid=fopen(fullfile(PathName,FileName),'r');
    trek=fread(fid,inf,'single');
    fclose(fid);
    trek(end-8:end)=[];
    trek=trek-mean(trek);
end;
    
    