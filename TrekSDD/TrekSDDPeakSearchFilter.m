function [TrekSet,trek]=TrekSDDPeakSearchFilter(TrekSet,NoiseInd)
kernel_type='gauss';
kernel_width=10;
kernel=load(['D:\!SCN\FilteringSDD\kernel_',kernel_type,'_',num2str(kernel_width),'.dat']);
N=numel(abs(kernel(:,2))>0);
Step=mean(diff(kernel(:,1)));
kernel=interp1(kernel(:,1),kernel(:,2),[1:135]);
kernel=kernel*1/Step;
trek=filter(kernel,1,TrekSet.trek);
S=SpecialTreks(trek);

TrekSetF=TrekSet;
rmfield(TrekSetF,'STP');
TrekSetF.trek=trek;
TrekSetF=TrekSDDNoise(TrekSetF);
Threshold=ceil(TrekSetF.Threshold);
TrekSet.SelectedPeakInd=find(S.MaxBool&trek>Threshold&TrekSet.trek<TrekSet.MaxSignal);
