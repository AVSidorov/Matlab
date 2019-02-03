function [Eradial,Epoloidal,vec]=elm_data_Efield(tbl,GridSet,icri)

% tbl is section points of potential
% Calculates Electric Field from potential data
% vec is spatial grid vector (for cartesian coordinates meshgrid)

if isstruct(GridSet)&&isfield(GridSet,'Grid')&&~isempty(GridSet.Grid)
    Grid=GridSet.Grid;
elseif ~isempty(GridSet)&&istable(GridSet)
    Grid=GridSet;
else
    error('elm_aps:err:wronginput','The Grid must be given');
end;
[x,y]=elm_grid_xy(GridSet,icri);

x=x(1:GridSet.Nsection);
y=y(1:GridSet.Nsection);

dLr=min(diff(Grid.r));
dLtheta=2*pi*Grid.r./Grid.Npoloidal;
dLtheta=min(dLtheta(dLtheta>0));
h=min([dLr,dLtheta]);
Rmax=max(x);
Nr=ceil(Rmax/h);
vec=[-Nr*h:h:Nr*h];
[X,Y]=meshgrid(vec,vec);
R=sqrt(X.^2+Y.^2);
bool=R<=Rmax;

% PotentialInterpolant=scatteredInterpolant(x,y,tbl);
% Pot=PotentialInterpolant(X,Y);
Pot=griddata(x,y,tbl,X,Y,'cubic');
Pot(~bool)=0;
[Ex,Ey]=gradient(Pot,h);
Ex=-Ex;
Ey=-Ey;
E=sqrt(Ex.^2+Ey.^2);
% ExInterpolant=griddedInterpolant(X',Y',Ex','cubic');
% EyInterpolant=griddedInterpolant(X',Y',Ey','cubic');

Ex_=reshape(Ex,numel(Ex),1);
Ey_=reshape(Ey,numel(Ey),1);
X_=reshape(X,numel(X),1);
Y_=reshape(Y,numel(Y),1);
R_=reshape(R,numel(R),1);

Rvec=[X_./R_,Y_./R_];
Evec=[Ex_,Ey_];

Eradial=zeros(length(Evec),1);
Epoloidal=zeros(length(Evec),1);
for i=1:length(Rvec)
    Eradial(i,1)=dot(Rvec(i,:),Evec(i,:));
    Epoloidal(i,1)=dot([-Rvec(i,2),Rvec(i,1)],Evec(i,:));    
end;

Eradial_x=Eradial.*Rvec(:,1);
Eradial_y=Eradial.*Rvec(:,2);
Eradial=reshape(Eradial,size(X));
Epoloidal=reshape(Epoloidal,size(X));

Eradial_x=reshape(Eradial_x,size(X));
Eradial_y=reshape(Eradial_y,size(Y));
Epoloidal_x=Ex-Eradial_x;
Epoloidal_y=Ey-Eradial_y;

clear Ex_ Ey_ X_ Y_ Rvec Evec; 