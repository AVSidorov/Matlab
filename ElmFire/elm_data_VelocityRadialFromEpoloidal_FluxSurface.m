function Vradial=elm_data_VelocityRadialFromEpoloidal_FluxSurface(Epoloidal,Nr,GridSet,icri)
% Calculates poloidal Electric Field from potential data 
% tbl is npoloidal x ntoroidal x ntime
if isstruct(GridSet)&&isfield(GridSet,'Grid')&&~isempty(GridSet.Grid)
    Grid=GridSet.Grid;
elseif ~isempty(GridSet)&&istable(GridSet)
    Grid=GridSet;
else
    error('elm_aps:err:wronginput','The Grid must be given');
end;

dny=size(Epoloidal,1); %TODO chech Grid.Npoloidal(Nr)==dny
dnz=size(Epoloidal,2);
dnt=size(Epoloidal,3);

Theta=2*pi/Grid.Npoloidal(Nr)*[0:Grid.Npoloidal(Nr)-1]';
theta=elm_grid_Theta2theta(icri,Theta,Nr-1,Grid);
B=icri.elm1.bt./(1+GridSet.Grid.r(Nr)/icri.elm1.r0*cos(theta));
B=repmat(B,1,dnz);
B=repmat(B,1,1,dnt);
Vradial=Epoloidal.*B./(B.*B);