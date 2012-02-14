function TrekSet=TrekPickTime(TrekSetIn,StartOffset,StartTime,ProcTime)
TrekSet=TrekSetIn;

if isempty(TrekSetIn.StartOffset)
    TrekSetIn.StartOffset=0;
elseif TrekSetIn.StartOffset<0
    TrekSetIn.StartOffset=0;
end;

if isempty(TrekSetIn.StartTime)
    TrekSet.StartTime=TrekSetIn.StartOffset;
elseif TrekSet.StartTime<TrekSetIn.StartOffset
    TrekSet.StartTime=TrekSetIn.StartOffset;
end;

%% StartOffset Picking
PickOffset=false;
if nargin<2
    PickOffset=true;
elseif isempty(StartOffset)
    PickOffset=true;
end;
    
if PickOffset
    if isempty(TrekSet.StartOffset)
        StartOffset=input('Input Start Offset Default is 0 us \n');
        if isempty(StartOffset)
            StartOffset=0;
        end;
    elseif TrekSet.StartOffset<0
        StartOffset=input('Input Start Offset Default is 0 us \n');
        if isempty(StartOffset)
            StartOffset=0;
        end;
    else    
        StartOffset=input(['Input Start Offset Default is ',num2str(TrekSet.StartOffset,'%6.0f us'),'\n']);
        if isempty(StartOffset)
            StartOffset=TrekSet.StartOffset;
        end;
    end;
end;    

TrekSet.StartOffset=StartOffset;
TrekSetIn.StartOffset=TrekSet.StartOffset;
if TrekSetIn.StartTime<TrekSetIn.StartOffset
    TrekSetIn.StartTime=TrekSetIn.StartOffset;
end;

%% Start Time Picking

PickStart=false;
if nargin<3
    PickStart=true;
elseif isempty(StartTime)
    PickStart=true;
end;



if PickStart
    if isempty(TrekSet.StartTime)
        TrekSet.StartTime=TrekSet.StartOffset;
    elseif TrekSet.StartTime<TrekSet.StartOffset
        TrekSet.StartTime=TrekSet.StartOffset;
    end;
    fprintf('Start Offset is %5.0fus \n',TrekSet.StartOffset);
    fprintf('Start Time is %5.0fus \n',TrekSet.StartTime);
    StartTime=input('Input StartTime>=Current. Default is current Start Time');
    if isempty(StartTime)
        StartTime=TrekSet.StartTime;
    elseif StartTime<TrekSet.StartOffset
        StartTime=TrekSet.StartOffset;
    end;
end;

TrekSet.StartTime=StartTime;

%% Process interval Picking
PickTime=false;
if nargin<4    
    PickTime=true;
elseif isempty(ProcTime)
    PickTime=true;
end;

if PickTime
    ProcTime=input('Input Processing Time. in us\n Default is whole trek \n');
    if isempty(ProcTime)
           ProcTime=(TrekSet.size-1)*TrekSet.tau-(TrekSet.StartTime-TrekSetIn.StartTime);
           %-1 because 2 points have one tau lenght interval
    end;
end;
%% Control and trek reducing
StI=round((TrekSet.StartTime-TrekSet.StartOffset)/TrekSet.tau)+1;
EndI=StI+round(ProcTime/TrekSet.tau);
ProcInt=[StI,EndI];
ProcIntTime=[TrekSet.StartTime,TrekSet.StartTime+ProcTime];

if any([PickOffset,PickTime,PickStart]);
    ProcIntTime=input(['Input Process Interval Times [...,...]\n Default is Current times [',num2str(TrekSet.StartTime),',',num2str(TrekSet.StartTime+ProcTime),'] by indexes input\n']);
    
    if not(isempty(ProcIntTime))
        TrekSet.StartTime=ProcIntTime(1);
        ProcTime=ProcIntTime(end)-ProcIntTime(1);
    end;
    
    StI=round((TrekSet.StartTime-TrekSet.StartOffset)/TrekSet.tau)+1;
    EndI=StI+round(ProcTime/TrekSet.tau);
    ProcInt=[StI,EndI];
    ProcInt1=input(['Input Process Interval indexes[...:...]\n Default is [',num2str(StI) ,':',num2str(EndI),']\n']);
    if not(isempty(ProcInt1)) 
        ProcInt=ProcInt1;
        clear ProcInt1;
    end;

    ProcIntTime=[TrekSet.StartOffset+(ProcInt(1)-1)*TrekSet.tau,TrekSet.StartOffset+(ProcInt(end)-1)*TrekSet.tau];
    fprintf('Process Interval is %8.3f-%8.3fus  %8.3f us long\n Indexes [%5.0f:%7.0f]\n',ProcIntTime(1),ProcIntTime(end),(ProcIntTime(end)-ProcIntTime(1)),ProcInt(1),ProcInt(end));
end;
TrekSet.StartTime=ProcIntTime(1);
TrekSet.size=ProcInt(end)-ProcInt(1);
TrekSet=TrekTimeCorrection(TrekSet);
