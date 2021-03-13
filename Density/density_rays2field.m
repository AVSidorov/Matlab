function [out,ph,Amp,phRay,Eres,Eant]=density_rays2field(beam,x,y)
% assumes x is center of antenna, y is vertical position

%% constants
c=299792458*100;

%% init
focus=beam.antFocus;
nr=beam.nr;
out.antRX_X=x;
out.antRX_Y=y;
raysOut=beam.r;

%% preallocation
len_out=NaN(nr,1);
ind_out=NaN(nr,1);
k_out=NaN(nr,1);
x_out=NaN(nr,1);
y_out=NaN(nr,1);
ph_out=NaN(nr,1);
phV_out=NaN(nr,1);

%% find out lengths and position (on RX antenna plane)
for i=1:nr
    kVac=2*pi*raysOut(i).freq/c;
	
    len_out(i)=interp1(raysOut(i).curY,raysOut(i).L,y,'linear',NaN);				
    
    if ~isnan(len_out(i))
        
        ind_out(i)=find(raysOut(i).L<=len_out(i),1,'last');
        ind=ind_out(i);
        
        l=len_out(i)-raysOut(i).L(ind);
        k0=sqrt(raysOut(i).curKx(ind)^2+raysOut(i).curKy(ind)^2);
        
        if ind<length(raysOut(i).curL)
            k1=sqrt(raysOut(i).curKx(ind+1)^2+raysOut(i).curKy(ind+1)^2);
            k_out(i)=((raysOut(i).curL(ind+1)-l)*k0+l*k1)/raysOut(i).curL(ind+1);
        else
            k_out(i)=k0;
        end

        phV_out(i)=len_out(i)*kVac;
        ph_out(i)=raysOut(i).curPhase(ind)+l*(k0+k_out(i))/2;
        
        t=2*l/(k0+k_out(i));        
        x_out(i)=polyval([raysOut(i).curAx(ind)*t^2/2, raysOut(i).curKx(ind)*t, raysOut(i).curX(ind)], l);
        y_out(i)=polyval([raysOut(i).curAy(ind)*t^2/2, raysOut(i).curKy(ind)*t, raysOut(i).curY(ind)], l);
        
    elseif (y-raysOut(i).curY(end))*raysOut(i).curKy(end)>0
        ind_out(i)=-1;
        k_out(i)=sqrt(raysOut(i).curKx(end)^2+raysOut(i).curKy(end)^2);
        l=(y-raysOut(i).curY(end))*k_out(i)/raysOut(i).curKy(end);
        len_out(i)=raysOut(i).L(end)+l;
        phV_out(i)=len_out(i)*kVac;
        ph_out(i)=raysOut(i).curPhase(end)+k_out(i)*l;
        x_out(i)=raysOut(i).curX(end)+ raysOut(i).curKx(end)/k_out(i)*l;
        y_out(i)=raysOut(i).curY(end)+ raysOut(i).curKy(end)/k_out(i)*l;       
    end
end


%% initial ray widths (half distances sum to neighbour rays)
for i=1:nr
    x_in(i)=raysOut(i).curX(1);
    y_in(i)=raysOut(i).curY(1);
end

dist0=sqrt(diff(x_in).^2+diff(y_in).^2);
dist0(end+1)=dist0(end);
dist0(2:end-1)=(dist0(1:end-2)+dist0(2:end-1))/2;
dist1=dist0;

%% calculate new halfwidths
% it's neccesary to find position where neighbour rays have same phase
for i=1:nr
    xx=[];
    yy=[];
    for sh=[-1 1]
        if (i+sh)>=1&&(i+sh)<=nr
            xx(end+1)=interp1(raysOut(i+sh).curPhase,raysOut(i+sh).curX,ph_out(i),'linear',NaN);
            yy(end+1)=interp1(raysOut(i+sh).curPhase,raysOut(i+sh).curY,ph_out(i),'linear',NaN);
        else
            xx(end+1)=x_out(i);
            yy(end+1)=y_out(i);
        end
        if isnan(xx(end))
            k=sqrt(raysOut(i+sh).curKx(end)^2+raysOut(i+sh).curKy(end)^2);
            l=(ph_out(i)-raysOut(i+sh).curPhase(end))/k;
            xx(end)=raysOut(i+sh).curX(end)+raysOut(i+sh).curKx(end)/k*l;
            yy(end)=raysOut(i+sh).curY(end)+raysOut(i+sh).curKy(end)/k*l;
        end
    end
    dist1(i)=(sqrt((x_out(i)-xx(1))^2+(y_out(i)-yy(1))^2)+sqrt((x_out(i)-xx(2))^2+(y_out(i)-yy(2))^2))/2;
end

%% out relative to inital Amplitude
amp_out=dist0./dist1;
amp_out=reshape(amp_out,[],1);

%% reduce rays. Leave only intersecting RX antenna plane
indR=find(~isnan(len_out));
ind_out=ind_out(indR);
len_out=len_out(indR);
k_out=k_out(indR);
phV_out=phV_out(indR);
ph_out=ph_out(indR);
x_out=x_out(indR);
y_out=y_out(indR);
amp_out=amp_out(indR);

[x_out,index]=sortrows(x_out);
indR=indR(index);
ind_out=ind_out(index);
len_out=len_out(index);
k_out=k_out(index);
phV_out=phV_out(index);
ph_out=ph_out(index);
y_out=y_out(index);
amp_out=amp_out(index);



[~,~,~,rayGauss]=Gauss_beam(x_out/100,x/100,-focus,raysOut(1).freq);
rayGauss=rayGauss.';
Eant=beam.ampIn(indR).*amp_out.*exp(-1i*ph_out);
Eres=Eant.*rayGauss;

%% integrating result field on antenna
% distances
dist2=sqrt(diff(x_out).^2+diff(y_out).^2);
dist2(end+1)=dist2(end);
dist2(2:end-1)=(dist2(1:end-2)+dist2(2:end-1))/2;

total=sum(Eres.*dist2*0.7);  
ph=angle(total);
Amp=abs(total);

%% Calculating phase by phase along ray
% Determine position of result field amplitude maximum
[~,mI]=max(abs(Eres));
if mI>1&&mI<length(indR)    
    fit=polyfit(x_out(mI-1:mI+1),abs(Eres(mI-1:mI+1)),2);
    x_max=-fit(2)/2/fit(1);    
else
    x_max=x_out(mI);
end


[~,indMaxOut]=min(abs(x_max-x_out));  %Ray wich comes in maximum of field
[~,indMaxIn]=max(beam.ampIn);         %Ray with maximal initial amplitude
[~,indMidOut]=min(abs(x-x_out));      %Ray wich comes in center of RX antennae

indMaxOut=indR(indMaxOut);
indMidOut=indR(indMidOut);



%% output
out.ph=ph;
out.ampOut=Amp;
out.xMax=x_max;

out.rayMaxIn=indMaxIn;
out.rayMaxOut=indMaxOut;
out.rayMidOut=indMidOut;

out.nrOut=length(x_out);
out.x_out=x_out;
out.y_out=y_out;
out.len_out=len_out;
out.indRay_out=indR;
out.lastPointInd_out=ind_out;
out.ph_out=ph_out;
out.amp_out=amp_out;
out.k_out=k_out;

out.Gauss=rayGauss;
out.Eant=Eant;
out.Eres=Eres;
out.signal=total;

