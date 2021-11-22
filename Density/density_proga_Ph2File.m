function density_proga_Ph2File(Ph)
%% writes file for old proga input
fid=fopen('mstest.dat','w');
%fprintf(fid,'%2.2f\t%2.2f\n',Ph');
fprintf(fid,'%f\t%f\n',Ph');
fclose(fid);