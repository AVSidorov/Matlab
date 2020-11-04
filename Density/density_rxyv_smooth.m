function rxyv=density_rxyv_smooth(rxyv)
Plot=1;
fig=[];
% make equidistant on low field size R net
rxyv=sortrows(rxyv,1);
nR=size(rxyv,1);

PlotFcn;

x=rxyv(:,1)+rxyv(:,2);
xx=linspace(rxyv(1,1)+rxyv(1,2),rxyv(end,1)+rxyv(end,2),nR)';
rr=interp1(x,rxyv(:,1),xx);
rxyv(:,2)=interp1(rxyv(:,1),rxyv(:,2),rr);
rxyv(:,4)=interp1(rxyv(:,1),rxyv(:,4),rr);
rxyv(:,1)=rr;

PlotFcn('k');


[rxyv(:,4),~,ppV]=smooth_gui(rxyv(:,1),rxyv(:,4));
[rxyv(:,2),~,ppC]=smooth_gui(rxyv(:,1),rxyv(:,2));

PlotFcn('r');

    function PlotFcn(col)       
        if Plot
            if isempty(fig)||~ishandle(fig)||~strcmp(get(fig,'Type'),'figure')
                fig=figure;
            end
            
            if nargin<1||isempty(col)
                col='b';
            end;

            subplot(3,4,9:10);
            plot(diff(rxyv(:,1)+rxyv(:,2)),col);
            grid on; hold on;
            title('\Delta x=r+c');
            
            subplot(3,4,[1,2,5,6]);
            plot(rxyv(:,1),rxyv(:,4),col);
            grid on; hold on;
            title('v(r)');

            subplot(3,4,[3,4,7,8]);
            plot(rxyv(:,1),rxyv(:,2),col);
            grid on; hold on;
            title('c(r)');

            subplot(3,4,11);
            plot(diff(rxyv(:,1)),col);
            grid on; hold on;
            title('\Delta r');

            subplot(3,4,12);
            plot(diff(rxyv(:,2))./diff(rxyv(:,1)),col);
            grid on; hold on;
            title('\Delta c / \Delta r');
        end

    end
end