function DisDiv=sxr_div(Dis1,Dis2,Plot1);

if isempty(Plot1) Plot1=true; end;

DisDiv=Dis1./Dis2; DisDiv(:,1)=Dis1(:,1);

if Plot1
    figure; hold on;
    plot(DisDiv(:,1),DisDiv(:,2:15));
end;