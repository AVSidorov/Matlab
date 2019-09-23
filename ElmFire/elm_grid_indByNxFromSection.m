function ind=elm_grid_indByNxFromSection(nx,Grid)

SectionIdx=circshift(cumsum(Grid.Npoloidal),1)+1; % array with starting index for flux surface
SectionIdx(1)=1;
ind=zeros(sum(Grid.Npoloidal(nx)),1);
stI=1;
for i=1:length(nx)  
    ind(stI:stI+Grid.Npoloidal(nx(i))-1)=SectionIdx(nx(i)):SectionIdx(nx(i)+1)-1;
    stI=stI+Grid.Npoloidal(nx(i));
end
