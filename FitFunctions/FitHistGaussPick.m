function AStruct=FitHistGaussPick(Hist) 
h=figure;
    grid on; hold on;
    plot(Hist(:,1),Hist(:,2),'k','LineWidth',2);    
    s='d';
    AStruct.FITAmp=[];
    while ~isempty(s)
        figure(h);
        title('Input region for gauss fitting. Zoom end then press any key');
        pause;
        [x,y]=ginput(2);
        if exist('hf','var')&&~isempty(hf)&&ishandle(hf)
            delete([hlb;hrb;hf]);
        end;
        bool=Hist(:,1)>=min(x)&Hist(:,1)<=max(x);
        hlb=plot(min(x)*[1,1],[1,max(Hist(:,2))],'r','LineWidth',2);
        hrb=plot(max(x)*[1,1],[1,max(Hist(:,2))],'r','LineWidth',2);
        FITAmp=FitHistGauss(Hist(bool,:));
        hf=plot(Hist(:,1),exp(polyval(FITAmp.fit,Hist(:,1))),'b','LineWidth',2);
        if ~isempty(FITAmp.x1)
            plot(FITAmp.x1,max(Hist(:,2))/2*[1,1],'k');
        end;
        if exist('hln','var')&&~isempty(hln)&&ishandle(hln)
            delete([hln;hrn;hfwhm]);
        end;
        hfwhm=plot(FITAmp.x2,FITAmp.MaxY/2*[1,1],'b');
        hln=plot(min(FITAmp.xbound)*[1,1],[1,max(Hist(:,2))],'b','LineWidth',2);
        hrn=plot(max(FITAmp.xbound)*[1,1],[1,max(Hist(:,2))],'b','LineWidth',2);

        AStruct.FITAmp=FITAmp;
        title('If fit ok empty input');
        figure(h);
        s=input('If fit ok empty input\n','s');
    end;
    
    s='d';
    title('If main pulse Boudories are correct empty input');
    figure(h);
    s=input('If main pulse Boudories are correct empty input\n','s');
    if isempty(s)
        bool=Hist(:,1)>=min(FITAmp.xbound)&Hist(:,1)<=max(FITAmp.xbound);
        AStruct.NMain=sum(Hist(bool,2));   
        AStruct.NPileUp=sum(Hist(find(bool,1,'last')+1:end,2));
        AStruct.NNoise=sum(Hist(:,2))-AStruct.NMain-AStruct.NPileUp;  
    end;
    while ~isempty(s)
        title('Input region for main founded peaks calculation. Press key for continue');
        figure(h);
        pause;
        [x,y]=ginput(2);
        if exist('hln','var')&&~isempty(hln)&&ishandle(hln)
            delete([hln;hrn]);
        end;
        bool=Hist(:,1)>=min(x)&Hist(:,1)<=max(x);
        if exist('hln','var')&&~isempty(hln)&&ishandle(hln)
            delete([hln;hrn]);
        end;
        hln=plot(min(x)*[1,1],[1,max(Hist(:,2))],'b','LineWidth',2);
        hrn=plot(max(x)*[1,1],[1,max(Hist(:,2))],'b','LineWidth',2);
        AStruct.NMain=sum(Hist(bool,2));   
        AStruct.NPileUp=sum(Hist(find(bool,1,'last')+1:end,2));
        AStruct.NNoise=sum(Hist(:,2))-AStruct.NMain-AStruct.NPileUp;
        title('If fit ok empty input');
        figure(h);
        s=input('If fit ok empty input\n','s');
    end;
    
    close(h);