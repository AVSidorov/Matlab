function [K_W,K_Amp,Wb]=SpectrFit(spectr,MaxwT,TbOfMax,Te,Ne,CalAmplt,CalAmplf,MeasAmplf);

Hist_Arr(:,1)=Hist_Arr(:,1)*(5.9/CalAmplt)*(CalAmplf/MeasAmplf);
[Maxhist,MaxhistI]=max(Hist_Arr(:,2));
Wmaxhist=Hist_Arr(MaxhistI,1);
MaxwSp(:,1:2)=MaxwT(find(abs(MaxwT(:,1)-Te)<=dTe/2),2:3);
Wmax=TbOfMax(TeInd,3);

k=Wmax/Wmaxhist;
Hist1=Hist_Arr;
Hist1(:,1)=Hist_Arr(:,1)*k;
FitEndI=find(Hist1(MaxhistI:end,2)<11,1,'first');
FitStartI=find(Hist1(1:MaxhistI,2)>11,1,'first');
%FitEndI=MaxhistI+FitEndI;
MaxwFit=interp1(MaxwSp(:,1),MaxwSp(:,2),Hist1(FitStartI:FitEndI,1),'spline');
Amp=Maxhist/max(MaxwFit);
MaxwFit=MaxwFit*Amp;


% StFitPntInd=find((Hist1(FitStartI:MaxhistI,2)-MaxwFit(1:size(Hist1(FitStartI:MaxhistI,2),1)))>Hist1(FitStartI:MaxhistI,3));
% StFitPntInd=StFitPntInd(find((circshift(StFitPntInd,1)-StFitPntInd)==1&(circshift(StFitPntInd,2)-StFitPntInd)==2,1,'last'));
% 
% EndFitPntInd=find((Hist1(MaxhistI:FitEndI,2)-MaxwFit(MaxhistI-FitStartI+1:end))>Hist1(MaxhistI:FitEndI,3));
% EndFitPntInd=EndFitPntInd(find((circshift(EndFitPntInd,-1)-EndFitPntInd)==1&(circshift(EndFitPntInd,-2)-EndFitPntInd)==2,1,'first'));

StFitPntInd=find((Hist1(FitStartI:MaxhistI,2)-MaxwFit(1:size(Hist1(FitStartI:MaxhistI,2),1)))>Hist1(FitStartI:MaxhistI,3),1,'last');
%StFitPntInd=StFitPntInd(find((circshift(StFitPntInd,1)-StFitPntInd)==1&(circshift(StFitPntInd,2)-StFitPntInd)==2,1,'last'));

EndFitPntInd=find((Hist1(MaxhistI:FitEndI,2)-MaxwFit(MaxhistI-FitStartI+1:end))>0);
EndFitPntInd=EndFitPntInd(find((circshift(EndFitPntInd,-1)-EndFitPntInd)==1&(circshift(EndFitPntInd,-2)-EndFitPntInd)==2,1,'first'));

Wb=0.5*(Hist1(MaxhistI+EndFitPntInd-1,1)+Hist1(MaxhistI+EndFitPntInd-2,1));

EndFitPntInd=max([3,round(EndFitPntInd*0.5)]);
StFitPntInd=max([2,round(StFitPntInd*0.5)]);

EndFitPntInd=MaxhistI+EndFitPntInd;
StFitPntInd=MaxhistI-StFitPntInd;

StFitLnPntInd=EndFitPntInd;
EndFitLnPntInd=EndFitPntInd+1;


continue_str='d';
while continue_str~='y'

MaxwFit=interp1(MaxwSp(:,1),MaxwSp(:,2),Hist1(StFitPntInd:EndFitPntInd,1),'spline');
MaxwFitLn=Interp1(MaxwSp(:,1),log(MaxwSp(:,2)),Hist1(StFitLnPntInd:EndFitLnPntInd,1));
MaxwFit=[MaxwFit(1:end);exp(MaxwFitLn(2:end))];

Amp=sum(MaxwFit(:).*Hist1(StFitPntInd:EndFitLnPntInd,2))/sum(MaxwFit(:).*MaxwFit(:));
MaxwFit=MaxwFit*Amp;

trf=figure;
  hold on; grid on;
  title(['Time=',num2str(Time,'%4.2f'),' ms, Te=',num2str(Te,'%4.2f'),' ms K_W=',num2str(k,'%4.2f'),...
      ' K_A=',num2str(Amp,'%4.2f'),' W_b=',num2str(Wb,'%4.2f')]);   
  %errorbar(Hist1(:,1),Hist1(:,2),Hist1(:,3),'-ob');
  plot(Hist1(:,1),Hist1(:,2),'-ob');
  plot(MaxwSp(:,1),MaxwSp(:,2)*Amp,'>-g');
  plot(Hist1(StFitPntInd:EndFitLnPntInd,1),MaxwFit(:),'.-r');              
  plot([Wb,Wb],[1,max(Hist1(:,2))],'-r','LineWidth',2);
  set(gca,'YScale','log');

