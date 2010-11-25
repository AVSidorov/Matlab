function Amp=AmpPVQt_analisis(AmpPVQt);
a=0.005;
b=0.9;
% A=2.2956e-4;
% B=0.006;
A=2.6e-4;
B=0.0037;

Amp=[];

Vo=AmpPVQt(:,4);
E=Vo./log(b/a)/a;
P=760*(1+AmpPVQt(:,3));
G=AmpPVQt(:,7)*5e2;
k1=A/log(b/a)/log(b/a)/a./P;
k2=B/log(b/a);
V=(-k2+sqrt(k2^2+4.*k1.*log(G)))./(2*k1);
t=AmpPVQt(:,6);
Gmean=AmpPVQt(:,5);

fa=figure;
set(gca,'YScale','log');
hold on;
grid on;

Dates=AmpPVQt(1,1);
N=size(AmpPVQt,1);
bool=false(N,1);
f=1;
while f==1
    bool=bool|AmpPVQt(:,1)==Dates(end);   
    ind=find(not(bool),1,'first');
    if not(isempty(ind))
        Dates(end+1)=AmpPVQt(ind,1);
        f=1;
    else
        f=0;
    end;
end;
Nday=size(Dates',1);
for i=1:Nday
    pool=find(AmpPVQt(:,1)==Dates(i));
    Shots=AmpPVQt(pool(1),2);
    bool=false(N,1);
    f=1;
    while f==1
        bool=(bool|AmpPVQt(:,2)==Shots(end))&AmpPVQt(:,1)==Dates(i);   
        ind=find(not(bool)&AmpPVQt(:,1)==Dates(i),1,'first');
        if not(isempty(ind))
            Shots(end+1)=AmpPVQt(ind,2);
            f=1;
        else
            f=0;
        end;
    end;

    Nshot=size(Shots',1);

    for ii=1:Nshot
        bool=AmpPVQt(:,2)==Shots(ii)&AmpPVQt(:,1)==Dates(i);
        ind=find(bool);
        if max(size(ind))>2
            T=t(bool);
            dV=(Vo(bool)-V(bool))./Gmean(bool);
            if min(dV)<=0
                dV=dV+abs(min(dV))*1.01+max(dV)/100;
                mrk='*b-';
            else
                mrk='*r-';
            end;
            ch=0;
            while not(isempty(ch))&ch~=1
                if ch==3 T(end)=[]; dV(end)=[]; end;
                f1=figure;
                plot(T,dV,mrk);
                grid on; hold on;
                set(gca,'YScale','log');

                st=input('Input Start point\n');
                if isempty(st) st=1; end;            
                if st>=(max(size(T))-1) st=1; end;

                p=polyfit(T(st:end),log(dV(st:end)),1);

                plot([0,200],exp(polyval(p,[0,200])),'k','LineWidth',2);
                title(['tau is ',num2str(-1/p(1)),'us']);
                figure(f1);
                ch=input('Don''t take - 1. Repeat -2. Repeat without end point-3\n');
                close(gcf);
            end;

            if isempty(ch)
                figure(fa);
                plot(T,dV/max(dV),mrk);
                
                Amp(end+1,1)=Dates(i);
                Amp(end,2)=Shots(ii);
                Amp(end,3)=AmpPVQt(ind(1),3);
                Amp(end,4)=AmpPVQt(ind(1),4);
                Amp(end,5)=max(size(dV));
                Amp(end,6)=p(1);
                Amp(end,7)=p(2);            
            end;
        end;
    end;
    
end;
