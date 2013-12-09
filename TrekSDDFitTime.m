function FIT=TrekSDDFitTime(TrekSet,FitStruct)
FullTimeId=tic;
if isstruct(FitStruct)&&~isempty(FitStruct)&&isfield(FitStruct,'MaxInd')&&~isempty(FitStruct.MaxInd)
    Ind=FitStruct.MaxInd;
else
    Ind=FitStruct;
end;

fprintf('>>>>>>>>TrekFitTime started. Ind is %6d\n',Ind);

T=0;
Tmax=1;

if isfield(TrekSet,'Nfit')&&~isempty(TrekSet.Nfit)
    Nfit=TrekSet.Nfit;
else
    Nfit=30;
end;

BckgFitN=3;
gs=(1+sqrt(5))/2;
FitFast=false;

if ~isempty(TrekSet.STP)
    STP=TrekSet.STP;
else
    STP=StpStruct;
end;


%% determination of strict part of standard pulse
trek=TrekSet.trek;
Stp=STP.Stp;
StpN=STP.size;
FitIndPulseStrict=[1:STP.MinFitPoint]';
MaxShift=STP.MaxInd;
%% initial fit ind determination        

if ~isstruct(FitStruct)||isempty(FitStruct)||isempty(FitStruct.FitInd)
    FitInd=FitIndPulseStrict+Ind-STP.MaxInd;
    nextMarker=TrekSet.SelectedPeakInd(find(TrekSet.SelectedPeakInd>Ind+STP.FrontN,1,'first'));
    endI=max([nextMarker-STP.FrontN;Ind;FitInd(end);find(TrekSet.trek(1:Ind)<TrekSet.OverSt*TrekSet.StdVal,1,'last')+STP.FrontN]);
    FitInd=[FitInd(1):endI]';
    FitInd(FitInd<1|FitInd>TrekSet.size)=[];
    FitInd(FitInd>FitInd(1)+StpN-1)=[];

    FitIndPulse=FitInd-Ind+STP.MaxInd;






    FitInd=FitIndPulse+Ind-STP.MaxInd;
    FitInd(FitInd<1|FitInd>TrekSet.size)=[];
    FitIndPulse=FitInd-Ind+STP.MaxInd;

    BGLineFit=polyfit(FitInd(FitIndPulse<=STP.BckgFitN),trek(FitInd(FitIndPulse<=STP.BckgFitN)),1);
    BGLineFit=[0,0];


    fit=polyfit(Stp(FitIndPulse),trek(FitInd),1);
    
    FitStruct.Good=false;
    FitStruct.A=fit(1);
    FitStruct.B=fit(2);
    FitStruct.Shift=0;
    FitStruct.Khi=inf;
    FitStruct.FitInd=FitInd;
    FitStruct.FitIndStrict=[];
    FitStruct.FitIndPulse=FitIndPulse;
    FitStruct.FitIndPulseStrict=FitIndPulseStrict;
    FitStruct.N=StpN;
    FitStruct.FitPulse=Stp;
    FitStruct.FitPulseN=StpN;
    FitStruct.MaxInd=Ind;
    FitStruct.FitFast=FitFast;
    FitStruct.ShiftRangeL=10;
    FitStruct.ShiftRangeR=10;
    FitStruct.BGLineFit=BGLineFit;
    
end;

FIT=FitStruct;
FitFast=FIT.FitFast;

FitInd=FitStruct.FitInd;
FitIndPulse=FitStruct.FitIndPulse;
N=numel(FitInd);
BGLineFit=FIT.BGLineFit;
BGLine=polyval(FIT.BGLineFit,FitInd);

%% determenation shift ranges
%due to shift FitIndPulse may move to not characteristic part of
%pulse so, we couldn't have a big movement to right (negative shift)
MaxShiftR=FitInd(end)-Ind+STP.MaxInd-FIT.FitIndPulseStrict(end);
ShiftRangeR=MaxShiftR;

