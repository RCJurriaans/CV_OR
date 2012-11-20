function bestx = ransacA(match1, match2)

% This should be set automatically
iterations = 50;


threshold = 10;
P = 3;
mc = size(match1,2);

bestinliers = 0;
bestx = zeros(6,1);

for i=1:iterations;
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
    
    
    eps = 0.001;
    N1 = bestinliers;
    N = size(match1,2);
    k=3;
    q = (N1/N)^k;
    % N1 is the largest set on inliers so far
    % N is the total number of data-points = size(match1,2)
    % k is the number of data-points that are needed
    iterations = ceil( log(eps)/log(1-q))
    end
end

%m = reshape(bestx(1:4),2,2);
%t = bestx(5:6);



end