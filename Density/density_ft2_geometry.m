function figFT2=density_ft2_geometry
theta=linspace(0,2*pi,360);

r=0.078;

h=findobj('Type','figure','Tag','FT2fig');
if ~isempty(h)&&ishandle(h)
    figFT2=h;
else   
    figFT2=figure('Tag','FT2fig');
end;

h=findobj(figFT2,'Type','axes');
if isempty(h)||~ishandle(h)
    figure(figFT2);
     axesFT2=axes;
else
    axesFT2=h;
end;

h=findobj('Tag','FT2limiter');
if isempty(h)||~ishandle(h)
    hlimiter=plot(axesFT2,cos(theta)*r,sin(theta)*r,'r','LineWidth',3,'Tag','FT2limiter');
end;

grid on; hold on;
axis equal;