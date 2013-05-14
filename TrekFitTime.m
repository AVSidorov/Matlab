function FIT=TrekFitTime(TrekSet,Ind,FitStruct)
tic;
fprintf('>>>>>>>>TrekFitTime started. Ind is %6d\n',Ind);

Nfit=30;
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

if nargin<3||isempty(FitStruct)
    FitStruct.Good=false;
    FitStruct.A=1;
    FitStruct.B=0;
    FitStruct.Shift=0;
    FitStruct.Khi=inf;
    if ~isempty(Ipulse)
        FitStruct.FitInd=TrekSet.strictStInd(Ipulse):TrekSet.strictEndInd(Ipulse);
        FitStruct.FitIndPulse=FitStruct.FitInd-Ind+STP.MaxInd;
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
    FitStruct.ShiftRangeL=3;
    FitStruct.ShiftRangeR=3;
end;

FIT=FitStruct;
FitFast=FIT.FitFast;

N=FitStruct.N;
FitInd=FitStruct.FitInd;
FitIndPulse=FitStruct.FitIndPulse;


% shT>0 means shift in time left. Conditions for shT are to Avoid fitting
% by part of front. In this case we have good khi, but
% after subtracting get the negative line, because maximum
% of fit pulse much greater then trek pulse

%% determenation shift ranges
ShitfRangeL=3;
ShiftRangeR=3;
if isfield(FIT,'ShiftRangeL')&&~isempty(FIT.ShiftRangeL)
    ShiftRangeL=FIT.ShiftRangeL;
    MaxShift=ShiftRangeL;
end; 
if isfield(FIT,'ShiftRangeR')&&~isempty(FIT.ShiftRangeR)
    ShiftRangeR=FIT.ShiftRangeR;
    MaxShift=max([ShiftRangeL;ShiftRangeR]);
end;

%% initialization of ShKhi
ShKhi(1,1)=-(mi-1);
ShKhi(1,2)=inf;
if ~any(0==ShKhi(:,1))
    ShKhi(end+1,1)=0;
    ShKhi(end,2)=inf;
end;
if ~any(-ShiftRangeR==ShKhi(:,1))
    ShKhi(end+1,1)=-ShiftRangeR;
    ShKhi(end,2)=inf;
end;
if ~any(ShiftRangeL==ShKhi(:,1))
    ShKhi(end+1,1)=ShiftRangeL;
    ShKhi(end,2)=inf;
end;
if ~any(-(STP.MaxInd-Iend)==ShKhi(:,1))
    ShKhi(end+1,1)=-(STP.MaxInd-Iend);
    ShKhi(end,2)=inf;
end;    
if ~isempty(Ipulse)&&~any(-(STP.FrontN-TrekSet.SelectedPeakFrontN(Ipulse))==ShKhi(:,1))
    ShKhi(end+1,1)=-(STP.FrontN-TrekSet.SelectedPeakFrontN(Ipulse));
    ShKhi(end,2)=inf;
end;    

if ~any(-(STP.FrontN-((Ind-IstTrek)+(Ist-STP.BckgFitN)))==ShKhi(:,1))       %Ind-IstTrek is real front length above noise level 
                                                                            %to this value is added estimated front length below noise level
                                                                            %shift is difference between full front length STP.FrontN and calculated value    
    ShKhi(end+1,1)=-(STP.FrontN-((Ind-IstTrek)+(Ist-STP.BckgFitN)));
    ShKhi(end,2)=inf;
end;    
%% fitting
Ns=numel(FIT.FitIndPulseStrict);
NShKhi=0;
while any(isinf(ShKhi(:,2)))
    ShKhi(abs(ShKhi(:,1))>MaxShift,:)=[];
    while any(isinf(ShKhi(:,2)))
        for i=find(isinf(ShKhi(:,2)))'
           FitPulse=TrekSDDGetFitPulse(STP,ShKhi(i,1));
           FIT.FitPulse=FitPulse;
           FIT.Shift=ShKhi(i,1);
           FIT.A=trek(round(Ind-ShKhi(i,1)));
           FIT.B=0;
           FIT=TrekGetFitInd(TrekSet,Ind,FIT);
           FitInd=FIT.FitInd;
           FitIndPulse=FIT.FitIndPulse;
           FIT.FitIndPulseStrict=FitIndPulse;
           FIT.FitIndStrict=FitInd;
           N=0;
           while FIT.N-N>0
               N=FIT.N;
               if FitFast
                A=sum(FitPulse(FitIndPulse).*trek(FitInd))/sum(FitPulse(FitIndPulse).^2);
                B=0;
               else
                p=polyfit(FitPulse(FitIndPulse),trek(FitInd),1);
                A=p(1);
                B=p(2);
               end; 
               ShKhi(i,2)=sqrt(sum(((trek(FitInd)-A*FitPulse(FitIndPulse)-B)/TrekSet.Threshold).^2)/FIT.N);
               good(i)=all(abs(trek(FitInd)-A*FitPulse(FitIndPulse)-B)<TrekSet.Threshold)&A>TrekSet.Threshold;
               FIT.A=A;
               FIT.B=B;
               FIT=TrekGetFitInd(TrekSet,Ind,FIT);
               FitInd=FIT.FitInd;
               FitIndPulse=FIT.FitIndPulse;
               FIT.FitIndStrict=FitInd;
               FIT.FitIndPulseStrict=FitIndPulse;
           end;
           AB(i,1)=FIT.A;
           AB(i,2)=FIT.B;
           dNs=numel(FIT.FitIndPulseStrict)-Ns;
           if dNs>0
               ShKhi(:,2)=inf;
               Ns=numel(FIT.FitIndPulseStrict);
               break;
           end;
        end;
    end;
    
