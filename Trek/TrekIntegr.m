%function TrekIntegr(FileName1,PeakFileName);
function TrekIntegr(FileName1,PeakFileName);


Text1=false;           % switch between text and binary input files
Plot1=true;
OverSt1=2;         % noise regection threshold, in standard deviations    
Pass1=2;
StartOffset=16600; %in us Tokamak delay + 1.6ms
StPeakWrite=true;
tic;

if not(isstr(FileName1)); 
    trek1=FileName1; 
else
   if Text1;  
       trek1=load(FileName1);  
   else  
       fid = fopen(FileName1); trek1 = fread(fid,inf,'int16'); fclose(fid); clear fid; 
   end; 
end; 

if size(trek1,2)==2; trek1(:,1)=trek1(:,2); trek1(:,2)=[]; end; 
bool=(trek1(:)>4095)|(trek1(:)<0); OutRangeN=size(find(bool),1); 
if OutRangeN>0; fprintf('%7.0f  points out of the ADC range  \n',OutRangeN); end; 
trek1(bool,:)=[];  clear bool; 
trekSize1=size(trek1(:,1),1);
fprintf('Loading time =                                %7.4f  sec\n', toc); tic; 

NoiseArray=logical(true(trekSize1,1));  % first, all measurements are considered as noise
[MeanVal,StdVal,PeakPolarity,NoiseArray]=MeanSearch(trek1,OverSt1,NoiseArray);
if PeakPolarity==1; trek1(:)=trek1(:)-MeanVal;  else trek1(:)=MeanVal-trek1(:); end;
fprintf('First mean search   =                        %7.4f  sec\n', toc); 
fprintf('  Standard deviat = %6.4f\n', StdVal);
ProcInt=input(['Input Process Interval indexes[...:...]\n Default is whole trek[1:',num2str(size(trek1,1)),']\n']);
if isempty(ProcInt) ProcInt=[1:trekSize1]; end;
fprintf('Process Inteval is %8.3f-%8.3f us  %8.3f us long\n',ProcInt(1)*0.025,ProcInt(end)*0.025,(ProcInt(end)-ProcInt(1))*0.025);

clear MeanVal NoiseArray OutRangeN  PeakPolarity StdVal Text trekSize1;
trek=trek1(ProcInt);
trekSize=size(trek(:,1),1);
tic;
IntTrek=cumsum(trek);
fprintf('Time of Integration %4.2f\n', toc);
Window=input('Input Window Size in us\n');
Window=Window/0.025;
IntTrekSh=circshift(IntTrek,Window); IntTrekSh(1:Window)=0;
Flux=IntTrek-IntTrekSh;
% figure;
%  plot(0.025*[1:trekSize],Flux); hold on;
%  plot(0.025*[1,trekSize],[mean(Flux),mean(Flux)],'r');
%  
 if isstr(PeakFileName) 
     fid = fopen(PeakFileName, 'r');    line = fgetl(fid);     peaks=[]; 
     while not(feof(fid))  
         peaks=[peaks; fscanf(fid,'%g',7)'];    
     end; 
     fclose(fid); 
 else    
     if nargin==2 peaks=PeakFileName; end;
 end;  

if isstr(FileName1)
   [path1,name1,ext1,versn1]=fileparts(FileName1);
   FileName1=[strrep(name1,'trek',''),'T',num2str(ProcInt(1)*0.025,'%5.0fms-'),num2str(ProcInt(end)*0.025,'%5.0fms')];
end;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [MeanVal,StdVal,PP,Noise]=MeanSearch(tr,OverSt,Noise);    
% search the signal pedestal and make it zero
           % Input parameters: tr or trD - input measurements, Over St (see above), Noise - assumed initial noise array  
           % Output parameters: MeanValue, Standad deviation, Pulse polarity, Noise - residual noise array
trSize=size(tr,1); %  (N,1) dimension

M =mean(tr(:)); St=std(tr(:));  
Positive=size(find(tr(:)-(M+5*St)>0),1);  
Negative=size(find(tr(:)-(M-5*St)<0),1); 
MaxVal=max(tr(:)); MinVal=min(tr(:)); DeltaM=MaxVal-MinVal;  

if Positive>Negative PeakPolarity=1; else PeakPolarity=-1;  end; 

NoisePoints=size(find(Noise),1); 
while DeltaM>0.1
    M =[M,mean(tr(Noise))];  St=[St,std(tr(Noise))];          
    L=length(M);    
    if L>2   DeltaM=abs(M(L)-M(L-1));  else     DeltaM=10;    end; 
    NoiseLevel=M(L)+PeakPolarity*OverSt*St(L);    
    if PeakPolarity==1 Noise=(tr(:)<NoiseLevel); else; Noise=(tr(:)>NoiseLevel); end;  %(abs(M(L)-tr(:,2))<OverSt*St(L));
    NoisePoints=[NoisePoints,size(find(Noise),1)];
    %if St(L)==0 DeltaM=0;end;
end; 
    NoiseL=circshift(Noise,-1);   NoiseL(end)=Noise(end);     
    NoiseR=circshift(Noise,1);    NoiseR(1)=Noise(1);
    SingleNoise=not(Noise)&NoiseR&NoiseL;           %search alone peaks above the NoiseLevel
    Noise(SingleNoise)=true;                        %the alone peaks are brought to the Noise array
    NoiseIndx=find(Noise);
    Noise(1:NoiseIndx(1))=1;  Noise(NoiseIndx(end):end)=1;
    MeanVal=M(L); StdVal=St(L); PP=PeakPolarity;