if isfield(FIT,'ShiftRangeL')&&~isempty(FIT.ShiftRangeL)
    ShiftRangeL=FIT.ShiftRangeL;
else
    ShiftRangeL=10;
end; 
if isfield(FIT,'ShiftRangeR')&&~isempty(FIT.ShiftRangeR)
    ShiftRangeR=FIT.ShiftRangeR;
    if ShiftRangeR>MaxShiftR
        ShiftRangeR=MaxShiftR;
    end;
end;

%% initialization of ShKhi
ShKhi(1,1)=ShiftRangeL;
ShKhi(1,2)=inf;
ShKhi(2,1)=0;
ShKhi(2,2)=inf;
ShKhi(3,1)=-ShiftRangeR;
ShKhi(3,2)=inf;



if ~FIT.Good
    idx=(Ind-STP.MaxInd:Ind);
    idx=idx(idx>=1&idx<=TrekSet.size);
    STSet=SpecialTreks(trek(idx));
    if ~isempty(STSet)
        STSet.MinInd=STSet.MinInd+idx(1)-1;
        stI=max([STSet.MinInd(trek(STSet.MinInd)<TrekSet.OverSt*TrekSet.StdVal);Ind-STP.FrontN]);
        IndNew=stI+STP.FrontN;
        if IndNew~=Ind
            IndMean=(IndNew+Ind)/2;
            if all((Ind-IndNew)~=ShKhi(:,1))
                ShKhi(end+1,1)=Ind-IndNew;
                ShKhi(end,2)=inf;
            end;
            if all((Ind-IndMean)~=ShKhi(:,1))
                ShKhi(end+1,1)=Ind-IndMean;
                ShKhi(end,2)=inf;
            end;
        end;
    end;
end;


%% fitting

Nold=0;
FitIndOld=0;
timeId=tic;
KhiMinInd=[];
while T<Tmax&&(N>Nold||numel(intersect(FitInd,FitIndOld))~=N)
    if ~isempty(KhiMinInd)
        idx=find(ShKhi(:,1)>=ShKhi(KhiMinInd,1)-2&ShKhi(:,1)<=ShKhi(KhiMinInd,1)+2&~isinf(ShKhi(:,end)));
        KhiMinInd=find(ShKhi(idx,1)==ShKhi(KhiMinInd,1));
        idx(idx<1|idx>size(ShKhi,1))=[];
        FITs=FITs(idx(~isinf(ShKhi(idx,end))));
        good=good(idx(~isinf(ShKhi(idx,end))));
        ShKhi=ShKhi(idx(~isinf(ShKhi(idx,end))),:);
        ShKhi=[ShKhi,inf(size(ShKhi,1),1)];        
    end;
while T<Tmax&&any(isinf(ShKhi(:,end)))
    for i=find(isinf(ShKhi(:,end)))'
       if exist('FITs','var')>0&&~isempty(FITs)&&i<=numel(FITs)
           FitPulse=FITs(i).FitPulse;
       else 
           FitPulse=TrekSDDGetFitPulse(STP,ShKhi(i,1));
       end;
       bool=trek(FitInd)<TrekSet.MaxSignal;
       x=FitPulse(FitIndPulse(bool));
       y=(trek(FitInd(bool))-BGLine(bool));
       N=numel(x);
       if FitFast
        A=sum(FitPulse(FitIndPulse(bool)).*(trek(FitInd(bool))-BGLine))/sum(FitPulse(FitIndPulse(bool)).^2);
        B=0;
       else           
