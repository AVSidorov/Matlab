function tblAv=elm_data_fluxAvr(tbl,GridSet)
% flux surface averaging
%TODO cheking size of input array
tblAv=tbl;
for i=1:GridSet.dnx  
        tblAv(GridSet.SurfaceInd(i,1):GridSet.SurfaceInd(i,2),:)=repmat(mean(tblAv(GridSet.SurfaceInd(i,1):GridSet.SurfaceInd(i,2),:)),GridSet.Grid.Npoloidal(i),1);
end;