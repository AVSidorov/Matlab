function ind=elm_grid_fullsections(nZ,Grid)

%function for getting indexes for full cross sections with given toroidal
%grid numbers

%%TODO  checking nZ

if isstruct(Grid)&&isfield(Grid,'Nsection')&&~isempty(Grid.Nsection)
    Nsection=Grid.Nsection;
else
    Nsection=sum(Grid.Npoloidal(1:end-2));
end;

ind=zeros(numel(nZ)*Nsection,1);
for i=1:numel(nZ)
    ind((i-1)*Nsection+[1:Nsection]')=(nZ(i)-1)*Nsection+[1:Nsection]';
end;
