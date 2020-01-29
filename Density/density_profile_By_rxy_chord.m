function [rV1,rV2]=density_profile_By_rxy_chord(rxy,xchord,ychord,value)
fit=polyfit(xchord,ychord,1);
slope=fit(1);
intercept=polyval(fit,0);
 if ~all(diff(xchord))
     intercept=xchord(1);
     slope=inf;
 elseif ~all(diff(ychord))
     intercept=ychord(1);
     slope=0;
 end;
XYVR=density_chord_By_rxyV(slope,intercept,rxy,zeros(length(rxy),1));
if all(diff(xchord))
    VbyX=interp1(xchord,value,XYVR(:,1));
end
if all(diff(ychord))
    VbyY=interp1(ychord,value,XYVR(:,2));    
end