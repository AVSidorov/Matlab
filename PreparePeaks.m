function peaks=PreparePeaks(FileName);

MinAmp=0;
MaxAmp=4095;
tau=0.025;        % us digitizing time

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
end; 
OutLimits=peaks(:,5)<MinAmp|peaks(:,5)>MaxAmp;  
peaks(OutLimits,:)=[];

NPeaks=size(peaks,1);
MaxAmp=max(peaks(:,5));
MinTime=peaks(1,2);
MaxTime=peaks(end,2);
Period=peaks(end,3); 

hp1=figure;                 

subplot(2,1,1); hold on; grid on; 
                plot(peaks(:,2),peaks(:,4),'k>','MarkerFaceColor','k','MarkerSize',4);   % peak zero level
                plot(peaks(:,2),peaks(:,5),'r^','MarkerFaceColor','r','MarkerSize',4);   % peak amplitude  
                axis([MinTime,MaxTime,-100,MaxAmp]);
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
if isempty(MaxSignal) MaxSignal = MaxAmp; end;
MaxAmp=MaxSignal; 

OutLimits=peaks(:,5)<MinAmp|peaks(:,5)>MaxAmp;  
peaks(OutLimits,:)=[];

