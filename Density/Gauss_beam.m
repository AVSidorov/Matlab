function [R,wa,Amplitude,Field]=Gauss_beam(x,x0,z,freq)
% in meters
if nargin>3&&~isempty(freq)
    f=freq;
else   
    f=135e9;
end

nz=length(z);
nx=length(x);

waist=0.0035;
lambd  = 299792458.0/f;
z_R = pi * waist^2 / lambd; % Rayleigh length

%% calculate on given dz
wa=waist*sqrt(1.+(z.^2/z_R^2)); % beam width parameter
R=z.*(1.+z_R^2./z.^2);        % beam curvature radius
Psi=atan(z/z_R);                % Gouy phase

Amplitude=zeros(nz,nx);
Field=zeros(nz,nx);

for i=1:nz
  Amplitude(i,:)=waist/wa(i)*exp(-(x-x0).^2/wa(i)^2);
  Field(i,:)=Amplitude(i,:).*exp(1i*( 2*pi*z(i)/lambd+pi*(x-x0).^2/(R(i)*lambd)-Psi(i) ));
end
% %% plot
% bool=x>=x0-wa/2&x<=x0+wa/2;
% plot(x(bool),dz+Amplitude(bool),'r');
% 
% thetaLim=atan(wa/2/R);
% theta=linspace(-thetaLim,thetaLim,100);
% plot(x0+sin(theta)*R,(dz-R)+cos(theta)*R,'k')
