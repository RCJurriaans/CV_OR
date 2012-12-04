function [bestF bestinliers] = estimateFundamental(match1, match2)

match1 = [match1;ones(1,size(match1,2))];
match2 = [match2;ones(1,size(match2,2))];

bestcount = 0;
bestinliers = [];

iterations = 10;
miniter = iterations;
% We need a better value for this
threshold  = 10;
P=8;

i=0;


h = waitbar(0,'Initializing waitbar...');
while i<iterations
    waitbar(i/iterations,h,sprintf('at %d of %d iterations',[i,iterations]))
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
    
    if size(seed,2)>=8
        % Use inliers to re-estimate F
        [f1n,T1] = normalize(match1(1:2, seed));
        [f2n,T2] = normalize(match2(1:2, seed));
        A = getA(f1n, f2n);
        F = computeF(A,T1,T2);
        
        % Find inliers
        inliers = computeInliers(F,match1,match2,threshold);
        
        % if inlier count< best sofar, use new F
        if size(inliers,2)>bestcount
            bestcount=size(inliers,2);
            bestF = F;
            bestinliers=inliers;
        end
        
        % Within a chance of epsilon, find number of required iterations
        % N1 is the largest set on inliers so far
        % N is the total number of data-points = size(match1,2)
        % k is the number of data-points that are needed
        eps = 0.001;
        N1 = bestcount;
        N = size(match1,2);
        k=P;
        q = (N1/N)^k;
        iterations = max(miniter,ceil( log(eps)/log(1-q)));
        
    end
    i = i+1;
    
end

disp(strcat(int2str(iterations), ' iterations used to estimate F'));
close(h);
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