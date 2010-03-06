function TrekSet=TrekPickTime(TrekSetIn);
TrekSet=TrekSetIn;

StartOffset=input(['Input Start Offset Default is ',num2str(TrekSet.StartOffset,'%6.0f us'),'\n']);

if not(isempty(StartOffset))
    TrekSet.StartOffset=StartOffset;
end;

ProcIntTime=input(['Input Process Interval Times [...,...]\n Default is whole trek[',num2str(TrekSet.StartOffset),',',num2str(TrekSet.StartOffset+TrekSet.size*TrekSet.tau),'] by indexes input\n']);
    
    if isempty(ProcIntTime)
        StI=1;
        EndI=TrekSet.size;
        ProcInt=[StI:EndI];
        ProcIntTime=[TrekSet.StartOffset+(StI-1)*TrekSet.tau,TrekSet.StartOffset+(EndI-1)*TrekSet.tau];
    else
        StI=max([(ProcIntTime(1)-TrekSet.StartOffset)/TrekSet.tau+1,1]);
        EndI=min([(ProcIntTime(end)-TrekSet.StartOffset)/TrekSet.tau+1,TrekSet.size]);
        ProcInt=[StI:EndI];
    end;

    ProcInt1=input(['Input Process Interval indexes[...:...]\n Default is [',num2str(StI) ,':',num2str(EndI),']\n']);
    if not(isempty(ProcInt1)) 
        ProcInt=ProcInt1;
        clear ProcInt1;
    end;

ProcIntTime=[TrekSet.StartOffset+(ProcInt(1)-1)*TrekSet.tau,TrekSet.StartOffset+(ProcInt(end)-1)*TrekSet.tau];
fprintf('Process Inteval is %8.3f-%8.3fus  %8.3f us long\n Indexes [%5.0f:%7.0f]\n',ProcIntTime(1),ProcIntTime(end),(ProcIntTime(end)-ProcIntTime(1)),ProcInt(1),ProcInt(end));

TrekSet.StartTime=ProcIntTime(1);
TrekSet.size=ProcInt(end)-ProcInt(1)+1;
