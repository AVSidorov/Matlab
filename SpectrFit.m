function [K_W,K_Amp,Wb]=SpectrFit(Spectr,MaxwSp,CalAmplt,CalAmplf,MeasAmplf);

MaxwSp(find(MaxwSp(:,2)<=0),:)=[];
[Max,MaxI]=max(MaxwSp(:,2));
%Max2=max([MaxwSp(MaxI-1,2),MaxwSp(MaxI+1,2)]);
%MaxI2=find(MaxwSp(:,2)==Max2);
%FitI=sort([MaxI,MaxI2]);
 FitI=sort([MaxI-1,MaxI+1]);

Wfit=MaxwSp(FitI(1),1):(MaxwSp(FitI(end),1)-MaxwSp(FitI(1),1))/100:MaxwSp(FitI(end),1);
MaxwFitLn=interp1(MaxwSp(FitI,1),log(MaxwSp(FitI,2)),Wfit,'spline');
MaxwFit=exp(MaxwFitLn(1:end));
[Wmax,WmaxI]=max(MaxwFit);
Wmax=Wfit(WmaxI);

Spectr(:,1)=Spectr(:,1)*(5.9/CalAmplt)*(CalAmplf/MeasAmplf);
[MaxSpectr,MaxSpectrI]=max(Spectr(:,2));
WmaxSp=Spectr(MaxSpectrI,1);

k=Wmax/WmaxSp;
spectr1=Spectr;
spectr1(:,1)=Spectr(:,1)*k;


EndFitPntInd=find(spectr1(:,1)<=MaxwSp(end,1),1,'last');
StFitPntInd=find(spectr1(:,1)>=MaxwSp(FitI(1),1),1,'first');
MaxwFitLn=interp1(MaxwSp(:,1),log(MaxwSp(:,2)),spectr1(StFitPntInd:EndFitPntInd,1),'spline');
MaxwFit=exp(MaxwFitLn(1:end));
[Wmax,WmaxI]=max(MaxwFit);
Amp=MaxSpectr/Wmax;
MaxwFit=MaxwFit*Amp;

WbInd=find((spectr1(StFitPntInd:EndFitPntInd,2)-MaxwFit)>spectr1(StFitPntInd:EndFitPntInd,3));
WbInd=WbInd(find(WbInd>(MaxSpectrI-StFitPntInd)));
WbInd=WbInd(find((circshift(WbInd,-1)-WbInd)==1&(circshift(WbInd,-2)-WbInd)==2,1,'first'));
if isempty(WbInd)
    WbInd=WmaxI;
end;
WbInd=WbInd+StFitPntInd-1;
EndFitPntInd=WbInd-1;
Wb=0.5*(spectr1(WbInd-1,1)+spectr1(WbInd,1));


continue_str='d';
while continue_str~='y'

MaxwFitLn=interp1(MaxwSp(:,1),log(MaxwSp(:,2)),spectr1(StFitPntInd:EndFitPntInd,1),'spline');
MaxwFit=exp(MaxwFitLn(1:end));

Amp=sum(MaxwFit(:).*spectr1(StFitPntInd:EndFitPntInd,2))/sum(MaxwFit(:).*MaxwFit(:));
MaxwFit=MaxwFit*Amp;

trf=figure;
  hold on; grid on;
  title(['K_W=',num2str(k,'%4.2f'),' K_A=',num2str(Amp,'%4.2f'),' W_b=',num2str(Wb,'%4.2f')]);   
  %errorbar(spectr1(:,1),spectr1(:,2),spectr1(:,3),'-ob');
  plot(spectr1(:,1),spectr1(:,2),'-ob');
  plot(MaxwSp(:,1),MaxwSp(:,2)*Amp,'>-g');
  plot(spectr1(StFitPntInd:EndFitPntInd,1),MaxwFit(:),'.-r');              
  plot([Wb,Wb],[1,max(spectr1(:,2))],'-r','LineWidth',2);
  plot([spectr1(StFitPntInd,1),spectr1(StFitPntInd,1)],[spectr1(1,2),max(spectr1(:,2))],'k','LineWidth',1);
  plot([spectr1(EndFitPntInd,1),spectr1(EndFitPntInd,1)],[spectr1(1,2),max(spectr1(:,2))],'k','LineWidth',1);
  axis([0,2*Wb,spectr1(1,2),1.2*max(spectr1(:,2))]);
  set(gca,'YScale','log');

