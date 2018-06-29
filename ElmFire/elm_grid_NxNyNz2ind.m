function ind=elm_grid_NxNyNz2ind(vec,Grid,icri)
% Function to convert  radial, poloidal and toroidal grid numbers to grid
% point index
nx=vec(:,1);
ny=vec(:,2);
nz=vec(:,3);

Nsection=sum(Grid.Npoloidal(1:end-2));
SectionIdx=circshift(cumsum(Grid.Npoloidal),1)+1; % array with starting index for flux surface
SectionIdx(1)=1;

ind=(nz-1)*Nsection+(SectionIdx(nx)-1)+ny;

