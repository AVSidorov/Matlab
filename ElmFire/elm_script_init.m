tbl=elm_read_outtable('grid.inp');
Grid=array2table(tbl,'VariableNames',{'r','Npoloidal'});
icri=elm_read_icri;
GridSet=elm_grid_GridSet(Grid,icri);
Ts=icri.elm3.tint*icri.elm3.nene;
time=[0:Ts:icri.elm3.ttint];