%         p=polyfit(FitPulse(FitIndPulse(bool)),(trek(FitInd(bool))-BGLine(bool)),1);
        
        p(1)=(N*sum(x.*y)-sum(x)*sum(y))/(N*sum(x.^2)-sum(x)^2);
        p(2)=(sum(y)-p(1)*sum(x))/N;
        
        
        A=p(1);
        B=p(2);
       end; 
       PulseSubtract=BGLine+A*FitPulse(FitIndPulse)+B;
       PulseSubtract(PulseSubtract>=TrekSet.MaxSignal)=trek(FitInd(PulseSubtract>=TrekSet.MaxSignal));
       ShKhi(i,end)=sqrt(sum(((trek(FitInd)-PulseSubtract)/TrekSet.StdVal).^2)/N);
       good(i)=all(abs(trek(FitInd)-PulseSubtract)<TrekSet.Threshold)&A>TrekSet.StdVal;
       FITs(i)=FIT;
       FITs(i).A=A;
       FITs(i).B=B;
       FITs(i).Good=good(i);
       FITs(i).Shift=ShKhi(i,1);
       FITs(i).Khi=ShKhi(i,end);
       FITs(i).FitPulse=FitPulse;
       FITs(i).BGLineFit=BGLineFit;
%        FITs(i)=TrekSDDGetFitInd(TrekSet,FITs(i));        
    end;
    
%      ShKhi(not(good),:)=[];  %in peak on front Khi can have not only one minimum
%      good(not(good))=[];  
      [ShKhi,index]=sortrows(ShKhi);
      good=good(index);
      FITs=FITs(index);
      bool=isnan(ShKhi(:,end));
      ShKhi(bool,:)=[];
      good(bool)=[];
      FITs(bool)=[];
      endInd=size(ShKhi,1);
      EndGoodInd=1;
      StGoodInd=1;     
      if isempty(ShKhi)
        FitPulse=TrekSDDGetFitPulse(STP,0);
        FIT.FitPulse=FitPulse;
        FIT.Shift=0;
        FIT.Good=false;
        FIT.A=TrekSet.trek(Ind);
        FIT.B=0;
        FIT.MaxInd=Ind;
        FIT=TrekSDDGetFitInd(TrekSet,FIT);
        return; 
      end;
%% search for characteristic points
      if any(good)
         [KhiMin,KhiMinInd]=min(ShKhi(good,end));
         GoodInd=find(good);
         KhiMinInd=GoodInd(KhiMinInd);
         
         StGoodInd=find(not(good(1:KhiMinInd)),1,'last')+1;
         if isempty(StGoodInd)
            StGoodInd=1;
         end;
         EndGoodInd=find(not(good(KhiMinInd:end)),1,'first')+KhiMinInd-1-1;
         %KhiMinInd-1 to make index equal full indexes
         %second -1, to take previous point before first false
         if isempty(EndGoodInd)
             EndGoodInd=numel(good);
         end;
         MinInds=KhiMinInd;
         KhiMinIndMain=KhiMinInd;
      else
         MinInds=find(ShKhi(:,end)<=circshift(ShKhi(:,end),1)&ShKhi(:,end)<=circshift(ShKhi(:,end),-1)&ShKhi(:,end)>0);
         NotZeroKhi=find(ShKhi(:,end)>0);
         [KhiMin,KhiMinIndMain]=min(ShKhi(NotZeroKhi,end));
         KhiMinIndMain=NotZeroKhi(KhiMinIndMain);
      end;
     
      
      d=inf;
      if KhiMinIndMain>1
          d=min([d;ShKhi(KhiMinIndMain,1)-ShKhi(KhiMinIndMain-1,1)]);
      end;
      if KhiMinIndMain<size(ShKhi,1)
          d=min([d;ShKhi(KhiMinIndMain+1,1)-ShKhi(KhiMinIndMain,1)]);
      end;
     
