function SXR_Temperature;

FileCount=0;
continuestr='n';
while continuestr~='y'

    FileCount=FileCount+1;

    
    FileName=input('Input Name of SXR Data File as String\n');
    tic;
    tr=load(FileName);
    fprintf('Time of load %4.2f\n', toc);
    
    Be=input('Input Be Foil Thikness default is 100 um\n');
    if isempty(Be) Be=100; end;  
    Sm=input('Input Smooth Parametr default is 100 points\n');
    if isempty(Sm) Sm=100; end;  

    tr=SXR_norm(tr,Sm);  
    
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

BeMinus=input('Input Be Thikness for minus default is 400\n');
if isempty(BeMinus) BeMinus=400; end;


IdxMin=find(Data(:,1)==BeMinus);
IdxMinN=size(IdxMin,1);
for i=1:IdxMinN
 SXRMinus=trek(:,:,IdxMin(i));
 Idx100=find(Data(:,1)==100);
 Idx100N=size(Idx100,1);
 for ii=1:Idx100N
    SXR100=trek(:,:,Idx100(ii));
    IdxOth=find((Data(:,1)>100)&(Data(:,1)<BeMinus));
    IdxOthN=size(IdxOth,1);
    for iii=1:IdxOthN
        SXR2=trek(:,:,IdxOth(iii));
        
        SXR100(:,2:15)=SXR100(:,2:15)-SXRMinus(:,2:15); 
        SXR2(:,2:15)=SXR2(:,2:15)-SXRMinus(:,2:15);
        SXRDiv(:,1)=SXR100(:,1);
        SXRDiv(:,2:15)=SXR100(:,2:15)./SXR2(:,2:15);

        Te(:,1)=SXR100(:,1);
        for it=2:15
            for iit=1:1714
                Te(iit,it)=sxr_tables2(Table,SXRDiv(iit,it),Data(iii,1));
            end;
        end;
        FileName=['TeD',num2str(Data(Idx100(ii),3),'%02.0f'),'Be',num2str(Data(Idx100(ii),1),'%3.0f'),'Sm',num2str(Data(ii,2),'%4.0f'),...
                      'DivD',num2str(Data(IdxOth(iii),3),'%02.0f'),'Be',num2str(Data(IdxOth(iii),1),'%3.0f'),'Sm',num2str(Data(IdxOth(iii),2),'%4.0f'),...
                      'MD',num2str(Data(IdxMin(i),3),'%02.0f'),'Be',num2str(Data(IdxMin(i),1),'%3.0f'),'Sm',num2str(Data(IdxMin(i),2),'%4.0f')];
        figure('name',FileName);
            plot(Te(:,1),Te(:,6:11));
        save([FileName,'.dat'], 'Te','-ASCII');            
    end;
 end;
end;
