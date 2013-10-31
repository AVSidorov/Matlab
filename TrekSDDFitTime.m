function FIT=TrekSDDFitTime(TrekSet,Ind,FitStruct)
tic;
fprintf('>>>>>>>>TrekFitTime started. Ind is %6d\n',Ind);

T=0;
Tmax=10;

Nfit=30;
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
STPD=StpStruct([STP.TimeInd(1:end-1),diff(STP.FinePulse)]);
SPSetStpD=SpecialTreks(STPD.FinePulse);
endIndPulse=round(STPD.TimeInd(SPSetStpD.MinInd(find(STPD.TimeInd(SPSetStpD.MinInd)>STPD.MaxInd,1,'first'))));
if isempty(endIndPulse)||endIndPulse>=STP.MaxInd
    endIndPulse=round((STPD.MaxInd+STP.MaxInd)/2);
end;
FitIndPulseStrict=[1:endIndPulse]';

%% initial fit ind determination        


FitInd=FitIndPulseStrict+Ind-STP.MaxInd;
FitInd=[FitInd(1):Ind]';
FitInd(FitInd<1|FitInd>TrekSet.size)=[];

FitIndPulse=FitInd-Ind+STP.MaxInd;






FitInd=FitIndPulse+Ind-STP.MaxInd;
FitInd(FitInd<1|FitInd>TrekSet.size)=[];
FitIndPulse=FitInd-Ind+STP.MaxInd;

BGLineFit=polyfit(FitInd(FitIndPulse<=STP.BckgFitN),trek(FitInd(FitIndPulse<=STP.BckgFitN)),1);
BGLineFit=[0,0];

if nargin<3||isempty(FitStruct)

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
        ShitfRangeR=MaxShiftR;
    end;
end;

%% initialization of ShKhi
ShKhi(1,1)=ShiftRangeL;
ShKhi(1,2)=inf;
ShKhi(2,1)=0;
ShKhi(2,2)=inf;
ShKhi(3,1)=-ShiftRangeR;
ShKhi(3,2)=inf;

FITs=[FIT,FIT,FIT];

STSet=SpecialTreks(trek(1:Ind));
stI=max([STSet.MinInd(trek(STSet.MinInd)<TrekSet.OverSt*TrekSet.StdVal);Ind-STP.FrontN]);
IndNew=stI+STP.FrontN;
if IndNew~=Ind
    IndMean=(IndNew+Ind)/2;
    if all((Ind-IndNew)~=ShKhi(:,1))
        ShKhi(end+1,1)=Ind-IndNew;
        ShKhi(end,2)=inf;
        FITs=[FITs,FIT];
    end;
    if all((Ind-IndMean)~=ShKhi(:,1))
        ShKhi(end+1,1)=Ind-IndMean;
        ShKhi(end,2)=inf;
        FITs=[FITs,FIT];
    end;
end;



%% fitting

Nold=0;
FitIndOld=0;
timeId=tic;
while T<Tmax&&(N>Nold||numel(intersect(FitInd,FitIndOld))~=N)


while T<Tmax&&any(isinf(ShKhi(:,end)))
    ShKhi(ShKhi(:,1)<-(MaxShiftR+1),:)=[];    %don't move to far right

    for i=find(isinf(ShKhi(:,end)))'
       FitPulse=TrekSDDGetFitPulse(STP,ShKhi(i,1));
       if FitFast
        A=sum(FitPulse(FitIndPulse).*(trek(FitInd)-BGLine))/sum(FitPulse(FitIndPulse).^2);
        B=0;
       else
        p=polyfit(FitPulse(FitIndPulse),(trek(FitInd)-BGLine),1);
        A=p(1);
        B=p(2);
       end; 
       ShKhi(i,end)=sqrt(sum(((trek(FitInd)-BGLine-A*FitPulse(FitIndPulse)-B)/TrekSet.StdVal).^2)/N);
       good(i)=all(abs(trek(FitInd)-BGLine-A*FitPulse(FitIndPulse)-B)<TrekSet.Threshold)&A>TrekSet.Threshold;
       FITs(i)=FIT;
       FITs(i).A=A;
       FITs(i).B=B;
       FITs(i).Good=good(i);
       FITs(i).Shift=ShKhi(i,1);
       FITs(i).Khi=ShKhi(i,end);
       FITs(i).FitPulse=FitPulse;
       FITs(i).BGLineFit=BGLineFit;
       FITs(i)=TrekSDDGetFitInd(TrekSet,FITs(i));        
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
         ShKhi(end,2)=inf;
     end;

  for i=1:numel(MinInds)
     KhiMinInd=MinInds(i);
     li=max([KhiMinInd-1;1]);
     ri=min([KhiMinInd+1;size(ShKhi,1)]);
    if ri-li>1
        [KhiFit,s,m]=polyfit(ShKhi(li:ri,1),ShKhi(li:ri,end),2);
         mid=-KhiFit(2)/(2*KhiFit(1))*m(2)+m(1);
            if mid>-ShiftRangeR&&~any(mid==ShKhi(:,1))%&&mid<ShiftRangeL
                ShKhi(end+1,1)= mid;  
                ShKhi(end,end)=inf;
            end;
     end;
   
     if EndGoodInd-StGoodInd>1 %to avoid bad conditioned fit
        [KhiFit,s,m]=polyfit(ShKhi(good(StGoodInd:EndGoodInd),1),ShKhi(good(StGoodInd:EndGoodInd),end),2);
        mid=-KhiFit(2)/(2*KhiFit(1))*m(2)+m(1);
        if mid>-ShiftRangeR&&~any(mid==ShKhi(:,1))%&&mid<ShiftRangeLKhiFit(1)>0                
                ShKhi(end+1,1)= mid;  
                ShKhi(end,end)=inf;
        end;
     end;

     dS=ShKhi(ri,1)-ShKhi(li,1);

     if ~any(ShKhi(:,1)==ShKhi(ri,1)-dS/gs)
        ShKhi(end+1,1)=ShKhi(ri,1)-dS/gs;
        ShKhi(end,end)=inf;
     end;
     if ~any(ShKhi(:,1)==ShKhi(ri,1)+dS/gs)
        ShKhi(end+1,1)=ShKhi(li,1)+dS/gs;
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
    T=toc(timeId);
%% check for exit
    if T<Tmax&&~notEx&&size(ShKhi,1)>Nfit||(min(diff(sortrows(ShKhi(:,1))))<=1/Nfit&&good(KhiMinInd))%&&abs(ShKhi(end,1)<=1)size(ShKhi,1)&&>=2*Nfit
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
FitInd=FITs(KhiMinInd).FitInd;
FitIndPulse=FITs(KhiMinInd).FitIndPulse;
BGLineFit=FITs(KhiMinInd).BGLineFit;
BGLine=polyval(BGLineFit,FitInd);
N=numel(FitInd);
MaxShiftR=FitInd(end)-Ind+STP.MaxInd-FIT.FitIndPulseStrict(end);
ShKhi=[ShKhi,inf(size(ShKhi,1),1)];
end;

ShKhi(:,end)=[];

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
toc;
%%
if TrekSet.Plot
    figure;
        subplot(2,1,1);            
            plot(FIT.FitInd,trek(FIT.FitInd));
            grid on; hold on;
            plot(Ind,trek(Ind),'*r');
            plot(FIT.FitInd,FIT.A*FitPulse(FIT.FitIndPulse)+FIT.B+BGLine,'r');
            plot(FIT.FitInd,trek(FIT.FitInd)-FIT.A*FitPulse(FIT.FitIndPulse)-FIT.B-BGLine,'k');
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

