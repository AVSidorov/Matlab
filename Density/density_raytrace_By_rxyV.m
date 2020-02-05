function XYRV=density_raytrace_By_rxyV(slope,intercpt,rxy,N)
%% const in CGS
LAMBDA         = 0.22;%2.15E-1;%wavelength of the interferometer
ELECTRONCHARGE = 4.8027E-10;
LIGHTVELOS     = 2.9979E10; 
ELECTRONMASS   = 9.1083E-28;
OMEGA          = 2*pi*LIGHTVELOS/LAMBDA;
DENSCOEFF      = (ELECTRONCHARGE)^2/OMEGA/LIGHTVELOS/ELECTRONMASS;%*2*pi;
OMEGAPLCOEFF   = 4*pi*ELECTRONCHARGE^2/ELECTRONMASS;
 OMEGA=2*pi*136e9;
%% data prepare
%in case of refraction slope is intial value
if nargin<4&&size(rxy,2)==4
    N=rxy(:,4);
elseif nargin<4||isempty(N)
    N=ones(size(rxy,1),1);
end
bool=rxy(:,1)<=0|isnan(rxy(:,1));
rxy(bool,:)=[];
N(bool,:)=[];
% to avoid null division
N(N==0)=eps;
lenRXY=size(rxy,1);
XYRV=zeros(lenRXY*2,4);

%% convert dencity to refractive index
Den=N;
if max(N)<1e10 %convert phase to density unit
    N=N/(DENSCOEFF*100); %*100 because working in meters
end;
N=sqrt(1-N*OMEGAPLCOEFF/OMEGA^2);    

%% trace 

% we shall start from max radius

[rxy,index]=sortrows(rxy,-1);
N=N(index);

%propagation direction must be traced because reflection is possible

currentR=1; 
currentPoint=1;

trace(true); %trace inside
trace(false); %trace outside

function trace(InOut)
%% counter setting
    stI=currentR;
    if InOut
        stp=1;
        endI=lenRXY;
    else
        stp=-1;
        endI=1;
    end
%% tracing    
    for curR=stI:stp:endI
        %% find intersections
        [xi,yi]=linecirc(slope,intercpt,rxy(curR,2),rxy(curR,3),rxy(curR,1));
        %exit if no intersection
        if ~all(isfinite([xi,yi]))
            currentR=curR-1;
            break;
        end
       
        %% pick refraction point from intersections        
        if currentPoint==1
            if abs(yi(1)-yi(2))>eps
                if InOut
                    %leave only upper part
                    [yi,ind]=max(yi);
                else
                    %leave only lower part
                    [yi,ind]=min(yi);
                end
                    xi=xi(ind);
            else
                if InOut
                    %leave only low field side
                    [xi,ind]=max(xi);
                else
                    %leave only high field side
                    [xi,ind]=min(yi);
                end
                yi=yi(ind);
            end        
        else
            dist=sqrt((XYRV(currentPoint-1,1)-xi).^2+(XYRV(currentPoint-1,2)-yi).^2);
            if curR~=stI
                [dist,ind]=min(dist);
            else
                [dist,ind]=max(dist);
            end
            xi=xi(ind);
            yi=yi(ind);
        end
        %% store point
        XYRV(currentPoint,1)=xi;
        XYRV(currentPoint,2)=yi;    
        XYRV(currentPoint,3)=rxy(curR,1);
        XYRV(currentPoint,4)=Den(curR);
        currentPoint=currentPoint+1;

        %% refraction = changing ray vector
        if curR~=1&&curR~=endI % for inner/outter circle no refraction           
            %incedence ray vector (before)
            l=[xi-XYRV(currentPoint-2,1) yi-XYRV(currentPoint-2,2)];
            l=l/norm(l);
            % this way of l determination is better than from slope so as
            % vectors l=-l have same slope.
            % currentPoint everytime>3 because refraction starts from
            % second density circle and currentPoint counter was
            % incremented one more time
            % after storing current refraction position

            % normalized vector from center is normal to circle density border
            n=[xi-rxy(curR,2) yi-rxy(curR,3)];
            n=stp*n/norm(n); %unit vector stp=1 means propagation inside circle stp=-1 outside

            if InOut
                R=N(curR-stp)/N(curR);    %density inside ring is equal to one on it
            else
                R=N(curR)/N(curR+stp);
            end
            C=-n*l';

            %refracted (new) ray vector
            v=R*l+(R*C-sqrt(1-R^2*(1-C^2)))*n; %wiki eng            

            if ~isreal(v) %reflection
                drc=1;
                v=l-2*(l*n')*n;
                break;
            end;
            %% new line for intersections
            %new slope and intercpt
            if abs(v(1))>eps
                slope=v(2)/v(1);
                intercpt=yi-xi/v(1)*v(2);
            else
                slope=inf*sign(v(2));
                intercpt=xi;
            end;
        elseif curR==1&&~InOut
            XYRV=XYRV(1:currentPoint-1,:);
        end
    end
end

end