function [Integrs]=SpectrInt(FileName);
% This program takes histogram of measured spectra and makes foil signals and foil spectra
%if isempty(SmoothParam) SmoothParam=100; end;
%if isempty(Plot1) Plot1=true; end;
%if isempty(Plot2) Plot2=true; end;
if isstr(FileName) 
    Spectra=load(FileName);
    [path,name,ext,versn]=fileparts(FileName);
else
    Spectra=FileName;
end;
SpectraN=size(Spectra,1);
NSpectra=(size(Spectra,2)-1)/3;
Int=zeros(NSpectra,6);
for TimeI=0:NSpectra-1
 for i=1:SpectraN
        Int(TimeI+1,1)=Int(TimeI+1,1)+exp(-0.12*50/Spectra(i,TimeI*3+2)^3.12)*(1-exp(-345.55/Spectra(i,TimeI*3+2)^2.7))*Spectra(i,TimeI*3+3);
        Int(TimeI+1,2)=Int(TimeI+1,2)+exp(-0.12*150/Spectra(i,TimeI*3+2)^3.12)*(1-exp(-345.55/Spectra(i,TimeI*3+2)^2.7))*Spectra(i,TimeI*3+3);
        Int(TimeI+1,3)=Int(TimeI+1,3)+exp(-0.12*250/Spectra(i,TimeI*3+2)^3.12)*(1-exp(-345.55/Spectra(i,TimeI*3+2)^2.7))*Spectra(i,TimeI*3+3);
        Int(TimeI+1,4)=Int(TimeI+1,4)+exp(-0.12*350/Spectra(i,TimeI*3+2)^3.12)*(1-exp(-345.55/Spectra(i,TimeI*3+2)^2.7))*Spectra(i,TimeI*3+3);
        Int(TimeI+1,5)=Int(TimeI+1,5)+exp(-0.12*450/Spectra(i,TimeI*3+2)^3.12)*(1-exp(-345.55/Spectra(i,TimeI*3+2)^2.7))*Spectra(i,TimeI*3+3);
        Int(TimeI+1,6)=Int(TimeI+1,6)+exp(-0.12*650/Spectra(i,TimeI*3+2)^3.12)*(1-exp(-345.55/Spectra(i,TimeI*3+2)^2.7))*Spectra(i,TimeI*3+3);
 end;
end;
for i=1:6
    Integrs.IntRatio(1:NSpectra,i)=Int(1:NSpectra,1)./Int(1:NSpectra,i);
    Integrs.IntRatio1(1:NSpectra,i)=Int(1:NSpectra,i)./Int(1:NSpectra,1);
end;
%---------
for i=1:6
    IntMin700(1:NSpectra,i)=Int(1:NSpectra,i)-Int(1:NSpectra,6);
end;

for i=1:5
    Integrs.IntRatioMin700(1:NSpectra,i)=IntMin700(1:NSpectra,1)./IntMin700(1:NSpectra,i);
    Integrs.IntRatio1Min700(1:NSpectra,i)=IntMin700(1:NSpectra,i)./IntMin700(1:NSpectra,1);
end;
%---------

for i=1:5
    IntMin500(1:NSpectra,i)=Int(1:NSpectra,i)-Int(1:NSpectra,5);
end;

for i=1:4
    Integrs.IntRatioMin500(1:NSpectra,i)=IntMin500(1:NSpectra,1)./IntMin500(1:NSpectra,i);
    Integrs.IntRatio1Min500(1:NSpectra,i)=IntMin500(1:NSpectra,i)./IntMin500(1:NSpectra,1);
end;
%---------

for i=1:4
    IntMin400(1:NSpectra,i)=Int(1:NSpectra,i)-Int(1:NSpectra,4);
end;

for i=1:3
    Integrs.IntRatioMin400(1:NSpectra,i)=IntMin400(1:NSpectra,1)./IntMin400(1:NSpectra,i);
    Integrs.IntRatio1Min400(1:NSpectra,i)=IntMin400(1:NSpectra,i)./IntMin400(1:NSpectra,1);
end;
%---------

for i=1:3
    IntMin300(1:NSpectra,i)=Int(1:NSpectra,i)-Int(1:NSpectra,3);
