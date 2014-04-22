function phase=unwrapSid(phase,tol)

phase=unwrap(phase);

dphase=diff(phase);
dphase=dphase-mean(dphase);
if nargin<2
    tol=3.5*std(dphase);
end;
Ind=find(abs(dphase)>tol);
for i=1:numel(Ind)
    phase(Ind(i):end)=phase(Ind(i):end)-dphase(Ind(i));
end;
return;