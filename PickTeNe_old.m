function [Te,Ne]=PickTeNe(Time);
Time=Time/1000;
FileName=input('Input Te array name or Name of variable, default is manual input\n','s');
if isempty(FileName)
    Te=input('Input Te in keV\n');
else
    Te_Arr=evalin('base',FileName);
    Te=interp1(Te_Arr(:,1),Te_Arr(:,2),Time)/1000;
    fprintf('At time %2.2f ms Te interpolated is %4.3f keV\n',Time,Te);
end;
FileName=input('Input Ne array name or Name of variable, default is manual input\n','s');
if isempty(FileName)
    Ne=input('Input Ne in 10^13cm-3\n');
else
    Ne_Arr=evalin('base',FileName);
    Ne=interp1(Ne_Arr(:,1),Ne_Arr(:,2),Time);
    fprintf('At time %2.2f ms Ne interpolated is %4.3f*10^13cm^-3 \n',Time,Ne);
end;
