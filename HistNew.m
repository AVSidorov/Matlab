function HistA=HistNew(FileName,TrekName,TimeInt);
% HistA=Hist(FileName);  makes histograms from a peak file.

IntervalBool=false; % if IntervalBool then select only peaks within the SelectedInterval
SelectedInterval=[10,1000]; % selected peaks within this preceeding interval.  

MinFront=0.03;    % minimal front edge of peaks, us
MaxFront=0.4;     % maximal front edge of peaks, us
MinDuration=0.02; % minimal peak duration, us. Shorter peaks are eliminated 
MaxDuration=20.0; % maximal peak duration, us. Longer peaks are eliminated. 

MinAmp=4096;      % Minimal peak amplitude 
MinInterval=0.05;  % minimum peak-to-peak interval,  us
MaxCombined=30;   % maximum combined peaks allowed for MinInterval
AveragN=20;       % Averaged number of peaks in histogram interval  
HistInterval=20;  % count interval for amplitude and cahrge histograms
tau=0.025;        % us digitizing time
MeasureIntervalDef=26112;    % us measurement interval at 25 ns digitizing time 
AverageIntervalN=52;   % the number of intervals for average peak numbers.  

if exist('hist')==7
    HistFolder=[cd,'\hist\'];
else
    mkdir(cd,'hist');
    HistFolder=[cd,'\hist\'];
end;


MinTimeDef=14600;
tic;
if isstr(FileName) 
    fid = fopen(FileName, 'r');    line = fgetl(fid);     peaks=[]; 
    bool=feof(fid);
    peaks=fscanf(fid,'%g',[7,inf])';
    %while not(feof(fid))  
    %    peaks=[peaks; fscanf(fid,'%g',7)'];    
    %end; 
    fclose(fid); 
else  
    peaks=FileName;  
    if nargin>=2 FileName=TrekName; end;
end; 
fprintf('Histograms will be writen \n in %s directory\n', HistFolder);
fprintf('Histogram interval  %3.0f counts\n',HistInterval);

Period=peaks(end,3); 

if isempty(TimeInt)
    MinTime=input(['Input the time offset (us). ',num2str(MinTimeDef),' is default.\n']);  
    if isempty(MinTime) MinTime=MinTimeDef; end; 
else
    MinTime=TimeInt(1);
end;
peaks(:,2)=peaks(:,2)+MinTime; 
if isempty(TimeInt)
    MaxTime=peaks(end,2);
    MeasureInterval=MaxTime-MinTime;
    MeasureInterval=input(['Input measure interval ',num2str(MeasureIntervalDef),' is default ',num2str(MeasureInterval),' is by peaks input "0".\n']);
    if isempty(MeasureInterval) MeasureInterval=MeasureIntervalDef; end;
    if MeasureInterval==0 MeasureInterval=MaxTime-MinTime; end;
else
    MaxTime=TimeInt(end);
    MeasureInterval=MaxTime-MinTime;
    MeasureInterval=input(['Input measure interval ',num2str(MaxTime-MinTime),' is default .\n']);
    if isempty(MeasureInterval) MeasureInterval=MaxTime-MinTime; end;
end;
fprintf('MeasureInterval is %9.4f\n',MeasureInterval);    
NPeaks=size(peaks,1);
MaxAmp=max(peaks(:,5));
hp1=figure;                 
if isstr(FileName)  set(hp1,'name',FileName);  else  set(hp1,'name','array');   end; 
AverIntrerval=MeasureInterval/AverageIntervalN; 
for i=1:AverageIntervalN AverPeaks(i,1)=MinTime+AverIntrerval*i; 
    AverPeaks(i,2)=size(find(peaks(:,2)>MinTime+AverIntrerval*(i-1)&...
                             peaks(:,2)<MinTime+AverIntrerval*i),1)*1000/AverIntrerval; 
end; 

subplot(2,1,1); hold on; grid on; 
                plot(peaks(:,2),peaks(:,4),'k>','MarkerFaceColor','k','MarkerSize',4);   % peak zero level
                plot(peaks(:,2),peaks(:,5),'r^','MarkerFaceColor','r','MarkerSize',4);   % peak amplitude  
                %plot(peaks(:,1)+peaks(:,7),peaks(:,6),'bd','MarkerFaceColor','y','MarkerSize',4);   % peak charge
                plot(AverPeaks(:,1),AverPeaks(:,2),'-g','LineWidth',3);
                axis([MinTime,MaxTime,-100,MaxAmp]);
subplot(2,1,2); hold on; 
                %semilogy(peaks(:,1),peaks(:,2)-peaks(:,1),'-ro');             %front
                %semilogy(peaks(:,1),peaks(:,7),'-yo');                        %peak or front duration, us
                semilogy(peaks(:,2),peaks(:,3),'-bo','MarkerSize',4);         %peak-to-peak interval
                %semilogy(peaks(:,1),(peaks(:,8)-1),'md','MarkerFaceColor','y','MarkerSize',6);   % double peaks                                           
                grid on; 
                x=[MinTime,MaxTime]; 
                y=[tau,tau]; semilogy(x,y,'-g','LineWidth',1.5);                
                y=[Period,Period]; semilogy(x,y,'-g','LineWidth',1.5);                
                axis([MinTime,MaxTime,tau,1.2*max(peaks(:,3))]);
%                set(gca,'ytick',[0.01 0.1 1 10 100 1000]);
                xlabel('t, us'); ylabel('front & interval, us');                 
                legend('front', 'duration', 'interval to next',0);    

                
MaxSignal = input('Input the maximum signal level. Higher signals will be cut: \n');  
if isempty(MaxSignal) MaxSignal = MaxAmp; end;
MaxAmp=MaxSignal; 

exitstr='n';
while exitstr~='y'

TimeSpectralIntervalNum=input('Input number of time interval for processing.\n Default is whole trace or one interval proccessing.\n');
if isempty(TimeSpectralIntervalNum)
    TimeSpectralInterval=input('Input time interval for spectral analysis (us). \n 1) Time in us the whole trace covered, or \n 2) "Enter" - the whole trace, or \n 3) "0" - to specify a single interval. \n');
    if isempty(TimeSpectralInterval)
        TimeSpectralInterval=MeasureInterval;
        TimeSpectralIntervalNum=1;
    else
        if TimeSpectralInterval==0
            SingleInterval = input('Input the single interval [.. , ..] (us) \n');
            MinTime = SingleInterval(1);
            MaxTime = SingleInterval(2);
            TimeSpectralIntervalNum=1;
            TimeSpectralInterval=SingleInterval(2)-SingleInterval(1);
        else 
            TimeSpectralIntervalNum= round(MeasureInterval/TimeSpectralInterval);
            TimeSpectralInterval=round(MeasureInterval/TimeSpectralIntervalNum);
        end;
    end;
else
    TimeSpectralInterval=input(['Input time interval for spectral analysis (us). \n 1) "Enter" the whole trace devide by ',...
                            num2str(TimeSpectralIntervalNum),' intervals or \n [Now is not present] \n']);
    if isempty(TimeSpectralInterval)
        TimeSpectralInterval=round(MeasureInterval/TimeSpectralIntervalNum);    
    end;
end;    
fprintf('%5.0f intervals %5.0f us each are choozen for spectral analysis  \n',TimeSpectralIntervalNum,TimeSpectralInterval); 

figure(hp1);
% if exist('llp')==1 delete(llp(:)); clear llp; end;
% if exist('rlp')==1 delete(rlp(:)); clear rlp; end;
% if exist('tlp')==1 delete(tlp);    clear tlp; end;
delete(findobj(hp1,'Type','line','color','red','LineStyle','-'));

subplot(2,1,1);                
    x=[MinTime,MaxTime]; y=[MaxSignal,MaxSignal];   tlp=plot(x,y,'-r','LineWidth',1); 
    y=[0,MaxSignal];
    StartInterval=MinTime:TimeSpectralInterval:MinTime+(TimeSpectralIntervalNum-1)*TimeSpectralInterval; 
    EndInterval=StartInterval+TimeSpectralInterval; 
    EndInterval(end)=min(EndInterval(end),peaks(end,2)); 
    CenterOfInterval=(StartInterval+EndInterval)/2; 
    for n=1:TimeSpectralIntervalNum
        x=[StartInterval(n),StartInterval(n)];    lp=plot(x,y,'-r','LineWidth',2); 
        x=[EndInterval(n),EndInterval(n)];        rp=plot(x,y,'-r','LineWidth',2); 
    end; 
    
OutLimits=(peaks(:,2)>MaxTime)|(peaks(:,2)<MinTime)|peaks(:,5)>MaxAmp;  
peaks(OutLimits,:)=[]; 
if IntervalBool
    OutLimits=[]; 
    PreccedInterv=circshift(peaks(:,3),1); 
    OutLimits=(PreccedInterv<SelectedInterval(1))|(PreccedInterv>SelectedInterval(2)); 
    peaks(OutLimits,:)=[];     
end;     

for n=1:TimeSpectralIntervalNum
    InsideInterval(:,n)=(peaks(:,2)>=StartInterval(n))&(peaks(:,2)<=EndInterval(n));
end; 

NPeaks=size(peaks,1);
MaxAmp=max(peaks(:,5));
    
%peak amplitude histogram
NPass=round(max(peaks(:,7)));
MaxAmplN=0; 
MaxAmpl=max(peaks(:,5));
MinAmpl=0; %min(peaks(:,4));
PeakAmplRange=MaxAmpl-MinAmpl; 
HistIntervalA=HistInterval; %   =PeakAmplRange/HistNA;       % interval for amplitudes
HistNA=fix(PeakAmplRange/HistIntervalA)+1;  %HistNA=fix(NPeaks/AveragN);  
if HistNA==0; HistNA=1; end;     % the number of intervals     
for i=1:HistNA HistA(i,1)=MinAmpl+(i-0.5)*HistIntervalA; end; 
HistA2=HistA;
for n=1:TimeSpectralIntervalNum  
    for i=1:HistNA
        HistBool=(peaks(InsideInterval(:,n),5)<HistA(i,1)+HistIntervalA/2)&...
                 (peaks(InsideInterval(:,n),5)>=HistA(i,1)-HistIntervalA/2);
        HistA(i,2*n)=size(peaks(HistBool,1),1);  %peak amplitude
        HistA(i,2*n+1)=sqrt(HistA(i,2*n));   %peak amplitude error
        MaxAmplN=max(MaxAmplN,HistA(i,2*n));
        HistBool=(peaks(InsideInterval(:,n),5)<HistA(i,1)+HistIntervalA/2)&...
                 (peaks(InsideInterval(:,n),5)>=HistA(i,1)-HistIntervalA/2)&...
                 peaks(InsideInterval(:,n),end)>1; 
        HistA2(i,n+1)=size(peaks(HistBool,1),1); %peak aplitude     
    end;
%    ZeroBool=HistA(:,2)==0; 
%    HistA(ZeroBool,:)=[]; 
end; 


%Chi2 histogram
MaxChiN=0; 
MaxChi=max(peaks(:,6));
MinChi=0; 
PeakChiRange=MaxChi-MinChi; 
HistNChi=fix(NPeaks/100)+1;   % the number of intervals 
HistIntervalChi=PeakChiRange/HistNChi;
    
for i=1:HistNChi HistChi(i,1)=MinChi+(i-0.5)*HistIntervalChi; end; 

for n=1:TimeSpectralIntervalNum  
    for i=1:HistNChi
        HistBool=(peaks(InsideInterval(:,n),6)<HistChi(i,1)+HistIntervalChi/2)&...
                 (peaks(InsideInterval(:,n),6)>=HistChi(i,1)-HistIntervalChi/2);
        HistChi(i,2*n)=size(peaks(HistBool,1),1);  %Chi2
        HistChi(i,2*n+1)=sqrt(HistChi(i,2*n));   %Chi2 error
        MaxChiN=max(MaxChiN,HistChi(i,2*n));
    end;
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
test=rand(NPeaks,1)*(peaks(end,2)-peaks(1,2));
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



sfig=figure; 
if isstr(FileName) set(sfig,'name',[FileName,' spectra'] );  else
                   set(sfig,'name','array spectra');   end; 

num2str(TimeSpectralInterval/1000,'%4.2f');
title(['Time=',num2str((MinTime+MaxTime)/2000,'%4.2f'),' ms, Interval=',num2str(TimeSpectralInterval/1000,'%4.2f'),' ms']); 
cm=colormap(hsv(TimeSpectralIntervalNum));
                  hold on; grid on; axis([0,max(MaxAmpl),1,1.2*MaxAmplN]); 
                 for n=1:TimeSpectralIntervalNum   
                   plot(HistA(:,1),(HistA(:,2*n)),'Color',cm(n,:),'LineWidth',1,'Marker','o'); 
                   text(max(MaxAmpl)*(0.25+0.6*n/TimeSpectralIntervalNum),MaxAmplN,num2str(n),'Color',cm(n,:));
                 end; 
                 set(gca,'YScale','log');                
                 xlabel('peak, counts'); ylabel('numbers');                                

hp=figure; 
if isstr(FileName) set(hp,'name',[FileName,' spectra'] );  else
                   set(hp,'name','array spectra');   end; 

num2str(TimeSpectralInterval/1000,'%4.2f');
title(['Time=',num2str((MinTime+MaxTime)/2000,'%4.2f'),' ms, Interval=',num2str(TimeSpectralInterval/1000,'%4.2f'),' ms']); 
cm=colormap(hsv(TimeSpectralIntervalNum));
subplot(2,2,1);  hold on; grid on; axis([0,max(MaxAmpl),1,1.2*MaxAmplN]); 
                 for n=1:TimeSpectralIntervalNum   
                   errorbar(HistA(:,1),(HistA(:,2*n)),(HistA(:,2*n+1)),'Color',cm(n,:),'LineWidth',1,'Marker','o'); 
                   plot(HistA(:,1),(HistA2(:,n+1)),'Color',cm(n,:),'LineWidth',0.5,'Marker','.'); 
                   text(max(MaxAmpl)*(0.25+0.6*n/TimeSpectralIntervalNum),MaxAmplN,num2str(n),'Color',cm(n,:));
                 end; 
                 set(gca,'YScale','log');                
%                x=[Threshold,Threshold]; y=[1,max(HistA(:,2))];
%                semilogy(x,y,'-b');
                 xlabel('peak, counts'); ylabel('numbers');                                
                                       
subplot(2,2,2); semilogy(peaks(:,5),peaks(:,2)-peaks(:,1),'r^','MarkerFaceColor','r','MarkerSize',4);    % peak front(peak amplitude)
                hold on; grid on;       
%                semilogy(peaks(:,6),peaks(:,2)-peaks(:,1),'rd','MarkerFaceColor','y','MarkerSize',6);   % peak front(Charge)
                %semilogy(peaks(:,5),peaks(:,7),'yd','MarkerFaceColor','y','MarkerSize',4);   % peak or front durat (peak amplitude)                
                semilogy(peaks(:,5),peaks(:,3),'b^','MarkerSize',4);     % peak interval (peak amplitude)                
%               semilogy(peaks(:,6),peaks(:,3),'rd','MarkerFaceColor','c','MarkerSize',6);   % peak interval (peak amplitude)
                x=[0,max(max(peaks(:,5)),max(peaks(:,6)))]; 
                y=[tau,tau];   semilogy(x,y,'-r','LineWidth',1.5);                
 %               y=[ChargeTime,ChargeTime]; semilogy(x,y,'-g','LineWidth',1.5);                
                y=[Period,Period]; semilogy(x,y,'-b','LineWidth',1.5);                                
                axis([0,max(peaks(:,5)),0.01,1.2*max(max(peaks(:,2)-peaks(:,1)),max(peaks(:,3)))]);
                xlabel('peak, counts'); ylabel('front & intervals, us'); 
                legend('front', 'duration', 'interval to next',0); 
              
subplot(2,2,3); hold on; grid on; axis([0,max(MaxChi),1,1.2*MaxChiN]);     
                for n=1:TimeSpectralIntervalNum   
                   semilogy(HistChi(:,1),HistChi(:,2*n),'Color',cm(n,:),'LineWidth',0.5,'Marker','o');  
                   text(max(MaxChi)*(0.25+0.6*n/TimeSpectralIntervalNum),MaxChiN,num2str(n),'Color',cm(n,:));
                end; 
                set(gca,'YScale','log');                       
                xlabel('Chi2, a.u.'); ylabel('numbers');                 

subplot(2,2,4); errorbar(HistT(:,1),log(HistT(:,2)),1./sqrt(HistT(:,2)),'-b.'); grid on; hold on; 
%                 semilogy(HistP(:,1),HistP(:,2),'-r');    
                x=[Period,Period];  y=[1,NPeaks*HistIntervalT/Period];
                plot(x,log(y),'-r^');
                x=[0,HistT(end,1)];  y=NPeaks*exp(-x/Period)*HistIntervalT/Period;
                plot(x,log(y),'-k');
                axis([0,max(HistT(:,1)),0,1.2*max(log(HistT(:,2)))]);
                xlabel('peak interval, us'); ylabel('exp & Poisson, numbers');                 

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
    %[path,name,ext,versn]=fileparts(FileName);
    if nargin==2 
        HistAFile=[HistFolder,'H',FileName,'.dat']; 
    else
        %HistAFile=[HistFolder,strrep(name,'peak','A'),ext]; 
        HistAFile=[HistFolder,'H',FileName,'.dat']; 
    end;
    HistAFile=strrep(HistAFile,'.',['Av',num2str(TimeSpectralInterval/1000,'%3.1f'),'ms.']); 
else 
    HistAFile=[HistFolder,'AmplAv',num2str(TimeSpectralInterval/1000,'%3.1f'),'ms.dat'];     
end; 
    
if IntervalBool 
    HistAFile=strrep(HistAFile,HistFolder,[HistFolder,'S']);
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
 
 exitstr=input('Exit? y/[n]\n','s');
 exitstr=lower(exitstr);
 if isempty(exitstr) exitstr='n'; end;  
end;