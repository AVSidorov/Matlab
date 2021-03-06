function Ne=NeByAngelTime(alpha,Time);

r=alpha*1.15;
Time=Time/1000;

FileName=input('Input Ne table array name or Name of variable, default is manual input\n','s');
if isempty(FileName)
    Ne=input('Input Ne in 10^13cm-3\n');
else
    Ne_Tab=evalin('base',FileName);
    NeProfile(:,1)=Ne_Tab(:,1);
    NeProfile(:,2)=Ne_Tab(:,find(Time>=Ne_Tab(1,:),1,'last'));
    NeProfile(:,3)=Ne_Tab(:,find(Time<=Ne_Tab(1,:),1,'first'));
    NeProfile(1,4)=Time;
for i=2:size(NeProfile,1)
    NeProfile(i,4)=interp1(NeProfile(1,2:3),NeProfile(i,2:3),Time);
end;
    R(1)=find(r>=NeProfile(:,1),1,'last');
    R(2)=find(r<=NeProfile(:,1),1,'first');
    Ne=interp1(NeProfile(R,1),NeProfile(R,4),r)/1E13;
    fprintf('At time %2.2f ms Ne interpolated is %4.3f *10^13cm-3\n',Time,Ne);
end;

