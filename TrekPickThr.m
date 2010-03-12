function TrekSet=TrekPickThr(TrekSetIn);

TrekSet=TrekSetIn;

StartIntervalNum=100;   %Start Number of intervals in Histogram for Threshold Search
Plot=false;


tic;
disp('>>>>>>>> Pick Threshold started');

trek=TrekSet.trek;
StdVal=TrekSet.StdVal;
trSize=TrekSet.size;
OverSt=TrekSet.OverStThr;



FrontInd=[];
FrontHigh=zeros(trSize,1);



trR=circshift(trek,1);
trL=circshift(trek,-1);

MaxBool=trek>trR&trek>=trL;
MinBool=trek<=trR&trek<trL;
MaxBool(1)=false;    MaxBool(end)=false;
MaxInd=find(MaxBool);
MaxN=size(MaxInd,1);

MinBool(1)=false;    MinBool(end)=false;
MinInd=find(MinBool);
MinN=size(MinInd,1);

%making first minimum earlier then thirst maximum
 while MaxInd(1)<MinInd(1)
     MaxInd(1)=[];
     MaxN=MaxN-1;
 end;
 
%making equal quantity of maximums and minimums
 while MinN>MaxN
      MinInd(end)=[];
      MinN=MinN-1;
 end;

 
 FrontHigh=trek(MaxInd)-trek(MinInd);

 
 Thr=0;

 MinFrontHigh=min(FrontHigh);
 MaxFrontHigh=max(FrontHigh);

 HS=(MaxFrontHigh-MinFrontHigh)/StartIntervalNum;

 [HistFH,HI]=sid_hist(FrontHigh,1,HS);
 HS=min([HS,HI]);
 [HistFH,HI]=sid_hist(FrontHigh,1,HS);
 
sm=1;

FlatHistInd=ones(StartIntervalNum,1);

while size(FlatHistInd,1)>StartIntervalNum/10;
    HistFH(:,2)=smooth(HistFH(:,2),sm);
    
    HistR=circshift(HistFH(:,2),1);
    HistR(1)=HistFH(1,2);
    HistL=circshift(HistFH(:,2),-1);

    FrontHistBool=HistFH(:,2)>HistR&HistFH(:,2)<HistL;
    TailHistBool=HistFH(:,2)<HistR&HistFH(:,2)>HistL;
    FlatHistBool=HistFH(:,2)==HistR|HistFH(:,2)==HistL;

    FrontHistInd=find(FrontHistBool);
    TailHistInd=find(TailHistBool);
    FlatHistInd=find(FlatHistBool);
    sm=sm+2;
end;

if  size(TailHistInd,1)>0
     if  not(isempty(FrontHistInd))
         while FrontHistInd(1)<TailHistInd(1)
            FrontHistInd(1)=[];
            if isempty(FrontHistInd);  break;  end;
         end;
     end;

    if  not(isempty(FrontHistInd))
        bool=TailHistInd<FrontHistInd(1);
    else
        bool=ones(size(TailHistInd,1));
    end;
    
    FitInd=TailHistInd(bool);

    if size(FitInd,1)>1
        p=polyfit(HistFH(FitInd,1),log(HistFH(FitInd,2)),1);
        p1=p;
        p(2)=p(2)-log(HistFH(FitInd(end),2));
        Thr=roots(p);
    else
        Thr=HistFH(1,1);
    end;

end;

Ind=find(HistFH(:,2)==1,1,'first');
Thr=min([HistFH(Ind,1),Thr]);
Thr=max([Thr,2*StdVal]);

     

    if Plot
        HistFig=figure; 
        semilogy(HistFH(:,1),HistFH(:,2),'-b.');
        hold on; grid on;

        semilogy(HistFH(FitInd,1),exp(polyval(p1,HistFH(FitInd,1))),'-g.','LineWidth',2);
        plot([Thr,Thr],[1,max(HistFH(:,2))],'-r','LineWidth',2);
        
        Bool=FrontHigh>Thr;
        [HistFH,HI]=sid_hist(FrontHigh(Bool),1,HS);
        semilogy(HistFH(:,1),HistFH(:,2),'-m.');

        pause;
        close(gcf);
    end;
    
 

TrekSet.OverStThr=Thr/StdVal;
TrekSet.OverStStd=TrekSet.OverStThr/2; %/2 because Threshold is for FrontHigh, which is double amlitude

TrekSet.Thr=Thr;

fprintf('The Threshold  = %5.3f %5.3f*%7.4f \n',Thr,Thr/StdVal,StdVal);

disp('>>>>>>>> Pick Threshold finished');
toc;

