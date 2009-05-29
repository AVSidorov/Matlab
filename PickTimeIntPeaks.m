function peaks_out=PickTimeIntPeaks(peaks);

MaxAmp=max(peaks(:,5));
MinTime=peaks(1,2);
MaxTime=peaks(end,2);

fprintf('Now (Default) Interval is [%4.2f:%4.2f]\n',MinTime,MaxTime);

cor_decision=input('To choose Time Interval press ''C''\n Default All Peaks\n','s');
cor_decision=lower(cor_decision);
if cor_decision=='c' 

    hp1=figure;                 

        hold on; grid on; 
        plot(peaks(:,2),peaks(:,4),'k>','MarkerFaceColor','k','MarkerSize',4);   % peak zero level
        plot(peaks(:,2),peaks(:,5),'r^','MarkerFaceColor','r','MarkerSize',4);   % peak amplitude  
        axis([MinTime,MaxTime,-100,MaxAmp]);

    gr_input_decision=input('For graph interval input press ''g'' \n','s');
    gr_input_decision=lower(gr_input_decision);
    if gr_input_decision=='g'
        disp('Input Start Point Zoom figure if nessecary then press enter');
        pause;
        figure(hp1);
        [x,y]=ginput(1);
        MinTime=x;
        plot([x,x],[0,MaxAmp],'r','LineWidth',2);
        disp('Input End Point Zoom figure if nessecary then press enter');
        pause;
        figure(hp1);
        [x,y]=ginput(1);
        MaxTime=x;
        plot([x,x],[0,MaxAmp],'r','LineWidth',2);
    end;
    fprintf('Now (Default) Interval is [%4.2f:%4.2f]\n',MinTime,MaxTime);
    TimeInt=input('input new interval [Start Time,End Time]\n');
    if not(isempty(TimeInt))
        MinTime=TimeInt(1);
        MaxTime=TimeInt(end);
    end;

end;
peaksbool=peaks(:,2)>=MinTime & peaks(:,2)<=MaxTime;
peaks_out(:,:)=peaks(peaksbool,:);
