function NoiseSet=NoiseFit(trek,varargin)
% this function make gaussian fitting for noise level determination on
% treks with signal
HistStep=1;
nargsin=size(varargin,2);
if ~isempty(varargin)&&mod(nargsin,2)~=0
    error('incorrect number of input arguments');
end;

for i=1:fix(nargsin/2) 
    eval([varargin{1+2*(i-1)},'=varargin{2*i};']);
end;

trSize=numel(trek);
TrekFig=figure;
plot(trek);
grid on; hold on;

title('Zoom figure. Choose region for fit Std.');
Ind=[];
HighBorder=0;
LowBorder=0;
ch=input('Zoom figure. Add Region? (just ''Enter'').If input is not empty go NextStep (whole trek)\n','s');    
while isempty(ch)
    title('Input fit borders. Y is important too (for histogram borders)');
    [x,y]=ginput(2);
    Ind=[Ind,round(min(x)):round(max(x))];
    %TODO whats bad work on non normilized trek (MeanVal~=0)
    HighBorder=round(max(y))-0.5;
    LowBorder=round(min(y))-0.5;
    plot([round(min(x)),round(min(x))],[LowBorder,HighBorder],'r','LineWidth',2);
    plot([round(max(x)),round(max(x))],[LowBorder,HighBorder],'r','LineWidth',2);
    h=findobj('tag','PointsInWork');
       if ~isempty(h)&&ishandle(h)
           delete(h);
       end;
    Ind(Ind<1|Ind>trSize)=[];
    plot(Ind,trek(Ind),'k','tag','PointsInWork');
    ch=input('Zoom figure. Add Region? (just ''Enter'').If input is not empty go Next Step\n','s');    
end;
if isempty(Ind)
    Ind=[1:trSize];
    LowBorder=min(trek);
    HighBorder=max(trek);
end;
bool=false(trSize,1);
bool(Ind)=true;
A=HistOnNet(trek(bool),[LowBorder:HistStep:HighBorder]);
StdTrek=std(trek(bool));

HistFig=figure;
plot(A(:,1),A(:,2));
grid on; hold on;
set(gca,'YScale','log');
title('Zoom region for fit borders. Then press ''Enter'' (empty input) for input borders');
ch=input('Zoom figure to choose Region. Then just ''Enter''\n','s');  

Means=[];
Thr=[];
Std=[];
while isempty(ch)
    title('Input fit borders');
    [x,y]=ginput(2);
    
    bool=A(:,1)>=min(x)&A(:,1)<=max(x);
    [fit,s,m]=polyfit(A(bool,1),log(A(bool,2)),2);
    mid=-fit(2)/(2*fit(1))*m(2)+m(1);
    r=roots(fit)*m(2)+m(1);
    stdev=sqrt(-1/fit(1)/2)*m(2);

    Means=[Means;mid];
    Std=[Std;stdev];
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
      
    

    title('If empty input repeat fitting. If d/D delete this fitting from set');
   
    plot([x(1),x(1)],[1,max(A(:,2))],'g','tag','LeftBorder');
    plot([x(2),x(2)],[1,max(A(:,2))],'g','tag','RightBorder');
    plot([min(r):HistStep:max(r)],exp(polyval(fit,[min(r):HistStep:max(r)],[],m)),'k','tag','FitCurve');
    plot([mid,mid],[1,exp(polyval(fit,mid,[],m))],'r','LineWidth',2,'tag','Mid');
    plot([r(1),r(1)],[1,exp(polyval(fit,mid,[],m))],'k','LineWidth',2,'tag','LeftThreshold');
    plot([r(2),r(2)],[1,exp(polyval(fit,mid,[],m))],'k','LineWidth',2,'tag','RightThreshold');
    plot([mean(Means),mean(Means)],[1,max(A(:,2))],'r','tag','Mean');
    plot([mean(Means)+mean(Thr),mean(Means)+mean(Thr)],[1,max(A(:,2))],'k','tag','LeftThr');
    plot([mean(Means)-mean(Thr),mean(Means)-mean(Thr)],[1,max(A(:,2))],'k','tag','RightThr');
    ch=input('Fit?\n','s');
    if ~isempty(ch)&&lower(ch)=='d'
        Means(end)=[];
        Thr(end)=[];
        Std(end)=[];
        ch='';
    end;
    
end;
fprintf('Choose MeanVal. Default is  %7.3f. Last is %7.3f\n',mean(Means),Means(end));
MeanVal=input('MeanVal is ');
if isempty(MeanVal)
    MeanVal=mean(Means);
end;

fprintf('Choose Std. Default is  %7.3f. Last is %7.3f. std(trek) on process interval is %7.3f\n',mean(Std),Std(end),StdTrek);
StdDev=input('Std is ');
if isempty(StdDev)
    StdDev=mean(Std);
end;

fprintf('Choose Threshold. Default is  %7.3f. Last is %7.3f\n',mean(Thr),Thr(end));
Threshold=input('Threshold is ');
if isempty(Threshold)
    Threshold=mean(Thr);
end;

fprintf('Choose OverSt. Default is  %7.3f by Std and Thr\n',Threshold/StdDev);
OverSt=input('OverSt is ');
if isempty(OverSt)
    OverSt=Threshold/StdDev;
end;

figure(TrekFig);
plot([1,trSize],MeanVal+[Threshold,Threshold],'r');
plot([1,trSize],MeanVal+[-Threshold,-Threshold],'r');
pause;

if ~isempty(HistFig)&&ishandle(HistFig)
    close(HistFig);
end;
if ~isempty(TrekFig)&&ishandle(TrekFig)
    close(TrekFig);
end;

NoiseSet.MeanVal=MeanVal;
NoiseSet.StdVal=StdDev;
NoiseSet.Threshold=Threshold;
NoiseSet.OverSt=OverSt;
NoiseSet.Ind=Ind;