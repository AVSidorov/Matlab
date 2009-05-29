function [SXRSmooth]=sxr1(FileName,SmoothParam,Plot1,Plot2);
if isempty(SmoothParam) SmoothParam=100; end;
if isempty(Plot1) Plot1=true; end;
if isempty(Plot2) Plot2=true; end;
if isstr(FileName) 
    SXR=load(FileName); 
else
    SXR=FileName;
end;
SXRSmooth(:,1)=SXR(:,1);
for i=2:15 
    SXRSmooth(:,i)=smooth(SXR(:,i),SmoothParam);
end;
if Plot1|Plot2
    if isstr(FileName)
        figure('Name',[FileName,' Smooth',num2str(SmoothParam),' Points']);
    else
        figure;
    end;
    hold on;
    if Plot1 plot(SXR(:,1),SXR(:,2:15)); end;
    if Plot2 plot(SXRSmooth(:,1),SXRSmooth(:,2:15),'-'); end;
end;
end;