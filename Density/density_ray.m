function ray=density_ray(x,y,n,x0,y0,kx0,ky0,freq)
% wrapper for density_raytrace function with standard output to struct
if nargin<8||isempty(freq)
    freq=135e9;    
end;
ray.freq=freq;
[ray.curX,ray.curY,ray.curKx,ray.curKy,ray.curL,ray.curAx,ray.curAy,ray.curPhase]=density_raytrace(x,y,n,x0,y0,kx0,ky0,freq);
ray.L=cumsum(ray.curL);