function Specs=Trek2Specs(TrekSet);
Npoint=20;
HI=0.05;

AmpCol=5;





StT=25000;
EndT=30000;
peaks=TrekSet.peaks;
QCol=size(peaks,2)+1;
peaks(:,end+1)=TrekSet.charge;

bool=peaks(:,2)>=StT&peaks(:,2)<=EndT;
peaks=peaks(bool,:);

peaks=sortrows(peaks,QCol);

Nall=size(peaks,1);
Nmean=max([1e3,round(Nall/Npoint)]);
Nmean=min([1e4,Nmean]);
if Nall<3*Nmean Specs=[]; return; end;


for i=1:fix(Nall/Nmean)

if i<fix(Nall/Nmean)
    Ind=(i-1)*Nmean+1:i*Nmean;
else
    if (size(peaks,1)-fix(Nall/Nmean)*Nmean)<Nmean/2

      Ind=(i-1)*Nmean+1:size(peaks,1);
    else
      Ind=(i-1)*Nmean+1:i*Nmean;
    end;
end;
[Hist,HI,HS,Specs(i)]=sid_hist(peaks(Ind,AmpCol),1,20,20);

figure;
grid on; hold on;
set(gca,'YScale','log');
plot(Hist(:,1),Hist(:,2),'*r-');

ch=input(['Step ',num2str(i),'. For exit not empty input.\n'],'s');
close(gcf);

if not(isempty(ch)) close(gcf); return; end;

    
end;

if (size(peaks,1)-fix(Nall/Nmean)*Nmean)>Nmean/2

    Ind=fix(Nall/Nmean)*Nmean+1:size(peaks,1);
    [Hist,HI,HS,Specs(end+1)]=sid_hist(peaks(Ind,AmpCol),1,20,20);

end;


