function rcn=density_proga_readRCN
%% writes file for old proga input
fid=fopen('nrstest.txt','r');
rcn=reshape(cell2mat(textscan(fid,'%f',inf,'HeaderLines',1,'MultipleDelimsAsOne',1)),3,[])';
fclose(fid);