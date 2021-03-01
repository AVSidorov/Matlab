function [ph,Amp,phRay,x_max,x_out,Erx,Eant]=density_rays2field(raysIn,raysOut,x,y)
% assumes x is center of antenna, y is vertical position

c=299792458*100;
focus=0.0095;

nr=size(raysIn,1);
len_out=NaN(nr,1);
ind_out=NaN(nr,1);
k_out=NaN(nr,1);
x_out=NaN(nr,1);
y_out=NaN(nr,1);
ph_out=NaN(nr,1);
phV_out=NaN(nr,1);
Amp=zeros(nr,1);

for i=1:nr
    kVac=2*pi*raysOut(i).freq/c;
	
    len_out(i)=interp1(raysOut(i).curY,raysOut(i).L,y,'linear',NaN);				
    
	if ~isnan(len_out(i))
        
        ind_out(i)=find(raysOut(i).L<=len_out(i),1,'last');
        ind=ind_out(i);
        
        l=len_out(i)-raysOut(i).L(ind);

        if ind<length(raysOut(i).curL)
            k_out(i)=((raysOut(i).curL(ind+1)-l)*sqrt(raysOut(i).curKx(ind)^2+raysOut(i).curKy(ind)^2)+...
            l*sqrt(raysOut(i).curKx(ind+1)^2+raysOut(i).curKy(ind+1)^2))...
            /raysOut(i).curL(ind+1);
        else
            k_out(i)=sqrt(raysOut(i).curKx(ind)^2+raysOut(i).curKy(ind)^2);
        end

        phV_out(i)=len_out(i)*kVac;
        ph_out(i)=raysOut(i).curPhase(ind)+(sqrt(raysOut(i).curKx(ind)^2+raysOut(i).curKy(ind)^2)+k_out(i))/2*l;
        x_out(i)=polyval([raysOut(i).curAx(ind)*kVac^2/k_out(i)^2, raysOut(i).curKx(ind)/k_out(i), raysOut(i).curX(ind)], l);
        y_out(i)=polyval([raysOut(i).curAy(ind)*kVac^2/k_out(i)^2, raysOut(i).curKy(ind)/k_out(i), raysOut(i).curY(ind)], l);
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


dist0=sqrt(diff(raysIn(:,1)*100).^2+diff(raysIn(:,2)*100).^2);
dist0(end+1)=dist0(end);
dist0(2:end-1)=(dist0(1:end-2)+dist0(2:end-1))/2;
dist1=dist0;

%calculate halfwidths
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
Amp=dist0./dist1;

indR=find(~isnan(len_out));
ind_out=ind_out(indR);
len_out=len_out(indR);
k_out=k_out(indR);
phV_out=phV_out(indR);
ph_out=ph_out(indR);
x_out=x_out(indR);
y_out=y_out(indR);
Amp=Amp(indR);

[x_out,index]=sortrows(x_out);
indR=indR(index);
ind_out=ind_out(index);
len_out=len_out(index);
k_out=k_out(index);
phV_out=phV_out(index);
ph_out=ph_out(index);
y_out=y_out(index);
Amp=Amp(index);


dist2=sqrt(diff(x_out).^2+diff(y_out).^2);
dist2(end+1)=dist2(end);
dist2(2:end-1)=(dist2(1:end-2)+dist2(2:end-1))/2;

[~,~,~,rayGauss]=Gauss_beam(x_out/100,x/100,-focus,raysOut(1).freq);
rayGauss=rayGauss.';
Eant=raysIn(indR,5).*Amp.*exp(-1i*ph_out);
Erx=Eant.*rayGauss;

total=sum(Erx.*dist2*0.7);  

ph=angle(total);
Amp=abs(total);
%% Calculating phase by phase along ray
% Determine position of result field amplitude maximum
[~,mI]=max(abs(Erx));
if mI>1&&mI<length(indR)    
    fit=polyfit(x_out(mI-1:mI+1),abs(Erx(mI-1:mI+1)),2);
    x_max=-fit(2)/2/fit(1);    
else
    x_max=x_out(mI);
end


[~,indMaxIn]=min(abs(x_max-x_out)); %Ray wich comes in maximum of field
[~,indMaxOut]=max(raysIn(:,5));     %Ray with maximal initial amplitude

phBase=abs(y-(raysOut(indMaxIn).curY(1)+raysOut(indMaxOut).curY(1))/2)*kVac;

% phRay=interp1(x_out,(phV_out-ph_out)/2/pi,x_max,'pchip');
phRay=interp1(x_out,(phBase-ph_out)/2/pi,x_max,'pchip');
