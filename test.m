function test;
exitstr='n';
while exitstr~='y'
    exitstr=input('Exit? y/[n]\n','s');
    exitstr=lower(exitstr);
    if isempty(exitstr) exitstr='n'; end;    
end;   