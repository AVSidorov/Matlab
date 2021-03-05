function beam=density_beam(x,y,n,rays,antx_TX,anty_TX,antx_RX,anty_RX,freq)
    
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
    beam.antRX_X=antx_RX;
    beam.antRX_Y=anty_RX;
    
    %% adjust grid by ant
    Ind=max([1 find(y<anty_TX,1,'last')]);
    y=y(Ind:end);
    n=n(Ind:end,:);

    Ind=min([length(y) find(y>anty_RX,1,'first')]);
    y=y(1:Ind);
    n=n(1:Ind,:);
    %% raytracing
    for i=1:nr
        beam.r(i)=density_ray(x,y,n,rays(i,1)*100+antx_TX,(rays(i,2)-focus)*100+anty_TX,rays(i,4),rays(i,3),freq);
    end;
   