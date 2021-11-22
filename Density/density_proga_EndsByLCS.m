function Ph=density_proga_EndsByLCS(Ph,shiftX,shiftY,triang,elon)
[Rlcs,ld,xmax,xmin,ymax,ymin]=density_rlcs1(shiftX,shiftY,triang,elon,false);
Ph=sortrows(Ph);
if Ph(1,2)~=0
    Ph=[[xmin 0];Ph];
end;
if Ph(end,2)~=0
    Ph(end+1,:)=[xmax 0];
end;