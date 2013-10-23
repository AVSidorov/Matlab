function FIT=TrekFitTime(TrekSet,Ind,FitStruct)
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

Stp=STP.Stp;
StpN=STP.size;

trek=TrekSet.trek;

Ipulse=find(TrekSet.SelectedPeakInd==Ind);

ShiftRangeL=10;
ShiftRangeR=10;

if nargin<3||isempty(FitStruct)
    FitStruct.Good=false;
    FitStruct.A=1;
    FitStruct.B=0;
    FitStruct.Shift=0;
    FitStruct.Khi=inf;
    if ~isempty(Ipulse)
        FitStruct.FitInd=TrekSet.strictStInd(Ipulse):TrekSet.strictEndInd(Ipulse);
        FitStruct.FitIndPulse=FitStruct.FitInd-Ind+STP.MaxInd;
        FitStruct.FitIndPulse(FitStruct.FitIndPulse<1|FitStruct.FitIndPulse>StpN)=[];
        FitStruct.FitIndPulse=[STP.BckgFitN-BckgFitN:FitStruct.FitIndPulse(end)];
        FitStruct.FitInd=FitStruct.FitIndPulse+Ind-STP.MaxInd;
        FitStruct.FitInd(FitStruct.FitInd<1|FitStruct.FitInd>TrekSet.size)=[];
        FitStruct.FitIndPulse=FitStruct.FitInd-Ind+STP.MaxInd;
        FitStruct.FitIndPulse(FitStruct.FitIndPulse<1|FitStruct.FitIndPulse>StpN)=[];
    else
        FitStruct.FitInd=[];    
        FitStruct.FitIndPulse=[];
    end;
    FitStruct.FitIndPulseStrict=[];
    FitStruct.N=StpN;
    FitStruct.FitPulse=Stp;
    FitStruct.FitPulseN=StpN;
    FitStruct.MaxInd=STP.MaxInd;
    FitStruct.FitFast=FitFast;
    FitStruct.ShiftRangeL=ShiftRangeL;
    FitStruct.ShiftRangeR=ShiftRangeR;
end;

FIT=FitStruct;
FitFast=FIT.FitFast;

FitInd=FitStruct.FitInd;
FitIndPulse=FitStruct.FitIndPulse;
N=numel(FitInd);


% shT>0 means shift in time left. Conditions for shT are to Avoid fitting
% by part of front. In this case we have good khi, but
% after subtracting get the negative line, because maximum
% of fit pulse much greater then trek pulse

%% determenation shift ranges
if isfield(FIT,'ShiftRangeL')&&~isempty(FIT.ShiftRangeL)
    ShiftRangeL=FIT.ShiftRangeL;
end; 
if isfield(FIT,'ShiftRangeR')&&~isempty(FIT.ShiftRangeR)
    ShiftRangeR=FIT.ShiftRangeR;    
end;
MaxShift=max([ShiftRangeL;ShiftRangeR;STP.FrontN]);
%% initialization of ShKhi
ShKhi(1,1)=ShiftRangeL;
ShKhi(1,2)=inf;
ShKhi(2,1)=0;
ShKhi(2,2)=inf;
ShKhi(3,1)=-ShiftRangeR;
ShKhi(3,2)=inf;
FITs=[FIT,FIT,FIT];

Nold=0;
FitIndOld=0;
timeId=tic;
while T<Tmax&&(N>Nold||numel(intersect(FitInd,FitIndOld))~=N)
%% fitting

while T<Tmax&&any(isinf(ShKhi(:,end)))
    ShKhi(abs(ShKhi(:,1))>MaxShift,:)=[];    

    for i=find(isinf(ShKhi(:,end)))'
       FitPulse=TrekSDDGetFitPulse(STP,ShKhi(i,1));           
       if FitFast
        A=sum(FitPulse(FitIndPulse).*trek(FitInd))/sum(FitPulse(FitIndPulse).^2);
        B=0;
       else
        p=polyfit(FitPulse(FitIndPulse),trek(FitInd),1);
        A=p(1);
        B=p(2);
       end; 
       ShKhi(i,end)=sqrt(sum(((trek(FitInd)-A*FitPulse(FitIndPulse)-B)/TrekSet.Threshold).^2)/N);
       good(i)=all(abs(trek(FitInd)-A*FitPulse(FitIndPulse)-B)<TrekSet.Threshold)&A>TrekSet.Threshold;
       FITs(i)=FIT;
       FITs(i).A=A;
       FITs(i).B=B;
       FITs(i).Good=good(i);
       FITs(i).Shift=ShKhi(i,1);
       FITs(i).Khi=ShKhi(i,end);
       FITs(i).FitPulse=FitPulse;
       FITs(i)=TrekGetFitInd(TrekSet,Ind,FITs(i));        
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
        FIT=TrekGetFitInd(TrekSet,Ind,FIT);
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
N=numel(FitInd);
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
FIT=TrekGetFitInd(TrekSet,Ind,FIT);

%%
toc;
%%
if TrekSet.Plot
    figure;
        subplot(2,1,1);            
            plot(FIT.FitInd,trek(FIT.FitInd));
            grid on; hold on;
            plot(FIT.FitInd,FIT.A*FitPulse(FIT.FitIndPulse)+FIT.B,'r');
            plot(FIT.FitInd,trek(FIT.FitInd)-FIT.A*FitPulse(FIT.FitIndPulse)-FIT.B,'k');
            plot(FIT.FitInd(1)+[1,FIT.N],[TrekSet.Threshold,TrekSet.Threshold],'g');
            plot(FIT.FitInd(1)+[1,FIT.N],[-TrekSet.Threshold,-TrekSet.Threshold],'g');
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

