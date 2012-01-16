function [TrekSet,MinKhi]=TrekGetDoublePeaksSid(TrekSetIn,I);
TrekSet=TrekSetIn;

tic;
disp('>>>>>>>>Get Double Peaks started');

fprintf('Initial Ind - Time is %4d - %5.3fus\n',TrekSet.SelectedPeakInd(I),TrekSet.StartTime+TrekSet.SelectedPeakInd(I)*TrekSet.tau);

Nfit=10;

EndPlot=true;
LambdaFitPlot=true;


STP=StpStruct(TrekSet.StandardPulse);

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


rMin=TrekSet.Threshold/TrekSet.trek(TrekSet.SelectedPeakInd(I));
rMax=1/rMin;



Ind=find(RSF(:,1)>=rMin&RSF(:,1)<=rMax&RSF(:,3)>=PulseFrontMin&RSF(:,3)<=PulseFrontMax);
if isempty(Ind)
    pause;
end;

RSF=RSF(Ind,:);


i=0;
ex=false;
%% first point search
while not(ex)
    i=i+1;

    Ind=ceil(size(RSF,1)*rand); %take random point;
    RS(1:2,i)=RSF(Ind,1:2); %to save search path
%% Check for good Front

    STPC=StpCombined(STP,RSF(Ind,1),RSF(Ind,2));   
    FIT=TrekFitFast(TrekSet,I,STPC);    
    Khi(i)=FIT.Khi;
    Good(i)=FIT.Good; 
    if not(Good(i))
        RSF(Ind,:)=[];
        continue;
    end;
%% Check border
    r=tabulateSid(RSF(:,1));
    s=tabulateSid(RSF(:,2));
    
    ri=find(r(:,1)==RSF(Ind,1));
    si=find(s(:,1)==RSF(Ind,2));
    if ri==1|ri==size(r,1)|si==1|si==size(s,1)
        continue;
    else
        ln=RSF(:,2)==RSF(Ind,2)&RSF(:,1)==r(ri-1,1);%left
        rn=RSF(:,2)==RSF(Ind,2)&RSF(:,1)==r(ri+1,1);%right
        un=RSF(:,1)==RSF(Ind,1)&RSF(:,2)==s(si+1,1);%upper
        bn=RSF(:,1)==RSF(Ind,1)&RSF(:,2)==s(si-1,1);%boottom        
    end;
    if not(any(ln)&any(rn)&any(un)&any(bn))
        continue;
    end;
%% Check neighbours Fronts for Good
    for Ind=[find(ln),find(rn),find(un),find(bn)];

        STPC=StpCombined(STP,RSF(Ind,1),RSF(Ind,2));
        FIT=TrekFitFast(TrekSet,I,STPC);    
        
        good=FIT.Good;        
        if not(good)
            RSF(Ind,:)=[];
            break;
        end;
    end;
    if not(good)
        continue;
    end;
%%   
   ex=true;
end; %while not(ex) first point search



%% Conjugate gradients method
 %Boundaryes
 shMin=min(RSF(:,2));
 shMax=max(RSF(:,2));
 rMin=max([rMin,min(RSF(:,1))]);
 rMax=min([rMax,max(RSF(:,1))]);

%% First Point Initialization
r=zeros(5,1);
r(1)=RS(1,i);
r(2)=RSF(find(ln),1);
r(3)=RSF(find(rn),1);
r(4)=RSF(find(un),1);
r(5)=RSF(find(bn),1);

s=zeros(5,1);
s(1)=RS(2,i);
s(2)=RSF(find(ln),2);
s(3)=RSF(find(rn),2);
s(4)=RSF(find(un),2);
s(5)=RSF(find(bn),2);

Gr=1; %previous ratio grad value
Gs=1; %previous shift grad value
Sr=0; %previous ratio move vector value
Ss=0; %previous shift move vector value

KHI=zeros(5,1);

MinKHIInd=2;
iStart=i;
Lambda=[];
Khi=[];
ex=false;

