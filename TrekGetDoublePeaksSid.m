function [FIT,Ratio,Shift]=TrekGetDoublePeaksSid(TrekSet,I,FitSet);


tic;
disp('>>>>>>>>Get Double Peaks started');

fprintf('Initial Ind - Time is %4d - %5.3fus\n',TrekSet.SelectedPeakInd(I),TrekSet.StartTime+TrekSet.SelectedPeakInd(I)*TrekSet.tau);

Nfit=10;
gs=(1+sqrt(5))/2;

EndPlot=true;
LambdaFitPlot=false;


STP=StpStruct(TrekSet.StandardPulse);
if nargin<3
 FitSet=TrekFitTime(TrekSet,I,STP);
end;
FIT=FitSet;

F=load('D:\!SCN\EField\OvlpTest\RatShFront','RatShFront');
RSF=F.RatShFront;
clear F;

if nargin<2
return;
end;

PulseFrontN=TrekSet.SelectedPeakFrontN(I);
PulseFrontNOver=TrekSet.SelectedPeakInd(I)-find(TrekSet.trek(1:TrekSet.SelectedPeakInd(I))<TrekSet.Threshold,1,'last');

PulseFrontMin=min([PulseFrontN,PulseFrontNOver])-1;
PulseFrontMax=max([PulseFrontN,PulseFrontNOver])+1;
if not(isempty(find(TrekSet.PeakOnFrontInd==TrekSet.SelectedPeakInd(I))))
    PulseFrontMin=PulseFrontMin-1;
    PulseFrontMax=PulseFrontMax+1;
end;


rMin=TrekSet.Threshold/TrekSet.trek(TrekSet.SelectedPeakInd(I));
rMax=1/rMin;



Ind=find(RSF(:,1)>=rMin&RSF(:,1)<=rMax&RSF(:,3)>=PulseFrontMin&RSF(:,3)<=PulseFrontMax);


RSF=RSF(Ind,:);

rTab=tabulateSid(RSF(:,1));
sTab=tabulateSid(RSF(:,2));

Ind=[1:size(RSF,1)];

i=1;
iStart=1;
RS(1,1)=1;
RS(2,1)=0;
Khi(1)=FitSet.Khi;
Good(1)=FitSet.Good;
ExcelentFit=false;
while not(ExcelentFit)
     if isempty(Ind)
         FIT.Good=false;
         Ratio=RS(1,end);
         Shift=RS(2,end);
     return;
     end;
    while not(FIT.Good)&numel(Ind)>0 %search first point better than not combined pulse;
        i=i+1;
        ind=ceil(numel(Ind)*rand); %take random point;
        RS(1:2,i)=RSF(Ind(ind),1:2); %to save search path
        Ind(ind)=[];
        STPC=StpCombined(STP,RS(1,i),RS(2,i));
        FIT=TrekFitTime(TrekSet,I,STPC);
        Khi(i)=FIT.Khi;
        Good(i)=FIT.Good;
    end;
    if not(FIT.Good)
        i=i+1;
        [MinKhi,MinKhiInd]=min(Khi);
        RS(1,i)=RS(1,MinKhiInd);
        RS(2,i)=RS(2,MinKhiInd);
        Khi(i)=MinKhi;
        Good(i)=Good(MinKhiInd);
    end;
    
%% Conjugate gradients method
%% Boundaryes
    %   shMin=min(RSF(:,2));
      shMin=0;              %second peak always shifted in positive direction
    %  shMax=max(RSF(:,2)); 
      shMax=STP.FrontN+2;   %if shift >= then will be 2 maximums
    %  rMin=max([rMin,min(RSF(:,1))]);
       rMin=rMin; 
    %  rMax=min([rMax,max(RSF(:,1))]);
       rMax=rMax; 

%% Init
    Gr=1; %previous ratio grad value
    Gs=1; %previous shift grad value
    Sr=0; %previous ratio move vector value
    Ss=0; %previous shift move vector value

    KHI=zeros(5,1);
    r=zeros(5,1);
    s=zeros(5,1);

    iStart=i;
    Lambda=[];

    ex=false;

    while not(ex)%MinKHIInd>1
