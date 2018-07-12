function [x y]=elm_grid_xy(Grid,icri)
%This function gets cartesian coordinates of grid points

if isstruct(Grid)
    GridSet=Grid;
    Grid=GridSet.Grid;
elseif nargin>1
    GridSet=elm_grid_GridSet(Grid,icri);
end;

x=zeros(GridSet.Nsection,1);
y=x;
for nx=1:length(Grid.r)
    Theta=2*pi/Grid.Npoloidal(nx)*[0:Grid.Npoloidal(nx)-1];
    if nargin>1
        theta=elm_grid_Theta2theta(icri,[],nx-1,Grid);
    else
        theta=Theta;
    end;
       
    x(GridSet.SurfaceInd(nx,1):GridSet.SurfaceInd(nx,2))=Grid.r(nx)*cos(theta);
    y(GridSet.SurfaceInd(nx,1):GridSet.SurfaceInd(nx,2))=Grid.r(nx)*sin(theta);
end;