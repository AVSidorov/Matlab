function densitytool 

hfig=figure('CreateFcn',@CreateFig,'Color','w','Resize','off');

    function CreateFig(obj,evnt)
        % Get some screen and figure position measurements
        tempFigure=figure('Visible','off','Units','pixels');
        dfp=get(tempFigure,'Position');
        dfop=get(tempFigure,'OuterPosition');
        diffp = dfop - dfp;
        xmargin = diffp(3);
        ymargin = diffp(4);
        close(tempFigure)
        oldu = get(0,'Units');
        set(0,'Units','pixels');
        screenSize=get(0,'ScreenSize');
        screenWidth=screenSize(3);
        screenHeight=screenSize(4);
        set(0,'Units',oldu');
        
        oldu = get(obj,'Units');
        set(obj,'Units','pixels');
        set(obj,'OuterPosition',[10,0.05*screenHeight,screenWidth*0.9,screenHeight*0.9]);
        set(obj,'Units',oldu);
        % set(obj,'WindowStyle','docked');
        drawnow;
        
        data=guidata(obj);
        
        data.Fs=5e6;
        data.freq=420e3/(data.Fs/2);
        data.freqF=data.freq;
        data.bandwidth=0.0004;
        data.NFFT=pow2(18);
        
        data.timeScale=1e-3;
        
        data.freqScale=1;
        data.freqUnits=1;
        
        data.timeBase=[0,14e-3];
        data.timeTail=[60e-3,70e-3];
        
        data.hzoom=zoom(obj);
        set(data.hzoom,'ActionPostCallback',@AfterZoom);
        data.haxes=uipanel('Parent',obj,'Units','Normalized','Position',[0 0 0.8 1],'Tag','AxesContainer');
        data.hvideo=subplot(2,2,1,'Parent',data.haxes);
        grid on; hold on;
        data.hspec=subplot(2,2,2);
        grid on; hold on;
        data.hphase=subplot(2,2,3:4);
        grid on; hold on;
       

        data.hcontrols=uipanel('Parent',obj,'Units','Normalized','Position',[0.8 0 0.2 1],'Tag','ControlsContainer');
        data.hbuttonLoad=uicontrol(data.hcontrols,'Style','pushbutton','String','Load file',...
            'Units','Normalized','Position',[0.0 0.9 1 0.1],'Callback',@ButtonLoad,...
            'FontSize',14);
        data.hbuttonSave=uicontrol(data.hcontrols,'Style','pushbutton','String','Save file',...
            'Units','Normalized','Position',[0.0 0.0 1 0.1],'Callback',@ButtonSave,...
            'FontSize',14);

        height=1;
        widthLabel=0.4;
        widthEdit=0.4;
        widthUnit=1-widthLabel-widthEdit;
        fmtFreq='%10.1f';

        data.hsampling=uipanel('Parent',data.hcontrols,'Units','Normalized','Position',[0 0.8 1 0.05],'Tag','FreqContainer');
            data.hFs=uipanel('Parent',data.hsampling,'Tag','FreqContainer',...
                'Units','Normalized','Position',[0 1-1*height 1 height]);
                uicontrol(data.hFs,'Style','Text','String','Sampling freq',...
                    'Units','Normalized','Position',[0 0 widthLabel 0.8],...
                    'FontSize',14);
                data.heditbandwidth=uicontrol(data.hFs,'Style','edit','Tag','Fs','String',num2str(data.Fs,fmtFreq),...            
                    'Units','Normalized','Position',[widthLabel 0.1 widthEdit 0.8],'CallBack',@EditFreq,...
                    'FontSize',14,'BackgroundColor','w');
                uicontrol(data.hFs,'Style','Text','String','Hz','Tag','frequnits',...
                    'Units','Normalized','Position',[1-widthUnit 0 widthUnit 0.8],...
                    'FontSize',14);
        
        height=1/5;
        widthLabel=0.4;
        widthEdit=0.4;
        widthUnit=1-widthLabel-widthEdit;
        fmtFreq='%8.6f';

        data.hfreq=uipanel('Parent',data.hcontrols,'Units','Normalized','Position',[0 0.5 1 0.3],'Tag','FreqContainer');
            data.hradiobuttongroup=uibuttongroup(data.hfreq,...
                'Units','Normalized','Position',[0.0 1-1*height 1 height],'SelectionChangeFcn',@RadioCBK);
                data.hradiobutton=uicontrol(data.hradiobuttongroup,'Style','radiobutton',...
                    'String','Normalized','Tag','freqNorm',...
                    'Units','Normalized','Position',[0.0 0.00 0.33 1]);
                data.hradiobutton=uicontrol(data.hradiobuttongroup,'Style','radiobutton',...
                    'String','Hz','Tag','freqHz',...
                    'Units','Normalized','Position',[0.33 0.00 0.33 1]);
                data.hradiobutton=uicontrol(data.hradiobuttongroup,'Style','radiobutton',....
                    'String','kHz','Tag','freqkHz',...
                    'Units','Normalized','Position',[0.66 0.00 0.33 1]);
            data.hbandwidth=uipanel('Parent',data.hfreq,'Tag','FreqContainer',...
                'Units','Normalized','Position',[0 1-2*height 1 height]);
                uicontrol(data.hbandwidth,'Style','Text','String','Bandwidth',...
                    'Units','Normalized','Position',[0 0 widthLabel 0.8],...
                    'FontSize',14);
                data.heditbandwidth=uicontrol(data.hbandwidth,'Style','edit','Tag','bandwidth','String',num2str(data.bandwidth,fmtFreq),...            
                    'Units','Normalized','Position',[widthLabel 0.1 widthEdit 0.8],'CallBack',@EditFreq,...
                    'FontSize',14,'BackgroundColor','w');
                uicontrol(data.hbandwidth,'Style','Text','String','Hz','Tag','frequnits',...
                    'Units','Normalized','Position',[1-widthUnit 0 widthUnit 0.8],...
                    'FontSize',14);
            data.hFREQ=uipanel('Parent',data.hfreq,'Units','Normalized','Position',[0 1-3*height 1 height],'Tag','FreqContainer');
                uicontrol(data.hFREQ,'Style','Text','String','Freq trek',...
                    'Units','Normalized','Position',[0 0 widthLabel 0.8],...
                    'FontSize',14);
                data.heditfreq=uicontrol(data.hFREQ,'Style','edit','Tag','freq','String',num2str(data.bandwidth,fmtFreq),...            
                    'Units','Normalized','Position',[widthLabel 0.1 widthEdit 0.8],'CallBack',@EditFreq,...
                    'FontSize',14,'BackgroundColor','w');
                uicontrol(data.hFREQ,'Style','Text','String','Hz','Tag','frequnits',...
                    'Units','Normalized','Position',[1-widthUnit 0 widthUnit 0.8],...
                    'FontSize',14);
            data.hFREQF=uipanel('Parent',data.hfreq,'Units','Normalized','Position',[0 1-4*height 1 height],'Tag','FreqContainer');
                uicontrol(data.hFREQF,'Style','Text','String','Freq filter',...
                    'Units','Normalized','Position',[0.00 0 widthLabel 0.8],...
                    'FontSize',14);
                data.heditfreqf=uicontrol(data.hFREQF,'Style','edit','Tag','freqF','String',num2str(data.bandwidth,fmtFreq),...            
                    'Units','Normalized','Position',[widthLabel 0.1 widthEdit 0.8],'CallBack',@EditFreq,...
                    'FontSize',14,'BackgroundColor','w');
                uicontrol(data.hFREQF,'Style','Text','String','Hz','Tag','frequnits',...
                    'Units','Normalized','Position',[1-widthUnit 0 widthUnit 0.8],...
                    'FontSize',14);
           data.hbuttonAdjust=uicontrol(data.hfreq,'Style','pushbutton','String','Adjust',...
                    'Units','Normalized','Position',[0.0 1-5*height 1 height],'Callback',@ButtonAdjust,...
                    'FontSize',14,'Enable','off');
        height=1/2;
        widthLabel=0.5;
        widthEdit=0.5;
        widthUnit=1-widthLabel-widthEdit;
        fmtTime='%4.2f';
        
        data.htime=uipanel('Parent',data.hcontrols,'Units','Normalized','Position',[0 0.2 1 0.3],'Tag','FreqContainer');
            data.htimeBase=uipanel('Parent',data.htime,'Tag','timeContainer',...
                'Units','Normalized','Position',[0 1-1*height 1 height]);
                uicontrol(data.htimeBase,'Style','Text','String',{'Time Base Start';' ms'},...
                    'Units','Normalized','Position',[0 0.5 widthLabel 0.5],...
                    'FontSize',11);
                uicontrol(data.htimeBase,'Style','Text','String','Time Base End, ms',...
                    'Units','Normalized','Position',[widthLabel 0.5 widthLabel 0.5],...
                    'FontSize',11);
                data.hedittimeBaseStart=uicontrol(data.htimeBase,'Style','edit','Tag','timeBaseSt','String',num2str(data.timeBase(1)/data.timeScale,fmtTime),...            
                    'Units','Normalized','Position',[0 0 widthEdit 1/3],'CallBack',@EditTime,...
                    'FontSize',14,'BackgroundColor','w');
                data.hedittimeBaseEnd=uicontrol(data.htimeBase,'Style','edit','Tag','timeBaseEnd','String',num2str(data.timeBase(end)/data.timeScale,fmtTime),...            
                    'Units','Normalized','Position',[widthEdit 0 widthEdit 1/3],'CallBack',@EditTime,...
                    'FontSize',14,'BackgroundColor','w');
            data.htimeTail=uipanel('Parent',data.htime,'Tag','timeContainer',...
                'Units','Normalized','Position',[0 1-2*height 1 height]);
                uicontrol(data.htimeTail,'Style','Text','String','Time Tail Start, ms',...
                    'Units','Normalized','Position',[0 0.5 widthLabel 0.5],...
                    'FontSize',11);
                uicontrol(data.htimeTail,'Style','Text','String','Time Tail End, ms',...
                    'Units','Normalized','Position',[widthLabel 0.5 widthLabel 0.5],...
                    'FontSize',11);
                data.hedittimeTailStart=uicontrol(data.htimeTail,'Style','edit','Tag','timeTailSt','String',num2str(data.timeTail(1)/data.timeScale,fmtTime),...            
                    'Units','Normalized','Position',[0 0 widthEdit 1/3],'CallBack',@EditTime,...
                    'FontSize',14,'BackgroundColor','w');
                data.hedittimeTailEnd=uicontrol(data.htimeTail,'Style','edit','Tag','timeTailEnd','String',num2str(data.timeTail(end)/data.timeScale,fmtTime),...            
                    'Units','Normalized','Position',[widthEdit 0 widthEdit 1/3],'CallBack',@EditTime,...
                    'FontSize',14,'BackgroundColor','w');


        guidata(obj,data);
    end
    function AfterZoom(obj,evnt)
        data=guidata(obj);   
        if ~isempty(data.trek)
            ylim=get(data.hphase,'Ylim');
            
            h=findobj(data.hphase,'Tag','timeMark');
            delete(h);           

            patch([data.timeBase(1),data.timeBase(end),data.timeBase(end),data.timeBase(1)]/data.timeScale,....
                ylim(1)+[0,0,range(ylim)/20,range(ylim)/20],...
                [0 0 0 0],...
                'FaceColor','interp','FaceAlpha',0.3,'Tag','timeMark',...
                'Parent',data.hphase);
            patch([data.timeTail(1),data.timeTail(end),data.timeTail(end),data.timeTail(1)]/data.timeScale,...
                ylim(1)+[0,0,range(ylim)/20,range(ylim)/20],...
                [0 0 0 0],...
                'FaceColor','interp','FaceAlpha',0.3,'Tag','timeMark',...
                'Parent',data.hphase);
        end
    end
    function ButtonLoad(obj,evnt)
        data=guidata(obj);
        [trek,filename]=DensityTrekLoadFromSingle;
        if ~isempty(trek)
            data.trek=trek;
            set(obj,'String',filename);
        end
        guidata(obj,data);
        NewTrek(obj,data);
    end
    function ButtonSave(obj,evnt)
        data=guidata(obj);
        if ~isempty(data.phZK)
            [FileName,PathName,FilterIndex]=uiputfile({'*.dat','File of single';'*.txt','ASCII tab'},'Save phase to file');
            switch FilterIndex
                case 1
                    fid=fopen(fullfile(PathName,FileName),'w');
                    fwrite(fid,data.phZK(:,2),'single');
                    dt=mean(diff(data.phZK(:,1)));
                    save(fullfile(PathName,['dt_',FileName]),'dt','-ascii','-double');
                    fclose(fid);
                otherwise
                    save(fullfile(PathName,FileName),'-struct','data','phZK','-ascii','-double','-tabs');
            end
        end
    end
    function ButtonAdjust(obj,evnt)
        set(obj,'Enable','off');
        drawnow;
        data=guidata(obj);
        [data.phZK,data.freq,data.trekF]=DensityAdjustFreq(@DensityPhaseZeroCross,data.trek,1/data.Fs,data.bandwidth,data.timeBase,data.timeTail,data.freq);
        data.freqF=data.freq;
        guidata(obj,data); 
        set(obj,'Enable','on');
        ControlRedraw(obj,data);
        ReDraw(obj,data);
    end
    function ControlRedraw(obj,evnt)
        data=guidata(obj);       
        set(data.heditbandwidth,'String',num2str(data.bandwidth*data.freqUnits/data.freqScale,getFormat(data.bandwidth*data.freqUnits/data.freqScale)));
        set(data.heditfreq,'String',num2str(data.freq*data.freqUnits/data.freqScale,getFormat(data.freq*data.freqUnits/data.freqScale)));
        set(data.heditfreqf,'String',num2str(data.freqF*data.freqUnits/data.freqScale,getFormat(data.freqF*data.freqUnits/data.freqScale)));
        h=findobj(data.hfreq,'Tag','frequnits');
        set(h,'String',get(get(data.hradiobuttongroup,'SelectedObject'),'String'));
        set(data.hedittimeBaseStart,'String',num2str(data.timeBase(1)/data.timeScale,getFormat(data.timeBase(1)/data.timeScale)));
        set(data.hedittimeBaseEnd,'String',num2str(data.timeBase(end)/data.timeScale,getFormat(data.timeBase(end)/data.timeScale)));
        set(data.hedittimeTailStart,'String',num2str(data.timeTail(1)/data.timeScale,getFormat(data.timeTail(1)/data.timeScale)));
        set(data.hedittimeTailEnd,'String',num2str(data.timeTail(end)/data.timeScale,getFormat(data.timeTail(end)/data.timeScale)));        
        function n=lastNonZeroOrder(x)
          n0=ceil(-log10(x-fix(x)))-1;          
          x=x*10^n0;
          n=n0;
            while x-fix(x)>=0.01
                x=x*10;
                n=n+1;
            end
            if n==n0
                n=0;
            end                
        end        
        function fmt=getFormat(x)
                if x~=0
                    npos=(ceil(log10(x))+abs(ceil(log10(x))))/2;
                    nneg=lastNonZeroOrder(x);
                    fmt=['%',num2str(npos+nneg+1,'%2.0f'),'.',num2str(nneg,'%2.0f'),'f'];
                else
                    fmt='%1.0f';
                end                    
        end
    end
    function RadioCBK(obj,evnt)
        data=guidata(obj);
        switch get(get(obj,'SelectedObject'),'Tag')
            case 'freqNorm'
                data.freqUnits=1;
                data.freqScale=1;
            case 'freqHz'
                data.freqUnits=data.Fs/2;
                data.freqScale=1;
            case 'freqkHz'
                data.freqUnits=data.Fs/2;
                data.freqScale=1e3;                               
        end
        guidata(obj,data);
        ControlRedraw(obj,evnt);
    end
    function NewTrek(obj,evnt)        
        data=guidata(obj);
            h=findobj(data.hvideo,'Tag','trek');
            delete(h);
            plot(data.hvideo,[0:length(data.trek)-1]*1/data.Fs/data.timeScale,data.trek,'b','LineWidth',2,'Tag','trek');

            data.NFFT=fix(length(data.trek)/2)*2;          
            Y=fft(data.trek,data.NFFT);            
            data.f=linspace(0,1,data.NFFT/2+1);
            
            h=findobj(data.hspec,'Tag','spec');
            delete(h);
            plot(data.hspec,data.f,abs(Y(1:data.NFFT/2+1))/max(abs(Y)),'k','LineWidth',3,'tag','spec');

            data.freq=getMaxFreq(data.trek);
            data.freqF=data.freq;

            h=findobj(data.hspec,'Tag','freq');            
            delete(h);
            plot(data.hspec,data.freq*[1 1], [1e-10 1.1],'r','LineWidth',2,'Tag','freq');
            
            data.timeTail=[data.timeTail(1),[length(data.trek)-1]*1/data.Fs];
            
            set(data.hbuttonAdjust,'Enable','on');
        guidata(obj,data);
        Recalculate(obj,evnt);
        AfterZoom(obj,evnt);
    end
    function Recalculate(obj,evnt)
        data=guidata(obj);        
        if isfield(data,'trek')&&~isempty(data.trek)                                             
            [data.trekF,data.Y,data.Filter]=BandFFT(data.trek,data.freqF,data.bandwidth,1e-10,data.NFFT);                       
            data.phZK=DensityPhaseZeroCross(data.trekF,1/data.Fs,data.freq*data.Fs/2,false);
            [data.phZK,data.timeBase,data.timeTail]=DensityAdjustPhase(data.phZK,1/data.Fs,data.timeBase,data.timeTail);
        end;                      
        guidata(obj,data);
        ReDraw(obj,evnt);
    end
    function ReDraw(obj,evnt)
        data=guidata(obj);        
        if isfield(data,'trek')&&~isempty(data.trek)                        
            h=findobj(data.haxes,'Tag','trace');
            delete(h);

            h=findobj(data.hspec,'Tag','freqF');            
            set(h,'Tag','trace');
            set(h,'Color',[0.5 0.5 0.5]);
            
            if data.freqF~=data.freq
                plot(data.hspec,data.freqF*[1 1], [1e-10 1.1],'m','LineWidth',2,'Tag','freqF');
            end;
                                
            h=findobj(data.hspec,'Tag','filter');
            set(h,'Tag','trace');
            set(h,'Color',[0.5 0.5 0.5]);
            plot(data.hspec,data.f,data.Filter(1:data.NFFT/2+1),'b','LineWidth',2,'Tag','filter');
            
            h=findobj(data.hvideo,'Tag','trekF');
            delete(h);
            plot(data.hvideo,[0:length(data.trekF)-1]*1/data.Fs/data.timeScale,data.trekF,'r','LineWidth',2,'Tag','trekF');
                        
            h=findobj(data.hphase,'Tag','phase');
            set(h,'Tag','trace');
            set(h,'Color',[0.5 0.5 0.5]);
            plot(data.hphase,data.phZK(:,1)/data.timeScale,data.phZK(:,2),'r','LineWidth',3,'Tag','phase');             
        end;                      
        guidata(obj,data);
        ControlRedraw(obj,evnt);
    end
    function EditFreq(obj,evnt)
        data=guidata(obj);
        freq=round(str2double(get(obj,'String'))*1e10)/1e10/data.freqUnits*data.freqScale;        
        if ~isempty(freq)&&isnumeric(freq)
            if strcmpi('Fs',get(obj,'Tag'))
                freq=freq*data.freqUnits/data.freqScale;
                data.Fs=freq;
                guidata(obj,data);
                NewTrek(obj,evnt);
            else
                if freq<1&&freq>2/data.NFFT
                    switch get(obj,'Tag')
                        case 'bandwidth'
                            data.bandwidth=freq;
                        case 'freq'
                            data.freq=freq;
                        case 'freqF'
                            data.freqF=freq;
                    end
                end
            end
        end
        guidata(obj,data);    
        Recalculate(obj,evnt);
    end
    function EditTime(obj,evnt)
        data=guidata(obj);
        time=str2double(get(obj,'String'))*data.timeScale;
        time=max([0 time]);
        time=min([time (length(data.trek)-1)*(1/data.Fs)]);
        if ~isempty(time)&&isnumeric(time)
            switch lower(get(obj,'Tag'))
                case 'timebasest'
                    data.timeBase(1)=time;
                case 'timebaseend'
                    data.timeBase(end)=time;
                case 'timetailst'
                    data.timeTail(1)=time;
                case 'timetailend'
                    data.timeTail(end)=time;
            end
        end
        guidata(obj,data);
        AfterZoom(obj,data);
        Recalculate(obj,data); 
    end
end