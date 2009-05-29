function HistA=HistSimple(peaks);


HistInterval=20;  % count interval for amplitude and cahrge histograms
tau=0.025;        % us digitizing time



fprintf('Histogram interval  %3.0f counts\n',HistInterval);

Period=peaks(end,3); 

NPeaks=size(peaks,1);
MaxAmpl=max(peaks(:,5));
hp1=figure;                 
MinTime=peaks(1,2);
MaxTime=peaks(end,2);

subplot(2,1,1); hold on; grid on; 
                plot(peaks(:,2),peaks(:,4),'k>','MarkerFaceColor','k','MarkerSize',4);   % peak zero level
                plot(peaks(:,2),peaks(:,5),'r^','MarkerFaceColor','r','MarkerSize',4);   % peak amplitude  
                axis([MinTime,MaxTime,-100,MaxAmpl]);
subplot(2,1,2); hold on; 
                semilogy(peaks(:,2),peaks(:,3),'-bo','MarkerSize',4);         %peak-to-peak interval
                grid on; 
                x=[MinTime,MaxTime]; 
                y=[tau,tau]; semilogy(x,y,'-g','LineWidth',1.5);                
                y=[Period,Period]; semilogy(x,y,'-g','LineWidth',1.5);                
                axis([MinTime,MaxTime,tau,1.2*max(peaks(:,3))]);
                xlabel('t, us'); ylabel('front & interval, us');                 
                legend('front', 'duration', 'interval to next',0);    

                
MaxSignal = input('Input the maximum signal level. Higher signals will be cut: \n');  
if isempty(MaxSignal) MaxSignal = MaxAmpl; end;
MaxAmpl=MaxSignal; 

cor_decision=input('To choose Time Interval press ''C''\n Default All Peaks\n','s');
cor_decision=lower(cor_decision);
if cor_decision=='c' 
    gr_input_decision=input('For graph interval input press ''g'' \n','s');
    gr_input_decision=lower(gr_input_decision);
    if gr_input_decision=='g'
        disp('Input Start Point Zoom figure if nessecary then press enter');
        pause;
        figure(hp1);
        subplot(2,1,1);
        [x,y]=ginput(1);
        MinTime=x;
        plot([x,x],[0,MaxAmpl],'r','LineWidth',2);
        disp('Input End Point Zoom figure if nessecary then press enter');
        pause;
        figure(hp1);
        subplot(2,1,1);
        [x,y]=ginput(1);
        MaxTime=x;
        plot([x,x],[0,MaxAmpl],'r','LineWidth',2);
    end;
    fprintf('Now (Default) Interval is [%4.2f:%4.2f]\n',MinTime,MaxTime);
    TimeInt=input('input new interval [Start Time,End Time]\n');
    if not(isempty(TimeInt))
        MinTime=TimeInt(1);
        MaxTime=TimeInt(end);
    end;

end;


TimeSpectralIntervalNum=1;
TimeSpectralInterval=MaxTime-MinTime;
fprintf('%5.0f intervals %5.0f us each are choozen for spectral analysis  \n',TimeSpectralIntervalNum,TimeSpectralInterval); 

figure(hp1);

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
    
OutLimits=(peaks(:,2)>MaxTime)|(peaks(:,2)<MinTime)|peaks(:,5)>MaxAmpl;  
peaks(OutLimits,:)=[]; 


    
%peak amplitude histogram
HistA=sid_spectr(peaks,5,HistInterval,1);
HistA(:,2)=HistA(:,2)/(TimeSpectralInterval/1000);
HistA(:,3)=sqrt(HistA(:,2));
MaxAmplN=max(HistA(:,2));
HistBool=peaks(:,end)>1; 
if not(isempty(peaks(HistBool,:)))
HistA2=sid_spectr(peaks(HistBool,:),5,HistInterval,1);
else
HistA2=HistA;
HistA2(:,2:3)=HistA(:,2:3)/1000;    
end;

%Chi2 histogram
HistChi=sid_spectr(peaks,6);
MaxChi=max(peaks(:,6));
MaxChiN=max(HistChi(:,2));


%peak interval histogram
HistT=sid_spectr(peaks,3);
HistIntervalT=HistT(3,1)-HistT(2,1);
ZeroBool=HistT(:,2)==0; 
HistT(ZeroBool,:)=[];
MaxTN=max(HistT(:,2));


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
HistP=sid_spectr(Poisson,1,HistIntervalP);


sfig=figure; 

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

num2str(TimeSpectralInterval/1000,'%4.2f');
title(['Time=',num2str((MinTime+MaxTime)/2000,'%4.2f'),' ms, Interval=',num2str(TimeSpectralInterval/1000,'%4.2f'),' ms']); 
cm=colormap(hsv(TimeSpectralIntervalNum));
subplot(2,2,1);  hold on; grid on; axis([0,max(MaxAmpl),1,1.2*MaxAmplN]); 
                 for n=1:TimeSpectralIntervalNum   
                   errorbar(HistA(:,1),(HistA(:,2*n)),(HistA(:,2*n+1)),'Color',cm(n,:),'LineWidth',1,'Marker','o'); 
%                   plot(HistA(:,1),(HistA2(:,n+1)),'Color',cm(n,:),'LineWidth',0.5,'Marker','.'); 
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
fprintf('The number of peaks =  %5.0f\n', NPeaks);
fprintf('The period of peaks =  %6.4f ms\n', Period/1000);
fprintf('Resolution in the peak amplitude histogram=  %3.3f counts\n', HistInterval);
fprintf('Resolution in the peak interval histogram=  %3.3f us\n', HistIntervalT);
fprintf('Expected number of double peaks for 0.025 us = %3.3f \n', NPeaks*0.025/Period);
%fprintf('Expected number of double peaks for %5.3f us = %5.3f \n', MinInterval, NPeaks*MinInterval/Period);
%fprintf('Detected number of double peaks for %5.3f us = %5.3f \n', MinInterval, size(find(peaks(:,end)==2)));
%fprintf('Expected number of triple peaks for %5.3f us = %5.3f \n', MinInterval, NPeaks*(MinInterval/Period)^2/2);
%fprintf('Detected number of triple peaks for %5.3f us = %5.3f \n', MinInterval, size(find(peaks(:,end)==2)));
%fprintf('The selected number of double peaks for %5.3f us = %3.0f \n', MinInterval, DoublePeakNum);
%fprintf('The selected number of triple peaks for %5.3f us = %3.0f \n', MinInterval, TriplePeakNum);
fprintf('=====================\n');                

    