%% Calculate KHI for current point and neighbours
%% init points for Gradient (local)
        Dr=[r(1)/Nfit;abs(RS(1,i)-RS(1,i-1))];
        Dr=Dr(find(Dr));
        Dr=min(Dr);

        r(1)=RS(1,i);
        r(2)=max([r(1)-Dr;rMin]); 
        r(3)=min([r(1)+Dr;rMax]);
        r(4)=r(1);
        r(5)=r(1);

        Ds=[1/Nfit;abs(RS(2,i)-RS(2,i-1))];
        Ds=Ds(find(Ds));
        Ds=min(Ds);
        
        s(1)=RS(2,i);
        s(2)=s(1);
        s(3)=s(1);
        s(4)=max([s(1)-Ds;shMin]);
        s(5)=min([s(1)+Ds;shMax]);
%% Fitting point for Gradient

        for ii=1:5;
            STPC=StpCombined(STP,r(ii),s(ii));
            FIT=TrekFitTime(TrekSet,I,STPC);    
            good(ii)=FIT.Good;
            KHI(ii)=FIT.Khi;
        end; %for ii cycle


        Khi(i)=KHI(1);
        Good(i)=good(1);

%% Gradient determenation
        MinKHIbyR=min(KHI([1,4,5]));
        MinKHIbyS=min(KHI([1,2,3]));   
        if MinKHIbyS<KHI(1)
            GRADr(i)=(MinKHIbyS-KHI(1))/(r(find(KHI==MinKHIbyS,1,'first'))-r(1));
        else
            GRADr(i)=0;
        end;

        if MinKHIbyR<KHI(1)
            GRADs(i)=(MinKHIbyR-KHI(1))/(s(find(KHI==MinKHIbyR,1,'first'))-s(1));
        else
            GRADs(i)=0;
        end;
%% Finding vectors for CGM        

        w(i)=(GRADr(i)^2+GRADs(i)^2)/(Gr^2+Gs^2);

        dR(i)=-GRADr(i)+w(i)*Sr;
        dS(i)=-GRADs(i)+w(i)*Ss;

        %now vectors will old on next step
        Sr=dR(i); 
        Ss=dS(i);

        Gr=GRADr(i);
        Gs=GRADs(i);
        if (Sr^2+Ss^2)==0
            ex=true;
            continue;
        end;

%% determination of lambda max
        LambdaMax=inf;
        if dR(i)<0
           LambdaMax=(rMin-r(1))/dR(i);
        elseif dR(i)>0
           LambdaMax=(rMax-r(1))/dR(i);
        end;
          if dS(i)<0
             LambdaMax=min([(shMin-s(1))/dS(i),LambdaMax]);
          elseif dS(i)>0
             LambdaMax=min([(shMax-s(1))/dS(i),LambdaMax]);
          end;

