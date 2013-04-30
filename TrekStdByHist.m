function TrekSet=TrekStdByHist(TrekSetIn)
TrekSet=TrekSetIn;
T=0;
Tmax=60;
A=zeros(4096,2);
A(:,1)=[0:4095]';
i=0;
tic;
timeId=tic;
while T<Tmax&&i<TrekSet.size
    i=i+1;
    A(TrekSet.trek(i)+1,2)=A(TrekSet.trek(i)+1,2)+1; %+1 because indexes can't be equal zero
    T=toc(timeId);    
end;    
toc;
fprintf('\n %8.0f points proccessed %3.0f % of full trek\n',i,100*i/TrekSet.size);

figure;
plot(A(:,1),A(:,2));
grid on; hold on;
set(gca,'YScale','log');

title('Zoom region for fit borders. Then press ''Enter'' (empty input) for input borders');
ch='a';
while ~isempty(ch)
    ch=input('Fit?\n','s');
end;

Means=[];
Thr=[];
while isempty(ch)
    title('Input fit borders');
    [x,y]=ginput(2);
    
    bool=A(:,1)>=min(x)&A(:,1)<=max(x);
    [fit,s,m]=polyfit(A(bool,1),log(A(bool,2)),2);
    mid=-fit(2)/(2*fit(1))*m(2)+m(1);
    r=roots(fit)*m(2)+m(1);

    Means=[Means;mid];
    Thr=[Thr;mean(abs(r-mid))];

    h=findobj('tag','LeftBorder');
       if ~isempty(h)&&ishandle(h)
           delete(h);
       end;
    h=findobj('tag','RightBorder');
       if ~isempty(h)&&ishandle(h)
           delete(h);
       end;
    h=findobj('tag','FitCurve');
       if ~isempty(h)&&ishandle(h)
           delete(h);
       end;
    h=findobj('tag','Mid');
       if ~isempty(h)&&ishandle(h)
           delete(h);
       end;
    h=findobj('tag','LeftThreshold');
       if ~isempty(h)&&ishandle(h)
           delete(h);
       end;
    h=findobj('tag','RightThreshold');
       if ~isempty(h)&&ishandle(h)
           delete(h);
       end;
    h=findobj('tag','Mean');
       if ~isempty(h)&&ishandle(h)
           delete(h);
       end;
    h=findobj('tag','LeftThr');
       if ~isempty(h)&&ishandle(h)
           delete(h);
       end;
    h=findobj('tag','RightThr');
       if ~isempty(h)&&ishandle(h)
           delete(h);
       end;
      
    

    title('If empty input repeat fitting');
    plot([x(1),x(1)],[1,max(A(:,2))],'g','tag','LeftBorder');
    plot([x(2),x(2)],[1,max(A(:,2))],'g','tag','RightBorder');
    plot([r(1):r(2)],exp(polyval(fit,[r(1):r(2)],[],m)),'k','tag','FitCurve');
    plot([mid,mid],[1,exp(polyval(fit,mid,[],m))],'r','LineWidth',2,'tag','Mid');
    plot([r(1),r(1)],[1,exp(polyval(fit,mid,[],m))],'k','LineWidth',2,'tag','LeftThreshold');
    plot([r(2),r(2)],[1,exp(polyval(fit,mid,[],m))],'k','LineWidth',2,'tag','RightThreshold');
    plot([mean(Means),mean(Means)],[1,max(A(:,2))],'r','tag','Mean');
    plot([mean(Means)+mean(Thr),mean(Means)+mean(Thr)],[1,max(A(:,2))],'k','tag','LeftThr');
    plot([mean(Means)-mean(Thr),mean(Means)-mean(Thr)],[1,max(A(:,2))],'k','tag','RightThr');
    ch=input('Fit?\n','s');
end;
if round(mean(Means))~=round(Means(end))
    fprintf('Choose MeanVal. Default is n %7.3f. Last is %7.3f\n',mean(Means),Means(end));
    MeanVal=input('MeanVal is ');
    if isempty(MeanVal)
        MeanVal=mean(Means);
    end;
    fprintf('Choose Threshold. Default is n %7.3f. Last is %7.3f\n',mean(Thr),Thr(end));
    Threshold=input('Threshold is ');
    if isempty(Threshold)
        Threshold=mean(Thr);
    end;
else
    MeanVal=round(mean(Means));
    Threshold=round(mean(Thr));
end;

trek=TrekSet.trek;
trek=trek-MeanVal;
if numel(find(trek>Threshold))>=numel(find(trek<-Threshold))
    PeakPolarity = 1;
else
    PeakPolarity = -1;
end;
trek=PeakPolarity*trek;
MaxSignal=max([PeakPolarity*(TrekSet.MaxSignal-MeanVal);PeakPolarity*(TrekSet.MinSignal-MeanVal)]);
MinSignal=min([PeakPolarity*(TrekSet.MaxSignal-MeanVal);PeakPolarity*(TrekSet.MinSignal-MeanVal)]);

TrekSet.trek=trek;
TrekSet.MeanVal=MeanVal;
TrekSet.Threshold=Threshold;
TrekSet.MinSignal=MinSignal;
TrekSet.MaxSignal=MaxSignal;
TrekSet.StdVal=std(trek(abs(trek)<Threshold));
TrekSet.OverSt=max([TrekSet.OverSt,Threshold/TrekSet.StdVal]);
close(gcf);