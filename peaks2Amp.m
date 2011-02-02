function Amp=peaks2Amp(peaks);
Npoint=200;
HI=0.05;

Date=100319;
N=42;

P=0;
HV=1600;


QCol=5;
AmpCol=6;

% bool=peaks(:,1)==Date&peaks(:,2)==N&abs(peaks(:,3)-P)<=0.01&abs(peaks(:,4)-HV)<=5;
bool=peaks(:,1)==Date&peaks(:,2)==N;

Nall=size(find(bool),1);
Nmean=max([2e3,round(Nall/Npoint)]);
Nmean=min([1e4,Nmean]);
if Nall<3*Nmean Amp=[]; return; end;

P=mean(peaks(bool,3));
HV=mean(peaks(bool,4));

peaks=sortrows(peaks(bool,:),QCol);
    

% St=0;
% dQ=mean(peaks(bool,QCol))/(Nall/Nmean/2);
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

Amp(i,1)=Date;
Amp(i,2)=P;
Amp(i,3)=HV;
Amp(i,4)=mean(peaks(Ind,QCol));
% Amp(i,5)=mean(peaks(Ind,QCol+1));
% Amp(i,6)=mean(peaks(Ind,QCol+2));
% Amp(i,7)=mean(peaks(Ind,QCol+3));
Amp(i,5)=Ps.Wmain;
Amp(i,6)=Ps.SigmaMainP;

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

    Amp(end+1,1)=Date;
    Amp(end,2)=P;
    Amp(end,3)=HV;
    Amp(end,4)=mean(peaks(Ind,QCol));
    % Amp(end,5)=mean(peaks(Ind,QCol+1));
    % Amp(end,6)=mean(peaks(Ind,QCol+2));
    % Amp(end,7)=mean(peaks(Ind,QCol+3));
    Amp(end,5)=Ps.Wmain;
    Amp(end,6)=Ps.SigmaMainP;
    figure(gcf);
    pause;
    close(gcf);
end;


