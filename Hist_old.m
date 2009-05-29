function HistA=Hist_Old(FileName);
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
MinTime=input('Input the time offset (us). Zero iz default.\n');  
if isempty(MinTime) MinTime=0; end; 
peaks(:,1:2)=peaks(:,1:2)+MinTime; 
MaxTime=peaks(end,1);
NPeaks=size(peaks,1);
MaxAmp=max(max(peaks(:,5)),max(peaks(:,6)));
hp=figure;                 
if isstr(FileName)  set(hp,'name',FileName);  else  set(hp,'name','array');   end; 
subplot(2,1,1); hold on; grid on; 
                plot(peaks(:,1),peaks(:,4),'k>','MarkerFaceColor','k','MarkerSize',4);   % peak zero level
                plot(peaks(:,2),peaks(:,5),'r^','MarkerFaceColor','r','MarkerSize',4);   % peak amplitude  
                plot(peaks(:,1)+peaks(:,7),peaks(:,6),'bd','MarkerFaceColor','y','MarkerSize',4);   % peak charge
                axis([MinTime,MaxTime,-100,MaxAmp]);
subplot(2,1,2); hold on; 
                semilogy(peaks(:,1),peaks(:,2)-peaks(:,1),'-ro');             %front
                semilogy(peaks(:,1),peaks(:,7),'-yo');                        %peak or front duration, us
                semilogy(peaks(:,1),peaks(:,3),'-bo','MarkerSize',4);         %peak-to-peak interval
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
MaxAmp=MaxSignal; MaxTime=peaks(end,1);
TimeSpectralInterval=input('Input time interval for spectral analysis (us). The trace as a whole is default. \n');  
if isempty(TimeSpectralInterval) 
    TimeSpectralInterval=peaks(end,1)-peaks(1,1); 
    TimeSpectralIntervalNum=1; 
else 
    TimeSpectralIntervalNum=input('Input the number of the time intervals. \n The default number covers the whole trace. \n  to choose a single interval insert 1.  \n'); 
    if isempty(TimeSpectralIntervalNum) 
        TimeSpectralIntervalNum=fix((peaks(end,1)-peaks(1,1))/TimeSpectralInterval)+1; 
    else
        TimeSpectralIntervalNum=min(TimeSpectralIntervalNum,fix((peaks(end,1)-peaks(1,1))/TimeSpectralInterval)+1); 
        if TimeSpectralIntervalNum==1 
            MinTimeNew = input('Input the minimum time for interval (us).  Peaks before this time will be cut: \n');  
            if isempty(MinTimeNew) MinTime=MinTimeNew; end;
            MaxTime = input('Input the maximum time for interval (us).  Peaks after this time will be cut: \n');  
            if isempty(MaxTime) MaxTime=peaks(end,1); end;
        end;           
    end; 
end; 


subplot(2,1,1);                
    x=[MinTime,MaxTime]; y=[MaxSignal,MaxSignal];   plot(x,y,'-r','LineWidth',2); 
    y=[0,MaxSignal];
    StartInterval=MinTime:TimeSpectralInterval:MinTime+(TimeSpectralIntervalNum-1)*TimeSpectralInterval; 
    EndInterval=StartInterval+TimeSpectralInterval; 
    EndInterval(end)=min(EndInterval(end),peaks(end,2)); 
    CenterOfInterval=(StartInterval+EndInterval)/2; 
    for n=1:TimeSpectralIntervalNum
        x=[StartInterval(n),StartInterval(n)];    plot(x,y,'-r','LineWidth',2); 
        x=[EndInterval(n),EndInterval(n)];        plot(x,y,'-r','LineWidth',2); 
    end; 
    
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



hp=figure; 
if isstr(FileName) set(hp,'name',[FileName,' spectra'] );  else
                   set(hp,'name','array spectra');   end; 
% subplot(3,2,1); plot(trek(:,2),trek(:,5),'-b'); hold on; grid on; 
%                 plot(peaks(:,1),peaks(:,2),'ro');
%                 plot(trek(:,1),EdgeBool*50,'-g');
%                 x=[trek(1,1),trek(end,1)];
%                 Threshold=[Threshold,Threshold];
%                 plot(x,Threshold,'-m');
%                 plot(x,-Threshold,'-m');
%                 axis([MinTime,MaxTime,-StdVal*PeakSt,MaxAmp+StdVal*PeakSt]);
%                 xlabel('t, us'); ylabel('counts');                 

num2str(TimeSpectralInterval/1000,'%4.2');
title(['Time=',num2str((MinTime+MaxTime)/2000,'%4.2'),' ms, Interval=',num2str(TimeSpectralInterval/1000,'%4.2'),' ms']); 
subplot(2,2,1);  for n=1:TimeSpectralIntervalNum   semilogy(HistA(:,1),HistA(:,2*n),'-b^'); hold on; end; 
                 grid on; axis([0,max(MaxAmpl),1,1.2*MaxAmplN]);
%                x=[Threshold,Threshold]; y=[1,max(HistA(:,2))];
%                semilogy(x,y,'-b');
                xlabel('peak, counts'); ylabel('numbers');                                
                                       
subplot(2,2,2); semilogy(peaks(:,5),peaks(:,2)-peaks(:,1),'r^','MarkerFaceColor','r','MarkerSize',4);    % peak front(peak amplitude)
                hold on; grid on;       
%                semilogy(peaks(:,6),peaks(:,2)-peaks(:,1),'rd','MarkerFaceColor','y','MarkerSize',6);   % peak front(Charge)
                semilogy(peaks(:,5),peaks(:,7),'yd','MarkerFaceColor','y','MarkerSize',4);   % peak or front durat (peak amplitude)                
                semilogy(peaks(:,5),peaks(:,3),'b^','MarkerSize',4);     % peak interval (peak amplitude)                
%               semilogy(peaks(:,6),peaks(:,3),'rd','MarkerFaceColor','c','MarkerSize',6);   % peak interval (peak amplitude)
                x=[0,max(max(peaks(:,5)),max(peaks(:,6)))]; 
                y=[tau,tau];   semilogy(x,y,'-r','LineWidth',1.5);                
 %               y=[ChargeTime,ChargeTime]; semilogy(x,y,'-g','LineWidth',1.5);                
                y=[Period,Period]; semilogy(x,y,'-b','LineWidth',1.5);                                
                axis([0,max(max(peaks(:,5)),max(peaks(:,6))),0.01,1.2*max(max(peaks(:,2)-peaks(:,1)),max(peaks(:,3)))]);
                xlabel('peak, counts'); ylabel('front & intervals, us'); 
                legend('front', 'duration', 'interval to next',0); 
              
subplot(2,2,3); for n=1:TimeSpectralIntervalNum   semilogy(HistCh(:,1),HistCh(:,2*n),'-r^'); hold on; end; 
                grid on; axis([0,max(MaxCh),1,1.2*MaxChN]);                
                xlabel('charge, a.u.'); ylabel('numbers');                 

subplot(2,2,4); semilogy(HistT(:,1),HistT(:,2),'-go'); grid on; hold on; 
                semilogy(HistP(:,1),HistP(:,2),'-r');    
                x=[Period,Period];  y=[1,NPeaks*HistIntervalP/Period];
                semilogy(x,y,'-r^');
                axis([0,max(HistT(:,1)),1,1.2*max([max(HistT(:,2)),max(HistP(:,2)),y(2)])]);
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