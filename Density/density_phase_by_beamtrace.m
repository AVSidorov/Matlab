function [prof,ph,phU]=density_phase_by_beamtrace(x,y,n,rays,antSet,ph,Ncount,freq)
if size(antSet,2)<4
    antSet(:,3:4)=antSet(:,1:2);
    antSet(:,4)=-antSet(:,4);
end

if nargin<8||isempty(freq)
    freq=[];
end;
    
if nargin<6||isempty(ph)
    if nargin<7||isempty(Ncount)
        Ph=density_phase_by_grid(y,n,freq);
        Ncount=ceil(ceil(max(Ph))/0.4);
    end;
    ph=zeros(size(antSet,1),Ncount+1);
    stI=1;
elseif nargin<7||isempty(Ncount)||Ncount==size(ph,2)-1
        Ncount=size(ph,2)-1;
        stI=Ncount+1;
elseif ~isempty(ph)&&~isempty(Ncount)
        stI=size(ph,2)+1;        
else
    stI=1;
end
    
n(isnan(n))=0;
n0=n;

for count=stI:Ncount+1
    n=n0*(count-1)/Ncount;
    for ii=1:size(antSet,1)
         ph(ii,count)=density_beamtrace(x,y,n,rays,antSet(ii,1),antSet(ii,2),antSet(ii,3),antSet(ii,4),freq);
    end;
    disp(count);
end;
phU=unwrap(ph')-repmat(ph(:,1)',Ncount+1,1);
phU=phU/2/pi;
phU=phU';
prof=phU(:,end);