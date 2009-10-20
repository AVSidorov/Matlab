function [flow1,flow2,spectr]=AnalyzePeaks(peaks);

SpecInterv=250;
SpecStep=1; %Step in spectr or 'mean' etc. from sid_hist

MeasAmplf=33.33;
ClbrAmplf=33.33;
ClbrAmplt=1725;

fprintf('Default Amplification in measurements is %6.3f\n', MeasAmplf);
MeasAmp=input('Input Amplification in this trek (value not number)\n (1=1, 2=1.1,3=3.704,4=11.11,5=33.33,6=100)\n');
if not(isempty(MeasAmp))
    MeasAmplf=MeasAmp;
end;

fprintf('Default Amplification in calibration is %6.3f\n', ClbrAmplf);
ClbrAmp=input('Input Amplification in calibration (value not number)\n(1=1, 2=1.1,3=3.704,4=11.11,5=33.33,6=100)\n');
if not(isempty(ClbrAmp))
    ClbrAmplf=ClbrAmp;
end;

fprintf('Default Calibration Amplitude is %7.3f\n', ClbrAmplt);
ClbrAmpl=input('Input Amplitude of 5.96 keV peak\n');
if not(isempty(ClbrAmpl))
    ClbrAmplt=ClbrAmpl;
end;

SmParam=1;
tau=0.020;
%???? ??????? ????? ????????????? ????????? ?? ????????????? ? ????????????
%???? ?????? ??????

%Peaks massive main parameters
NPeaks=size(peaks,1);

MaxAmpl=max(peaks(:,5));
MinAmpl=0; %min(peaks(:,5));


MaxTime=max(peaks(:,2));%peaks(end,2)
MinTime=min(peaks(:,2));%peaks(1,2)
TimeInt=MaxTime-MinTime;
Time=0.5*(MinTime+MaxTime);

Period=TimeInt/NPeaks;


MaxT=max(peaks(:,3));
MinT=min(peaks(:,3));
PeakTRange=MaxT-MinT;

MaxChi=max(peaks(:,6));
MinChi=0; 
PeakChiRange=MaxChi-MinChi; 


%peak amplitude histogram

PeakAmplRange=MaxAmpl-MinAmpl; 
SpecNA=fix(PeakAmplRange/SpecInterv)+1;

[spectr,SpecInterv,SpecStep]=sid_hist(peaks,5,SpecStep,'10percent');

MaxAmplN=max(spectr(:,2)); 
MinAmplN=min(spectr(:,2)); 

Pass2Bool=peaks(:,end)>1; 
if max(size(peaks(Pass2Bool)))>1;
    spectr2=sid_hist(peaks(Pass2Bool));
else
  spectr2=[];  
end;
% Flow

flow1=NPeaks/(TimeInt/1000);


%Chi2 histogram
HistNChi=fix(NPeaks/100)+1;   % the number of intervals 
HistIntervalChi=PeakChiRange/HistNChi;
HistStepChi=PeakChiRange/NPeaks;

HistChi=sid_hist(peaks,6,HistStepChi,HistIntervalChi);

MaxChiN=max(HistChi(:,2));

%peak interval histogram
HistIntervalT=PeakTRange/SpecNA;          % interval for T
HistStepT=PeakTRange/NPeaks;

HistT=sid_hist(peaks,3,HistStepT,HistIntervalT);

ZeroBool=HistT(:,2)==0; 
HistT(ZeroBool,:)=[];

%Poisson interval distribution
test=rand(NPeaks,1)*TimeInt;
Poisson=sort(test); 
Poisson=circshift(Poisson,-1)-Poisson;
MeanP=mean(Poisson(1:end-1));
Poisson(end)=MeanP; 
MaxP=max(Poisson);
MinP=min(Poisson);
PeakPRange=MaxP-MinP; 
HistIntervalP=HistIntervalT;                   % interval for T
HistStepP=PeakPRange/NPeaks; 
HistP=sid_hist(Poisson,1,HistStepP,HistIntervalP);


hp=figure; 
set(hp,'name','array spectra');  

