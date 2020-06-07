function [rays,F]=density_beam_rays(n,minA,dz,focus,freq)
% n number of rays
% minA value less than unit relative amplitude on boudary ray

if nargin<1||isempty(n)
    n=100;
end 
if nargin<2||isempty(minA)||minA>=1
    minA=exp(-1);
end
if nargin<3||isempty(dz)
    dz=1.23504500132716030000e-02;
end
if nargin<4||isempty(focus)
    focus=0.0009;
end
if nargin<5
    freq=135e9;
end

[G_R,G_w,Amp,Field]=Gauss_beam(0,0,dz,freq);

%% estimate z range
k=sqrt(-log(minA));
theta=atan(k*G_w/G_R);
z=linspace(dz-G_R+cos(theta)*G_R,dz,n);

%% Gauss beam parameters on z
waist=0.0035;
lambd  = 299792458.0/freq;
k=2*pi/lambd;

z_R = pi * waist^2 / lambd; 
R=z.*(1.+z_R^2./z.^2);        % beam curvature radius
Psi=atan(z/z_R);                % Gouy phase
Phase=angle(Field);
%convert phase to 0-2*pi range
Phase=Phase+2*pi;
Phase=Phase-2*pi*fix(Phase/2/pi);

%% calculate x  in points xz phase is constant
PhaseK=Phase+Psi-k*z;
PhaseK=PhaseK-2*pi*floor(PhaseK/2/pi);


x=sqrt(2*R.*PhaseK/k);
if iscolumn(z)
    z=z';
end
if iscolumn(x)
    x=x';
end

z=[flip(z(x>0)) z];
x=[-flip(x(x>0)) x];

[x,index]=sort(x);
z=z(index);
theta=linspace(-theta,theta,n);
xx=sin(theta)*G_R;
zz=interp1(x,z,xx,'pchip',NaN);
xx(isnan(zz))=[];
zz(isnan(zz))=[];
n=length(xx);

rays=zeros(n,6);
for i=1:n
    [G_R,G_w,Amp,Field]=Gauss_beam(xx(i),0,zz(i),freq);
    rays(i,1)=xx(i);
    rays(i,2)=zz(i)+focus;
    rays(i,4)=xx(i)/G_R;
    rays(i,3)=sqrt(1-rays(i,4)^2);
    rays(i,5)=Amp;
    rays(i,6)=angle(Field);
end

% G_x0=0;
% G_y0=dz-G_R;
% k=sqrt(-log(minA));
% theta=linspace(-atan(k*G_w/G_R),atan(k*G_w/G_R),n);
% rays(:,1)=G_x0+sin(theta)*G_R;
% rays(:,2)=focus+G_y0+cos(theta)*G_R;
% rays(:,4)=sin(theta);
% rays(:,3)=cos(theta);

% F=zeros(n,1);
% for i=1:n
%     [~,~,A,F(i)]=Gauss_beam(rays(i,1),0,rays(i,2)-focus);
%     rays(i,5)=A;
% end
end