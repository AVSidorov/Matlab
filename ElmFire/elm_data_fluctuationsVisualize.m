function tbl=elm_data_fluctuationsVisualize(filename,Grid,icri,varargin)


hfig=figure('CreateFcn',@CreateFig);

% set(hfig,'KeyPressFcn',@KeyPress_fcn);




    function CreateFig(obj,evnt)
        data=guidata(obj);
        data.icri=icri;
        grid on;
        data.haxes=gca;
        data.filename=elm_read_filename(filename);
        data.GridSet=elm_grid_GridSet(Grid,icri);   
        data.MatFile=matfile(data.filename);
        %% checkig that grid and tbl in mat are consistent
        data.Ngrid=data.MatFile.Ngrid;
        data.NtimeStep=size(data.MatFile,'tbl',1)/data.Ngrid;

        %% preparing the plotting grid
        [data.x data.y]=elm_grid_xy(data.GridSet);

        data.x=data.x(1:data.GridSet.Nsection);
        data.y=data.y(1:data.GridSet.Nsection);
        data.tri=delaunay(data.x,data.y);
        data.nZ=1;
        data.nS=1; %number of species
        data.scaleZ=3e18;
        data.t=1;
        data.ch=0;       
        set(data.haxes,'DataAspectRatio',[1 1 data.scaleZ]);
        caxis(data.haxes,[-data.scaleZ +data.scaleZ]);
        view(2);
        colorbar;
        data.hbutton=uicontrol(obj,'Style','pushbutton','String','Start','Position',[1,1,100,100],'CallBack',@ButtonStart);
        data.htimer=timer('ExecutionMode','fixedSpacing','Period',0.002,'UserData',obj,'TimerFcn',@main);
        guidata(obj,data);
    end    
    function main(src,evnt)
        obj=get(src,'UserData');
        data=guidata(obj);        
         if ~isempty(data.ch)
            Ind=(data.t-1)*data.Ngrid+elm_grid_fullsections(data.nZ,data.GridSet.Grid);
            tbl=data.MatFile.tbl(Ind,data.nS);
            tblAv=elm_data_fluxAvr(tbl,data.GridSet);
            tblD=tbl-tblAv;
            trisurf(data.tri,data.x,data.y,tblD,'LineStyle','none','Parent',data.haxes);
            title(data.haxes,['Time step is ',num2str((data.t-1)*data.icri.elm3.nene,'%d')]);
            set(data.haxes,'DataAspectRatio',[1 1 data.scaleZ]);
            caxis([-data.scaleZ +data.scaleZ]);
            view(2);
            colorbar;
            data.t=data.t+1;
            if data.t>data.NtimeStep
                data.t=1;
            end;      
        end;
        guidata(obj,data);
    end

    function ButtonStart(obj,evnt)
        data=guidata(obj);
        if strcmpi(data.htimer.Running,'off')
            start(data.htimer);
        else
            stop(data.htimer);
        end
    end

%     function KeyPress_fcn(obj,evnt)
%         data=guidata(obj);
%         switch evnt.Key
%             case 'escape'
%                 data.ch=[];
%             case 'backspace'
%                 data.ch=1;
%         end
%         guidata(obj,data);
%     end
end


