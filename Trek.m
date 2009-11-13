function Trek;
N='13';
combStr=['p',N,'=['];
tic
fid = fopen([N,'sxr.dat']); trek = fread(fid,inf,'single'); fclose(fid); clear fid; trek(end-8:end)=[];
toc
partN=fix(size(trek,1)/500000);
for i=1:partN-1
    eval(['ProcessingTrek(trek(',num2str((i-1)*500000+1),':',num2str(i*500000),'));']);
    combStr=[combStr,'p',N,'T',num2str((i-1)*10),'d',num2str(round(i*10)),'ms;'];
end;
    eval(['ProcessingTrek(trek(',num2str((partN-1)*500000+1),':end));']);
    combStr=[combStr,'p',N,'T',num2str((partN-1)*10),'d',num2str(round(size(trek,1)*0.020/1000)),'ms];'];
clear trek partN i;
evalin('base',combStr);
evalin('base',['[spec',N,',spec',N,'Int]=sid_hist(p',N,',5);']);
evalin('base',['[spec',N,',spec',N,'Int]=sid_hist(p',N,',5,spec',N,'Int/50,spec',N,'Int/5);']);
evalin('base',['Poisson(spec',N,');']);



