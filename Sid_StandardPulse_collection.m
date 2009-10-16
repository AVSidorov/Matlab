function sid_StandardPulse_collection;
S=strvcat('0 ','10','20','30','40','50','60','70','84');
T=cellstr(S);
for n=18:31
    N=num2str(n,'%02d');
    for i=1:size(T,1)-1
        Str=['StP',N,'T',char(T(i)),'d',char(T(i+1)),'ms'];
        A=evalin('base',['exist(''',Str,''',''var'')']);
        if A
            [MaxInd,sizeP]=evalin('base',['sid_compare_standard_pulse(',Str,');']);
            assignin('base','MaxInd',MaxInd);
            assignin('base','sizeP',sizeP);
            if MaxInd>1
                fprintf(['Pulse from variable ',Str,' is taken \n \n']);
                evalin('base','StP(:,end+1)=zeros(100,1);');
                evalin('base',['StP((10-MaxInd)+1:(10-MaxInd)+sizeP,end)=',Str,';']);
            end;
        end;
    end;
end;
        