cor_decision=input('To correct Fit Points interval press ''C''\n','s');
cor_decision=lower(cor_decision);
if cor_decision=='c' 
    gr_input_decision=input('For graph interval input press ''g'' \n','s');
    gr_input_decision=lower(gr_input_decision);
    if gr_input_decision=='g'
        dW=spectr1(2,1)-spectr1(1,1);
        disp('Input Start Fit Point Zoom figure if nessecary then press enter');
        pause;
        figure(trf);
        [x,y]=ginput(1);
        StFitPntInd=find(abs(spectr1(:,1)-x)<=dW/2,1,'first');
        if isempty(StFitPntInd)
            StFitPntInd=MaxSpectrI-3;
        end;
        plot([x,x],[1,max(spectr1(:,2))],'g','LineWidth',2);
        disp('Input End Point Zoom figure if nessecary then press enter');
        pause;
        figure(trf);
        [x,y]=ginput(1);
        EndFitPntInd=find(abs(spectr1(:,1)-x)<=dW/2,1,'first');
        if isempty(EndFitPntInd)
            EndFitPntInd=MaxSpectrI+3;
        end;

        continue_str='d';
    end;     
    fprintf('Now Spline Fit interval is [%2.0f:%2.0f]\n',StFitPntInd,EndFitPntInd);
    FitInt=input('input new interval [Start index,End Index]\n');
    if not(isempty(FitInt))
        StFitPntInd=FitInt(1);
        EndFitPntInd=FitInt(end);
        continue_str='d';
    end;
else
 continue_str='y';
end;
 if continue_str~='y' 
     close(gcf);
 end;
end;
kSt=k-0.3;
kEnd=k+0.3;
dk=0.01;

clear Amp MaxwFit k;
A=[];
i=0;
for k=kSt:dk:kEnd
 i=i+1;
 spectr1=Spectr;
 spectr1(:,1)=Spectr(:,1)*k;
  MaxwFitLn=interp1(MaxwSp(:,1),log(MaxwSp(:,2)),spectr1(StFitPntInd:EndFitPntInd,1),'spline');
  MaxwFit=exp(MaxwFitLn(1:end));
 A(i)=sum(MaxwFit(:).*spectr1(StFitPntInd:EndFitPntInd,2))/sum(MaxwFit(:).*MaxwFit(:));
 MaxwFit=MaxwFit*A(i);
 sums(i)=sum((spectr1(StFitPntInd:EndFitPntInd,2)-MaxwFit).*(spectr1(StFitPntInd:EndFitPntInd,2)-MaxwFit));
end;

[MinKhi,MinKhiI]=min(sums);
K_W=kSt+dk*(MinKhiI-1);
K_Amp=A(MinKhiI);
MaxwSp(:,2)=MaxwSp(:,2)*K_Amp;
  spectr1=Spectr;
  spectr1(:,1)=Spectr(:,1)*K_W;
 % MaxwFit=interp1(MaxwSp(:,1),MaxwSp(:,2),spectr1(StFitPntInd:EndFitPntInd,1),'spline');
  maxW=min([spectr1(end,1),MaxwSp(end,1)]);
  FitEndI=find(spectr1(:,1)<=maxW,1,'last');
  MaxwFitLn=interp1(MaxwSp(:,1),log(MaxwSp(:,2)),spectr1(StFitPntInd:FitEndI,1),'spline');
  MaxwFit=exp(MaxwFitLn);
  WbInd=find((spectr1(StFitPntInd:FitEndI,2)-MaxwFit)>spectr1(StFitPntInd:FitEndI,3));
  WbInd=WbInd(find(WbInd>(EndFitPntInd-StFitPntInd)));
  WbInd=WbInd(find((circshift(WbInd,-1)-WbInd)==1&(circshift(WbInd,-2)-WbInd)==2,1,'first'));
  WbInd=WbInd+StFitPntInd-1;
  Wb=0.5*(spectr1(WbInd-1,1)+spectr1(WbInd,1));
figure;
  hold on; grid on;
  %errorbar(spectr1(:,1),spectr1(:,2),spectr1(:,3),'-ob');
  plot(spectr1(:,1),spectr1(:,2),'-ob');
  errorbar(spectr1(WbInd-3:WbInd+3,1),spectr1(WbInd-3:WbInd+3,2),spectr1(WbInd-3:WbInd+3,3),'.-m');
  title(['K_W=',num2str(K_W,'%4.2f'),' K_A=',num2str(K_Amp,'%4.2f\n'),'W_b=',num2str(Wb,'%4.2f keV')]);   
  plot(MaxwSp(:,1),MaxwSp(:,2),'>-g');
  plot(spectr1(StFitPntInd:FitEndI,1),MaxwFit,'.-r');              
  plot([Wb,Wb],[1,max(spectr1(:,2))],'-r','LineWidth',2);
  axis([0,2*Wb,spectr1(1,2),1.2*max(spectr1(:,2))]);
  set(gca,'YScale','log');