%% adding shift points for search     
   % if point on edge 
    notEx=false;
    if KhiMinIndMain<=2
        notEx=true;
        ShKhi(end+1,1)=ShKhi(1,1)-1;
        ShKhi(end,end)=inf;
    end;
    
     if KhiMinIndMain>=endInd-1
         notEx=true;
         ShKhi(end+1,1)=ShKhi(endInd,1)+1;
         ShKhi(end,end)=inf;
     end;

  for i=1:numel(MinInds)
     KhiMinInd=MinInds(i);
     li=max([KhiMinInd-1;1]);
     ri=min([KhiMinInd+1;size(ShKhi,1)]);
    if ri-li>1&&range(ShKhi(li:ri,end))>1/Nfit
        [KhiFit,s,m]=polyfit(ShKhi(li:ri,1),ShKhi(li:ri,end),2);
         mid=-KhiFit(2)/(2*KhiFit(1))*m(2)+m(1);
            if mid>-ShiftRangeR&&~any(mid==ShKhi(:,1))%&&mid<ShiftRangeL
                ShKhi(end+1,1)= mid;  
                ShKhi(end,end)=inf;
            end;
     end;
   
     if EndGoodInd-StGoodInd>1&&range(ShKhi(good(StGoodInd:EndGoodInd),end))>1/Nfit %to avoid bad conditioned fit
        [KhiFit,s,m]=polyfit(ShKhi(good(StGoodInd:EndGoodInd),1),ShKhi(good(StGoodInd:EndGoodInd),end),2);
        mid=-KhiFit(2)/(2*KhiFit(1))*m(2)+m(1);
        if mid>-ShiftRangeR&&~any(mid==ShKhi(:,1))%&&mid<ShiftRangeLKhiFit(1)>0                
                ShKhi(end+1,1)= mid;  
                ShKhi(end,end)=inf;
        end;
     end;

     dS=ShKhi(ri,1)-ShKhi(li,1);

     Rgs=ShKhi(ri,1)-dS/gs;
     Rgs=round(Rgs*Nfit)/Nfit;
     if ~any(ShKhi(:,1)==Rgs)
        ShKhi(end+1,1)=ShKhi(ri,1)-dS/gs;
        ShKhi(end,end)=inf;
     end;
     
     Lgs=ShKhi(li,1)+dS/gs;
     Lgs=round(Lgs*Nfit)/Nfit;
     if ~any(ShKhi(:,1)==Lgs)
        ShKhi(end+1,1)=Lgs;
        ShKhi(end,end)=inf;
     end;
%  % gradient search
%         if KhiMinInd>2
%         bool=false(size(ShKhi,1),1);
%         bool(1:KhiMinInd-1,1)=true;
%         bool=bool&ShKhi(:,2)~=inf&~isnan(ShKhi(:,2));
%         [p,s,m]=polyfit(ShKhi(bool,1),ShKhi(bool,2),1);
%         
%         r=roots(p)*m(2)+m(1);
%         if ~isempty(r)&&~any(ShKhi(:,1)==r)
%             ShKhi(end+1,1)= r;  
%             ShKhi(end,2)=inf;
%         end;
%       end;
% 
%      
%         bool=false(size(ShKhi,1),1);
%         bool(KhiMinInd+1:endInd,1)=true;
%       if KhiMinInd<endInd-1          
%         [p,s,m]=polyfit(ShKhi(bool,1),ShKhi(bool,2),1);
%         r=roots(p)*m(2)+m(1);
%         if ~isempty(r)&&~any(ShKhi(:,1)==r)
%             ShKhi(end+1,1)= r;  
%             ShKhi(end,2)=inf;
%         end;
%       end;

    end;
    ShKhi(abs(ShKhi(:,1))>MaxShift,:)=[];    %don't move to far right
    ShKhi(diff(ShKhi(:,1))==0,:)=[];
    T=toc(timeId);
%% check for exit
    if ~notEx&&(size(ShKhi(~isinf(ShKhi(:,end)),:),1)>Nfit||d<=1/Nfit)%&&abs(ShKhi(end,1)<=1)size(ShKhi,1)&&>=2*Nfit
        if any(good)||size(ShKhi,1)>3*Nfit
            ShKhi(isinf(ShKhi(:,end)),:)=[];
        else
            [KhiMin,KhiMinInd]=min(ShKhi(:,end));
            for i=ShiftRangeL:-1:ShiftRangeL-Nfit
                if ~any(ShKhi(:,1)==i)
                    ShKhi(end+1,1)= i;  
                    ShKhi(end,end)=inf; 
                end;
            end
        end;
    end;
