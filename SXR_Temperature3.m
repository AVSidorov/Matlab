function SXR_Temperature3;

FileCount=0;
continuestr='n';
while continuestr~='y'

    FileCount=FileCount+1;

    
    FileName=input('Input Name of SXR Data File as String\n');
    Files{FileCount}=FileName;
    Be=input('Input Be Foil Thikness default is 100 um\n');
    if isempty(Be) Be=100; end;  
    Sm=input('Input Smooth Parametr default is 100 points\n');
    if isempty(Sm) Sm=100; end;  

    
    Data(FileCount,1)=Be;
    Data(FileCount,2)=Sm;
    Data(FileCount,3)=str2num(FileName(regexp(FileName,'[0-9]')));

    continuestr=input('Continue? y/[n]\n','s');
    continuestr=lower(continuestr);
    if isempty(continuestr) continuestr='n'; end;  
end;
Table=load('D:\!SCN\SXR\sxr_table.dat');

BeMinus=input('Input Be Thikness for minus default is 400\n');
if isempty(BeMinus) BeMinus=400; end;


if BeMinus==0
    IdxMinN=1;
else
    IdxMin=find(Data(:,1)==BeMinus);
    IdxMinN=size(IdxMin,1);
end;
for i=1:IdxMinN

 if BeMinus==0
     SXRMinus=zeros(1714,15);
 else
     tic;
     SXRMinus=load(Files{IdxMin(i)});
     fprintf(['Time of ',Files{IdxMin(i)},' load %4.2f\n'], toc);
     SXRMinus=SXR_norm(SXRMinus,Data(IdxMin(i),2));  
 end;

 Idx100=find(Data(:,1)==100);
 Idx100N=size(Idx100,1);
 for ii=1:Idx100N
     tic;
     SXR100=load(Files{Idx100(ii)});
     fprintf(['Time of ',Files{Idx100(ii)},' load %4.2f\n'], toc);
     SXR100=SXR_norm(SXR100,Data(Idx100(ii),2));  

    IdxOth=find((Data(:,1)>100)&(Data(:,1)<BeMinus));
    IdxOthN=size(IdxOth,1);
    for iii=1:IdxOthN

         tic;
         SXR2=load(Files{IdxOth(iii)});
         fprintf(['Time of ',Files{IdxOth(iii)},' load %4.2f\n'], toc);
         SXR2=SXR_norm(SXR2,Data(IdxOth(iii),2));  
        
        SXR100(:,2:15)=SXR100(:,2:15)-SXRMinus(:,2:15); 
        SXR2(:,2:15)=SXR2(:,2:15)-SXRMinus(:,2:15);
        SXRDiv(:,1)=SXR100(:,1);
        Good=SXR2>0;
        Bad=not(Good);
        for id=2:15 
            SXRDiv(Good(:,id),id)=SXR100(Good(:,id),id)./SXR2(Good(:,id),id); 
            SXRDiv(Bad(:,id),id)=-2; 
        end;
        Te(:,1)=SXR100(:,1);
        for it=2:15
            for iit=1:1714
                Te(iit,it)=sxr_tables2(Table,SXRDiv(iit,it),Data(IdxOth(iii),1));
            end;
        end;
        FileName=['TeD',num2str(Data(Idx100(ii),3),'%02.0f'),'Be',num2str(Data(Idx100(ii),1),'%3.0f'),'Sm',num2str(Data(ii,2),'%4.0f'),...
                      'DivD',num2str(Data(IdxOth(iii),3),'%02.0f'),'Be',num2str(Data(IdxOth(iii),1),'%3.0f'),'Sm',num2str(Data(IdxOth(iii),2),'%4.0f'),...
                      'MD',num2str(Data(IdxMin(i),3),'%02.0f'),'Be',num2str(Data(IdxMin(i),1),'%3.0f'),'Sm',num2str(Data(IdxMin(i),2),'%4.0f')];
        save([FileName,'.dat'], 'Te','-ASCII');            
    clear Bad Good SXR2 SXRDiv Te FileName;    
    end;
    clear SXR100;
  end;
  clear SXRMinus;
end;