%      ShKhi(not(good),:)=[];  %in peak on front Khi can have not only one minimum
%      good(not(good))=[];  
      [ShKhi,index]=sortrows(ShKhi);
      good=good(index);
      AB=AB(index,:);
      bool=AB(:,1)<TrekSet.Threshold|isnan(ShKhi(:,2));
      ShKhi(bool,:)=[];
      good(bool)=[];
      AB(bool,:)=[];
      endInd=size(ShKhi,1);
      EndGoodInd=1;
      StGoodInd=1;     
      if isempty(ShKhi)||(size(ShKhi,1)-NShKhi)<=0
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
      NShKhi=size(ShKhi,1);
%% search for characteristic points
      if any(good)
         [KhiMin,KhiMinInd]=min(ShKhi(good,2));
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
         MinInds=find(ShKhi(:,2)<=circshift(ShKhi(:,2),1)&ShKhi(:,2)<=circshift(ShKhi(:,2),-1));
         [KhiMin,KhiMinIndMain]=min(ShKhi(:,2));
      end;
    
     
%% adding shift points for search     
   % if point on edge 
    notEx=false;
    if KhiMinIndMain<=2
        notEx=true;
        ShKhi(end+1,1)=ShKhi(1,1)-1;
        ShKhi(end,2)=inf;
    end;
    
%     if KhiMinIndMain>=endInd-1
%         notEx=true;
%         ShKhi(end+1,1)=ShKhi(endInd,1)+1;
%         ShKhi(end,2)=inf;
%     end;

  for i=1:numel(MinInds)
     KhiMinInd=MinInds(i);
     li=max([KhiMinInd-1;1]);
     ri=min([KhiMinInd+1;size(ShKhi,1)]);
    if ri-li>1
        [KhiFit,s,m]=polyfit(ShKhi(li:ri,1),ShKhi(li:ri,2),2);
         mid=-KhiFit(2)/(2*KhiFit(1))*m(2)+m(1);
            if mid>-ShiftRangeR&&~any(mid==ShKhi(:,1))%&&mid<ShiftRangeL
                ShKhi(end+1,1)= mid;  
                ShKhi(end,2)=inf;
            end;
     end;
   
     if EndGoodInd-StGoodInd>1 %to avoid bad conditioned fit
        [KhiFit,s,m]=polyfit(ShKhi(good(StGoodInd:EndGoodInd),1),ShKhi(good(StGoodInd:EndGoodInd),2),2);
        mid=-KhiFit(2)/(2*KhiFit(1))*m(2)+m(1);
        if mid>-ShiftRangeR&&~any(mid==ShKhi(:,1))%&&mid<ShiftRangeLKhiFit(1)>0                
                ShKhi(end+1,1)= mid;  
                ShKhi(end,2)=inf;
        end;
     end;

     dS=ShKhi(ri,1)-ShKhi(li,1);

     if ~any(ShKhi(:,1)==ShKhi(ri,1)-dS/gs)
        ShKhi(end+1,1)=ShKhi(ri,1)-dS/gs;
        ShKhi(end,2)=inf;
     end;
     if ~any(ShKhi(:,1)==ShKhi(ri,1)+dS/gs)
        ShKhi(end+1,1)=ShKhi(li,1)+dS/gs;
        ShKhi(end,2)=inf;
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
%% check for exit
    if ~notEx&&size(ShKhi,1)>Nfit||(min(diff(sortrows(ShKhi(:,1))))<=1/Nfit&&good(KhiMinInd))%&&abs(ShKhi(end,1)<=1)size(ShKhi,1)&&>=2*Nfit
        if any(good)||size(ShKhi,1)>3*Nfit
            ShKhi(isinf(ShKhi(:,2)),:)=[];
        else
            [KhiMin,KhiMinInd]=min(ShKhi(:,2));
            for i=ShiftRangeL:-1:ShiftRangeL-Nfit
                if ~any(ShKhi(:,1)==i)
                    ShKhi(end+1,1)= i;  
                    ShKhi(end,2)=inf; 
                end;
            end
        end;
    end;
end;


if any(good)
         [KhiMin,KhiMinInd]=min(ShKhi(good,2));
         GoodInd=find(good);
         KhiMinInd=GoodInd(KhiMinInd);
else
    [KhiMin,KhiMinInd]=min(ShKhi(:,2));
end;
FitPulse=TrekSDDGetFitPulse(STP,ShKhi(KhiMinInd,1));





FIT.Good=good(KhiMinInd);
FIT.A=AB(KhiMinInd,1);
FIT.B=AB(KhiMinInd,2);
FIT.Shift=ShKhi(KhiMinInd,1);
FIT.Khi=ShKhi(KhiMinInd,2);
FIT.FitPulse=FitPulse;
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
            plot(ShKhi(:,1),ShKhi(:,2),'.b');
            grid on; hold on;
            plot(ShKhi(good,1),ShKhi(good,2),'or');
            KhiFit=polyfit(ShKhi(:,1),ShKhi(:,2),2);
            plot(ShKhi(:,1),polyval(KhiFit,ShKhi(:,1)));
            if numel(find(good))>2
                KhiFit=polyfit(ShKhi(good,1),ShKhi(good,2),2);
                plot(ShKhi(good,1),polyval(KhiFit,ShKhi(good,1)),'r');
            end;
            plot(FIT.Shift,FIT.Khi,'d');
    pause;
    close(gcf);
end;

