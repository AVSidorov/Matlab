function SXR_Temperature;

FileCount=0;
continuestr='n';
while continuestr~='y'

    FileCount=FileCount+1;

    tic;
    FileName=input('Input Name of Peak File as String\n');
    tr=load(FileName);
    fprintf('Time of load %4.2f\n', toc);
    
    Be=input('Input Be Foil Thikness default is 100 um\n');
    if isempty(Be) Be=100; end;  
    Sm=input('Input Smooth Parametr default is 100 points\n');
    if isempty(Sm) Sm=100; end;  

    for i=2:15 
        tr(:,i)=smooth(tr(:,i),Sm);
    end;
     
    
    Data(FileCount,1)=Be;
    Data(FileCount,2)=Sm;
    Data(FileCount,3)=str2num(FileName(regexp(FileName,'[0-9]')));

    trN=size(tr,1);
    trek(1:trN,:,FileCount)=tr;

    clear tr;
    continuestr=input('Continue? y/[n]\n','s');
    continuestr=lower(continuestr);
    if isempty(continuestr) continuestr='n'; end;  
end;
Table=load('D:\!SCN\SXR\sxr_table.dat');
SXR1=trek(:,:,find(Data(:,1)==100));
SXR2=trek(:,:,find(Data(:,1)==200));
SXR3=trek(:,:,find(Data(:,1)==400));
SXR1(:,2:15)=SXR1(:,2:15)-SXR3(:,2:15); 
SXR2(:,2:15)=SXR2(:,2:15)-SXR3(:,2:15);
SXRDiv(:,1)=SXR1(:,1);
SXRDiv(:,2:15)=SXR1(:,2:15)./SXR2(:,2:15);

Te(:,1)=SXR1(:,1);
for i=2:15
    for ii=1:1714
        Te(ii,i)=sxr_tables2(Table,SXRDiv(ii,i),200);
    end;
end;
figure;
      plot(Te(:,1),Te(:,6:11));
