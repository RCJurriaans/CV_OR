function bestx = ransacA(match1, match2)
% Ransac to find affine transformation
% Input is a set of point pairs

% Iterations is automatically changed during runtime
% based on inlier-count. Set min-iterations to circumvent corner-cases
iterations = 50;
miniterations=5;

% Threshold is 10 pixels
threshold = 10;

% The model needs atleast 3 point pairs (6 equations) to
% form an affine transformation
P = 3;

%
mc = size(match1,2);
bestinliers = 0;
bestx = zeros(6,1);
i=1;

while ((i<iterations) || (i<miniterations))
    % Take P matches
    perm = randperm(size(match1,2));
    seed = perm(1:P);
    
    % Fit model
    b = [match2(1,seed) match2(2,seed)];
    A = [match1(1:2,seed)', zeros(P , 2) ones(P, 1) ,zeros(P ,1);...
        zeros(P , 2), match1(1:2,seed)', zeros(P ,1), ones(P, 1)];
    newx = pinv(A)* b';
    
    % Determine inliers
    A = [match1', zeros(mc , 2) ones(mc, 1) ,zeros(mc ,1);...
        zeros(mc , 2), match1', zeros(mc ,1), ones(mc, 1)];
    b2 = A*newx;
    b2 = reshape(b2, size(match2,2), 2)';
    inliers = find(sqrt(sum((match2-b2).^2)) <threshold); % TODO
    
    % Refit model
    ic = size(inliers,2);
    A = [match1(:,inliers)', zeros(ic , 2), ones(ic, 1) , zeros(ic ,1);...
        zeros(ic , 2), match1(:,inliers)', zeros(ic ,1), ones(ic, 1)];
    b = [match2(1,inliers) match2(2,inliers)];
    newx = pinv(A)* b';
    
    % Determine final inliers, if better than what we had save x
    mc = size(match1,2);
    A = [match1', zeros(mc , 2) ones(mc, 1) ,zeros(mc ,1);...
        zeros(mc , 2), match1', zeros(mc ,1), ones(mc, 1)];
    b2 = A*newx;
    b2 = reshape(b2, size(match2,2), 2)';
    inliers = find(sqrt(sum((match2-b2).^2)) <threshold);
    
    if size(inliers,2)>bestinliers
        bestinliers = size(inliers,2);
        bestx = newx;
        
        % Within a chance of epsilon, find number of required iterations
        % N1 is the largest set on inliers so far
        % N is the total number of data-points = size(match1,2)
        % k is the number of data-points that are needed
        eps = 0.001;
        N1 = bestinliers;
        N = size(match1,2);
        k=3;
        q = (N1/N)^k;
        iterations = ceil( log(eps)/log(1-q));
    end
    
    i = i+1;
end
end
