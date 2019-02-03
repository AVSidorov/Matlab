function [Velocity,VelocityTab]=elm_data_getRotationVelocity(corrLag,corrTimeTab,nx,GridSet,icri)
% function averages correlations Lag between time layers and recalculates
% it to physical values (km/s) corrLag is from elm_data_getRotationSpeed
corrLevel=0.65;
Ts=icri.elm3.tint*icri.elm3.nene;

timeShiftMax=size(corrLag,1);
dnz=size(corrLag,2);
dnt=size(corrLag,3);

VelocityTab=zeros(timeShiftMax,dnz,dnt);
% Calculations with angles get more accurate value because the poloidal angles
% are not equedistant

Ny=[0:GridSet.Grid.Npoloidal(nx)-1];
theta=elm_grid_Theta2theta(icri,[],nx-1,GridSet);

Theta=[0:2*pi/GridSet.Grid.Npoloidal(nx):2*pi];
Theta(end)=[];
% if interpolation was made in elm_data_getRotation theta=Theta
theta=Theta;

%recalculate lags to distance
for timeShift=1:timeShiftMax    
    VelocityTab(timeShift,:,:)=sign(corrLag(timeShift,:,:)).*interp1(Ny,theta,abs(corrLag(timeShift,:,:))*timeShift,'phcip')*GridSet.Grid.r(nx)/(Ts*timeShift)/1e3;
    VelocityTab(timeShift,:,:)=circshift(VelocityTab(timeShift,:,:),[0,0,fix(timeShift/2)]);
end;
%% choosing time shifts for averaging
% check mean level
% BASE is one time layer shift 
Vmean=mean(mean(VelocityTab,3),2);
Vstd=mean(std(VelocityTab,0,3),2);
bool=abs(Vmean-Vmean(1))<=Vstd(1);
Velocity=squeeze(mean(VelocityTab(bool,:,:),2));    
% check correlation value
V=Velocity(1,:);
Std=inf;
timeShiftMax=size(Velocity,1);
for timeShift=2:timeShiftMax
    dV=Velocity(timeShift,:)-V;
    Std=min([Std,std(dV(timeShiftMax:end-timeShiftMax))]);
    if all(abs(dV(timeShiftMax:end-timeShiftMax))<=10*Std)
        V=mean(Velocity(1:timeShift,:),1);
    end;
end;
Velocity=squeeze(V); 
 