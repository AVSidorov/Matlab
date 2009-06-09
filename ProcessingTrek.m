function [peaks,trekMinus,StandardPulseFirst]=ProcessingTrek(FileName);


Pass1=2;
OverSt=1.2;         % noise regection threshold, in standard deviations 

[trek,ProcInt,ProcIntTime,StdVal]=PrepareTrek(FileName);
if isempty(trek); return; end;


[PeakSetFirst,StandardPulseFirst]=Tops(trek,true,StdVal*OverSt);

if isstr(FileName)
    [pathstr, name, ext, versn]=fileparts(FileName);
    assignin('base',['StP',name,'T',num2str(round(ProcIntTime(1)/1000)),'d',num2str(round(ProcIntTime(end)/1000)),'ms'],StandardPulseFirst);
else
    assignin('base',['StPT',num2str(round(ProcIntTime(1)/1000)),'d',num2str(round(ProcIntTime(end)/1000)),'ms'],StandardPulseFirst);
end;

[peaks,trekMinus]=GetPeaks(trek,Pass1,PeakSetFirst,StandardPulseFirst,StdVal*OverSt);

peaks(:,2)=peaks(:,2)+ProcIntTime(1);
%peaks(:,1)=peaks(:,1)+ProcInt(1);
if isstr(FileName)
    [pathstr, name, ext, versn]=fileparts(FileName);
    assignin('base',['p',name,'T',num2str(round(ProcIntTime(1)/1000)),'d',num2str(round(ProcIntTime(end)/1000)),'ms'],peaks);
else
    assignin('base',['pT',num2str(round(ProcIntTime(1)/1000)),'d',num2str(round(ProcIntTime(end)/1000)),'ms'],peaks);
end;

[Flow1,Flow2,Uloop,Etor,Wb,K_W,K_A]=ProcessPeaks(peaks);


