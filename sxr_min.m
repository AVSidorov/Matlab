function DisMin=sxr_min(Dis1,Dis2,Plot1,Plot2);

if isempty(Plot1) Plot1=true; end;
if isempty(Plot2) Plot2=true; end;

DisMin=Dis1-Dis2; DisMin(:,1)=Dis1(:,1);
if Plot1|Plot2
    figure; hold on;
    if Plot1 plot(Dis1(:,1),Dis1(:,2:15),'-.'); end;
    if Plot2 plot(DisMin(:,1),DisMin(:,2:15)); end;
end;