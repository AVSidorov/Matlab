function FIT=TrekFitTime(TrekSet,I,StpSet,FitStruct);

Plot=false;
Nfit=10;

if nargin<3
    StpSet=StpStruct(TrekSet.StandardPulse);
end;

if nargin<4
    FitStruct=TrekFitFast(TrekSet,I,StpSet);
end;

FIT=FitStruct;

if FitStruct.Good
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
    khiFitInd=1:3;

    while any(isinf(ShKhi(khiFitInd,2)))&min(diff(sortrows(ShKhi(khiFitInd,1))))>=1/Nfit%&abs(ShKhi(end,1)<=1) 
        for i=find(isinf(ShKhi(khiFitInd,2)))'
           FitPulse=interp1([1:StpN]',Stp,[1:StpN]'+ShKhi(khiFitInd(i),1),'spline',0);
           A=sum(FitPulse(FitIndPulse).*trek(FitInd))/sum(FitPulse(FitIndPulse).^2);
           ShKhi(khiFitInd(i),2)=sum((trek(FitInd)-A*FitPulse(FitIndPulse)).^2)/N/trek(TrekSet.SelectedPeakInd(I));
        end;  
        if ShKhi(khiFitInd(end),2)>min(ShKhi(:,2)) %in peak on front Khi can have not only one minimum
            ShKhi=sortrows(ShKhi);
            [KhiMin,KhiMinInd]=min(ShKhi(:,2));
%             li=find(ShKhi(:,1)<ShKhi(KhiMinInd,1),1,'first');
%             ri=find(ShKhi(:,1)>ShKhi(KhiMinInd,1),1,'first');
%           if ShKhi sorted
            li=max([KhiMinInd-1;1]);
            ri=min([KhiMinInd+1;size(ShKhi,1)]);
            AddPointBool=([li,ri]==KhiMinInd);
            if not(isempty(find(AddPointBool)))
                ShKhi(end+1,1)=max(ShKhi([li,ri],1))+0.5*(ShKhi(KhiMinInd,1)-ShKhi([not(AddPointBool),false],1));%ri and li always different indexes
                khiFitInd=[li,ri,size(ShKhi,1)];
                ShKhi(end,2)=inf;        
                continue;
            else
                khiFitInd=[li,ri,KhiMinInd];
            end;
            
        end;
        KhiFit=polyfit(ShKhi(khiFitInd,1),ShKhi(khiFitInd,2),2);
        ShKhi(end+1,1)=-KhiFit(2)/(2*KhiFit(1));
        khiFitInd=[khiFitInd,size(ShKhi,1)];
        if ShKhi(end,1)<-1
            ShKhi(end,1)=max([-1;0.5*(-1+min( ShKhi(ShKhi(:,1)>-1,1) ))]); 
        end;
        ShKhi(end,2)=inf;        
    end;

    FitPulse=interp1([1:StpN],Stp,[1:StpN]'+ShKhi(end,1),'spline',0);
    A=sum(FitPulse(FitIndPulse).*trek(FitInd))/sum(FitPulse(FitIndPulse).^2);
    ShKhi(end,2)=sum((trek(FitInd)-A*FitPulse(FitIndPulse)).^2)/N/trek(TrekSet.SelectedPeakInd(I));
    
    [KhiMin,KhiMinInd]=min(ShKhi(:,2));
    FitPulse=interp1([1:StpN],Stp,[1:StpN]'+ShKhi(KhiMinInd,1),'spline',0);
    A=sum(FitPulse(FitIndPulse).*trek(FitInd))/sum(FitPulse(FitIndPulse).^2);

    FIT.A=A;
    FIT.B=0;
    FIT.Shift=ShKhi(KhiMinInd,1);
    FIT.Khi=KhiMin;
    FIT.FitPulse=A*FitPulse;
    FIT.FitPulseN=StpN;


%%
    if Plot
        figure;
            subplot(2,1,1);            
                plot(FitInd,trek(FitInd));
                grid on; hold on;
                plot(FitInd,A*FitPulse(FitIndPulse),'r');
                plot(FitInd,trek(FitInd)-A*FitPulse(FitIndPulse),'k');
                plot(FitInd(1)+[1,N],[TrekSet.Threshold,TrekSet.Threshold],'g');
                plot(FitInd(1)+[1,N],[-TrekSet.Threshold,-TrekSet.Threshold],'g');
            subplot(2,1,2);
                plot(ShKhi(khiFitInd,1),ShKhi(khiFitInd,2),'or');
                grid on; hold on;
                plot(ShKhi(:,1),ShKhi(:,2),'*r')
                KhiFit=polyfit(ShKhi(khiFitInd,1),ShKhi(khiFitInd,2),2);
                t=[-1:1/Nfit:1];
                plot(t,polyval(KhiFit,t));
                plot(FIT.Shift,FIT.Khi,'d');
        pause;
        close(gcf);
    end;

end; %if FitStruct.Good
