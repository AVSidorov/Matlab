function Kernel=MakeKernelByResponse(Response,Pulse,Plot)
%function makes FIR filter kernel for given initial and filtered Pulse forms.
%first column in arrays is time in us
if nargin<3
    Plot=true;
end;

if size(Response,1)<size(Response,2)
    Response=Response';
end;
if size(Response,2)<2
    disp('No time column in Response Pulse. Function exit');
    return;
end;

if size(Pulse,1)<size(Pulse,2)
    Pulse=Pulse';
end;
if size(Pulse,2)<2
    disp('No time column in Initial Pulse. Function exit');
    return;
end;

Response=sortrows(Response,1);
Pulse=sortrows(Pulse,1);

timeStep=min([diff(Response(:,1));diff(Pulse(:,1))]);

if timeStep==0
    disp('There are points with same time. Function exit');
    return;
end;

time=[0:timeStep:max([Response(end,1);Pulse(end,1)])]';
response=interp1(Response(:,1),Response(:,2),time,'spline',0);
pulse=interp1(Pulse(:,1),Pulse(:,2),time,'spline',0);

Fs=1/(timeStep*1e-6);
NFFT=pow2(nextpow2(numel(response)));
f = Fs/2*linspace(0,1,NFFT/2+1);
Ypulse=fft(pulse,NFFT);
Yresp =fft(response,NFFT);
Yfilter=Yresp./Ypulse;

Kernel(:,1)=[1:NFFT]*timeStep;
Kernel(:,2)=ifft(Yfilter);

if Plot
    pulseFilt=filter(Kernel(:,2),1,pulse);
    figure;    
    subplot(2,2,1:2);
        grid on; hold on;
        plot(Pulse(:,1),Pulse(:,2),'b');
        plot(Response(:,1),Response(:,2),'k');
        plot(time,pulseFilt,'.r');
    subplot(2,2,3);
        grid on; hold on;
        plot(Kernel(:,1),Kernel(:,2));
    subplot(2,2,4);
        grid on; hold on;
        plot(f,abs(Ypulse(1:NFFT/2+1)),'b');
        plot(f,abs(Yresp(1:NFFT/2+1)),'k');
        plot(f,abs(Yfilter(1:NFFT/2+1)),'r');
end;
