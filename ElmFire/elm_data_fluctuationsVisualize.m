function tbl=elm_data_fluctuationsVisualize(filename,Grid,icri,varargin)

filename=elm_read_filename(filename);
GridSet=elm_grid_GridSet(Grid,icri);

MatFile=matfile(filename);
%% checkig that grid and tbl in mat are consistent
Ngrid=MatFile.Ngrid;
NtimeStep=size(MatFile,'tbl',1)/Ngrid;

%% preparing the plotting grid
[x y]=elm_grid_xy(GridSet);

x=x(1:GridSet.Nsection);
y=y(1:GridSet.Nsection);
tri=delaunay(x,y);

%%
fh_cb=@KeyPress_fcn;
hfig=figure('KeyPressFcn',fh_cb);

grid on; %hold on;
haxes=gca;
pause;
nZ=1;
nS=1; %number of species

ch=0;
t=1;
scaleZ=3e18;


while ~isempty(ch)
    Ind=(t-1)*Ngrid+elm_grid_fullsections(nZ,Grid);
    tbl=MatFile.tbl(Ind,nS);
    tblAv=elm_data_fluxAvr(tbl,GridSet);
    tblD=tbl-tblAv;
    trisurf(tri,x,y,tblD,'LineStyle','none','Parent',haxes);
%     DataAspectRatio=get(haxes,'DataAspectRatio');
%     set(haxes,'DataAspectRatio',[1 1 DataAspectRatio(end)]);
    title(haxes,['Time step is ',num2str((t-1)*icri.elm3.nene,'%d')]);
    set(haxes,'DataAspectRatio',[1 1 scaleZ]);
    caxis([-scaleZ +scaleZ]);
    view(2);
    colorbar;
    t=t+1;
    if t>NtimeStep
        t=1;
    end;
    pause(0.03);
    if ch==1
        pause;
        ch=0;
    end;
end;
close(hfig);

    function KeyPress_fcn(src,evnt)
        switch evnt.Key
            case 'escape'
                ch=[];
            case 'backspace'
                ch=1;
        end
    end
end


