function [Spec,ky]=elm_data_PoloidalWaveNumbersSpectra(vec,Nr,GridSet,icri,NFFT)
% vec is poloidal data
% Calculates wavenumberspectra
if isstruct(GridSet)&&isfield(GridSet,'Grid')&&~isempty(GridSet.Grid)
    Grid=GridSet.Grid;
elseif ~isempty(GridSet)&&istable(GridSet)
    Grid=GridSet;
else
    error('elm_aps:err:wronginput','The Grid must be given');
end;
ny=length(vec);

if ny~=Grid.Npoloidal(Nr)
    error('elm_aps:err:wronginput','Vector length and Npoloidal don''t match');
end

Theta=2*pi/Grid.Npoloidal(Nr)*[0:Grid.Npoloidal(Nr)-1]';
theta=elm_grid_Theta2theta(icri,Theta,Nr-1,Grid);

y=linspace(0,2*pi*Grid.r(Nr),ny);
vec_y=interp1(theta*2*Grid.r(Nr),vec,y);

if nargin<5
    NFFT=ny;
end;
ky=Grid.Npoloidal(Nr)/Grid.r(Nr)/2*linspace(0,1,fix(NFFT/2)+1);
Spec=fft(vec-mean(vec),NFFT);