function A=ConstantDiffAndIntSmooth(A,N)
i=1;
polarity=1;
while i<numel(A)-2*N
while i+N<numel(A)
        n=N;
        while (i+n)<numel(A)&&polarity*(sum(A(i:i+n))-(n+1)*A(i))<=0
            n=n+1;
        end;
        if (i+n)==numel(A)
            break;
        end;
        a=2*(sum(A(i:i+n))-(n+1)*A(i))/(n*(n+1));
        for ii=1:n
            A(i+ii)=A(i)+ii*a;
        end;
        i=i+1;
end;
polarity=-polarity;
end;