function [nx,ny,nz]=elm_grid_ind2NxNyNz(ind,Grid,icri)
% Function to convert vector grid coordinates to radial, poloidal and toroidal grid numbers

Nsection=sum(Grid.Npoloidal(1:end-2));
SectionIdx=circshift(cumsum(Grid.Npoloidal),1)+1; % array with starting index for flux surface
SectionIdx(1)=1;


nz=fix(ind/Nsection)+1; %number of toroidal cross section
SectionInd=ind-(nz-1)*Nsection; % index relative to cross section start
nx=zeros(size(ind));
for i=1:numel(SectionInd)
    nx(i)=find(SectionInd(i)>=SectionIdx,1,'last');
end;
ny=zeros(size(ind));
ny(:)=SectionInd(:)-SectionIdx(nx)+1;