while not(ex)%MinKHIInd>1
%% Calculate KHI for current point and neighbours
    for ii=1:5;
        STPC=StpCombined(STP,r(ii),s(ii));
        FIT=TrekFitTime(TrekSet,I,STPC);    
        good(ii)=FIT.Good;
        KHI(ii)=FIT.Khi;
    end; %for ii cycle

    KHI(not(good))=1.1*max(KHI(good));
    Khi(i)=KHI(1);
    [MinKHI,MinKHIInd]=min(KHI);
%% Finding vectors for CGM

    GRADr(i)=((KHI(2)-KHI(1))./(r(2)-r(1))+(KHI(3)-KHI(1))./(r(3)-r(1)))/2;
    GRADs(i)=((KHI(4)-KHI(1))./(s(4)-s(1))+(KHI(5)-KHI(1))./(s(5)-s(1)))/2;
    w(i)=(GRADr(i)^2+GRADs(i)^2)/(Gr^2+Gs^2);

    dR(i)=-GRADr(i)+w(i)*Sr;
    dS(i)=-GRADs(i)+w(i)*Ss;

    %now vectors will old on next step
    Sr=dR(i); 
    Ss=dS(i);

    Gr=GRADr(i);
    Gs=GRADs(i);
    
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

%% Search lambda - length along [dR(i);dS(i)] vector
    LmbdKhi=[]; %renew if changed fit direction
    LmbdKhi(1:3,1:2)=[0,KHI(1);LambdaMax/2,inf;LambdaMax,inf];
    khiFitInd=1:3;
    [KhiSMin,KhiSMinInd]=min(LmbdKhi(:,2));
    
    while any(isinf(LmbdKhi(khiFitInd,2)))&...
         (min(diff(sortrows(LmbdKhi(khiFitInd,1))))>=LmbdKhi(KhiSMinInd,1)/Nfit|min(diff(sortrows(LmbdKhi(khiFitInd,2))))>=KhiSMin/Nfit)

        for ii=find(isinf(LmbdKhi(khiFitInd,2)))'
            STPC=StpCombined(STP,r(1)+LmbdKhi(khiFitInd(ii),1)*dR(i),s(1)+LmbdKhi(khiFitInd(ii),1)*dS(i));
            FIT=TrekFitTime(TrekSet,I,STPC);
            LmbdKhi(khiFitInd(ii),2)=FIT.Khi;
        end;

        if any(isinf(LmbdKhi(khiFitInd,2)))
            LambdaMax=min(LmbdKhi(isinf(LmbdKhi(:,2)),1));       
            MaxGoodLmbd=max(LmbdKhi(LmbdKhi(:,1)<LambdaMax,1));
            %LambdaMax=0.5*(LambdaMax+MaxGoodLambda);
            khiFitBool=false(size(LmbdKhi,1),1);
            khiFitBool(LmbdKhi(:,1)<=MaxGoodLmbd)=true;
            khiFitInd=find(khiFitBool)';
            LmbdKhi(end+1,1)=0.5*(LambdaMax+MaxGoodLmbd);                
            LmbdKhi(end,2)=inf;
            khiFitInd=[khiFitInd,size(LmbdKhi,1)];
            if numel(khiFitInd)<3
                LmbdKhi(end+1,1)=mean(LmbdKhi(khiFitInd,1));
                LmbdKhi(end,2)=inf;
                khiFitInd=[khiFitInd,size(LmbdKhi,1)];
            end;
            continue;
        end;

        if LmbdKhi(end,2)>KhiSMin
            LmbdKhi=sortrows(LmbdKhi);
            [KhiMin,KhiMinInd]=min(LmbdKhi(:,2));
            li=max([KhiMinInd-1;1]);
            firstBadInd=find(isinf(LmbdKhi(:,2)),1,'first'); %so LmbdKhi is sorted by Lambda
            ri=min([KhiMinInd+1;size(LmbdKhi,1);firstBadInd-1]);             

            AddPointBool=([li,ri]==KhiMinInd);
            if not(isempty(find(AddPointBool)))
                LmbdKhi(end+1,1)=min([max(LmbdKhi([li,ri],1))+0.5*(LmbdKhi(KhiMinInd,1)-LmbdKhi([not(AddPointBool),false],1)),LambdaMax]);
                LmbdKhi(end,2)=inf;
                khiFitInd=[ri,li,size(LmbdKhi,1)];
                continue;
            else
                khiFitInd=[ri,li,KhiMinInd];
            end;
        end;
        KhiSFit=polyfit(LmbdKhi(khiFitInd,1),LmbdKhi(khiFitInd,2),2);
        LmbdKhi(end+1,1)=-KhiSFit(2)/(2*KhiSFit(1));
        khiFitInd=[khiFitInd,size(LmbdKhi,1)];
        if LmbdKhi(end,1)<0
            LmbdKhi(end,1)=min(LmbdKhi(LmbdKhi(:,1)>0,1))/2;
        end;
        if LmbdKhi(end,1)>LambdaMax
            MaxGoodLmbd=max(LmbdKhi(LmbdKhi(:,1)<LambdaMax,1));
            LmbdKhi(end,1)=0.5*(LambdaMax+MaxGoodLmbd);
        end;        
        LmbdKhi(end,2)=inf;
        [KhiSMin,KhiSMinInd]=min(LmbdKhi(:,2));
    end;
    STPC=StpCombined(STP,r(1)+LmbdKhi(end,1)*dR(i),s(1)+LmbdKhi(end,1)*dS(i));
    FIT=TrekFitTime(TrekSet,I,STPC);
    LmbdKhi(end,2)=FIT.Khi;
    [KhiSMin,KhiSMinInd]=min(LmbdKhi(:,2));
    Lambda(i)=LmbdKhi(KhiSMinInd,2);
    if LambdaFitPlot
        figure;
        subplot(3,1,1)
            plot(LmbdKhi(not(isinf(LmbdKhi(:,2))),1),LmbdKhi(not(isinf(LmbdKhi(:,2))),2),'*r');
            grid on; hold on;
            plot(LmbdKhi(khiFitInd,1),LmbdKhi(khiFitInd,2),'or');
            plot(LmbdKhi(KhiSMinInd,1),LmbdKhi(KhiSMinInd,2),'dk');
            plot([LambdaMax,LambdaMax],[KhiSMin,max(LmbdKhi(khiFitInd,2))],'m');
            plot([0:1/Nfit:max(LmbdKhi(khiFitInd,1))],polyval(KhiSFit,[0:1/Nfit:max(LmbdKhi(khiFitInd,1))]));
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
    STPC=StpCombined(STP,r(1)+Lambda(i)*dR(i),s(1)+Lambda(i)*dS(i));
    FIT=TrekFitTime(TrekSet,I,STPC);

    if  FIT.Khi<Khi(i)   
    %% Set new points
        r(1)=RS(1,i)+Lambda(i)*dR(i);
        r(2)=RS(1,i);
        r(3)=RS(1,i)+2*Lambda(i)*dR(i);
        r(4)=r(1);
        r(5)=r(1);

        s(1)=RS(2,i)+Lambda(i)*dS(i);
        s(2)=s(1);
        s(3)=s(1);
        s(4)=RS(2,i);
        s(5)=RS(2,i)+2*Lambda(i)*dS(i);   
        if (Lambda(i)*dR(i)<RS(1,i)/Nfit|Lambda(i)*dS(i)<RS(1,i)/Nfit|(Khi(i)-FIT.Khi)<FIT.Khi/Nfit)&...
            i-iStart>3
            
            ex=true;
        end;
        i=i+1;

        RS(1,i)=r(1);  
        RS(2,i)=s(1);
    %%
    else
        Lambda(i)=[];
        if dR(i)==-GRADr(i)&dS(i)==-GRADs(i)
           ex=true;
        end;
        Sr=0; %if Khi don't decrease then use only Gradient
        Ss=0; %And Repeat the Step
    end;
end; % while itteration cycle
i=numel(Khi);
if size(RS,2)>i
    RS(:,end)=[];
end;

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


            