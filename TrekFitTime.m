function FIT=TrekFitTime(TrekSet,Ind,FitStruct)
tic;
fprintf('>>>>>>>>TrekFitTime started. Ind is %6d\n',Ind);

Nfit=20;
gs=(1+sqrt(5))/2;



if nargin<3
    FitStruct=TrekFitFast(TrekSet,Ind);
end;

FIT=FitStruct;
FitFast=FIT.FitFast;

trek=TrekSet.trek;
if ~isempty(TrekSet.STP)
    STP=TrekSet.STP;
else
    STP=StpStruct;
end;

Stp=STP.Stp;
StpN=STP.size;


N=FitStruct.N;
FitInd=FitStruct.FitInd;
FitIndPulse=FitStruct.FitIndPulse;


% shT>0 means shift in time left. Conditions for shT are to Avoid fitting
% by part of front. In this case we have good khi, but
% after subtracting get the negative line, because maximum
% of fit pulse much greater then trek pulse

ShKhi(3,1)=0; %in FitFast made fitting with zero shift last point must be with minimal
ShKhi(3,2)=FIT.Khi;
AB(3,1)=FIT.A;
AB(3,2)=FIT.B;
ShKhi(1:2,1)=[-1;1];
ShKhi(1:2,2)=[inf;inf];
good=[false;false;FIT.Good];


while any(isinf(ShKhi(:,2)))
    for i=find(isinf(ShKhi(:,2)))'
       FitPulse=TrekGetFitPulse(STP,ShKhi(i,1));
       N=0;
       while N~=FIT.N||numel(find(FIT.FitInd-FitInd))>0
           FitInd=FIT.FitInd;
           FitIndPulse=FIT.FitIndPulse;
           N=FIT.N;
           if FitFast
            A=sum(FitPulse(FitIndPulse).*trek(FitInd))/sum(FitPulse(FitIndPulse).^2);
            B=0;
           else
            p=polyfit(FitPulse(FitIndPulse),trek(FitInd),1);
            A=p(1);
            B=p(2);
           end;
           FIT.FitPulse=A*FitPulse+B;
           FIT=TrekGetFitInd(TrekSet,Ind,FIT);
        end;
%        ShKhi(khiFitInd(i),2)=sum((trek(FitInd)-A*FitPulse(FitIndPulse)).^2)/N/trek(Ind);
       ShKhi(i,2)=sqrt(sum(((trek(FitInd)-A*FitPulse(FitIndPulse)-B)/TrekSet.Threshold).^2)/N);
       good(i)=all(abs(trek(FitInd)-A*FitPulse(FitIndPulse)-B)<TrekSet.Threshold);
       AB(i,1)=A;
       AB(i,2)=B;
    end;
%      ShKhi(not(good),:)=[];  %in peak on front Khi can have not only one minimum
%      good(not(good))=[];  
      [ShKhi,index]=sortrows(ShKhi);
      good=good(index);
      AB=AB(index,:);
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
         if EndGoodInd-StGoodInd>1 %to avoid bad conditioned fit
            KhiFit=polyfit(ShKhi(good(StGoodInd:EndGoodInd),1),ShKhi(good(StGoodInd:EndGoodInd),2),2);
            if KhiFit(1)>0
                
                if abs(-KhiFit(2)/(2*KhiFit(1)))<=1&&isempty(find(ShKhi(:,1)==-KhiFit(2)/(2*KhiFit(1))))==0                    
                    ShKhi(end+1,1)= -KhiFit(2)/(2*KhiFit(1));  
                    ShKhi(end,2)=inf;
                end;
            end;
         end;
      else
         [KhiMin,KhiMinInd]=min(ShKhi(:,2));
      end;
     li=max([KhiMinInd-1;1]);
     ri=min([KhiMinInd+1;size(ShKhi,1)]);
     if ri-li>1
        KhiFit=polyfit(ShKhi(li:ri,1),ShKhi(li:ri,2),2);
            if KhiFit(1)>0
                if abs(-KhiFit(2)/(2*KhiFit(1)))<=1&&isempty(find(ShKhi(:,1)==-KhiFit(2)/(2*KhiFit(1))))
                    ShKhi(end+1,1)= -KhiFit(2)/(2*KhiFit(1));  
                    ShKhi(end,2)=inf;
                end;
            end;
     end;
     dS=ShKhi(ri,1)-ShKhi(li,1);
     

     if isempty(find(ShKhi(:,1)==ShKhi(ri,1)-dS/gs))
        ShKhi(end+1,1)=ShKhi(ri,1)-dS/gs;
        ShKhi(end,2)=inf;
     end;
     if isempty(find(ShKhi(:,1)==ShKhi(ri,1)+dS/gs))
        ShKhi(end+1,1)=ShKhi(li,1)+dS/gs;
        ShKhi(end,2)=inf;
     end;
    % check for exit
    if min(diff(sortrows(ShKhi(:,1))))<=1/Nfit%&&abs(ShKhi(end,1)<=1)size(ShKhi,1)&&>=2*Nfit
        ShKhi(isinf(ShKhi(:,2)),:)=[];
    end;
end;



FitPulse=TrekGetFitPulse(STP,ShKhi(KhiMinInd,1));





FIT.Good=good(KhiMinInd);
FIT.A=AB(KhiMinInd,1);
FIT.B=AB(KhiMinInd,2);
FIT.Shift=ShKhi(KhiMinInd,1);
FIT.Khi=ShKhi(KhiMinInd,2);
FIT.FitPulse=A*FitPulse+B;
FIT.FitPulseN=StpN;
FIT.MaxInd=Ind;

%%
toc;
%%
if TrekSet.Plot
    figure;
        subplot(2,1,1);            
            plot(FitInd,trek(FitInd));
            grid on; hold on;
            plot(FitInd,A*FitPulse(FitIndPulse)+B,'r');
            plot(FitInd,trek(FitInd)-A*FitPulse(FitIndPulse)-B,'k');
            plot(FitInd(1)+[1,N],[TrekSet.Threshold,TrekSet.Threshold],'g');
            plot(FitInd(1)+[1,N],[-TrekSet.Threshold,-TrekSet.Threshold],'g');
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

