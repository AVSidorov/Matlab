function [TrekSet,fit]=TrekSDDMerge(TrekSetIn)
%This function merges two treks written in differen ADC channels with
%different ranges. In must be base channel (whithout number after sxr);
TrekSet=TrekRecognize(TrekSetIn);
if TrekSet(end).type>0 
    TrekSet=TrekLoad(TrekSet);
end;

i=2;
while i<=4
FileName=[TrekSet(1).name,num2str(i),'.dat'];
    TrekSet(end+1)=TrekRecognize(FileName,'StartOffset',TrekSet(1).StartOffset,'Date',TrekSet(1).Date,...
                           'Amp',TrekSet(1).Amp,'HV',TrekSet(1).HV,'P',TrekSet(1).P,'Plot',TrekSet(1).Plot);
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
    return;     
end;

for i=2:fileN
    bool=(TrekSet(1).trek<TrekSet(1).MaxSignal&TrekSet(1).trek>TrekSet(1).MinSignal&...
            TrekSet(i).trek<TrekSet(i).MaxSignal&TrekSet(i).trek>TrekSet(i).MinSignal);
    fit(i,:)=polyfit(TrekSet(i).trek(bool),TrekSet(1).trek(bool),1);
end;

[fit,index]=sortrows(fit,1);
TrekSet=TrekSet(index);

for i=2:fileN
    bool=(TrekSet(1).trek<TrekSet(1).MaxSignal&TrekSet(1).trek>TrekSet(1).MinSignal&...
            TrekSet(i).trek<TrekSet(i).MaxSignal&TrekSet(i).trek>TrekSet(i).MinSignal);
    fit(i,:)=polyfit(TrekSet(i).trek(bool),TrekSet(1).trek(bool),1);
    dif=TrekSet(i).trek*fit(i,1)+fit(i,2)-TrekSet(1).trek;
    s=std(dif);
    ds=1;
    while ds>1e-4
        ds=s-std(dif(abs(dif)<s*3.5));
        s=s-ds;
    end;
    bool=abs(dif)>=s*4;
    TrekSet(1).trek(bool)=TrekSet(i).trek(bool)*fit(i,1)+fit(i,2);
    TrekSet(1).MaxSignal=TrekSet(i).MaxSignal*fit(i,1)+fit(i,2);
    TrekSet(1).MinSignal=TrekSet(i).MinSignal*fit(i,1)+fit(i,2);
end;
TrekSet=TrekSet(1);    
TrekSet.Merged=true;
