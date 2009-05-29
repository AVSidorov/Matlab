function HistA=Histauto(FileName);
% HistA=Hist(FileName);  makes histograms from a peak file.

IntervalBool=false; % if IntervalBool then select only peaks within the SelectedInterval
SelectedInterval=[10,1000]; % selected peaks within this preceeding interval.  

MinFront=0.03;    % minimal front edge of peaks, us
MaxFront=0.4;     % maximal front edge of peaks, us
MinDuration=0.02; % minimal peak duration, us. Shorter peaks are eliminated 
MaxDuration=20.0; % maximal peak duration, us. Longer peaks are eliminated. 

MinAmp=4096;      % Minimal peak amplitude 
MinInterval=0.1;  % minimum peak-to-peak interval,  us
MaxCombined=30;   % maximum combined peaks allowed for MinInterval
AveragN=20;       % Averaged number of peaks in histogram interval  
HistInterval=20;  % count interval for amplitude and cahrge histograms
tau=0.025;        % us digitizing time
HistFolder='';

tic;
if isstr(FileName) 
    fid = fopen(FileName, 'r');
    line = fgetl(fid);
    peaks=[]; 
    while not(feof(fid))
        peaks=[peaks; fscanf(fid,'%g',8)'];
    end; 
    fclose(fid); 
else  
    peaks=FileName;  
end; 
Period=peaks(end,3); 
MinTime=14600;
peaks(:,1:2)=peaks(:,1:2)+MinTime; 
MaxTime=peaks(end,1);
NPeaks=size(peaks,1);
MaxAmp=max(max(peaks(:,5)),max(peaks(:,6)));
MaxSignal = MaxAmp;
MaxAmp=MaxSignal; MaxTime=peaks(end,1);
TimeSpectralInterval=2567;
TimeSpectralIntervalNum=fix((peaks(end,1)-peaks(1,1))/TimeSpectralInterval)+1; 
 
StartInterval=MinTime:TimeSpectralInterval:MinTime+(TimeSpectralIntervalNum-1)*TimeSpectralInterval; 
EndInterval=StartInterval+TimeSpectralInterval; 
EndInterval(end)=min(EndInterval(end),peaks(end,2)); 
CenterOfInterval=(StartInterval+EndInterval)/2; 
   
OutLimits=(peaks(:,1)>MaxTime)|(peaks(:,1)<MinTime)|peaks(:,5)>MaxAmp;  
peaks(OutLimits,:)=[]; 
if IntervalBool
    OutLimits=[]; 
    PreccedInterv=circshift(peaks(:,3),1); 
    OutLimits=(PreccedInterv<SelectedInterval(1))|(PreccedInterv>SelectedInterval(2)); 
    peaks(OutLimits,:)=[];     
end;     


for n=1:TimeSpectralIntervalNum
    InsideInterval(:,n)=(peaks(:,1)>=StartInterval(n))&(peaks(:,1)<=EndInterval(n));
end; 

%NPeaks=size(peaks,1);
MaxAmp=max(max(peaks(:,5)),max(peaks(:,6)));
    
%peak amplitude histogram
MaxAmplN=0; 
MaxAmpl=max(peaks(:,5));
MinAmpl=0; %min(peaks(:,4));
PeakAmplRange=MaxAmpl-MinAmpl; 
HistIntervalA=HistInterval; %   =PeakAmplRange/HistNA;       % interval for amplitudes
HistNA=fix(PeakAmplRange/HistIntervalA)+1;  %HistNA=fix(NPeaks/AveragN);  
if HistNA==0; HistNA=1; end;     % the number of intervals     
for i=1:HistNA HistA(i,1)=MinAmpl+(i-0.5)*HistIntervalA; end; 
for n=1:TimeSpectralIntervalNum  
    for i=1:HistNA
        HistBool=(peaks(InsideInterval(:,n),5)<HistA(i,1)+HistIntervalA/2)&...
                 (peaks(InsideInterval(:,n),5)>=HistA(i,1)-HistIntervalA/2);
        HistA(i,2*n)=size(peaks(HistBool,1),1);  %peak aplitude
        HistA(i,2*n+1)=sqrt(HistA(i,2*n));   %peak aplitude error
        MaxAmplN=max(MaxAmplN,HistA(i,2*n));
    end;
%    ZeroBool=HistA(:,2)==0; 
%    HistA(ZeroBool,:)=[]; 
end; 

%peak 'charge'  histogram
MaxChN=0; 
MaxCh=max(peaks(:,6));
MinCh=0; %min(peaks(:,4));
PeakChRange=MaxAmpl-MinAmpl; 
HistIntervalCh=HistInterval;
HistNCh=fix(PeakChRange/HistIntervalCh)+1;
if HistNCh==0; HistNCh=1; end;     % the number of intervals     
for i=1:HistNCh HistCh(i,1)=MinCh+(i-0.5)*HistIntervalCh; end; 

for n=1:TimeSpectralIntervalNum  
    for i=1:HistNCh
        HistBool=(peaks(InsideInterval(:,n),6)<HistCh(i,1)+HistIntervalCh/2)&...
                 (peaks(InsideInterval(:,n),6)>=HistCh(i,1)-HistIntervalCh/2);
        HistCh(i,2*n)=size(peaks(HistBool,1),1);  %peak aplitude
        HistCh(i,2*n+1)=sqrt(HistCh(i,2*n));   %peak aplitude error
        MaxChN=max(MaxChN,HistCh(i,2*n));
    end;
%    ZeroBool=HistA(:,2)==0; 
%    HistA(ZeroBool,:)=[]; 
end; 



%peak interval histogram
MaxT=max(peaks(:,3));
MinT=min(peaks(:,3));
PeakTRange=MaxT-MinT; 
HistIntervalT=PeakTRange/HistNA;          % interval for T
for i=1:HistNA
    HistT(i,1)=MinT+(i-0.5)*HistIntervalT; 
    HistBool=(peaks(:,3)<HistT(i,1)+HistIntervalT/2)&...
             (peaks(:,3)>=HistT(i,1)-HistIntervalT/2);
    HistT(i,2)=size(peaks(HistBool,1),1);    %peak-to-peak intervals    
end;
ZeroBool=HistT(:,2)==0; 
HistT(ZeroBool,:)=[];


%Poisson interval distribution
test=rand(NPeaks,1)*(peaks(end,1)-peaks(1,1));
Poisson=sort(test); 
Poisson=circshift(Poisson,-1)-Poisson;
MeanP=mean(Poisson(1:end-1));
Poisson(end)=MeanP; 
MaxP=max(Poisson);
MinP=min(Poisson);
PeakPRange=MaxP-MinP; 
HistIntervalP=HistIntervalT;                   % interval for T
for i=1:HistNA
    HistP(i,1)=MinP+(i-0.5)*HistIntervalP; 
    HistBool=(Poisson<HistP(i,1)+HistIntervalP/2)&...
             (Poisson>=HistP(i,1)-HistIntervalP/2);
    HistP(i,2)=size(Poisson(HistBool),1);           %peak-to-peak intervals
end;



fprintf('---------------------\n');                
if IntervalBool 
   fprintf('Peaks are selected within preceeding interval from %6.4f to %6.4f us\n',SelectedInterval(1), SelectedInterval(2));
end; 
fprintf('The number of peaks =  %5.0f\n', NPeaks);
fprintf('The period of peaks =  %6.4f ms\n', Period/1000);
fprintf('Resolution in the peak amplitude histogram=  %3.3f counts\n', HistIntervalA);
fprintf('Resolution in the peak interval histogram=  %3.3f us\n', HistIntervalT);
fprintf('Expected number of double peaks for 0.025 us = %3.3f \n', NPeaks*0.025/Period);
fprintf('Expected number of double peaks for %5.3f us = %5.3f \n', MinInterval, NPeaks*MinInterval/Period);
%fprintf('Detected number of double peaks for %5.3f us = %5.3f \n', MinInterval, size(find(peaks(:,end)==2)));
fprintf('Expected number of triple peaks for %5.3f us = %5.3f \n', MinInterval, NPeaks*(MinInterval/Period)^2/2);
%fprintf('Detected number of triple peaks for %5.3f us = %5.3f \n', MinInterval, size(find(peaks(:,end)==2)));
%fprintf('The selected number of double peaks for %5.3f us = %3.0f \n', MinInterval, DoublePeakNum);
%fprintf('The selected number of triple peaks for %5.3f us = %3.0f \n', MinInterval, TriplePeakNum);
fprintf('=====================\n');                

if isstr(FileName) 
    HistAFile=[HistFolder,strrep(FileName,'peak','A')]; 
    HistAFile=strrep(HistAFile,'.',['Av',num2str(TimeSpectralInterval/1000,'%3.1f'),'ms.']); 
    HistCFile=[HistFolder,strrep(FileName,'peak','C')]; 
    HistCFile=strrep(HistCFile,'.',['Av',num2str(TimeSpectralInterval/1000,'%3.1f'),'ms.']); 
else 
    HistAFile=['AmplAv',num2str(TimeSpectralInterval/1000,'%3.1f'),'ms.dat'];     
    HistCFile=['ChargAv',num2str(TimeSpectralInterval/1000,'%3.1f'),'ms.dat'];     
end; 
if IntervalBool 
    HistAFile=strrep(HistAFile,HistFolder,[HistFolder,'S']);
    HistCFile=strrep(HistCFile,HistFolder,[HistFolder,'S']);    
end; 
fid=fopen(HistAFile,'w'); 
HeadOfFile='Ampl   '; 
for n=1:TimeSpectralIntervalNum HeadOfFile=[HeadOfFile,' keV',num2str(n), ' N', num2str(CenterOfInterval(n)/1000,'%5.2f'),'ms dN',num2str(n)]; end; 
HeadOfFile=[HeadOfFile,'\n'];    
fprintf(fid,HeadOfFile);
for i=1:HistNA 
    fprintf(fid,'%7.2f ' ,HistA(i,1));
    for n=1:TimeSpectralIntervalNum  fprintf(fid,'%7.2f %3.0f %5.2f ' ,HistA(i,1), HistA(i,2*n:2*n+1));  end; 
    fprintf(fid,'\n');    
end;  
fclose(fid);

fid=fopen(HistCFile,'w'); 
HeadOfFile='Charge '; 
for n=1:TimeSpectralIntervalNum HeadOfFile=[HeadOfFile,' keV',num2str(n), ' N', num2str(CenterOfInterval(n)/1000,'%5.2f'),'ms dN',num2str(n)]; end; 
HeadOfFile=[HeadOfFile,'\n'];    
fprintf(fid,HeadOfFile);
for i=1:HistNCh 
    fprintf(fid,'%7.2f ' ,HistCh(i,1));
    for n=1:TimeSpectralIntervalNum  fprintf(fid,'%7.2f %3.0f %5.2f ',HistCh(i,1),HistCh(i,2*n:2*n+1));  end; 
    fprintf(fid,'\n');    
end;  
fclose(fid);