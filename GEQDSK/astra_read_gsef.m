function Out=astra_read_gsef(filename,Plot)
if nargin<2
    Plot=false;   
end
if isstr(filename)
    fid=fopen(filename);
else
    error('geqdsk:err:wrongfilename','Input must be String filename');
end
%% reading from Fable i
%  	read(1,*) Nx,Nt
% 		read(1,*) ((r_a(i,j),i=1,Nx),j=1,Nt)
% 		read(1,*) (thetap(j),j=1,Nt)
% 		read(1,*) (Rb(j),j=1,Nt)
% 		read(1,*) (Zb(j),j=1,Nt)
% 		read(1,*) ((XX(i,j),i=1,Nx),j=1,Nt)
% 		read(1,*) ((YY(i,j),i=1,Nx),j=1,Nt)
% 		read(1,*) ((PSI(i,j),i=1,Nx),j=1,Nt)
% 		read(1,*) ((B_R(i,j),i=1,Nx),j=1,Nt)
% 		read(1,*) ((B_Z(i,j),i=1,Nx),j=1,Nt)
% 		read(1,*) ((B_T(i,j),i=1,Nx),j=1,Nt)
% 		read(1,*) (PSIn_grid(i),i=1,Nx)
% 		read(1,*) (dum1(i),i=1,Nx)
% 		read(1,*) (dum2(i),i=1,Nx)
% 		read(1,*) (ipol_grid(i),i=1,Nx)
% 		read(1,*) (pressure(i),i=1,Nx)
% 		read(1,*) (qprof(i),i=1,Nx)
% 	close(1)
Out.nx=cell2mat(textscan(fid,'%d',1,'Delimiter',{' ','\t','\n','r','\b'},'MultipleDelimsAsOne',1));
Out.nt=cell2mat(textscan(fid,'%d',1,'Delimiter',{' ','\t','\n','r','\b'},'MultipleDelimsAsOne',1));
Out.r_a=reshape(cell2mat(textscan(fid,'%f',Out.nx*Out.nt,'Delimiter',{' ','\t','\n','r','\b'},'MultipleDelimsAsOne',1)),Out.nx,Out.nt);
Out.thetap=cell2mat(textscan(fid,'%f',Out.nt,'Delimiter',{' ','\t','\n','r','\b'},'MultipleDelimsAsOne',1));
Out.Rb=cell2mat(textscan(fid,'%f',Out.nt,'Delimiter',{' ','\t','\n','r','\b'},'MultipleDelimsAsOne',1));
Out.Zb=cell2mat(textscan(fid,'%f',Out.nt,'Delimiter',{' ','\t','\n','r','\b'},'MultipleDelimsAsOne',1));
Out.XX=reshape(cell2mat(textscan(fid,'%f',Out.nx*Out.nt,'Delimiter',{' ','\t','\n','r','\b'},'MultipleDelimsAsOne',1)),Out.nx,Out.nt);
Out.YY=reshape(cell2mat(textscan(fid,'%f',Out.nx*Out.nt,'Delimiter',{' ','\t','\n','r','\b'},'MultipleDelimsAsOne',1)),Out.nx,Out.nt);
Out.PSI=reshape(cell2mat(textscan(fid,'%f',Out.nx*Out.nt,'Delimiter',{' ','\t','\n','r','\b'},'MultipleDelimsAsOne',1)),Out.nx,Out.nt);
Out.B_R=reshape(cell2mat(textscan(fid,'%f',Out.nx*Out.nt,'Delimiter',{' ','\t','\n','r','\b'},'MultipleDelimsAsOne',1)),Out.nx,Out.nt);
Out.B_Z=reshape(cell2mat(textscan(fid,'%f',Out.nx*Out.nt,'Delimiter',{' ','\t','\n','r','\b'},'MultipleDelimsAsOne',1)),Out.nx,Out.nt);
Out.B_T=reshape(cell2mat(textscan(fid,'%f',Out.nx*Out.nt,'Delimiter',{' ','\t','\n','r','\b'},'MultipleDelimsAsOne',1)),Out.nx,Out.nt);
Out.PSIn_grid=cell2mat(textscan(fid,'%f',Out.nx,'Delimiter',{' ','\t','\n','r','\b'},'MultipleDelimsAsOne',1));
Out.dum1=cell2mat(textscan(fid,'%f',Out.nx,'Delimiter',{' ','\t','\n','r','\b'},'MultipleDelimsAsOne',1));
Out.dum2=cell2mat(textscan(fid,'%f',Out.nx,'Delimiter',{' ','\t','\n','r','\b'},'MultipleDelimsAsOne',1));
Out.ipol_grid=cell2mat(textscan(fid,'%f',Out.nx,'Delimiter',{' ','\t','\n','r','\b'},'MultipleDelimsAsOne',1));
Out.pressure=cell2mat(textscan(fid,'%f',Out.nx,'Delimiter',{' ','\t','\n','r','\b'},'MultipleDelimsAsOne',1));
Out.qprof=cell2mat(textscan(fid,'%f',Out.nx,'Delimiter',{' ','\t','\n','r','\b'},'MultipleDelimsAsOne',1));
fclose(fid);

if Plot
 astra_plot_gsef(Out);      
end