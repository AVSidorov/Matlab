function geqdsk_write(In,filename)
if nargin<2||isempty(filename)||~ischar(filename)
    filename='abc.geqdsk';
end;        
%%
formatDesc=[repmat('% 8s',1,6),repmat('%4i',1,3)];
formatArray=['\n',repmat(' % 10.8E',1,5)];
formatN=['\n',repmat(' % 4i',1,2)];

bdry=reshape([In.rbdry,In.zbdry]',1,[]);
limiter=reshape([In.xlim,In.ylim]',1,[]);

%%
fid=fopen(filename,'w');

fprintf(fid,formatDesc,In.Desc{1:6},In.idum,In.nxefit,In.nyefit);
fprintf(fid,formatArray,In.xdim,In.zdim,In.rcentr,In.rgrid1,In.zmid);
fprintf(fid,formatArray,In.rmagx,In.zmagx,In.simagx,In.sibdry,In.bcentr);
fprintf(fid,formatArray,In.cpasma,In.simagx,In.xdum,In.rmagx,In.xdum);
fprintf(fid,formatArray,In.zmagx,In.xdum,In.sibdry,In.xdum,In.xdum);
fprintf(fid,formatArray,In.fpol);
fprintf(fid,formatArray,In.pres);
fprintf(fid,formatArray,In.ffprim);
fprintf(fid,formatArray,In.pprime);
fprintf(fid,formatArray,In.psi');
fprintf(fid,formatArray,In.qpsi);
fprintf(fid,formatN,In.nbdry,In.nlim);
fprintf(fid,formatArray,bdry);
fprintf(fid,formatArray,limiter);

fclose(fid);
