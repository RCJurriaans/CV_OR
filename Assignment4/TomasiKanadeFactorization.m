function [M, S] = TomasiKanadeFactorization( D )
%

    % 
    [U,W,V] = svd(D);
    
    sqrtW3 = sqrt(W(1:3,1:3));
    M = U(:,1:3) * sqrtW;
    S = sqrtW * V(:,1:3).T;
    
    % Deal with affine ambiguity
    L = inv( tranpose(M) * M );
    C = chol(L)';
    
    M = M * C;
    S = inv(C) * M;
    
    X = S(1,:)';
    Y = S(2,:)';
    Z = S(3,:)';
    scatter3(X,Y,Z,20, [1 0 0])
    
    
end

