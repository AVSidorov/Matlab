function Theta=elm_grid_thetaReal2Theta(theta,icri,r)
% transforming from geometrical theta to grid poloidal angle Theta 
if nargin<2||isempty(icri)
    return;
end;
if nargin<3
    r=icri.elm1.a;
end
Theta=theta;
bool=theta>=0&theta<=pi;
asp=r/icri.elm1.r0;
Theta(bool)=acos((cos(theta(bool))+asp)./(1+asp*cos(theta(bool))));
Theta(~bool)=2*pi-acos((cos(theta(~bool))+asp)./(1+asp*cos(theta(~bool))));