end;


if any(good)
         [KhiMin,KhiMinInd]=min(ShKhi(good,end));
         GoodInd=find(good);
         KhiMinInd=GoodInd(KhiMinInd);
else
    [KhiMin,KhiMinInd]=min(ShKhi(:,end));
    NotZeroKhi=find(ShKhi(:,end)>0);
    [KhiMin,KhiMinInd]=min(ShKhi(NotZeroKhi,end));
    KhiMinInd=NotZeroKhi(KhiMinInd);
end;
FitPulse=TrekSDDGetFitPulse(STP,ShKhi(KhiMinInd,1));

%% Changing FitInd
FitIndOld=FitInd;
Nold=N;
FITs(KhiMinInd)=TrekSDDGetFitInd(TrekSet,FITs(KhiMinInd));  
FitInd=FITs(KhiMinInd).FitInd;
FitIndPulse=FITs(KhiMinInd).FitIndPulse;
BGLineFit=FITs(KhiMinInd).BGLineFit;
BGLine=polyval(BGLineFit,FitInd);
N=numel(FitInd);
end;



FIT.Good=good(KhiMinInd);
FIT.A=FITs(KhiMinInd).A;
FIT.B=FITs(KhiMinInd).B;
FIT.Shift=ShKhi(KhiMinInd,1);
FIT.Khi=ShKhi(KhiMinInd,end);
FIT.FitPulse=FITs(KhiMinInd).FitPulse;
FIT.FitPulseN=StpN;
FIT.MaxInd=Ind;
FIT=TrekSDDGetFitInd(TrekSet,FITs(KhiMinInd));
BGLine=polyval(FIT.BGLineFit,FIT.FitInd);

%%

%%
if TrekSet.Plot
    figure;
        subplot(2,1,1);            
            plot(FIT.FitInd,trek(FIT.FitInd));
            grid on; hold on;
            plot(Ind,trek(Ind),'*r');
            plot(FIT.FitInd,FIT.A*FitPulse(FIT.FitIndPulse)+FIT.B+BGLine,'r');
            PulseSubtract=BGLine+A*FitPulse(FitIndPulse)+B;
            PulseSubtract(PulseSubtract>=TrekSet.MaxSignal)=0;
            plot(FIT.FitInd,trek(FIT.FitInd)-PulseSubtract,'k');
            plot(FIT.FitInd(1)+[1,FIT.N],[TrekSet.Threshold,TrekSet.Threshold],'g');
            plot(FIT.FitInd(1)+[1,FIT.N],[-TrekSet.Threshold,-TrekSet.Threshold],'g');
%             plot(FIT.FitInd,polyval(FIT.BGLineFit,FIT.FitInd),'m');
        subplot(2,1,2);
            grid on; hold on;
            for i=2:size(ShKhi,2)
                plot(ShKhi(:,1),ShKhi(:,i),'b');
            end;
            plot(ShKhi(:,1),ShKhi(:,end),'.b');
            plot(ShKhi(good,1),ShKhi(good,end),'or');
            KhiFit=polyfit(ShKhi(:,1),ShKhi(:,end),2);
            plot(ShKhi(:,1),polyval(KhiFit,ShKhi(:,1)),'k');
            if numel(find(good))>2
                KhiFit=polyfit(ShKhi(good,1),ShKhi(good,end),2);
                plot(ShKhi(good,1),polyval(KhiFit,ShKhi(good,1)),'r');
            end;
            plot(FIT.Shift,FIT.Khi,'d');
    pause;
    close(gcf);
end;

