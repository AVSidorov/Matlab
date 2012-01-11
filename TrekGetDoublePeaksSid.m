function [TrekSet,MinKhi]=TrekGetDoublePeaksSid(TrekSetIn,I);
TrekSet=TrekSetIn;

tic;
disp('>>>>>>>>Get Double Peaks started');

fprintf('Initial Ind - Time is %4d - %5.3fus\n',TrekSet.SelectedPeakInd(I),TrekSet.StartTime+TrekSet.SelectedPeakInd(I)*TrekSet.tau);

Nfit=7;
FitPassN=2;

EndPlot=false;
PulsePlot=false;
FitPlot=false;

trek=TrekSet.trek;
PulseN=numel(TrekSet.StandardPulse);
MaxInd=find(TrekSet.StandardPulse==1); %Standard Pulse must be normalized by Amp
BckgFitInd=find(TrekSet.StandardPulse==0);%Standard Pulse must have several zero point at front end and last zero point
BckgFitInd(end)=[];
BckgFitN=numel(BckgFitInd);
FrontN=MaxInd-BckgFitN;
TailInd=find(TrekSet.StandardPulse<=0);
TailInd(TailInd<MaxInd)=[];
TailInd=TailInd(1);
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
shMax=2*FrontN;
amMin=TrekSet.Threshold/TrekSet.trek(TrekSet.SelectedPeakInd(I));
amMax=1/amMin;



Ind=find(RSF(:,1)>=amMin&RSF(:,1)<=amMax&RSF(:,3)>=PulseFrontMin&RSF(:,3)<=PulseFrontMax);
RSF=RSF(Ind,:);


i=0;
ex=false;
%% first point search
while not(ex)
    i=i+1;

    r=tabulateSid(RSF(:,1));
    s=tabulateSid(RSF(:,2));

    Ind=ceil(size(RSF,1)*rand);
    RS(1:2,i)=RSF(Ind,1:2); %to save search path
%% Check for good Front
%%  make Stp
            PulseShifted=RSF(Ind,1)*interp1([1:PulseN],TrekSet.StandardPulse,[1:PulseN]-(RSF(Ind,2)-fix(RSF(Ind,2))),'spline',0)';
            PulseShifted(find(PulseShifted(1:MaxInd)<0))=0;
            PulseShifted(end)=0;
            Stp=zeros(PulseN+fix(RSF(Ind,2)),1);
            StpN=PulseN+fix(RSF(Ind,2));
            Stp(1:PulseN)=TrekSet.StandardPulse;
            Stp([1:PulseN]+fix(RSF(Ind,2)))=Stp([1:PulseN]+fix(RSF(Ind,2)))+PulseShifted;
            StpR=circshift(Stp,1);
            StpL=circshift(Stp,-1);
            maxI=find(Stp>StpR&Stp>StpL);
            maxI(maxI>=MaxInd+RSF(Ind,2)+2)=[];
            maxN=numel(maxI);           
%% FitInd Determination (initial Fitting)
            FitInd=[1:maxI]+TrekSet.SelectedPeakInd(I)-maxI;
            FitIndPulse=[1:maxI];
            A=sum(Stp(FitIndPulse).*trek(FitInd))/sum(Stp(FitIndPulse).^2);
            bool=TrekSet.trek(FitInd)-A*Stp(FitIndPulse)<TrekSet.Threshold;
            Good(i)=all(bool); 
            if not(Good(i))
                RSF(Ind,:)=[];
                continue;
            end;
%% Check border
    
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
%%  make Stp
            PulseShifted=RSF(Ind,1)*interp1([1:PulseN],TrekSet.StandardPulse,[1:PulseN]-(RSF(Ind,2)-fix(RSF(Ind,2))),'spline',0)';
            PulseShifted(find(PulseShifted(1:MaxInd)<0))=0;
            PulseShifted(end)=0;
            Stp=zeros(PulseN+fix(RSF(Ind,2)),1);
            StpN=PulseN+fix(RSF(Ind,2));
            Stp(1:PulseN)=TrekSet.StandardPulse;
            Stp([1:PulseN]+fix(RSF(Ind,2)))=Stp([1:PulseN]+fix(RSF(Ind,2)))+PulseShifted;
            StpR=circshift(Stp,1);
            StpL=circshift(Stp,-1);
            maxI=find(Stp>StpR&Stp>StpL);
            maxI(maxI>=MaxInd+RSF(Ind,2)+2)=[];
            maxN=numel(maxI);           
