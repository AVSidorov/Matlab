function [phX,phX0]=density_phase_by_grid(y,n,freq)
% x in cm

if nargin<3||isempty(freq)
    f=135e9;    
else
    f=freq;
end;

if ~iscolumn(y)
    y=y';
end

dy=diff(y);
[dPhdL,dPhdL0]=density_den2phase(n,f);
phX=dPhdL(1:end-1,:)'*dy;
phX0=dPhdL0(1:end-1,:)'*dy;