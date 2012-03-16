function TrekSet=TrekPickTime(TrekSetIn,StartTime,ProcTime)
%% Pick neccessary part from trek
TrekSet=TrekSetIn;


%%
if TrekSet.Plot
    tf=figure;
    plot(TrekSet.StartTime+[1:TrekSet.size]*TrekSet.tau,TrekSet.trek);
    grid on; hold on;
end;


%% Start Time Picking

PickStart=false;
if nargin<2
    PickStart=true;
elseif isempty(StartTime)
    PickStart=true;
end;



if PickStart
    fprintf('Start Offset is %5.0fus \n',TrekSet.StartOffset);
    fprintf('Start Time is %5.0fus \n',TrekSet.StartTime);
    StartTime=input('Input StartTime>=Current. Default is current Start Time\n');
    if isempty(StartTime)
        StartTime=TrekSet.StartTime;
    elseif StartTime<TrekSet.StartTime
        StartTime=TrekSet.StartTime;
    end;
end;


%% Process interval Picking
PickTime=false;
if nargin<3    
    PickTime=true;
elseif isempty(ProcTime)
    PickTime=true;
end;

if PickTime
    fprintf('StartTime time is %6.3fus\n',StartTime);
    fprintf('Max trek time is %6.3fus\n',TrekSet.StartTime+(TrekSet.size-1)*TrekSet.tau);
    EndTime=input('Input EndTime in us. If empty Choose Process interval.\n');
    if isempty(EndTime)
        fprintf('Max time is %6.3fus\n',TrekSet.StartTime-StartTime+(TrekSet.size-1)*TrekSet.tau);
        ProcTime=input('Input Processing Time in us. Default is maximal trek \n');
        if isempty(ProcTime)
            ProcTime=TrekSet.StartTime-StartTime+(TrekSet.size-1)*TrekSet.tau;
            %-1 because 2 points have one tau lenght interval
        elseif ProcTime>TrekSet.StartTime-StartTime+(TrekSet.size-1)*TrekSet.tau
            ProcTime=TrekSet.StartTime-StartTime+(TrekSet.size-1)*TrekSet.tau;
        end;
    else
        if (EndTime>StartTime)&(EndTime<TrekSet.StartTime+(TrekSet.size-1)*TrekSet.tau)
            ProcTime=EndTime-StartTime;
        else
            ProcTime=TrekSet.StartTime+(TrekSet.size-1)*TrekSet.tau-StartTime;
        end;
    end;
end;
%% Control and trek reducing
StI=round((StartTime-TrekSet.StartTime)/TrekSet.tau)+1;
EndI=StI+round(ProcTime/TrekSet.tau);
ProcInt=[StI,EndI];
ProcIntTime=[StartTime,StartTime+ProcTime];

while any([PickTime,PickStart]);
    ProcIntTime=input(['Input Process Interval Times [...,...]\n Default is Current times [',num2str(StartTime),',',num2str(StartTime+ProcTime),'] by indexes input\n']);
    
    if not(isempty(ProcIntTime))
        StartTime=ProcIntTime(1);
        ProcTime=ProcIntTime(end)-ProcIntTime(1);
    end;
    
    StI=round((StartTime-TrekSet.StartTime)/TrekSet.tau)+1;
    EndI=StI+round(ProcTime/TrekSet.tau);
    ProcInt=[StI,EndI];
    ProcInt1=input(['Input Process Interval indexes[...:...]\n Default is [',num2str(StI) ,':',num2str(EndI),']\n']);
    if not(isempty(ProcInt1)) 
        ProcInt=ProcInt1;
        clear ProcInt1;
    end;

    ProcIntTime=[TrekSet.StartTime+(ProcInt(1)-1)*TrekSet.tau,TrekSet.StartTime+(ProcInt(end)-1)*TrekSet.tau];
    fprintf('Process Interval is %8.3f-%8.3fus  %8.3f us long\n Indexes [%5.0f:%7.0f]\n',ProcIntTime(1),ProcIntTime(end),(ProcIntTime(end)-ProcIntTime(1)),ProcInt(1),ProcInt(end));
    StartTime=ProcIntTime(1);
    StI=ProcInt(1);
    EndI=ProcInt(end);
    if TrekSet.Plot
        figure(tf);
        sl=plot([StartTime,StartTime],[min(TrekSet.trek),max(TrekSet.trek)],'g','LineWidth',2);
        el=plot([ProcIntTime(end),ProcIntTime(end)],[min(TrekSet.trek),max(TrekSet.trek)],'r','LineWidth',2);
        grid on; hold on;
        s=input('Is correct? (Empty input)\n','s');
        if isempty(s)
            PickTime=false;
            PickStart=false;
        else
            delete(sl);
            delete(el);
        end;
    else
        PickTime=false;
        PickStart=false;
    end;
end;



TrekSet.StartTime=StartTime;
TrekSet.trek=TrekSet.trek(StI:EndI);
TrekSet.size=numel(TrekSet.trek);
%% Correction of Interval 
%!!!!!! Dodelat'
% if isfield(TrekSet,'BreakPointsInd')
%     if not(isempty(TrekSet.BreakPointsInd))
%         BreakPointInd=find(TrekSet.BreakPointsInd<StI,1,'last');
%         if not(isempty(BreakPointInd))
%             StI=TrekSet.BreakPointsInd(BreakPointInd);
%         else
%             BreakPointInd=find(TrekSet.BreakPointsInd>StI,1,'first');            
%             if not(isempty(BreakPointInd))
%                 if TrekSet.BreakPointsInd(BreakPointInd)<EndI
%                    StI=TrekSet.BreakPointsInd(BreakPointInd);
%                 end;
%             end;
%         end;
%         BreakPointInd=find(TrekSet.BreakPointsInd>EndI,1,'first');
%         if not(isempty(BreakPointInd))
%             EndI=TrekSet.BreakPointsInd(BreakPointInd);
%         else
%            BreakPointInd=find(TrekSet.BreakPointsInd<EndI,1,'last');            
%             if not(isempty(BreakPointInd))
%                 if TrekSet.BreakPointsInd(BreakPointInd)<EndI
%                    StI=TrekSet.BreakPointsInd(BreakPointInd);
%                 end;
%             end;
%         end;
%         TrekSet.StartTime=TrekSet.StartOffset+(StI-1)*TrekSet.tau;
%         TrekSet.size=EndI-StI;
%     end;
% end;