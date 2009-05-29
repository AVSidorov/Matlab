function Te=TeByAngelTime(alpha,Time);

r=alpha*1.15;
Time=Time/1000;

FileName=input('Input Te table array name or Name of variable, default is manual input\n','s');
if isempty(FileName)
    Te=input('Input Te in keV\n');
else
    Te_Tab=evalin('base',FileName);
    TeProfile(:,1)=Te_Tab(:,1);
    TeProfile(:,2)=Te_Tab(:,find(Time>=Te_Tab(1,:),1,'last'));
    TeProfile(:,3)=Te_Tab(:,find(Time<=Te_Tab(1,:),1,'first'));
    TeProfile(1,4)=Time;
for i=2:size(TeProfile,1)
    TeProfile(i,4)=interp1(TeProfile(1,2:3),TeProfile(i,2:3),Time);
end;
    R(1)=find(r>=TeProfile(:,1),1,'last');
    R(2)=find(r<=TeProfile(:,1),1,'first');
    Te=interp1(TeProfile(R,1),TeProfile(R,4),r);
    fprintf('At time %2.2f ms Te interpolated is %4.3f keV\n',Time,Te);
end;

