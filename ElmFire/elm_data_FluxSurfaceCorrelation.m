function [CorrLength,RL,RR]=elm_data_FluxSurfaceCorrelation(tbl,NX,GridSet,icri)
%tbl consists in vectors values on fixed radius with different poloidal
%angels, i.e. tbl = theta x r
%number of columns is number of radial points

if isstruct(GridSet)&&isfield(GridSet,'Grid')&&~isempty(GridSet.Grid)
    Grid=GridSet.Grid;
elseif ~isempty(GridSet)&&istable(GridSet)
    Grid=GridSet;
else
    error('elm_aps:err:wronginput','The Grid must be given');
end;


Corr=xcorr(tbl,'coeff');
dny=size(tbl,1);
dnx=size(tbl,2);
for i=1:dnx
 LeftInd=find(Corr(dny,1+(i-1)*dnx:i+(i-1)*dnx)>=1/exp(1),1,'first');   
 if ~isempty(LeftInd)&&LeftInd~=i&&LeftInd>1
     RL(i,1)=Grid.r(NX(i))-interp1(Corr(dny,1+(i-1)*dnx:i+(i-1)*dnx),Grid.r(NX(1:i)),1/exp(1),'linear','extrap');
 else
    RL(i,1)=0;
 end;
 
 RightInd=(i-1)+find(Corr(dny,i+(i-1)*dnx:i*dnx)<=1/exp(1),1,'first');
 if ~isempty(RightInd)&& RightInd~=i&&RightInd<dnx
     RR(i,1)=interp1(Corr(dny,i+(i-1)*dnx:i*dnx),Grid.r(NX(i:end)),1/exp(1),'linear','extrap')-Grid.r(NX(i));
 else
     RR(i,1)=0;
 end;
 if RR(i,1)>0&&RL(i,1)>0
     CorrLength(i,1)=RR(i,1)+RL(i,1);
 else
     CorrLength(i,1)=2*(RR(i,1)+RL(i,1));
 end;
end
 