function [out,ph,Amp,phRay,Eres,Eant]=density_rays2field(beam,x,y)
% assumes x is center of antenna, y is vertical position

%% constants
c=299792458*100;

%% init
focus=beam.antFocus;
nr=beam.nr;
out.antRX_X=x;
out.antRX_Y=y;


%% preallocation
len_out=NaN(nr,1);
ind_out=NaN(nr,1);
k_out=NaN(nr,1);
x_out=NaN(nr,1);
y_out=NaN(nr,1);
ph_out=NaN(nr,1);

%% find out position (on RX antenna plane), length etc.
for i=1:nr    
    ind=find(beam.r(i).curY<=y,1,'last');
    ind_out(i)=ind;

    dy=y-beam.r(i).curY(ind);
    curK=hypot(beam.r(i).curKx(ind),beam.r(i).curKy(ind));
    dl=inf;
    
    %TODO
    if ind==length(beam.r(i).curY)&&beam.r(i).curKy(ind)~=0
        
        dl=curK*dy/beam.r(i).curKy(ind);

        x_out(i)=beam.r(i).curKx(ind)*dl/curK+beam.r(i).curX(ind);
        y_out(i)=beam.r(i).curKy(ind)*dl/curK+beam.r(i).curY(ind);

        ph_out(i)=beam.r(i).curPhase(ind)+dl*curK;
        len_out(i)=beam.r(i).L(ind)+dl;
        k_out(i)=curK;
    else    
        if beam.r(i).curAy(ind)==0&&beam.r(i).curKy(ind)~=0
            t=dy/beam.r(i).curKy(ind);
        else
            t=roots([beam.r(i).curAy(ind),beam.r(i).curKy(ind),-dy]);
        end;
        t=t(~imag(t));
        t=t(t~=0);
        for ii=1:numel(t)
            kx=beam.r(i).curKx(ind)+beam.r(i).curAx(ind)*t(ii);
            ky=beam.r(i).curKy(ind)+beam.r(i).curAy(ind)*t(ii);
            k1=sqrt(kx^2+ky^2);
            if abs(k1-curK)<1e2*eps
                l=t(ii)*(k1+curK)/2;
            else
                l=t(ii)*(k1-curK)/(log(k1)-log(curK));
            end;
            if l>0&&l<dl
                x_out(i)=beam.r(i).curAx(ind)*t(ii)^2/2+beam.r(i).curKx(ind)*t(ii)+beam.r(i).curX(ind);
                y_out(i)=beam.r(i).curAy(ind)*t(ii)^2/2+beam.r(i).curKy(ind)*t(ii)+beam.r(i).curY(ind);

                dl=l;

                ph_out(i)=beam.r(i).curPhase(ind)+l*(k1+curK)/2;
                len_out(i)=beam.r(i).L(ind)+l;
                k_out(i)=k1;
            end
        end   
    end
end


%% initial ray widths (half distances sum to neighbour rays)
for i=1:nr
    x_in(i)=beam.r(i).curX(1);
    y_in(i)=beam.r(i).curY(1);
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
            if ph_out(i)<=beam.r(i+sh).curPhase(end)
                xx(end+1)=interp1(beam.r(i+sh).curPhase,beam.r(i+sh).curX,ph_out(i),'linear',NaN);
                yy(end+1)=interp1(beam.r(i+sh).curPhase,beam.r(i+sh).curY,ph_out(i),'linear',NaN);
            end
            if ph_out(i)>beam.r(i+sh).curPhase(end)||isnan(xx(end))
                k=hypot(beam.r(i+sh).curKx(end),beam.r(i+sh).curKy(end));
                dl=(ph_out(i)-beam.r(i+sh).curPhase(end))/k;
                xx(end+1)=beam.r(i+sh).curX(end)+dl*beam.r(i+sh).curKx(end)/k;
                yy(end+1)=beam.r(i+sh).curY(end)+dl*beam.r(i+sh).curKy(end)/k;
            end
        else
            xx(end+1)=x_out(i);
            yy(end+1)=y_out(i);
        end
%         if sh==-1
%             col='b';
%         else
%             col='m';
%         end;            
%             plot([x_out(i),xx(end)],[y_out(i),yy(end)],['.-',col]);
     end
    dist1(i)=(sqrt((x_out(i)-xx(1))^2+(y_out(i)-yy(1))^2)+sqrt((x_out(i)-xx(2))^2+(y_out(i)-yy(2))^2))/2;
end
dist1([1,end])=2*dist1([1,end]);
%% out relative to inital Amplitude
amp_out=dist0./dist1;
amp_out=reshape(amp_out,[],1);

%% reduce rays. Leave only intersecting RX antenna plane
indR=find(~isnan(len_out));
ind_out=ind_out(indR);
len_out=len_out(indR);
k_out=k_out(indR);
ph_out=ph_out(indR);
x_out=x_out(indR);
y_out=y_out(indR);
amp_out=amp_out(indR);

[x_out,index]=sortrows(x_out);
indR=indR(index);
ind_out=ind_out(index);
len_out=len_out(index);
k_out=k_out(index);
ph_out=ph_out(index);
y_out=y_out(index);
amp_out=amp_out(index);



[~,~,~,rayGauss]=Gauss_beam(x_out/100,x/100,-focus,beam.freq);
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


%% output
out.ph=ph;
out.ampOut=Amp;

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

