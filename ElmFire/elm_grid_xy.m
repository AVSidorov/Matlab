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
for i=1:length(Grid.r)
    Theta=2*pi/Grid.Npoloidal(i)*[0:Grid.Npoloidal(i)-1];    
    if nargin>1
        theta=elm_grid_Theta2theta(Theta,icri);
    else
        theta=Theta;
    end;
       
    x(GridSet.SurfaceInd(i,1):GridSet.SurfaceInd(i,2))=Grid.r(i)*cos(theta);
    y(GridSet.SurfaceInd(i,1):GridSet.SurfaceInd(i,2))=Grid.r(i)*sin(theta);
end;