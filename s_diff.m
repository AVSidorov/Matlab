function difp=s_diff(A,B);
NA=size(A,1);
for i=1:NA
        difp=sqrt(sum((A-B).^2)/NA);
end;
