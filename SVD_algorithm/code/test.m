function [] = test()
    tol = 0.000001;
    total=0;
    wrong=0;
    for i=1:50
        for j=1:50
            for k=10:20
                A=k*rand(i,j);
                [U,S,V]=MySVD(A);
                total=total+1;
                n0=sqrt(sum(sum((A-U*S*V').^2)));
                if n0 > tol
                    wrong=wrong+1;
                end
            end
        end
    end
    disp(wrong);
    disp(total);
end