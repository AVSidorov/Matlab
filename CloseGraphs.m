function CloseGraphs;
H=findobj('Type','figure');
figN=size(H,1);
for i=1:figN
    figure(H(i));
    decision='Y';
    decision=input('Close figure Y(default)/(other key)','s');
    if isempty(decision)
        figure(H(i));
        close(gcf);
    else
      if decision=='Y'|decision=='y'
        figure(H(i));
        close(gcf);
      end;
    end;
end;