title(['Time=',num2str(Time/1000,'%4.2f'),' ms, Interval=',num2str(TimeInt/1000,'%4.2f'),' ms']); 
cm=colormap(hsv(1));
subplot(2,2,1);  hold on; grid on; axis([0,MaxAmpl,MinAmplN,1.1*MaxAmplN]); 
                   errorbar(spectr(:,1),spectr(:,2),spectr(:,3),'Color',cm(1,:),'LineWidth',1,'Marker','.'); 
                   if not(isempty(spectr2))
                   plot(spectr2(:,1),spectr2(:,2),'Color',cm(1,:),'LineWidth',0.5,'Marker','.'); 
                   end;
                 set(gca,'YScale','log');                
                 xlabel('peak, counts'); ylabel('numbers');                                
                                       
subplot(2,2,2); semilogy(peaks(:,5),peaks(:,2)-peaks(:,1),'r^','MarkerFaceColor','r','MarkerSize',4);    % peak front(peak amplitude)
                hold on; grid on;       
                semilogy(peaks(:,5),peaks(:,3),'b^','MarkerSize',4);     % peak interval (peak amplitude)                
                x=[0,max(peaks(:,5))]; 
                y=[tau,tau];   semilogy(x,y,'-r','LineWidth',1.5);                
                y=[Period,Period]; semilogy(x,y,'-b','LineWidth',1.5);                                
                axis([0,MaxAmpl,0.01,1.2*max(max(peaks(:,2)-peaks(:,1)),max(peaks(:,3)))]);
                xlabel('peak, counts'); ylabel('front & intervals, us'); 
                legend('delta','interval to next',0); 
              
subplot(2,2,3); hold on; grid on; axis([0,MaxChi,1,1.2*MaxChiN]);     
                semilogy(HistChi(:,1),HistChi(:,2),'Color',cm(1,:),'LineWidth',0.5,'Marker','o');  
                set(gca,'YScale','log');                       
                xlabel('Chi2, a.u.'); ylabel('numbers');                 

subplot(2,2,4); errorbar(HistT(:,1),log(HistT(:,2)),1./sqrt(HistT(:,2)),'-b.'); grid on; hold on; 
                x=[Period,Period];  y=[1,NPeaks*HistIntervalT/Period];
                plot(x,log(y),'-r^');
                x=[0,HistT(end,1)];  y=NPeaks*exp(-x/Period)*HistIntervalT/Period;
                plot(x,log(y),'-k');
                axis([0,max(HistT(:,1)),0,1.2*max(log(HistT(:,2)))]);
                xlabel('peak interval, us'); ylabel('exp & Poisson, numbers');                 


CountkeV=5.96/ClbrAmplt*(ClbrAmplf/MeasAmplf);                
figure('Name','Spectr Counts/ms/keV');
    plot(spectr(:,1)*CountkeV,spectr(:,2)/(TimeInt/1000)/(SpecInterv*CountkeV),'.-r');
    grid on;
    set(gca,'YScale','log');

flow2=MaxAmplN/(TimeInt/1000)/(SpecInterv*CountkeV);

                
fprintf('---------------------\n');                
fprintf('The number of peaks =  %5.0f\n', NPeaks);
fprintf('The time of spectrum =  %5.0f us\n', Time);
fprintf('The time interval of spectrum =  %5.0f us\n', TimeInt);
fprintf('The period of peaks =  %6.5f us\n', Period);
fprintf('The flow1(by number of peaks) =  %5.0f N/ms\n', flow1);
fprintf('The flow2(by maximum of spectra in counts/ms/keV) =  %4.3f \n', flow2);
fprintf('Resolution in the peak amplitude spectr=  %3.3f counts or %5.1f eV \n', SpecInterv,SpecInterv*CountkeV*1000);
fprintf('Step in the peak amplitude spectr=  %3.3f counts or %5.1f eV\n', SpecStep,SpecStep*CountkeV*1000);
fprintf('Resolution in the peak interval histogram=  %3.3f us\n', HistIntervalT);
fprintf('Expected number of double peaks for %4.3f us = %3.3f \n', tau,NPeaks*tau/Period);
fprintf('=====================\n');                


