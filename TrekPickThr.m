function TrekSet=TrekPickThr(TrekSetIn);

TrekSet=TrekSetIn;

StartIntervalNum=100;   %Start Number of intervals in Histogram for Threshold Search
MaxOverSt=20;
MinOverSt=1.1;
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

 bool=FrontHigh<MaxOverSt*StdVal;
 [HistFH,HI,HS,HistSet]=sid_hist(FrontHigh(bool),1,HS);
 HS=min([HS,HI]);
 [HistFH,HI,HS,HistSet]=sid_hist(FrontHigh(bool),1,HS);

 if HistSet.Range/StdVal<4*TrekSet.OverStStd;
    Thr=MinOverSt*StdVal*TrekSet.OverStStd;
    Ind=find(HistFH(:,2)==1,1,'first');
    Thr=min([HistFH(Ind,1),Thr,HistFH(end,1)]);
    
    TrekSet.OverStThr=Thr/StdVal;
    TrekSet.OverStStd=TrekSet.OverStThr/2; %/2 because Threshold is for FrontHigh, which is double amlitude

    TrekSet.Threshold=Thr;
 else
 
 
    
    HistR=circshift(HistFH(:,2),1);
    HistR(1)=HistFH(1,2);
    HistL=circshift(HistFH(:,2),-1);

    MaxHistBool=HistFH(:,2)>HistR&HistFH(:,2)>=HistL;
    MinHistBool=HistFH(:,2)<=HistR&HistFH(:,2)<HistL;
    MinHistBool(1)=false;
        
    MaxHistInd=find(MaxHistBool);
    MinHistInd=find(MinHistBool);
    

    if size(MaxHistInd,1)>1
        FirstNonFlatInd=1;
        while HistFH(FirstNonFlatInd,2)==HistFH(FirstNonFlatInd+1,2)
            FirstNonFlatInd=FirstNonFlatInd+1;
            if FirstNonFlatInd==size(HistFH,1)
                break 
            end;
        end;
        
        if MaxHistInd(1)>MinHistInd(1)          
            MaxHistInd=[FirstNonFlatInd;MaxHistInd];
        end;

        while size(MaxHistInd,1)>size(MinHistInd,1)
            MaxHistInd(end)=[];
        end;

        while size(MaxHistInd,1)<size(MinHistInd,1)
            MinHistInd(end)=[];
        end;
        
        if size(MaxHistInd,1)>1
            TailHighHist=HistFH(MaxHistInd(1:end),2)-HistFH(MinHistInd(1:end),2);            
            Ind=find(TailHighHist>0,1,'first');
            FitInd=[MaxHistInd(Ind):MinHistInd(Ind)]';
        end;
        if isempty(FitInd);
            FitInd=[1:size(HistFH,1)]';
        end;
    else
        FitInd=[1:size(HistFH,1)]';
    end;



    

    if size(FitInd,1)>1
        p=polyfit(HistFH(FitInd,1),log(HistFH(FitInd,2)),1);
        p1=p;
        p(2)=p(2)-log(HistFH(FitInd(end),2));
        Thr=roots(p);
    else
        Thr=HistFH(1,1);
    end;



    Ind=find(HistFH(:,2)==1,1,'first');
    Thr=min([HistFH(Ind,1),Thr,HistFH(end,1)]);
    Thr=max([Thr,MinOverSt*StdVal]);

 end;
     

    if Plot
        HistFig=figure; 
        semilogy(HistFH(:,1),HistFH(:,2),'-b.');
        hold on; grid on;

        plot([Thr,Thr],[1,max(HistFH(:,2))],'-r','LineWidth',2);

        if exist('p1')
            if not(isempty(p1))
                semilogy(HistFH(FitInd,1),exp(polyval(p1,HistFH(FitInd,1))),'-g.','LineWidth',2);
            end;
        end;
        Bool=FrontHigh>Thr/2;
        if not(isempty(find(Bool))) 
            [HistFH,HI]=sid_hist(FrontHigh(Bool),1,HS,HI);
            semilogy(HistFH(:,1),HistFH(:,2),'-g.');
        end;

        Bool=FrontHigh>Thr;
        if not(isempty(find(Bool)))
            [HistFH,HI]=sid_hist(FrontHigh(Bool),1,HS,HI);
            semilogy(HistFH(:,1),HistFH(:,2),'-m.');
        end;

        fprintf(['Press ''C'' to correct the threshold or to accept the followes one as Threshold: \n',...
        '''e'' for manual input \n']);
        
        Decision=input('Default is red Threshold ','s');
        if isempty(Decision); Decision='q'; end;  

        if Decision=='e'||Decision=='E'
            Threshold=input('Input threshold ');
            if isempty(Threshold)
                Threshold=Thr;
            end;
        end;

        if Decision=='c'||Decision=='C'
                Color='m';   %Colors(1);
                x=[]; z=[];
                figure(HistFig);
                [x,z]=ginput(1);
                plot([x,x],[0,max(HistFH(:,2))],Color,'LineWidth',2);
            disp('=====================');
            Threshold=x;
            disp(['Automatic Threshold is ',num2str(Thr)]);
            disp(['Manual Threshold =',num2str(Threshold),' is taken']);

        end;    

        if Decision~='q'
            Thr=Threshold;
        end;
        

%         pause;
%         close(gcf);
    end;
    
 

TrekSet.OverStThr=Thr/StdVal;
TrekSet.OverStStd=max([TrekSet.OverStThr/2,MinOverSt]); %/2 because Threshold is for FrontHigh, which is double amlitude

TrekSet.Threshold=Thr;

fprintf('The Threshold  = %5.3f %5.3f*%7.4f \n',Thr,Thr/StdVal,StdVal);

disp('>>>>>>>> Pick Threshold finished');
toc;

