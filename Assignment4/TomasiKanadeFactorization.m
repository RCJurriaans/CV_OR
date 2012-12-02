function [M, S] = TomasiKanadeFactorization( D )
%

    % Decompose measurement matrix
    [U,W,V] = svd(D);
    
    sqrtW3 = sqrt(W(1:3,1:3));
    M = U(:,1:3) * sqrtW3;
    S = sqrtW3 * V(:,1:3)';
    
    % Deal with affine ambiguity
    %L = inv( M' * M );
    %size(M)
    
    %Acc = zeros(3);
    %for i = 1: (size(M,1) / 2)
    %    A = M(i*2-1:i*2, :)' * M(i*2-1:i*2, :)
    %    if abs(det(A)) > 0.1 
    %        Acc = Acc + inv(A)
    %    end
    %end
    
    %Acc = inv(Acc)
    %L = expm( logm(Acc) / (size(M,1) / 2) )
    
    
    %A = zeros(1.5 * size(M,1), 3); 
    %for i = 1: (size(M,1) / 2)
    %    
    %    Ai = M(i*2-1:i*2,:)
    %    A((i-1) * 3 + 1: i*3, :) = Ai' * Ai
    %end
    %size(A)
    %size(pinv(A))
    %size(repmat( eye(3), 0.5 * size(M,1), 1))
    %pinv( M(1:2, :)) * 
    %L = pinv(A) * repmat( eye(3), 0.5 * size(M,1), 1)
    
    numCams = size(M,1) / 2
    
    A = zeros(3*numCams, 6);
    
    for i = 1: numCams
        a1 = M(i*2-1,:);
        a2 = M(i*2, :);
        
        A((i-1)*3 + 1, 1) = a1(1) * a1(1);
        A((i-1)*3 + 1, 2) = 2 * a1(1) * a1(2);
        A((i-1)*3 + 1, 3) = 2 * a1(1) * a1(3);
        A((i-1)*3 + 1, 4) = a1(2) * a1(2);
        A((i-1)*3 + 1, 5) = 2 * a1(2) * a1(3);
        A((i-1)*3 + 1, 6) = a1(3) * a1(3);
        
        A((i-1)*3 + 2, 1) = a2(1) * a2(1);
        A((i-1)*3 + 2, 2) = 2 * a2(1) * a2(2);
        A((i-1)*3 + 2, 3) = 2 * a2(1) * a2(3);
        A((i-1)*3 + 2, 4) = a2(2) * a2(2);
        A((i-1)*3 + 2, 5) = 2 * a2(2) * a2(3);
        A((i-1)*3 + 2, 6) = a2(3) * a2(3);
        
        A((i-1)*3 + 3, 1) = a2(1) * a1(1);
        A((i-1)*3 + 3, 2) = a2(1) * a1(2) + a2(2) * a1(1);
        A((i-1)*3 + 3, 3) = a2(1) * a1(3) + a2(3) * a1(1);
        A((i-1)*3 + 3, 4) = a2(2) * a1(2);
        A((i-1)*3 + 3, 5) = a2(2) * a1(3) + a2(3) * a1(2);
        A((i-1)*3 + 3, 6) = a2(3) * a1(3);
        
    end
    
    sa = size(A)
    spa = size(pinv(A))
    
    M1 = M(1:2, :)
    
    
    Vc = pinv(A) * repmat([1 1 0]', numCams, 1);
    
    size(Vc)
    
    A * Vc
    
    L = zeros(3,3);
    L(1, 1) = Vc(1);
    L(1, 2) = Vc(2);
    L(2, 1) = Vc(2);
    L(1, 3) = Vc(3);
    L(3, 1) = Vc(3);
    L(2, 2) = Vc(4);
    L(2, 3) = Vc(5);
    L(3, 2) = Vc(5);
    L(3, 3) = Vc(6);
    
    
    C = chol(L)';
    
    
    
    
    % Update Motion and Structure matrices
    M = M * C;
    S = inv(C) * S;
    
    % Plot points
    size(S)
    X = S(1,:)';
    Y = S(2,:)';
    Z = S(3,:)';
    
    
    scatter3(X,Y,Z, 20, [1 0 0], 'filled');
    axis([-50 50 -50 50 -50 50 0 1])
    
    %plot3(X, Y, Z);
    %for i = 1:size(X,2)
    %   plot3(X(1,i), Y(1,i), Z(1,i));
    %   hold on
    %end
    
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