%% Search lambda - length along [dR(i);dS(i)] vector (golden section search)
        LmbdKhi=[]; %renew if changed fit direction
      
        LmbdKhi(1:4,1:2)=[0,KHI(1);LambdaMax*(1-1/gs),inf;LambdaMax/gs,inf;LambdaMax,inf];
        good=[Good(i);false;false;false];
        [KhiSMin,KhiSMinInd]=min(LmbdKhi(:,2));
        Delta=true;

        while any(isinf(LmbdKhi(:,2)))&Delta
              

            for ii=find(isinf(LmbdKhi(:,2)))'
                STPC=StpCombined(STP,r(1)+LmbdKhi(ii,1)*dR(i),s(1)+LmbdKhi(ii,1)*dS(i));
                FIT=TrekFitTime(TrekSet,I,STPC);
                good(ii)=FIT.Good;
                LmbdKhi(ii,2)=FIT.Khi;
            end;

                [LmbdKhi,index]=sortrows(LmbdKhi);
                good=good(index);
                [KhiMin,KhiMinInd]=min(LmbdKhi(:,2));
                li=max([KhiMinInd-1;1]);
                ri=min([KhiMinInd+1;size(LmbdKhi,1)]);
                dL=LmbdKhi(ri,1)-LmbdKhi(li,1);
                LmbdKhi(end+1,1)=LmbdKhi(ri,1)-dL/gs;
                LmbdKhi(end,2)=inf;
                LmbdKhi(end+1,1)=LmbdKhi(li,1)+dL/gs;
                LmbdKhi(end,2)=inf;

                Delta=dL>=LmbdKhi(end-1,1)/Nfit; %Left point may be at lambda=0 so tak point x1=b-dL/gs
                                                % points are
                                                % a(li),x1,x2,b(ri)
        end;
        [KhiMin,KhiMinInd]=min(LmbdKhi(:,2));
        STPC=StpCombined(STP,r(1)+LmbdKhi(KhiMinInd,1)*dR(i),s(1)+LmbdKhi(KhiMinInd,1)*dS(i));
        FIT=TrekFitTime(TrekSet,I,STPC);
        Lambda(i)=LmbdKhi(KhiMinInd,1);
        if LambdaFitPlot
            figure;
            subplot(3,1,1)
                plot(LmbdKhi(not(isinf(LmbdKhi(:,2))),1),LmbdKhi(not(isinf(LmbdKhi(:,2))),2),'*r');
                grid on; hold on;
                plot([LambdaMax,LambdaMax],[KhiMin,max(LmbdKhi(:,2))],'m');
                plot(LmbdKhi(KhiMinInd,1),KhiMin,'ok');
                title('Lambda search');
            subplot(3,1,2)
                plot(RS(1,:),RS(2,:),'.b-');            
                grid on; hold on;
                plot(RS(1,iStart:i),RS(2,iStart:i),'.r-');            
                plot(RS(1,1),RS(2,1),'ob-');
                plot(RS(1,iStart),RS(2,iStart),'dr-');
                plot(RS(1,end),RS(2,end),'*r-');
                title('Ratio-Shift path');
            subplot(3,1,3)
                plot(iStart:i,Khi(iStart:i),'*r-');
                grid on; hold on;
                title('Khi along RS-path');           
            pause;
            close(gcf);           
        end;


%%     

        if  FIT.Khi<Khi(i)   
            if (Lambda(i)*dR(i)<RS(1,i)/Nfit|Lambda(i)*dS(i)<RS(1,i)/Nfit|(Khi(i)-FIT.Khi)<FIT.Khi/Nfit)&...
                i-iStart>3

                ex=true;
                continue;
            end;

            RS(1,end+1)=RS(1,i)+Lambda(i)*dR(i);  
            RS(2,end)=RS(2,i)+Lambda(i)*dS(i);
            i=i+1;

%%
        else
            Lambda(i)=[];
            if dR(i)==-GRADr(i)&dS(i)==-GRADs(i)
               ex=true;
            end;
            Sr=0; %if Khi don't decrease then use only Gradient
            Ss=0; %And Repeat the Step
        end;
    end; % while not(ex) itteration cycle
    i=numel(Khi);
    if size(RS,2)>i
        RS(:,end)=[];
    end;
    STPC=StpCombined(STP,RS(1,end),RS(2,end));
    [TrekSet,ExcelentFit]=TrekSubtract(TrekSet,I,STPC,FIT);
    FIT.Good=ExcelentFit;
end; %while not(FIT.Good);
Ratio=RS(1,end);
Shift=RS(2,end);

toc;
%%

if EndPlot
    figure;
        subplot(2,1,1)
           plot(RS(1,:),RS(2,:),'.b-');            
            grid on; hold on;
            plot(RS(1,iStart:i),RS(2,iStart:i),'.r-');            
            plot(RS(1,1),RS(2,1),'ob-');
            plot(RS(1,iStart),RS(2,iStart),'dr-');
            plot(RS(1,end),RS(2,end),'*r-');
            title('Ratio-Shift path');
        subplot(2,1,2)
            plot(iStart:i,Khi(iStart:i),'*r-');
            grid on; hold on;
            title('Khi along RS-path');   
    pause;
    close(gcf);
end;


            