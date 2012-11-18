function H = ransac(match1, match2)
% Implementation of ransac to calculate homography
% Uses linear least squares solution

% Parameters of RANSAC
% d is the minimum required amount of inliers for a model
iterations = 100;
d = max(4,floor(0.5*size(match1,2)));
threshold = 15;

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
    H = [((A'*A) \ A'*nx2')';...
         ((A'*A) \ A'*ny2')';...
         ((A'*A) \ A'*ones(size(ny2))')'];
    
    % Find all inliers below theshold
    error = sum(((H*[x;y;ones(size(y))]) - [nx;ny;ones(size(y))]).^2);
    inlierind = find(error<threshold);
    if(size(inlierind,2)>d)
        inliers = [x;y;ones(size(y))];
        inliers = inliers(:,inlierind);
        
        outputinliers = [nx; ny; ones(size(ny))];
        outputinliers = outputinliers(:,inlierind);
        
        % Refit LQ
        A = inliers';
        H = [((A'*A) \ A'*outputinliers(1,:)')';...
             ((A'*A) \ A'*outputinliers(2,:)')';...
             ((A'*A) \ A'*ones(1,size(outputinliers,2))')'];
        
        % Find new inliers below threshold
        error = sum(((H*[x;y;ones(size(y))]) - [nx;ny;ones(size(y))]).^2);
        inlierind = find(error<threshold);
        inliers = [x;y;ones(size(y))];
        inliers = inliers(:,inlierind);
        outputinliers = [nx; ny; ones(size(ny))];
        outputinliers = outputinliers(:,inlierind);
        
        % Calculate error
        error = (sum(sum(((H*inliers) - outputinliers).^2)))/(size(inlierind,2)/size(match1,2));
        if minerror>error
            bestH = H;
            minerror = error;
            
        end
    end
end
H = bestH;
end