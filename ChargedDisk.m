function U=ChargedDisk(V,R,W,Ni,B); 
% electric field of a charged disk
%V - the potential difference between the central wire and the border B, V
%R - radius of the disc, mm  
%W - width of the disc, mm 
%Ni - The number of ions in the flat disk
%B - the border radius, mm
%U - potential from the centre
% Fredy R. Zypman. Off-axis electric field of a ring of charge. 
%                  Am. J. Phys. 74 4, April 2006

eps0=8.854187817e-12; % F/m
q=1.602e-19; % coulombs, ion charge
mH=1.673e-27; % proton mass
mAr=mH*40;    % Argon mass
d=0.025; % (was diameter) radius of the central wire, mm

Shape='G'; %  G- Gaussian, R-Rectangular

% ellptic integrals:
xx=0:0.001:1; [K,E] = ellipke(xx);
% (1-xx)*K-> 0 when xx->1 
% the best approximation in inteval [xx(end-1):x(end)] is
% (1-xx)^P*K=pi/2*(1-x) =>
P=1-log(K(end-1))/log(pi/2*(1-xx(end-1))); 


N=3000; % the number of points along the radius
Step=(B-d)/(N-1);
r=[d:Step:B]';

if Shape=='G'
    Charge(:,1)=r;
    Charge(:,2)=exp(-((r-R)/W).^2/2); 
    Charge(1:2,2)=0; Charge(Charge(:,2)<1e-3,2)=0;
    Charge(Charge(:,2)==0,:)=[];
    Charge(:,2)=q*Ni*Charge(:,2)/sum(Charge(:,2));
end;
if Shape=='R'
    Charge=zeros(N,2);
    Charge(:,1)=r;
    Charge((r<R-W/2|r>R+W/2),:)=[]; 
    Charge(:,2)=q*Ni/sum(Charge(:,2));
end;

NC=size(Charge,1);

% electric field of a ring
Coeff1=1e6/4/pi/eps0*Charge(:,2)/pi./Charge(:,1).^2;
Sqrt2=2^0.5;  x0=1-Sqrt2/pi;
Er=zeros(N,NC);
U=zeros(N,NC);
tic;
for i=1:NC; 
  x=r/Charge(i,1);  
  x(r==Charge(i,1))=x0;
  Er(:,i)=-Coeff1(i)*x./(1+x.^2).^1.5.*(pi+Sqrt2./(x-1));
  U(:,i)=cumsum(Er(:,i))*Step/1000;
end;

toc
tic; 
ErExact=zeros(N,NC);
UExact=zeros(N,NC);
ElliptK=zeros(N,1); ElliptE=zeros(N,1); 
for i=1:NC; 
  EK=zeros(N,1);  
  x=r/Charge(i,1);  
  Bool=(x~=1);
  myu=2*x./(1+x.^2);
%  [ElliptK,ElliptE] = ellipke(myu);
%  EK(Bool)=(ElliptE(Bool)./(x(Bool)-1)+ElliptK(Bool)./(x(Bool)+1)./(x(Bool).^2+1));
  ElliptE=interp1(xx,E,myu); 
  Ind=find(myu<xx(end-1));
  ElliptK(Ind)=interp1(xx,E,myu(Ind));
  Ind=find(myu>=xx(end-1)&myu~=1);
  if not(isempty(Ind))
     ElliptK(Ind)=pi/2*(1-myu(Ind)).^(1-P); 
  end;
  EK(Bool)=(ElliptE(Bool)./(x(Bool)-1)+ElliptK(Bool)./(x(Bool)+1)./(x(Bool).^2+1));
  EK(not(Bool))=0;
  ErExact(:,i)=-2*Coeff1(i)*EK;
  UExact(:,i)=cumsum(ErExact(:,i))*Step/1000;
end;
toc

U0=V*log(r/d)/log(B/d);
Er0=-V/log(B/d)./r;
HighErInd=find(Er0>=max(Er0)/2);
HighErInd=[1:3];

U=sum(U,2); Er=sum(Er,2);
UExact=sum(UExact,2); ErExact=sum(ErExact,2);
RelEr=mean(Er(HighErInd))/mean(Er0(HighErInd));
RelErExact=mean(ErExact(HighErInd))/mean(Er0(HighErInd));

t=cumsum((mAr/2/q./abs(U0(2:end))).^0.5)*Step*1e6; % ns
t=[0;t]; 


figure; subplot(2,1,1);
       semilogx(r,Er0,'-k.'); hold on; semilogx(r,Er0+Er,'-b.'); semilogx(r,Er0+ErExact,'-r.');grid on; 
       semilogx([d,B],[-4.8e3,-4.8e3],'-m'); %Ecrit
       semilogx(Charge(:,1),Charge(:,2)/max(abs(Charge(:,2)))*max(abs([Er0;Er]))/2,'-g.'); axis tight;
       
       title(['V=',num2str(V),' V, r=',num2str(R),' mm. ',num2str(W),' mm, Ni= ',num2str(Ni)]);
       ylabel('E, V/mm');
subplot(2,1,2);
       semilogx(r,U0,'-k.'); hold on; semilogx(r,U0+U,'-b.'); semilogx(r,U0+UExact,'-r.'); 
       semilogx(r,t,'-g.'); 
       xlabel('r, mm'); ylabel('U, V; t, ns');
       grid on; axis tight;
       text(r(2),0.8*V,['\DeltaU= ',num2str(round(10*U(end))/10),' V/ ',num2str(round(10*UExact(end))/10),' V']);
       text(r(2),0.6*V,['\deltaE/E= ',num2str(round(1000*RelEr)/10),'% / ',num2str(round(1000*(RelErExact))/10),'%']);