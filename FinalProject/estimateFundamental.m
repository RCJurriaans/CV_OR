function [bestF bestinliers] = estimateFundamental(match1, match2)

% Set in homogenous coordinates
match1 = [match1;ones(1,size(match1,2))];
match2 = [match2;ones(1,size(match2,2))];

% Initial values
bestcount = 0;
bestinliers = [];

% RANSAC parameters
iterations = 50;
miniter = iterations;
threshold  = 200;
P=8;

i=0;
%h = waitbar(0,'Initializing waitbar...');
while i<iterations
    
    % Take initial seed
    perm = randperm(size(match1,2));
    seed = perm(1:P);
    
    % Estimate F
    [f1n,T1] = normalize(match1(1:2, seed));
    [f2n,T2] = normalize(match2(1:2, seed));
    A = getA(f1n, f2n);
    F = computeF(A,T1,T2);
    
    % Find inliers using Sampson distance
    seed = computeInliers(F,match1,match2,threshold);
    
    % We need atleast 8 inliers to estimate F
    if size(seed,2)>=8
        % Use previously found inliers
        [f1n,T1] = normalize(match1(1:2, seed));
        [f2n,T2] = normalize(match2(1:2, seed));
        
        % Use inliers to re-estimate F
        A = getA(f1n, f2n);
        F = computeF(A,T1,T2);
        
        % Find final set of inliers
        inliers = computeInliers(F,match1,match2,threshold);
        
        % if inlier count< best sofar, use new F
        if size(inliers,2)>bestcount
            bestcount=size(inliers,2);
            bestF = F;
            bestinliers=inliers;
        end
        
        % Calculate how many iterations we need to run
        eps = 0.001;
        N1 = bestcount;
        N = size(match1,2);
        k=P;
        q = (N1/N)^k;
        % To prevent special cases, always run atleast a couple of times
        iterations = max(miniter,ceil( log(eps)/log(1-q)));
        
    end
    i = i+1;
   % waitbar(i/iterations,h,sprintf('at %d of %d iterations',[i,iterations]))
    
end

disp(strcat(int2str(iterations), ' iterations used to estimate F'));
%close(h);
pause(0.001);
disp(strcat(int2str(size(bestinliers,2)), ' inliers found'));
end

function F = computeF(A,T1,T2)
% SVD to get Least Square solution for Af=0
[~,~,Vt] = svd(A);
F = Vt(:,size(Vt,2));
F = reshape(F,3,3)';

% Make sure F is singular
F = singularizeF(F);

% Use transformation matrices around F
F = T2' * F' * T1;

% Make sure that norm(F)=1
F= F/norm(F);
end

function inliers = computeInliers(F,match1,match2,threshold)
% Calculate Sampson distance for each point
numer = (diag(match2' * (F*match1))').^2;
Fm1 = F*match1;
Fm2 = F'*match2;
denom = sum([Fm1(1:2,:);Fm2(1:2,:)].^2);
sd = numer./denom;

% Return inliers for which sd is smaller than threshold
inliers = find(sd<threshold);

end

function A = getA(x1, x2)
A = [x1(1,:)    .*  x2(1,:) ;...
     x1(1,:)    .*  x2(2,:) ;...
     x1(1,:)                ;...
     x1(2,:)    .*  x2(1,:) ;...
     x1(2,:)    .*  x2(2,:) ;...
     x1(2,:)                ;...
                    x2(1,:) ;...
                    x2(2,:) ;...
    ones(1,size(x1,2))     ]';
end