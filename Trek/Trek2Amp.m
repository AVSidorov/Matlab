function Amp=Trek2Amp(TrekSet);
Npoint=200;
HI=0.05;

AmpCol=5;


Nall=size(TrekSet.peaks,1);
Nmean=max([2e3,round(Nall/Npoint)]);
Nmean=min([1e4,Nmean]);
if Nall<3*Nmean Amp=[]; return; end;



peaks=TrekSet.peaks;
peaks(:,AmpCol)=peaks(:,AmpCol)/TrekSet.Amp/5.9;
QCol=size(peaks,2)+1;
peaks(:,end+1)=TrekSet.charge;
peaks=sortrows(peaks,QCol);
    

 St=0;
 dQ=15;
% i=1;
% Ex=0;
IN=zeros(7,1);

for i=1:fix(Nall/Nmean)

% while Ex==0
% N=0;
% while abs(N-Nmean)>10*sqrt(Nmean)
%     En=St+dQ;
%     bool=peaks(:,1)==Date&abs(peaks(:,3)-P)<=0.01&abs(peaks(:,4)-HV)<=5&peaks(:,QCol)>=St&peaks(:,QCol)<En;
%     N=size(find(bool),1);
%     if  Nmean/N<1.3
%         dQ=dQ*Nmean/N;
%     else
%         if N<Nmean 
%             dQ=1.1*dQ;
%         else
%             dQ=0.9*dQ;
%         end;
%     end;
% end;
if i<fix(Nall/Nmean)
    Ind=(i-1)*Nmean+1:i*Nmean;
else
    if (size(peaks,1)-fix(Nall/Nmean)*Nmean)<Nmean/2

      Ind=(i-1)*Nmean+1:size(peaks,1);
    else
      Ind=(i-1)*Nmean+1:i*Nmean;
    end;
end;

Hist=sid_hist(peaks(Ind,AmpCol),1,HI,HI);
[Ps,IN]=Poisson(Hist,IN);

Amp(i,1)=TrekSet.Date;
Amp(i,2)=TrekSet.Shot;
Amp(i,3)=TrekSet.P;
Amp(i,4)=TrekSet.HV;
Amp(i,5)=mean(peaks(Ind,QCol));
% Amp(i,5)=mean(peaks(Ind,QCol+1));
% Amp(i,6)=mean(peaks(Ind,QCol+2));
% Amp(i,7)=mean(peaks(Ind,QCol+3));
Amp(i,6)=Ps.Wmain;
Amp(i,7)=Ps.SigmaMainP;

figure(gcf);

ch=input(['Step ',num2str(i),'. For exit not empty input.\n'],'s');
if not(isempty(ch)) close(gcf); return; end;

close(gcf);
IN(1)=Ps.W1;
IN(2)=Ps.Sigma1;
IN(5)=Ps.W41;
% St=En;
% i=i+1;

% if size(find(peaks(:,1)==Date&abs(peaks(:,3)-P)<=0.01&abs(peaks(:,4)-HV)<=5&peaks(:,QCol)>=St),1)-Nmean<-10*sqrt(Nmean) Ex=1; end;
    
end;

if (size(peaks,1)-fix(Nall/Nmean)*Nmean)>Nmean/2

    Ind=fix(Nall/Nmean)*Nmean+1:size(peaks,1);
    Hist=sid_hist(peaks(Ind,AmpCol),1,HI,HI);
    [Ps,IN]=Poisson(Hist,IN);

    Amp(end+1,1)=TrekSet.Date;
    Amp(end,2)=TrekSet.Shot;
    Amp(end,3)=TrekSet.P;
    Amp(end,4)=TrekSet.HV;
    Amp(end,5)=mean(peaks(Ind,QCol));
    % Amp(end,5)=mean(peaks(Ind,QCol+1));
    % Amp(end,6)=mean(peaks(Ind,QCol+2));
    % Amp(end,7)=mean(peaks(Ind,QCol+3));
    Amp(end,6)=Ps.Wmain;
    Amp(end,7)=Ps.SigmaMainP;
    figure(gcf);
    pause;
    close(gcf);
end;


