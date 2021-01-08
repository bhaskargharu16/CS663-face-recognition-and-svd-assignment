function [U,S,V] = MySVD(A)
    [m,n]=size(A);
    left=A*(A');
    right=(A')*A;
    if m>=n
        [L_vec, L_val]=eig(left);
        [d1,L_ind] = sort(diag(L_val),'descend');
        L_val = L_val(L_ind,L_ind);
        L_vec = L_vec(:,L_ind);
        S = L_val(1:m,1:n);
        U=L_vec;
        V=normalize(A'*L_vec(:,1:n),'norm');
        S=sqrt(S);
    else
        [u,s,v]=MySVD(A');
        U=v;
        S=s';
        V=u;
end