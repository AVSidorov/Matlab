function Kernel=MakeKernelByResponse(Response,Pulse,Plot)
%function makes FIR filter kernel for given initial and filtered Pulse forms.
%first column in arrays is time in us
FilterSet=MakeFilterByResponse(Response,Pulse,Plot);
Kernel=FilterSet.Kernel;