%% FitInd Determination (initial Fitting)
            FitInd=[1:maxI]+TrekSet.SelectedPeakInd(I)-maxI;
            FitIndPulse=[1:maxI];
            A=sum(Stp(FitIndPulse).*trek(FitInd))/sum(Stp(FitIndPulse).^2);
            bool=TrekSet.trek(FitInd)-A*Stp(FitIndPulse)<TrekSet.Threshold;
            good=all(bool); 
            if not(good)
                RSF(Ind,:)=[];
                break;
            end;
    end;
   if not(good)
    continue;
   end;
   ex=true;
end; %while not(ex) first point search
toc;






while any(any(KHI(2,2)>KHI))
    for ri=1:3
        for si=1:3
%%  make Stp
            PulseShifted=r(ri)*interp1([1:PulseN],TrekSet.StandardPulse,[1:PulseN]-(s(si)-fix(s(si))),'spline',0)';
            PulseShifted(find(PulseShifted(1:MaxInd)<0))=0;
            PulseShifted(end)=0;
            Stp=zeros(PulseN+fix(s(si)),1);
            StpN=PulseN+fix(s(si));
            Stp(1:PulseN)=TrekSet.StandardPulse;
            Stp([1:PulseN]+fix(s(si)))=Stp([1:PulseN]+fix(s(si)))+PulseShifted;
            StpR=circshift(Stp,1);
            StpL=circshift(Stp,-1);
            maxI=find(Stp>StpR&Stp>StpL);
            maxI(maxI>=MaxInd+s(si)+2)=[];
            maxN=numel(maxI);           
%% FitInd Determination (initial Fitting)
            FitInd=[1:maxI]+TrekSet.SelectedPeakInd(I)-maxI;
            FitIndPulse=[1:maxI];
            A=sum(Stp(FitIndPulse).*trek(FitInd))/sum(Stp(FitIndPulse).^2);
            bool=TrekSet.trek(FitInd)-A*Stp(FitIndPulse)<TrekSet.Threshold;
            Good(ri,si)=all(bool);
            if Good(ri,si)   
                FitInd=[1:StpN]+TrekSet.SelectedPeakInd(I)-maxI;
                FitInd=FitInd(FitInd<=TrekSet.size&FitInd>=1);
                FitIndPulse=FitInd-TrekSet.SelectedPeakInd(I)+maxI;
                bool=TrekSet.trek(FitInd)-A*Stp(FitIndPulse)<TrekSet.Threshold;
                FitInd=FitInd(bool);
                FitIndPulse=FitIndPulse(bool);
                N=numel(FitInd);
%% Time Fitting Khi2 determination               
                Yi=trek(FitInd);
                % shT>0 means shift in time left. Conditions for shT are to Avoid fitting
                % by part of front. In this case we have good khi, but
                % after subtracting get the negative line, because maximum
                % of fit pulse much greater then trek pulse
                shT=1/2;
                KhiMinInd=1;
                while KhiMinInd<3&shT>=-1
                    Khi=[];
                    Khi(1:3)=inf;
                    shTi=1;
                    FineInd=[];
                    while (Khi(end)<=Khi(end-1)|Khi(end-1)<=Khi(end-2))&(shT>=-1)
                        FineInd(end+1)=shT;
                        FitPulse=interp1([1:StpN],Stp,[1:StpN]+shT,'spline',0);
                        A=sum(FitPulse(FitIndPulse).*Yi')/sum(FitPulse(FitIndPulse).^2);
                        Khi(shTi)=sum((Yi'-A*FitPulse(FitIndPulse)).^2)/N/trek(TrekSet.SelectedPeakInd(I));
                        shTi=shTi+1;
                        shT=shT-1/Nfit;                        
                    end;

                    [KhiMin,KhiMinInd]=min(Khi);
                    shT=FineInd(1)+2/Nfit;
                end;
                shTi=shTi-1;
                [KhiMin,KhiMinInd]=min(Khi);
                StInd=max([1,KhiMinInd-2]);
                EndInd=min([shTi,KhiMinInd+2]);

                KhiFit=polyfit(FineInd(StInd:EndInd),Khi(StInd:EndInd),2);
                Shift=-KhiFit(2)/(2*KhiFit(1));

                PulseFine=interp1([1:StpN],Stp,[1:StpN]+Shift,'spline',0);
                A=sum(PulseFine(FitIndPulse).*Yi')/sum(PulseFine(FitIndPulse).^2);
                KHI(ri,si)=sum((Yi'-A*PulseFine(FitIndPulse)).^2)/N/trek(TrekSet.SelectedPeakInd(I));
%%
            end; % if Good       

        end; %for si cycle
    end; %for ri cycle
    KHI(not(Good))=1.1*max(KHI(Good));
    [px,py]=gradient(KHI);
end; % while itteration cycle

toc;



            