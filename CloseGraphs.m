function CloseGraphs;
H=findobj('Type','figure');
figN=size(H,1);
for i=1:figN
    figure(H(i));
    decision='Y';
    decision=input('Close figure Y(default)/(other key)','s');
    if isempty(decision)
        close(gcf);
    else
      if decision=='Y'||decision=='y'
        close(gcf);
      end;
    end;
end;