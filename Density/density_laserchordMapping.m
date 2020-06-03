function [rxyn,minR,minRi]=density_laserchordMapping(rxyn,yN)
    laserChord=density_chord_By_rxyV(inf,1.5,rxyn);
    laserChord=laserChord(isfinite(laserChord(:,1))&isfinite(laserChord(:,2)),:);

    laserChord(:,4)=interp1(yN(:,1),yN(:,2),laserChord(:,2),'pchip',-1);
    laserChord=sortrows(laserChord,3);
    laserChord(find(diff(laserChord(:,3))==0)+1,:)=[];

    rxyn(:,4)=interp1(laserChord(:,3),laserChord(:,4),rxyn(:,1),'pchip',-1);        


    rxyn=sortrows(rxyn);
%% "fill the gap" extrapolate densities to core center, there are not  laser chord data
    % n(r)=...+a2 *r^2 + a1*r + a0  
    % n'(0)=0 =>a1=0
    % n(r_chord_min)=rxyn(r_chord_min),4)
    % n'(r_chord_min)=diff(rxyn(r_chord_min:r_chord_min+1));
    % n''(r_chord_min)=diff(rxyn(r_chord_min:r_chord_min+2),2)

    % border for approximation by spline
    
    
    ri=find(rxyn(:,4)>=0,1,'first');
    r=rxyn(ri,1);
    n=rxyn(ri,4);
    % find diffs
    nd=diff(rxyn(ri:ri+1,4))/diff(rxyn(ri:ri+1,1));
    ndd=diff(rxyn(ri:ri+2,4),2)/prod(diff(rxyn(ri:ri+2,1)));
    % fill the matrix
    A=[  r^3   r^2 1; ...
       3*r^2 2*r   0; ...
       6*r   2     0];
    % solve
    coeffs(1,[1,2,4])=linsolve(A,[n;nd;ndd]);

    rxyn(1:ri-1,4)=polyval(coeffs,rxyn(1:ri-1,1));
    if ndd>0||any(rxyn(1:ri-1,4)<max(rxyn(ri:end,4)))
        coeffs=[];
        coeffs(1,[1,3])=linsolve(A(1:end-1,2:end),[n;nd]);
        rxyn(1:ri-1,4)=polyval(coeffs,rxyn(1:ri-1,1));
    end
    minR=r;
    minRi=ri;
%% clean tail   
    ri=find(rxyn(:,4)>=0,1,'last');
    ri=min([ri,find(diff(rxyn(:,4))<=0,1,'last')]);
    r=rxyn(ri,1);
    % assume that max radius is LCS
    rm=rxyn(end,1);
    n=rxyn(ri,4);
    % find diffs
    nd=diff(rxyn(ri-1:ri,4))/diff(rxyn(ri-1:ri,1));
    ndd=diff(rxyn(ri-2:ri,4),2)/prod(diff(rxyn(ri-2:ri,1)));
    A=[  r^3   r^2  r    1; ...
         rm^3  rm^2 rm   1; ...
         3*r^2 2*r  1    0; ...   
         6*r   2    0    0];
    
    coeffs=linsolve(A,[n;0;nd;ndd]);        
    rxyn(ri+1:end,4)=polyval(coeffs,rxyn(ri+1:end,1)); 
     if ndd>0||any(rxyn(ri+1:end,4)>n)||any(rxyn(ri+1:end,4)<0)
        coeffs=linsolve(A(1:end-1,2:end),[n;0;nd]);
    end
    rxyn(ri+1:end,4)=polyval(coeffs,rxyn(ri+1:end,1)); 
    %rxyn(ri+1:end,4)=min(rxyn(rxyn(:,4)>0,4));
    
end