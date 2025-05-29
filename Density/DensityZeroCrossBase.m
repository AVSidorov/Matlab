function [phase,IndPhase] = DensityZeroCrossBase(trek, period, threshold, doPlot)
    ## trek videosignal
    ## period in indexes overrides calclulated
    ## threshold in pi's for noise detection
    if nargin<3
        threshold = 0.5; ## phase should change not greater than pi/2 in on half period
    end
    if nargin<4
        doPlot = false;
    end

    IndPreCross=find(trek.*circshift(trek,-1)<0|trek==0); %<= gives double indexing

    if IndPreCross(end)==numel(trek) IndPreCross(end)=[]; end;
    i=find(trek(IndPreCross)<0&trek(IndPreCross+1)>0,1,'first');
    IndPreCross=IndPreCross(i:end);

    IndCross=IndPreCross-trek(IndPreCross)./(trek(IndPreCross+1)-trek(IndPreCross));

    hPeriods = diff(IndCross);
    halfPeriod = mean(hPeriods); ## pi in indexes
    noiseBool = abs(hPeriods-halfPeriod)/halfPeriod > threshold;
    halfPeriod = mean(hPeriods(~noiseBool));
    if nargin>1
        halfPeriod = period/2;
    end
    phaseDiffs = (hPeriods - halfPeriod)/halfPeriod; ## differences in pi's
    phaseDiffs(noiseBool) = 0;

    phase = cumsum(phaseDiffs)/2;
    IndPhase=IndCross(1:end-1);

    if doPlot
        figure;
        plot(IndPhase, phase)
        grid on; hold on;
    end
