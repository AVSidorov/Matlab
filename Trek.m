function Trek;
N='17';
points=8000000;
tau=0.02;
combStr=['p',N,'=['];
tic
fid = fopen([N,'sxr.dat']); trek = fread(fid,inf,'single'); fclose(fid); clear fid; trek(end-8:end)=[];
toc
partN=fix(size(trek,1)/points);
for i=1:partN-1
    eval(['ProcessingTrekClb(trek(',num2str((i-1)*points+1),':',num2str(i*points),'));']);
    combStr=[combStr,'p',N,'T',num2str(round((i-1)*points*tau/1000)),'d',num2str(round(i*points*tau/1000)),'ms;'];
end;
    eval(['ProcessingTrekClb(trek(',num2str((partN-1)*points+1),':end));']);
    combStr=[combStr,'p',N,'T',num2str(round((partN-1)*points*tau/1000)),'d',num2str(round(size(trek,1)*tau/1000)),'ms];'];
clear trek partN i tau;
evalin('base',combStr);
clear combStr;
evalin('base',['[spec',N,',spec',N,'Int]=sid_hist(p',N,',5);']);
evalin('base',['[spec',N,',spec',N,'Int]=sid_hist(p',N,',5,spec',N,'Int/50,spec',N,'Int/5);']);
evalin('base',['Poisson(spec',N,');']);


