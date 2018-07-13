function [b,a] = LCR_filter(L,C,R,Fs)
% Returns equivalent IIR coefficients for an analog rRC filter
%
% Usage:     [b,A] = RC_FILTER(r,R, C, Fs);
%
%             r is the resistance value (in ohms)
%             R is the resistance value (in ohms)
%             C is the capacitance value (in farrads)
%             Fs is the digital sample rate (in Hz)
%
% Filter have the analog structure:
%                   
% 
% 
%              | |
%     Vi  o----| |--/\/\/\------+---------o  Vo
%              | |              |
%               C     L         | 
%                              --- 
%                              | |  R
%                              | | 
%                              ---   
%                               |
%                               |
%         o---------------------+---------o
%                              GND
%
%
% This function uses a pre-calculated equation for  these circuits
% that only requires the resistance and capacitance value to get a true
% digital filter equivalent to a analog filter.
%
% The math behind these equations is based off the basic bilinear transform
% technique that can be found in many DSP textbooks.  The reference paper
% for this function was "Conversion of Analog to Digital Transfer 
% Functions" by C. Sidney Burrus, page 6.
%
%
%
%
%

% Default to allpass if invalid type is selected
b = [ 1 0 0];
a = [ 1 0 0];

% Constants
tau1 = R * C;
tau2 = sqrt(L*C);
T  = 1 / Fs;

% w=1;
% w=1/tau1;
% w=1/tau2;
w=1/sqrt(tau1*tau2);


% Prewarped coefficient for Bilinear transform
 A = w / tan(w*T/2);
% A=1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The following equations were derived from
%
%            s*RC
% T(s) =  -------------------
%          1+s*RC+s^2*LC
%
%
% using Bilinear transform of
%
%            ( 1 - z^-1 )
% s -->  A * ------------
%            ( 1 + z^-1 )
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


    
    b(1) = A*tau1                / (1+(A*tau2)^2+A*tau1);
    b(3) = -b(1);
    a(2) = 2*(1-(A*tau2)^2)      / (1+(A*tau2)^2+A*tau1);
    a(3) = (1+(A*tau2)^2-A*tau1) / (1+(A*tau2)^2+A*tau1);
