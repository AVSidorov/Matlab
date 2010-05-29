function TrekSet=TrekPickThr(TrekSetIn);

TrekSet=TrekSetIn;

StartIntervalNum=100;   %Start Number of intervals in Histogram for Threshold Search
MaxOverSt=20;
Plot=TrekSet.Plot;
OverSt=TrekSet.OverSt;

tic;
disp('>>>>>>>> Pick Threshold started');

trek=TrekSet.trek;
if isempty(TrekSet.StdVal)
    StdVal=std(trek);
else
    if TrekSet.StdVal==0
        StdVal=std(trek);
    else
        StdVal=TrekSet.StdVal;       
    end;
end;
trSize=TrekSet.size;



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
 TailHigh=trek(MaxInd(1:end-1))-trek(MinInd(2:end));
 
 Thr=0;

 MinFrontHigh=min(FrontHigh);
 MaxFrontHigh=max(FrontHigh);

 HI=(MaxFrontHigh-MinFrontHigh)/StartIntervalNum;

 bool=FrontHigh<MaxOverSt*StdVal;
 [HistFH,HI,HS,HistSet]=sid_hist(FrontHigh(bool),1,HI);
 HS=min([HS,HI]);
 [HistFH,HI,HS,HistSet]=sid_hist(FrontHigh(bool),1,HS);
 [HistTH,HI,HS,HistSet1]=sid_hist(TailHigh(bool(1:end-1)),1,HS,HI);

 FirstNonFlatInd=1;
 
 while HistFH(FirstNonFlatInd,2)==HistFH(FirstNonFlatInd+1,2)    
     FirstNonFlatInd=FirstNonFlatInd+1;      
     if FirstNonFlatInd==size(HistFH,1)            
         break         
     end;   
 end;

    
 HistR=circshift(HistFH(:,2),1);
 HistR(1)=HistFH(1,2);
 HistL=circshift(HistFH(:,2),-1);

 MaxHistBool=HistFH(:,2)>HistR&HistFH(:,2)>=HistL;
 MinHistBool=HistFH(:,2)<=HistR&HistFH(:,2)<HistL;
 MinHistBool(1)=false;
      
 MaxHistInd=find(MaxHistBool);
 MinHistInd=find(MinHistBool);
 

 if size(MaxHistInd,1)>1
        
        if MaxHistInd(1)>MinHistInd(1)          
            MaxHistInd=[FirstNonFlatInd;MaxHistInd];
        end;

        while size(MaxHistInd,1)>size(MinHistInd,1)
            MaxHistInd(end)=[];
        end;

        while size(MaxHistInd,1)<size(MinHistInd,1)
            MinHistInd(end)=[];
        end;
 else
     MaxHistInd=FirstNonFlatInd;
     MinHistInd=HistSet.HistN;
 end;       
 
 MinHistN=size(MinHistInd,1);
 
 StdValInd=find(HistFH(:,1)>=StdVal*OverSt,1,'first');
 StartInd=min([MaxHistInd(1),StdValInd]);
 Ind=find(MinHistInd(:)>StdValInd,1,'first');
 
 
 if isempty(Ind)
    EndInd=StdValInd; 
 else
    EndInd=MinHistInd(Ind);
 end;
 
  FitInd=[StartInd:EndInd];  
  if max(size(FitInd))>1
        d=2;
        while d>=1; 
            FitInd=[StartInd:EndInd];  
            p=polyfit(HistFH(FitInd,1),log(HistFH(FitInd,2)),1);
            Ind=find(HistFH(:,1)>=(1-p(2))/p(1),1,'first');
            if not(isempty(Ind))
                Ind=find(abs(HistFH(StdValInd:Ind,2)-HistFH(StdValInd:Ind,3)-exp(polyval(p,HistFH(StdValInd:Ind,1))))>0,1,'first');
                EndInd=StdValInd+Ind-1;
            end;
            d=EndInd-FitInd(end);
        end;
    end;
Thr=HistFH(FitInd(end),1);

Ind=find(HistFH(:,2)==1,1,'first');
Thr=min([HistFH(Ind,1),Thr,HistFH(end,1)]);

     

    if Plot
        HistFig=figure; 
        semilogy(HistFH(:,1),HistFH(:,2),'-b.');
        hold on; grid on;
        plot(HistTH(:,1),HistTH(:,2),'-k.');

        plot([Thr,Thr],[1,max(HistFH(:,2))],'-r','LineWidth',2);

        if exist('p')
            if not(isempty(p))
                semilogy(HistFH(FitInd,1),exp(polyval(p,HistFH(FitInd,1))),'-g.','LineWidth',2);
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
    
 

TrekSet.Threshold=Thr;

fprintf('The Threshold  = %5.3f %5.3f*%7.4f \n',Thr,Thr/StdVal,StdVal);

disp('>>>>>>>> Pick Threshold finished');
toc;

