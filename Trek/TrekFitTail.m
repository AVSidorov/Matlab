function FitSet=TrekFitTail(TrekSet,Ind,StpSet)
tic;
fprintf('>>>>>>>>TrekFitTail started Ind is %6d\n',Ind);


if nargin<3
    StpSet=StpStruct(TrekSet.StandardPulse);
end;

Stp=StpSet.Stp;
maxI=StpSet.MaxInd;
StpN=StpSet.size;
trek=TrekSet.trek;
Khi=inf;
%%
FitInd=[1:StpN]'+Ind-maxI;
FitIndPulse=[1:StpN]'; %all arrays vert;

FitInd=FitInd(FitInd>=1&FitInd<=TrekSet.size);
I=find(TrekSet.SelectedPeakInd==Ind);
if I<numel(TrekSet.SelectedPeakInd)
    FitInd=FitInd(FitInd<TrekSet.SelectedPeakInd(I+1)-StpSet.FrontN);
end;
FitIndPulse=FitInd-Ind+maxI;
    

%%
if not(isempty(find(FitInd-StpSet.MaxInd)<2))
N=1;
while N~=numel(FitInd)&&N>0
%%
    N=numel(FitInd);
    
    A=sum(Stp(FitIndPulse).*trek(FitInd))/sum(Stp(FitIndPulse).^2);
    FitInd=[1:StpN]'+Ind-maxI;
    FitIndPulse=[1:StpN]'; %all arrays vert;

    FitInd=FitInd(FitInd>=1&FitInd<=TrekSet.size);
    if I<numel(TrekSet.SelectedPeakInd)
        FitInd=FitInd(FitInd<TrekSet.SelectedPeakInd(I+1)-StpSet.FrontN);
    end;
    FitIndPulse=FitInd-Ind+maxI;

    bool=abs(TrekSet.trek(FitInd)-A*Stp(FitIndPulse))<TrekSet.Threshold;

    FitInd=FitInd(bool);
    FitIndPulse=FitIndPulse(bool);
    
%%
    %if fit pulse points breaks  we reduce FitPulse by
    %removing stand points after breaks
    if not(isempty(FitInd))
     if numel(FitInd)>=StpSet.FrontN

        %Reduce points if break at front    
        HoleLength=diff(FitIndPulse);
        ind=find(HoleLength(FitIndPulse(1:end-1)<=maxI)>1,1,'last');
        if not(isempty(ind))
            FitIndPulse(1:ind)=[];
        end;
        FitInd=FitIndPulse+Ind-maxI;

            if not(isempty(FitInd))

            dAfter=circshift(FitIndPulse,-1)-FitIndPulse; %dist to next
            dAfter(end)=0;
            dBefore=FitIndPulse-circshift(FitIndPulse,1); %dist to previous
            dBefore(1)=0;


            %take first not short part after maximum
            HoleStart=find(dAfter>1); % at least first after max
            HoleEnd=find(dBefore>1);  % at least second after max
            PartLength=FitInd([HoleStart;numel(FitInd)])-FitInd([1;HoleEnd])+1;
            ind=find(PartLength>=StpSet.FrontN,1,'first')-1;
            if not(isempty(ind))&&ind>0
                FitIndPulse(1:HoleStart(ind))=[];
            end;
            FitInd=FitIndPulse+Ind-maxI;

            %reduce on tail after break
            dAfter=circshift(FitIndPulse,-1)-FitIndPulse; %dist to next
            dAfter(end)=0;

            FitIndPulseMax=FitIndPulse(dAfter>=StpSet.FrontN); % very small breaks is not important and take breaks more than
            %it allows to skip PeakOnTail, that gives bad fitting conditions, but fitting was good   
            if not(isempty(FitIndPulseMax))
                FitIndPulseMax=FitIndPulseMax(1); %Take First Break   
                FitIndPulse(FitIndPulse>FitIndPulseMax)=[]; % remove from fitting all points after break
                FitInd=FitIndPulse+Ind-maxI;
            end;
            else
                pause;
            end;
     else
         pause;
     end;
    end;
   

%%
end; %while
else
    N=0;
    A=0;
    Khi=0;
end;
%%

Khi=sqrt(sum(((TrekSet.trek(FitInd)-A*Stp(FitIndPulse))/TrekSet.Threshold).^2)/N);
% Khi=sum((TrekSet.trek(FitInd)-A*Stp(FitIndPulse)).^2)/N/trek(Ind);

FitSet.A=A;
FitSet.B=0;
FitSet.Shift=0;
FitSet.Khi=Khi;
FitSet.FitIndPulse=FitIndPulse;
FitSet.FitInd=FitInd;
FitSet.N=N;
FitSet.FitPulse=A*Stp;
FitSet.FitPulseN=StpN;
FitSet.MaxInd=Ind;
if N>1
    FitSet.Good=true;
    FitSet=TrekFitTime(TrekSet,Ind,StpSet,FitSet);
else
    FitSet.Good=false;
end;

%%
toc;
%% not neccessary if Plot is true fitting will be shown in TrekFitTime
% if TrekSet.Plot
%     figure;
%         plot(FitInd,trek(FitInd));
%         grid on; hold on;
%         plot(FitInd,A*Stp(FitIndPulse),'r');
%         plot(FitInd,trek(FitInd)-A*Stp(FitIndPulse),'k');
%         plot(FitInd(1)+[1,N],[TrekSet.Threshold,TrekSet.Threshold],'g');
%         plot(FitInd(1)+[1,N],[-TrekSet.Threshold,-TrekSet.Threshold],'g');
%     pause;
%     close(gcf);
% end;


