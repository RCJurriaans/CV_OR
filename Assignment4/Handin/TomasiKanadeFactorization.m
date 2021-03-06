function [M, S] = TomasiKanadeFactorization( D )

    % Decompose measurement matrix
    [U,W,V] = svd(D);
    
    % Compute Motion and Structure matrices
    sqrtW3 = sqrt(W(1:3,1:3));
    M = U(:,1:3) * sqrtW3;
    S = sqrtW3 * V(:,1:3)';
    
    % Plot points (with affine ambiguity)
    figure
    X = S(1,:)';
    Y = S(2,:)';
    Z = S(3,:)';
    scatter3(X,Y,Z, 20, [1 0 0], 'filled');
    
    
    % Deal with affine ambiguity
    % We want to find 3x3 matrix L s.t. A_i L A_i' = I
    % (see slides for interpretation of L and A_i)
    % Set up a system A Lv = I,
    % Where A is a matrix derived from the A_i's, and Lv is a vectorized
    % version of the symmetric matrix L we solve for.
    % Lv = [l11, l12, l13, l22, l23, l33]
    numCams = size(M,1) / 2;
    A = zeros(3*numCams, 6);
    for i = 1:numCams
        a1 = M(i*2-1,:); % First row of A_i
        a2 = M(i*2, :);  % Second row of A_i
        
        % Ensure  |a1| = 1
        A((i-1)*3 + 1, 1) = a1(1) * a1(1);
        A((i-1)*3 + 1, 2) = 2 * a1(1) * a1(2);
        A((i-1)*3 + 1, 3) = 2 * a1(1) * a1(3);
        A((i-1)*3 + 1, 4) = a1(2) * a1(2);
        A((i-1)*3 + 1, 5) = 2 * a1(2) * a1(3);
        A((i-1)*3 + 1, 6) = a1(3) * a1(3);
        
        % Ensure |a2| = 1
        A((i-1)*3 + 2, 1) = a2(1) * a2(1);
        A((i-1)*3 + 2, 2) = 2 * a2(1) * a2(2);
        A((i-1)*3 + 2, 3) = 2 * a2(1) * a2(3);
        A((i-1)*3 + 2, 4) = a2(2) * a2(2);
        A((i-1)*3 + 2, 5) = 2 * a2(2) * a2(3);
        A((i-1)*3 + 2, 6) = a2(3) * a2(3);
        
        % Ensure a1' a2 = 0
        A((i-1)*3 + 3, 1) = a2(1) * a1(1);
        A((i-1)*3 + 3, 2) = a2(1) * a1(2) + a2(2) * a1(1);
        A((i-1)*3 + 3, 3) = a2(1) * a1(3) + a2(3) * a1(1);
        A((i-1)*3 + 3, 4) = a2(2) * a1(2);
        A((i-1)*3 + 3, 5) = a2(2) * a1(3) + a2(3) * a1(2);
        A((i-1)*3 + 3, 6) = a2(3) * a1(3);
        
    end
    
    % Find least-squares solution to the parameters of L
    Lv = pinv(A) * repmat([1 1 0]', numCams, 1);
    
    % De-vectorize; place parameters in a symmetric matrix
    L = zeros(3,3);
    L(1, 1) = Lv(1);
    L(1, 2) = Lv(2);
    L(2, 1) = Lv(2);
    L(1, 3) = Lv(3);
    L(3, 1) = Lv(3);
    L(2, 2) = Lv(4);
    L(2, 3) = Lv(5);
    L(3, 2) = Lv(5);
    L(3, 3) = Lv(6);
    
    % Decompose L into lower triangular matrix C, s.t. C * C' = L
    C = chol(L)';
    
    % Update Motion and Structure matrices
    M = M * C;
    S = inv(C) * S;
    
    % Plot again, now with Euclidean structure
    figure
    X2 = S(1,:)';
    Y2 = S(2,:)';
    Z2 = S(3,:)';
    scatter3(X2, Y2, Z2, 20, [1 0 0], 'filled');
    axis( [-200 200 -200 200 -200 200] )
end

