function bestx = ransacH(match1, match2)

% This is automatically changed during runtime
% based on inlier-count. Set min-iterations to circumvent corner-cases
miniterations = 5;
iterations = 150;

% Threshold is 10 pixels
threshold = 10;

% The model needs atleast 4 points (8 equations) to
% form a homography matrix
P = 8;


mc = size(match1,2);
bestinliers = 0;
bestx = zeros(8,1);

for i=1:iterations;
    % Take P matches
    perm = randperm(size(match1,2));
    seed = perm(1:P);
    
    % Fit model
    b = [match2(1,seed) match2(2,seed)];
    %A = [match1(1:2,seed)', zeros(P , 2) ones(P, 1) ,zeros(P ,1);...
    %    zeros(P , 2), match1(1:2,seed)', zeros(P ,1), ones(P, 1)];
    mc = size(seed,2);
    x1 = match1(1,seed)';
    x2 = match2(1,seed)';
    y1 = match1(2,seed)';
    y2 = match2(2,seed)';

    A = [-x1, -y1, -ones(1, mc)', zeros(1, mc)', zeros(1, mc)', zeros(1, mc)', ...
         x2.*x1, x2.*y1, x2;...
        zeros(1, mc)', zeros(1, mc)', zeros(1, mc)', -match1(1,seed)', -match1(2,seed)', -ones(1, mc)',...
        y2.*match1(1,seed)', match2(2,seed)'.*match1(2,seed)',...
         match2(2,seed)'];                 
    %newx = pinv(A)* b';
    [~,~,V] = svd(A);
    newx = V(:,size(V,2));
    
    % Determine inliers
    H = [ newx(1) newx(2) newx(3);...
          newx(4) newx(5) newx(6);...
          newx(7) newx(8) newx(9)];
    b2 = H*[match1 ;ones(1,size(match1,2))];
    b2(1,:) = b2(1,:)./b2(3,:);
    b2(2,:) = b2(2,:)./b2(3,:);
    b2(3,:) = b2(3,:)./b2(3,:);
    inliers = find(sqrt(sum((match2-b2(1:2,:)).^2)) <threshold); 

    % Refit model
    seed = inliers;
    mc = size(seed,2);
    x1 = match1(1,seed)';
    x2 = match2(1,seed)';
    y1 = match1(2,seed)';
    y2 = match2(2,seed)';
    A = [-x1, -y1, -ones(1, mc)', zeros(1, mc)', zeros(1, mc)', zeros(1, mc)', ...
         x2.*x1, x2.*y1, x2;...
        zeros(1, mc)', zeros(1, mc)', zeros(1, mc)', -match1(1,seed)', -match1(2,seed)', -ones(1, mc)',...
        match2(2,seed)'.*match1(1,seed)', match2(2,seed)'.*match1(2,seed)',...
         match2(2,seed)'];                 
    [~,~,V] = svd(A);
    newx = V(:,size(V,2));
    
    % Determine inliers
    H = [ newx(1) newx(2) newx(3);...
          newx(4) newx(5) newx(6);...
          newx(7) newx(8) newx(9)];
    b2 = H*[match1 ;ones(1,size(match1,2))];
    b2(1,:) = b2(1,:)./b2(3,:);
    b2(2,:) = b2(2,:)./b2(3,:);
    b2(3,:) = b2(3,:)./b2(3,:);
    inliers = find(sqrt(sum((match2-b2(1:2,:)).^2)) <threshold);
    
    if size(inliers,2)>bestinliers
        bestinliers = size(inliers,2);
        bestx = newx;
        
        
        % Within a chance of epsilon, find number of required iterations
        % N1 is the largest set on inliers so far
        % N is the total number of data-points = size(match1,2)
        % k is the number of data-points that are needed
        if i>miniterations
            eps = 0.001;
            N1 = bestinliers;
            N = size(match1,2);
            k=P;
            q = (N1/N)^k;
            
            iterations = ceil( log(eps)/log(1-q));
        end
    end
end



end