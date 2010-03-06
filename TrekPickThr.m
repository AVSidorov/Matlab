function TrekSet=TrekPickThr(TrekSetIn);

TrekSet=TrekSetIn;

OverStMin=4;
OverStMax=20;
Plot=true;


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
 
 bool=(FrontHigh>OverStMin*StdVal)&(FrontHigh<OverStMax*StdVal);
 
 HistFH=sid_hist(FrontHigh(bool),1,'max');


 HistR=circshift(HistFH(:,2),1);
 HistL=circshift(HistFH(:,2),-1);
 MinHistBool=HistFH(:,2)<=HistR&HistFH(:,2)<=HistL;

 
 
 PreThr=HistFH(find(MinHistBool,1,'first'),1);
 if Plot
    figure;
    semilogy(HistFH(:,1),HistFH(:,2),'-g.');
    grid on; hold on;
    plot([PreThr,PreThr],[min(HistFH(:,2)),max(HistFH(:,2))],'-g','LineWidth',2);
 end;

 bool=(FrontHigh>PreThr-StdVal)&(FrontHigh<PreThr+StdVal);

[HistFH,HI]=sid_hist(FrontHigh(bool),1);
 
 [MinHist,MinHistInd]=min(HistFH(:,2));
 
 Thr=HistFH(MinHistInd,1);

%  HistR=circshift(HistFH(:,2),1);
%  HistL=circshift(HistFH(:,2),-1);
%  MinHistBool=HistFH(:,2)<=HistR&HistFH(:,2)<=HistL;
% 
% 
%  
%  Thr=HistFH(find(MinHistBool,1,'first'),1);

 if Plot
    semilogy(HistFH(:,1),HistFH(:,2),'-r.');
    plot([Thr,Thr],[min(HistFH(:,2)),max(HistFH(:,2))],'-r','LineWidth',2);
 end;

 

TrekSet.OverStThr=Thr/StdVal;
TrekSet.OverStStd=TrekSet.OverStThr/2; %/2 because Threshold is for FrontHigh, which is double amlitude

TrekSet.Thr=Thr;

fprintf('The Threshold  = %5.3f %5.3f*%7.4f \n',Thr,Thr/StdVal,StdVal);

disp('>>>>>>>> Pick Threshold finished');
toc;

if Plot
    HistFH=sid_hist(FrontHigh,1,HI/5);
    semilogy(HistFH(:,1),HistFH(:,2),'-b.');
end;
