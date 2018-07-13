function [theta,Theta]=elm_grid_Theta2theta(icri,Theta,r,Grid)
%% transforming from grid poloidal angle Theta to geometrical theta
if nargin<1||isempty(icri)
    error('elm:wrong_input','icri is mandatory input argument');
end;

if nargin<3
    r=icri.elm1.a;
end;

%% conversion of r
if nargin>2
    if r<0
        error('elm:wrong_input','Radius must be nonnegative');
    end
    
    if (r-fix(r))<=eps %checking of integer
        r=uint64(r);
        if r>icri.elm2.dnx+2
            error('elm:wrong_input','Wrong radius value. Radius is outside of grid');  
        end
        if nargin<4 
            error('elm:wrong_input','In case grid number input Grid must be specified');  
        end
    end
    
    if ~isinteger(r)
        if r>icri.elm1.aw
            r=r/1e2; %try to convert from cm to meters
        end
        if r>icri.elm1.aw
            error('elm:wrong_input','Wrong radius value. Radius is outside of grid');  
        end
    end
end


%% if Grid is inputed
if nargin>3
    %% conversion if Grid is inputed and is GridSet structure   
    if isstruct(Grid)&&isfield(Grid,'Grid')&&~isempty(Grid.Grid)
            Grid=Grid.Grid;
    elseif isstruct(Grid)
            error('elm:wrong_input','The Grid field in GridSet is absent or empty');
    end
    %% r proccessing
    if isinteger(r)
        %% conversion thru grid number to r
        if r<icri.elm2.dnx+2
            nx=r+1;
        else
            nx=r;
        end;
        r=Grid.r(nx);                    
    else
        %% grid number determination by r        
        [m, nx]=min(abs(Grid.r-r));
    end
%     fprintf('The nx index is %d r=%5.3f cm\n',nx,r*1e2);  
end                                     

%% Empty Theta    
    
if nargin>1&&isempty(Theta)    
    if nargin<4
       error('elm:wrong_input','if Theta is empty, all arguments have to be specified');
    end
    r=Grid.r(nx);            
    Theta=2*pi/Grid.Npoloidal(nx)*[0:Grid.Npoloidal(nx)-1];
end;


%% theta calculation
theta=Theta;
bool=theta>=0&theta<=pi;
asp=r/icri.elm1.r0;
theta(bool)=acos((cos(Theta(bool))-asp)./(1-asp*cos(Theta(bool))));
theta(~bool)=2*pi-acos((cos(Theta(~bool))-asp)./(1-asp*cos(Theta(~bool))));
