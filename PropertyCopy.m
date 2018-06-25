    function PropertyCopy(h)
if nargin<1||isempty(h)||~ishghandle(h)
    h=gcf;   
end;
hfig=ancestor(h,'figure','toplevel');
if ~isempty(hfig)&&ishghandle(hfig)
    propF=get(hfig);
    propFnames=fieldnames(propF);
    boolF=false(length(propFnames),1);

    haxes=findobj(hfig,'type','axes');
    if ~isempty(haxes)&&ishghandle(haxes)    
        propA=get(haxes(1));
        propAnames=fieldnames(propA);
        boolA=false(length(propAnames),1);
        
        hline=findobj(hfig,'type','line');
        propL=get(hline(1));
        propLnames=fieldnames(propL);
        boolL=false(length(propLnames),1);

        f=figure;
        t1=uitable(f,'Data',[num2cell(boolF),propFnames],'ColumnEditable',[true false],'Units','normalized','Position',[0.1,0.1,0.2,0.8]);
        t2=uitable(f,'Data',[num2cell(boolA),propAnames],'ColumnEditable',[true false],'Units','normalized','Position',[0.4,0.1,0.2,0.8]);
        t3=uitable(f,'Data',[num2cell(boolL),propLnames],'ColumnEditable',[true false],'Units','normalized','Position',[0.7,0.1,0.2,0.8]);
    end;
end

