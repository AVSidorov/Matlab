function [peaks,trekMinus]=ProcessingTrek(FileName);


Pass1=2;
OverSt=1.1;         % noise regection threshold, in standard deviations 

[trek,ProcInt,ProcIntTime,StdVal]=PrepareTrek(FileName);
if isempty(trek); return; end;


[PeakSetFirst,StandardPulseFirst]=Tops(trek,1,StdVal*OverSt);

[peaks,trekMinus]=GetPeaks(trek,Pass1,PeakSetFirst,StandardPulseFirst,StdVal*OverSt);

peaks(:,2)=peaks(:,2)+ProcIntTime(1);
%peaks(:,1)=peaks(:,1)+ProcInt(1);
if isstr(FileName)
    [pathstr, name, ext, versn]=fileparts(FileName);
    assignin('base',['p',name],peaks);
else
    assignin('base','peaks',peaks);
end;

[Flow1,Flow2,Uloop,Etor,Wb,K_W,K_A]=ProcessPeaks(peaks);