end;
for i=1:2
   Integrs.IntRatioMin300(1:NSpectra,i)=IntMin300(1:NSpectra,1)./IntMin300(1:NSpectra,i);
   Integrs.IntRatio1Min300(1:NSpectra,1)=IntMin300(1:NSpectra,i)./IntMin300(1:NSpectra,1);
end;


%mkdir(cd,'StandPulse');
 %PulseFolder=[cd,'\StandPulse\'];
write=false;
 if write
    if isstr(FileName)
        fid=fopen([name,'Int.dat'],'w');     
        fprintf(fid,'Time Be100 Be200 Be300 Be400 Be500 Be700\n');
        fprintf(fid,'%2.2f %3.3f %3.3f %3.3f %3.3f %3.3f %3.3f\n',[[22.46;27.71;32.95;38.14] Int(2:5,:)]');
        fclose(fid);

        fid=fopen([name,'IntR.dat'],'w');
        fprintf(fid,'Time Be100/Be200 Be100/Be300 Be100/Be400 Be100/Be500 Be100/Be700\n');
        fprintf(fid,'%2.2f %3.3f %3.3f %3.3f %3.3f %3.3f\n',[[22.46;27.71;32.95;38.14] IntRatio(2:5,:)]');
        fclose(fid);

        fid=fopen([name,'IntR1.dat'],'w');
        fprintf(fid,'Time Be200/Be100 Be300/Be100 Be400/Be100 Be500/Be100 Be700/Be100\n');
        fprintf(fid,'%2.2f %3.3f %3.3f %3.3f %3.3f %3.3f\n',[[22.46;27.71;32.95;38.14] IntRatio1(2:5,:)]');
        fclose(fid);
        
        fid=fopen([name,'IntRM700.dat'],'w');
        fprintf(fid,'Time Be100/Be200 Be100/Be300 Be100/Be400 Be100/Be500\n');
        fprintf(fid,'%2.2f %3.3f %3.3f %3.3f %3.3f\n',[[22.46;27.71;32.95;38.14] IntRatioMin700(2:5,:)]');
        fclose(fid);

        fid=fopen([name,'IntR1M700.dat'],'w');
        fprintf(fid,'Time Be200/Be100 Be300/Be100 Be400/Be100 Be500/Be100\n');
        fprintf(fid,'%2.2f %3.3f %3.3f %3.3f %3.3f\n',[[22.46;27.71;32.95;38.14] IntRatio1Min700(2:5,:)]');
        fclose(fid);

        fid=fopen([name,'IntRM500.dat'],'w');     
        fprintf(fid,'Time Be100/Be200 Be100/Be300 Be100/Be400\n');
        fprintf(fid,'%2.2f %3.3f %3.3f %3.3f\n',[[22.46;27.71;32.95;38.14] IntRatioMin500(2:5,:)]');
        fclose(fid);

        fid=fopen([name,'IntR1M500.dat'],'w');     
        fprintf(fid,'Time Be200/Be100 Be300/Be100 Be400/Be100\n');
        fprintf(fid,'%2.2f %3.3f %3.3f %3.3f\n',[[22.46;27.71;32.95;38.14] IntRatio1Min500(2:5,:)]');
        fclose(fid);

        fid=fopen([name,'IntRM400.dat'],'w');     
        fprintf(fid,'Time Be100/Be200 Be100/Be300\n');
        fprintf(fid,'%2.2f %3.3f %3.3f\n',[[22.46;27.71;32.95;38.14] IntRatioMin400(2:5,:)]');
        fclose(fid);
        
        fid=fopen([name,'IntR1M400.dat'],'w');     
        fprintf(fid,'Time Be200/Be100 Be300/Be100\n');
        fprintf(fid,'%2.2f %3.3f %3.3f\n',[[22.46;27.71;32.95;38.14] IntRatio1Min400(2:5,:)]');
        fclose(fid);

        fid=fopen([name,'IntRM300.dat'],'w');
        fprintf(fid,'Time Be100/Be200\n');
        fprintf(fid,'%2.2f %3.3f\n',[[22.46;27.71;32.95;38.14] IntRatioMin300(2:5,:)]');
        fclose(fid);

        fid=fopen([name,'IntR1M300.dat'],'w');
        fprintf(fid,'Time Be200/Be100\n');
        fprintf(fid,'%2.2f %3.3f\n',[[22.46;27.71;32.95;38.14] IntRatio1Min300(2:5,:)]');
        fclose(fid);
    
    end;
end;
