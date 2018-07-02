function theta=elm_grid_Theta2theta(Theta,icri)
% transforming from grid poloidal angle Theta to geometrical theta
theta=Theta;
if nargin<2||isempty(icri)
    return;
end;
bool=theta>=0&theta<=pi;
asp=icri.elm1.a/icri.elm1.r0;
theta(bool)=acos((cos(Theta(bool))-asp)./(1-asp*cos(Theta(bool))));
theta(~bool)=2*pi-acos((cos(Theta(~bool))-asp)./(1-asp*cos(Theta(~bool))));
