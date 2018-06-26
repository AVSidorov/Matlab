function r=elm_grid_Nr2r(Nr,Grid,icri)
%this function converts ElmFire grid cell radial number to flux surface
%radius

r=nan(size(Nr));

if nargin>2
    %check consistence. Number of input grid radii must be dnx+2
    if ~length(Grid.r)==icri.elm2.dnx+2
        error('The input parameters for grid is not consitent');
    end
    Ind=find(Nr>=0&Nr<=icri.elm2.dnx-1&Nr<length(Grid.r));
else
    Ind=find(Nr>=0&Nr<length(Grid.r));
end;
%r(Ind)=(Grid.r(Nr(Ind)+2)+Grid.r(Nr(Ind)+3))/2;
r(Ind)=Grid.r(Nr(Ind)+1); %There are no output in last two points
