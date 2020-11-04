function xChord=density_ant(n)
stp=0.001;

d=0.02;
rAnt=0.1;
lAnt=0.023;


xChordAnt=[-d/2:stp:d/2];

for i=1:numel(n)
    xChord(:,i)=xChordAnt+n(i)*lAnt;
end
