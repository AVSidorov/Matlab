function Kernel=MakeKernelByResponse(Response,Pulse)
%function makes FIR filter kernel for given initial and filtered Pulse forms.
%first column in arrays is time in us

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
end;

time=[0:timeStep:max([Response(end,1);Pulse(end,1)])]';
Response=interp1(Response(:,1),Response(:,2),time,'spline',0);
Pulse=interp1(Pulse(:,1),Pulse(:,2),time,'spline',0);

Fs=1/(timeStep*1e-6);
NFFT=pow2(nextpow2(numel(Response)));
f = Fs/2*linspace(0,1,NFFT/2+1);
Ypulse=fft(Pulse,NFFT);
Yresp =fft(Response,NFFT);
Yfilter=Yresp./Ypulse;

Kernel(:,1)=[1:NFFT]*timeStep;
Kernel(:,2)=ifft(Yfilter);


