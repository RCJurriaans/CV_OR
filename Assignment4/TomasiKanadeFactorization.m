function [M, S] = TomasiKanadeFactorization( D, colors )
%

    % Decompose measurement matrix
    [U,W,V] = svd(D);
    
    sqrtW3 = sqrt(W(1:3,1:3));
    M = U(:,1:3) * sqrtW3;
    S = sqrtW3 * V(:,1:3)';
    
    % Deal with affine ambiguity
    L = inv( M' * M );
    C = chol(L)';
    
    % Update Motion and Structure matrices
    M = M * C;
    S = inv(C) * S;
    
    % Plot points
    size(S)
    X = S(1,:)';
    Y = S(2,:)';
    Z = S(3,:)';
    scatter3(X,Y,Z,20, colors, 'filled')
    
%    L
%    C
%    M' * M
%    
%    M' * M
%    
%    figure 
%    X = S(1,:)';
%    Y = S(2,:)';
%    Z = S(3,:)';
%    scatter3(X,Y,Z,20, colors, 'filled')
   
end

