function [b,a]=SinExp_filter(alpha,w,Fs)
T  = 1 / Fs;
A = w / tan(w*T/2);
% A=A*w;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The following equations were derived from 
% Laplace transform for exp(-alpha*t)*sin(w*t)*H(t) 
%
%                  w^2
% T(s) =  -------------------
%          (s+alpha)^2 + w^2
%
%
% using Bilinear transform of
%
%            ( 1 - z^-1 )
% s -->  A * ------------
%            ( 1 + z^-1 )
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


b=[1,0,0];
a=[1,0,0];

b(1)=w^2    /((A+alpha)^2 + w^2);
b(2)=2*w^2  /((A+alpha)^2 + w^2);
b(3)=w^2    /((A+alpha)^2 + w^2);

a(2)=2* (alpha^2-A^2+w^2)   /((A+alpha)^2 + w^2);
a(3)=   ((A-alpha)^2+w^2)   /((A+alpha)^2 + w^2);