function [TrekSet,trek]=TrekSDDPeakSearchFilter(TrekSet,NoiseInd)

if ~isfield(TrekSet,'kernel')||isempty(TrekSet.kernel)
    STP=TrekSet.STP;
    time=(STP.TimeInd-1)*TrekSet.tau;
    Stp(:,1)=time;
    Stp(:,2)=STP.FinePulse;
    [M,MI]=max(STP.FinePulse);
    MaxTime=time(MI);
    Resp(:,1)=Stp(:,1);
    Resp(:,2)=exp(-(time-MaxTime).^2/(2*(sqrt(10)*0.02)^2))';
    Kernel=MakeKernelByResponse(Resp,Stp,false);
    kernel=KernelByTimeStep(Kernel,0.02);
    TrekSet.kernel=kernel;
end;

kernel=TrekSet.kernel;
kernel=kernel(1:137);

trek=filter(kernel,1,TrekSet.trek);
S=SpecialTreks(trek);
NoiseSet=NoiseFitAuto(trek(NoiseInd));
Threshold=ceil(NoiseSet.Threshold);
TrekSet.SelectedPeakInd=find(S.MaxBool&trek>Threshold&TrekSet.trek<TrekSet.MaxSignal);
