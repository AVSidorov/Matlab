function CloseGraphs;
H=findobj('Type','figure');
figN=size(H,1);
i=1;
while figN>0&i<=figN
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
      i=i+1;
    end;
  H=findobj('Type','figure');
  figN=size(H,1);
end;