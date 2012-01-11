function FIT=TrekFitTime(TrekSet,I,StpStruct,FitStruct);

Plot=false;
Nfit=10;

if nargin<3
    StpStruct=StpStruct(TrekSet.StandardPulse);
end;

if nargin<4
    FitStruct=TrekFitFast(TrekSet,I,StpStruct);
end;

FIT=FitStruct;

if FitStruct.Good
    trek=TrekSet.trek;
    Stp=StpStruct.Stp;
    StpN=StpStruct.size;

    N=FitStruct.N;
    FitInd=FitStruct.FitInd;
    FitIndPulse=FitStruct.FitIndPulse;


    Yi=trek(FIT.FitInd);
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
    KHI=sum((Yi'-A*PulseFine(FitIndPulse)).^2)/N/trek(TrekSet.SelectedPeakInd(I));

    FIT.A=A;
    FIT.Shift=Shift;
    FIT.Khi=KHI;
end; %if FitStruct.Good


%%
if Plot
    figure;
        subplot(2,1,1);
            plot(FitIndPulse,trek(FitInd));
            grid on; hold on;
            plot(FitIndPulse,A*PulseFine(FitIndPulse),'r');
            plot(FitIndPulse,Yi'-A*PulseFine(FitIndPulse),'k');
            plot([1,N],[TrekSet.Threshold,TrekSet.Threshold],'g');
            plot([1,N],[-TrekSet.Threshold,-TrekSet.Threshold],'g');
        subplot(2,1,2);
            plot(FineInd,Khi,'*r-');
            grid on; hold on;
            t=[FineInd(KhiMinInd-1):(FineInd(KhiMinInd+1)-FineInd(KhiMinInd-1))/Nfit:FineInd(KhiMinInd+1)];
            plot(t,polyval(KhiFit,t));
            plot(Shift,KHI,'d');
    pause;
    close(gcf);
end;