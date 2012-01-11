function [TrekSet,MinKhi]=TrekGetDoublePeaksSid(TrekSetIn,I);
TrekSet=TrekSetIn;

tic;
disp('>>>>>>>>Get Double Peaks started');

fprintf('Initial Ind - Time is %4d - %5.3fus\n',TrekSet.SelectedPeakInd(I),TrekSet.StartTime+TrekSet.SelectedPeakInd(I)*TrekSet.tau);

Nfit=2;

Plot=true;


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


shMin=0;
shMax=2*STP.FrontN;
amMin=TrekSet.Threshold/TrekSet.trek(TrekSet.SelectedPeakInd(I));
amMax=1/amMin;



Ind=find(RSF(:,1)>=amMin&RSF(:,1)<=amMax&RSF(:,3)>=PulseFrontMin&RSF(:,3)<=PulseFrontMax);
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


while MinKHIInd>1
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
%% Search lambda - length along [dR(i);dS(i)] vector
    %??? How to pick Lambda Step
    dL=1;
    KhiSMinInd=1;
    while KhiSMinInd<3&dL(1)>0.001
        dL(1)=dL(1)/Nfit;
        dL(2:end)=[];
        KhiS=[];
        KhiS(1)=KHI(1);    
        Lambdas=[];
        Lambdas(1)=0;
        while KhiSMinInd>numel(KhiS)-2&any(KhiS<inf)
            Lambdas(end+1)=Lambdas(end)+dL(end);
            STPC=StpCombined(STP,r(1)+Lambdas(end)*dR(i),s(1)+Lambdas(end)*dS(i));
            FIT=TrekFitTime(TrekSet,I,STPC);
            KhiS(end+1)=FIT.Khi;
            [KhiSMin,KhiSMinInd]=min(KhiS);
            dL(end+1)=dL(1)*log(2*numel(KhiS)); %make dL greater if too many steps
        end;
    end;
    StInd=max([1,KhiSMinInd-2]);
    EndInd=min([numel(KhiS),KhiSMinInd+2]);
    Khi(isinf(Khi))=1.1*max(Khi(not(isinf(Khi))));
    if (EndInd-StInd)>1&KhiSMinInd>1
        KhiSFit=polyfit(Lambdas(StInd:EndInd),KhiS(StInd:EndInd),2);
        Lambda(i)=-KhiSFit(2)/(2*KhiSFit(1));
    else
        Lambda(i)=Lambdas(KhiSMinInd);
    end;

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

        i=i+1;

        RS(1,i)=r(1);  
        RS(2,i)=s(1);
    %%
    else
        if dR(i)==-GRADr(i)&dS(i)==-GRADs(i)
            MinKHIInd=1;
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
if Plot
    figure;
        subplot(2,1,1)
            plot(RS(1,:),RS(2,:),'.r-');
            grid on; hold on;
            plot(RS(1,1),RS(2,1),'or-');
            plot(RS(1,end),RS(2,end),'*r-');
        subplot(2,1,2)
            plot(iStart:i,Khi(iStart:i),'*r-');
            grid on; hold on;
    pause;
    close(gcf);
end;


            