function HistA=ProcessTrek(FileName);


Text=false;           % switch between text and binary input files
Plot=false;

tic;

if not(isstr(FileName)); trek=FileName; else
   if Text;  trek=load(FileName);  else  
      fid = fopen(FileName); trek = fread(fid,inf,'int16'); fclose(fid); clear fid; 
end; end; 

if size(trek,2)==2; trek(:,2)=trek; trek(:,1)=(0:tau:tau*(size(trek,1)-1))'; end; 
bool=(trek(:)>4095)|(trek(:)<0); OutRangeN=size(find(bool),1); 
if OutRangeN>0; fprintf('%7.0f  points out of the ADC range  \n',OutRangeN); end; 
trek(bool,:)=[];  clear bool; 
trekSize=size(trek(:,1),1);
fprintf('Loading time =                                %7.4f  sec\n', toc); tic; 
