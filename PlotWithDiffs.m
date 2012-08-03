function f=PlotWithDiffs(A,f)
if nargin<2
    f=figure;
else
    figure(f);
end;
if size(A,2)==1
    A(:,2)=A;
    A(:,1)=1:size(A,1);
end;
subplot(3,1,1)
    grid on; hold on;
    plot(A(:,1),A(:,2),'.r-');
    h1=gca;
subplot(3,1,2)
    grid on; hold on;
    tD=(A(1:end-1,1)+A(2:end,1))/2;
    plot(tD,diff(A(:,2)),'.b-');
    h2=gca;
subplot(3,1,3)
    grid on; hold on;
    tD2=(tD(1:end-1)+tD(2:end))/2;
    plot(tD2,diff(A(:,2),2),'.k-');
    h3=gca;

linkaxes([h1,h2,h3],'x');
