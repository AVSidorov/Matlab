function table=tabulateSid(x);

%because tabulate (MatLab Statistic Toolbox) gives not exact values for first column
if size(x,1)<size(x,2)
    x=x';
end;
if size(x,2)>1
    x=x(:,1);
end;

i=0;
while i<numel(x)
i=i+1;
ind=find(x(:,1)==x(i,1));
table(i,1)=x(i,1);
table(i,2)=numel(ind);
% if table(i,2)>1
    x(ind(2:end),:)=[];
% end;
end
table=sortrows(table,1);