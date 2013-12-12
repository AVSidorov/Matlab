function [TrekMerged,fit]=TrekSDDMerge(TrekSetIn,varargin)
%This function merges two treks written in differen ADC channels with
%different ranges. In must be base channel (whithout number after sxr);
if isstruct(TrekSetIn)&&isfield(TrekSetIn,'Merged')&&TrekSetIn.Merged
    TrekMerged=TrekSetIn;
    fit=[];
    return;
elseif isstruct(TrekSetIn)&&isfield(TrekSetIn,'FileName')&&~isempty(TrekSetIn.FileName)
    TrekSet=TrekSDDRecognize(TrekSetIn.FileName,varargin{:});
elseif ischar(TrekSetIn)    
    TrekSet=TrekSDDRecognize(TrekSetIn,varargin{:});
end;

TrekSet.Plot=false;
if TrekSet(end).type>0 
    TrekSet=TrekLoad(TrekSet);
end;

fix=false;

i=2;
while i<=4
FileName=[TrekSet(1).name,num2str(i),'.dat'];
    TrekSet(end+1)=TrekSDDRecognize(FileName,varargin{:});
   TrekSet(end).Plot=false; 
   if TrekSet(end).type>0 
        TrekSet(end)=TrekLoad(TrekSet(end));
        TrekSet(end)=TrekPickTime(TrekSet(end),TrekSet(1).StartTime,TrekSet(1).size*TrekSet(1).tau);
    else
        TrekSet(end)=[];
    end;
 i=i+1;
end;                   

fileN=numel(TrekSet);

fit(1,:)=[1,0];

if fileN<2 
    TrekMerged=TrekSet;
    TrekMerged.Merged=true;
    fit=[];
    return;     
end;
WorkSize=pow2(23);
for i=2:fileN
    bool=(TrekSet(1).trek<TrekSet(1).MaxSignal&TrekSet(1).trek>TrekSet(1).MinSignal&...
            TrekSet(i).trek<TrekSet(i).MaxSignal&TrekSet(i).trek>TrekSet(i).MinSignal);
    bool(WorkSize+1:end)=false;
    fit(i,:)=polyfit(TrekSet(i).trek(bool),TrekSet(1).trek(bool),1);
end;

[fit,index]=sortrows(fit,1);
TrekSet=TrekSet(index);

TrekMerged=TrekSet(1);
for i=2:fileN
    bool=(TrekSet(1).trek<TrekSet(1).MaxSignal&TrekSet(1).trek>TrekSet(1).MinSignal&...
            TrekSet(i).trek<TrekSet(i).MaxSignal&TrekSet(i).trek>TrekSet(i).MinSignal);
    bool(WorkSize+1:end)=false;
    fit(i,:)=polyfit(TrekSet(i).trek(bool),TrekSet(1).trek(bool),1);
    if fix
        fit(i,1)=round(fit(i,1));
        fit(i,2)=mean(TrekSet(1).trek(bool)-fit(i,1)*TrekSet(i).trek(bool));
    end;
    dif=TrekSet(i).trek*fit(i,1)+fit(i,2)-TrekSet(1).trek;
    s=std(dif);
    ds=1;
    while ds>1e-4
        ds=s-std(dif(abs(dif)<s*3.5));
        s=s-ds;
    end;
    bool=abs(dif)>=s*4;
    TrekMerged.trek(bool)=TrekSet(i).trek(bool)*fit(i,1)+fit(i,2);
    TrekMerged.MaxSignal=TrekSet(i).MaxSignal*fit(i,1)+fit(i,2);
    TrekMerged.MinSignal=TrekSet(i).MinSignal*fit(i,1)+fit(i,2);
end;
TrekMerged.Merged=true;
return;

% if TrekSet(1).Plot
    figure; 
    clr=[0,0,1;1,0,0;0,0,0;1,0,1];
    subplot(2,1,1);
    grid on; hold on;
    for i=1:fileN
        plot(TrekSet(i).trek*fit(i,1)+fit(i,2),'Color',clr(i,:));
    end;
    subplot(2,1,2);
    grid on; hold on;
    for i=2:fileN
        plot(TrekSet(i).trek*fit(i,1)+fit(i,2)-(TrekSet(i-1).trek*fit(i-1,1)+fit(i-1,2)),'Color',clr(i,:));
    end;
% end;