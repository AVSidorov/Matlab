function np=calc_noise(A,SmoothParam,method);
NA=size(A,1);
if nargin==1
    SmoothParam=NA/100;
    Asm=smooth(A,SmoothParam);
    for i=1:NA
        np=sqrt(sum((A-Asm).^2)/NA);
    end;
end;
if nargin==2
    Asm=smooth(A,SmoothParam);
    for i=1:NA
        np=sqrt(sum((A-Asm).^2)/NA);
    end;
end;
if nargin==3
    Asm=smooth(A,SmoothParam,method);
    for i=1:NA
        np=sqrt(sum((A-Asm).^2)/NA);
    end;
end;