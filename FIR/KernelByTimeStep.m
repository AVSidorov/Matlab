function kernel=KernelByTimeStep(Kernel,timeStep)
%Makes kernel for filter function with necessary time step from kernel with
%time column (assumes us);

if size(Kernel,1)<size(Kernel,2)
    Kernel=Kernel';
end;

if size(Kernel,2)<2
    disp('No time column in Initial Kernel. Function exit');
    return;
end;

Kernel=sortrows(Kernel,1);
inStep=min(diff(Kernel(:,1)));
if inStep==0
    disp('There are points with same time. Function exit');
end;

time=[Kernel(:,1):timeStep:Kernel(end,1)];
kernel(:,1)=interp1(Kernel(:,1),Kernel(:,2),time,'linear',0);
kernel=kernel*(timeStep/inStep);