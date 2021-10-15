function beam=density_beam1(x,y,n,rays,antx_TX,anty_TX,freq)
    
    if nargin<9||isempty(freq)
        freq=135e9;    
    end;
    focus=0.0095; %in meters
    nr=size(rays,1);
    
    beam.nr=nr;
    beam.freq=freq;
    beam.ampIn=rays(:,5);
    beam.antFocus=focus;
    beam.antTX_X=antx_TX;
    beam.antTX_Y=anty_TX;
    
    %% raytracing
    for i=1:nr
        beam.r(i)=density_ray1(x,y,n,rays(i,1)*100+antx_TX,(rays(i,2)-focus)*100+anty_TX,rays(i,4),rays(i,3),freq);
    end;
   