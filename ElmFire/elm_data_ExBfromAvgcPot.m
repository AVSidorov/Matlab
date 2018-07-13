function Velocity=elm_data_ExBfromAvgcPot(GridSet,icri)
tbl=elm_read_outtable('avgcpot');
dnt=fix(size(tbl,1)/GridSet.dnx);
phi=reshape(tbl(:,3),GridSet.dnx,dnt);
%TODO make spline interpolation and calculating field exact in grid points


dR=diff(GridSet.Grid.r(1:end-2));
Er=zeros(GridSet.dnx-1,dnt);
for i=1:dnt
    Er(:,i)=diff(phi(:,i))./dR;
end;
% B=icri.elm1.bt./(1+GridSet.Grid.r/icri.elm1.r0);
% B=repmat(B(1:end-3),1,dnt);
% mean ExB velocity is on magnet axis r=0
B=icri.elm1.bt;
Velocity=Er./B;