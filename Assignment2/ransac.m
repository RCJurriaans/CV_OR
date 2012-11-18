function H = ransac(match1, match2)
% Implementation of ransac to calculate homography
% Uses linear least squares solution

% Parameters of RANSAC
% d is the minimum required amount of inliers for a model
iterations = 50;
threshold = 22;
d = max(4,floor(0.5*size(match1,2)));

% Initialize H
H = zeros(3);
minerror = Inf;
bestH = H;

x = match1(1,:);
y = match1(2,:);
nx = match2(1,:);
ny = match2(2,:);

onevec = ones(size(x));

for i=1:iterations
    % Draw initial random points
    perm = randperm(size(match1,2));
    seed = perm(:,1:4);
    
    x2 = x(seed);
    y2 = y(seed);
    nx2 = nx(seed);
    ny2 = ny(seed);
    onevec2 = onevec(seed);
    % Fit LQ solution
    A = [x2', y2', onevec2'];
    b = nx2';
    H = ((A'*A) \ A'*b)';
    b = ny2';
    H = [H; ((A'*A) \ A'*b)'];
    b = ones(size(ny2))';
    H = [H; ((A'*A) \ A'*b)'];
    
    % Find all inliers below theshold
    error = sum(((H*[x;y;ones(size(y))]) - [nx;ny;ones(size(y))]).^2);
    inlierind = find(error<threshold);
    if(sum(inlierind)>d)
        inliers = [x;y;ones(size(y))];
        inliers = inliers(:,inlierind);
        
        outputinliers = [nx; ny; ones(size(ny))];
        outputinliers = outputinliers(:,inlierind);
        
        % Refit LQ
        A = inliers';
        b = outputinliers(1,:)';
        H = ((A'*A) \ A'*b)';
        b = outputinliers(2,:)';
        H = [H; ((A'*A) \ A'*b)'];
        b = ones(1,size(outputinliers,2))';
        H = [H; ((A'*A) \ A'*b)'];
        
        % Find new inliers below threshold
        error = sum(((H*[x;y;ones(size(y))]) - [nx;ny;ones(size(y))]).^2);
        inlierind = find(error<threshold);
        inliers = [x;y;ones(size(y))];
        inliers = inliers(:,inlierind);
        outputinliers = [nx; ny; ones(size(ny))];
        outputinliers = outputinliers(:,inlierind);
        
        % Calculate error
        error = (sum(sum(((H*inliers) - outputinliers).^2)));
        if minerror>error
            bestH = H;
            minerror = error;
            
        end
    end
end
H = bestH;
end