function Theta=elm_grid_thetaReal2Theta(theta,icri)
% transforming from geometrical theta to grid poloidal angle Theta 
Theta=theta;
if nargin<2||isempty(icri)
    return;
end;
bool=theta>=0&theta<=pi;
asp=icri.elm1.a/icri.elm1.r0;
Theta(bool)=acos((cos(theta(bool))+asp)./(1+asp*cos(theta(bool))));
Theta(~bool)=2*pi-acos((cos(theta(~bool))+asp)./(1+asp*cos(theta(~bool))));