cor_decision=input('To correct Fit Points interval press ''C''\n','s');
cor_decision=lower(cor_decision);
if cor_decision=='c' 
    gr_input_decision=input('For graph interval input press ''g'' \n','s');
    gr_input_decision=lower(gr_input_decision);
    if gr_input_decision=='g'
        dW=Hist1(2,1)-Hist1(1,1);
        disp('Input Start Fit Point Zoom figure if nessecary then press enter');
        pause;
        figure(trf);
        [x,y]=ginput(1);
        StFitPntInd=find(abs(Hist1(:,1)-x)<=dW/2,1,'first');
        if isempty(StFitPntInd)
            StFitPntInd=MaxhistI-3;
        end;
        plot([x,x],[1,max(Hist1(:,2))],'g','LineWidth',2);
        disp('Input End Spline/Start Ln Fit Point Zoom figure if nessecary then press enter');
        pause;
        figure(trf);
        [x,y]=ginput(1);
        EndFitPntInd=find(abs(Hist1(:,1)-x)<=dW/2,1,'first');
        if isempty(EndFitPntInd)
            EndFitPntInd=MaxhistI+3;
        end;
        StFitLnPntInd=EndFitPntInd;
        EndFitLnPntInd=StFitLnPntInd;

        plot([x,x],[1,max(Hist1(:,2))],'c','LineWidth',2);

        disp('Input End Ln Fit Point Zoom figure if nessecary then press enter');
        pause;
        figure(trf);
        [x,y]=ginput(1);
        EndFitLnPntInd=find(abs(Hist1(:,1)-x)<=dW/2,1,'first');
        if isempty(EndFitLnPntInd)
            EndFitLnPntInd=StFitLnPntInd+1;
        end;

        plot([x,x],[1,max(Hist1(:,2))],'m','LineWidth',2);

        continue_str='d';
    end;     
    fprintf('Now Spline Fit interval is [%2.0f:%2.0f]\n',StFitPntInd,EndFitPntInd);
    FitInt=input('input new interval [Start index,End Index]\n');
    if not(isempty(FitInt))
        StFitPntInd=FitInt(1);
        EndFitPntInd=FitInt(end);
        continue_str='d';
    end;
    StFitLnPntInd=EndFitPntInd;
    fprintf('Now Ln Fit interval is [%2.0f:%2.0f]\n',StFitLnPntInd,EndFitLnPntInd);
    FitInt=input('input new interval [Start index,End Index]\n');
    if not(isempty(FitInt))
        StFitLnPntInd=FitInt(1);
        EndFitLnPntInd=FitInt(end);
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
 Hist1=Hist_Arr;
 Hist1(:,1)=Hist_Arr(:,1)*k;
 MaxwFit=interp1(MaxwSp(:,1),MaxwSp(:,2),Hist1(StFitPntInd:EndFitPntInd,1),'spline');
 MaxwFitLn=Interp1(MaxwSp(:,1),log(MaxwSp(:,2)),Hist1(StFitLnPntInd:EndFitLnPntInd,1));
 MaxwFit=[MaxwFit(1:end);exp(MaxwFitLn(2:end))];
 A(i)=sum(MaxwFit(:).*Hist1(StFitPntInd:EndFitLnPntInd,2))/sum(MaxwFit(:).*MaxwFit(:));
 MaxwFit=MaxwFit*A(i);
 sums(i)=sum((Hist1(StFitPntInd:EndFitLnPntInd,2)-MaxwFit).*(Hist1(StFitPntInd:EndFitLnPntInd,2)-MaxwFit));
end;
[MinKhi,MinKhiI]=min(sums);
K_W=kSt+dk*(MinKhiI-1);
K_Amp=A(MinKhiI);
MaxwSp(:,2)=MaxwSp(:,2)*K_Amp;
  Hist1=Hist_Arr;
  Hist1(:,1)=Hist_Arr(:,1)*K_W;
  MaxwFit=interp1(MaxwSp(:,1),MaxwSp(:,2),Hist1(StFitPntInd:EndFitPntInd,1),'spline');
  maxW=min([Hist1(end,1),MaxwSp(end,1)]);
  FitEndI=find(Hist1(:,1)<=maxW,1,'last');
  MaxwFitLn=Interp1(MaxwSp(:,1),log(MaxwSp(:,2)),Hist1(EndFitPntInd:FitEndI,1));
  MaxwFit=[MaxwFit(1:end-1);exp(MaxwFitLn)];
  WbInd=find((Hist1(StFitPntInd:FitEndI,2)-MaxwFit)>Hist1(StFitPntInd:FitEndI,3));
  WbInd=WbInd(find(WbInd>(EndFitLnPntInd-StFitPntInd)));
  WbInd=WbInd(find((circshift(WbInd,-1)-WbInd)==1&(circshift(WbInd,-2)-WbInd)==2,1,'first'));
  WbInd=WbInd+StFitPntInd-1;
  Wb=0.5*(Hist1(WbInd-1,1)+Hist1(WbInd,1));
  Efield=4*Te*Ne/Wb^2;
  Uloop=Efield*2*pi*0.55;
figure;
  hold on; grid on;
  %errorbar(Hist1(:,1),Hist1(:,2),Hist1(:,3),'-ob');
  plot(Hist1(:,1),Hist1(:,2),'-ob');
  errorbar(Hist1(WbInd-3:WbInd+3,1),Hist1(WbInd-3:WbInd+3,2),Hist1(WbInd-3:WbInd+3,3),'.-m');
  title(['Time=',num2str(Time,'%4.2f'),'ms, Te=',num2str(Te,'%4.2f'),'keV, Ne=',num2str(Ne,'%4.2f*10^13cm-3\n'),...
      'K_W=',num2str(K_W,'%4.2f'),' K_A=',num2str(K_Amp,'%4.2f\n'),...
      'W_b=',num2str(Wb,'%4.2f'),'keV, E=',num2str(Efield,'%4.2f'),'V/m, Uloop=',num2str(Uloop,'%4.2fV\n')]);   
  plot(MaxwSp(:,1),MaxwSp(:,2),'>-g');
  plot(Hist1(StFitPntInd:FitEndI,1),MaxwFit,'.-r');              
  plot([Wb,Wb],[1,max(Hist1(:,2))],'-r','LineWidth',2);
  set(gca,'YScale','log');
