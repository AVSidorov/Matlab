function [ph1,ph,x_max1,x_max]=density_out2phaseRay(out)
Eres=out.Eres;
x_out=out.x_out;
ph_out=out.ph_out;

%% Determine position of result field amplitude maximum
%by maximum and parabolic fit
[~,mI]=max(abs(Eres));
if mI>1&&mI<length(x_out)    
    fit=polyfit(x_out(mI-1:mI+1),abs(Eres(mI-1:mI+1)),2);
    x_max=-fit(2)/2/fit(1);    
else
    x_max=x_out(mI);
end

% by weighted mean
x_max1=sum(x_out.*abs(Eres))./sum(abs(Eres));

ph=interp1(x_out,ph_out,x_max);
ph1=interp1(x_out,ph_out,x_max1);

