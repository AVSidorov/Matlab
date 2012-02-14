function FIT=TrekFitTime(TrekSet,Ind,StpSet,FitStruct);
tic;
fprintf('>>>>>>>>TrekFitTime started. Ind is %6d\n',Ind);;

Nfit=10;
gs=(1+sqrt(5))/2;


if nargin<3
    StpSet=StpStruct(TrekSet.StandardPulse);
end;

if nargin<4
    FitStruct=TrekFitFast(TrekSet,Ind,StpSet);
end;

FIT=FitStruct;


trek=TrekSet.trek;
Stp=StpSet.Stp;
StpN=StpSet.size;

N=FitStruct.N;
FitInd=FitStruct.FitInd;
FitIndPulse=FitStruct.FitIndPulse;


% shT>0 means shift in time left. Conditions for shT are to Avoid fitting
% by part of front. In this case we have good khi, but
% after subtracting get the negative line, because maximum
% of fit pulse much greater then trek pulse

ShKhi(3,1)=0; %in FitFast made fitting with zero shift last point must be with minimal
ShKhi(3,2)=FIT.Khi;
ShKhi(1:2,1)=[-1;1];
ShKhi(1:2,2)=[inf;inf];
good=[false;false;FIT.Good];


while any(isinf(ShKhi(:,2)))&min(diff(sortrows(ShKhi(:,1))))>=1/Nfit%&abs(ShKhi(end,1)<=1) 
    for i=find(isinf(ShKhi(:,2)))'
       FitPulse=interp1([1:StpN]',Stp,[1:StpN]'+ShKhi(i,1),'spline',0);
       A=sum(FitPulse(FitIndPulse).*trek(FitInd))/sum(FitPulse(FitIndPulse).^2);
%        ShKhi(khiFitInd(i),2)=sum((trek(FitInd)-A*FitPulse(FitIndPulse)).^2)/N/trek(Ind);
       ShKhi(i,2)=sqrt(sum(((trek(FitInd)-A*FitPulse(FitIndPulse))/TrekSet.Threshold).^2)/N);
       good(i)=all(abs(trek(FitInd)-A*FitPulse(FitIndPulse))<TrekSet.Threshold);
    end;
%      ShKhi(not(good),:)=[];  %in peak on front Khi can have not only one minimum
%      good(not(good))=[];  
      [ShKhi,index]=sortrows(ShKhi);
      good=good(index);
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
            ShKhi(end+1,1)=-KhiFit(2)/(2*KhiFit(1));  
            if ShKhi(end,1)<-1
                ShKhi(end,1)=max([-1;0.5*(-1+min( ShKhi(ShKhi(:,1)>-1,1) ))]); 
            end;
            ShKhi(end,2)=inf;
         end;
      else
         [KhiMin,KhiMinInd]=min(ShKhi(:,2));
      end;
     li=max([KhiMinInd-1;1]);
     ri=min([KhiMinInd+1;size(ShKhi,1)]);
     dS=ShKhi(ri,1)-ShKhi(li,1);

     ShKhi(end+1,1)=ShKhi(ri,1)-dS/gs;
     ShKhi(end,2)=inf;
     ShKhi(end+1,1)=ShKhi(li,1)+dS/gs;
     ShKhi(end,2)=inf;
             
end;

for i=find(isinf(ShKhi(:,2)))'
   FitPulse=interp1([1:StpN]',Stp,[1:StpN]'+ShKhi(i,1),'spline',0);
   A=sum(FitPulse(FitIndPulse).*trek(FitInd))/sum(FitPulse(FitIndPulse).^2);
%        ShKhi(khiFitInd(i),2)=sum((trek(FitInd)-A*FitPulse(FitIndPulse)).^2)/N/trek(Ind);
   ShKhi(i,2)=sqrt(sum(((trek(FitInd)-A*FitPulse(FitIndPulse))/TrekSet.Threshold).^2)/N);
   good(i)=all(abs(trek(FitInd)-A*FitPulse(FitIndPulse))<TrekSet.Threshold);
end;
     [ShKhi,index]=sortrows(ShKhi);
      good=good(index);
      KhiFit=[];
      if any(good)        
         [KhiMin,KhiMinInd]=min(ShKhi(good,2));
         GoodInd=find(good);
         KhiMinInd=GoodInd(KhiMinInd);
         StGoodInd=find(not(good(1:KhiMinInd)),1,'last')+1;
         if isempty(StGoodInd)
            StGoodInd=1;
         end;
         EndGoodInd=find(not(good(KhiMinInd:end)),1,'first')+KhiMinInd-1-1;
         if isempty(EndGoodInd)
             EndGoodInd=numel(good);
         end;
         if EndGoodInd-StGoodInd>1
            KhiFit=polyfit(ShKhi(good(StGoodInd:EndGoodInd),1),ShKhi(good(StGoodInd:EndGoodInd),2),2);
         end;

      else
         [KhiMin,KhiMinInd]=min(ShKhi(:,2));
      end;


FitPulse=interp1([1:StpN],Stp,[1:StpN]'+ShKhi(KhiMinInd,1),'spline',0);
A=sum(FitPulse(FitIndPulse).*trek(FitInd))/sum(FitPulse(FitIndPulse).^2);
%  ShKhi(end,2)=sum((trek(FitInd)-A*FitPulse(FitIndPulse)).^2)/N/trek(Ind);




FIT.Good=good(KhiMinInd);
FIT.A=A;
FIT.B=0;
FIT.Shift=ShKhi(KhiMinInd,1);
FIT.Khi=ShKhi(KhiMinInd,2);
FIT.FitPulse=A*FitPulse;
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
            plot(FitInd,A*FitPulse(FitIndPulse),'r');
            plot(FitInd,trek(FitInd)-A*FitPulse(FitIndPulse),'k');
            plot(FitInd(1)+[1,N],[TrekSet.Threshold,TrekSet.Threshold],'g');
            plot(FitInd(1)+[1,N],[-TrekSet.Threshold,-TrekSet.Threshold],'g');
        subplot(2,1,2);
            plot(ShKhi(:,1),ShKhi(:,2),'or');
            grid on; hold on;
            if not(isempty(KhiFit))
                KhiFit=polyfit(ShKhi(:,1),ShKhi(:,2),2);
                t=[-1:1/Nfit:1];
                plot(t,polyval(KhiFit,t));
            end;
            plot(FIT.Shift,FIT.Khi,'d');
    pause;
    close(gcf);
end;

