function [bestF bestinliers] = estimateFundamental(match1, match2)

bestcount = 0;
bestinliers = [];

iterations = 50;
% We need a better value for this
threshold  = 0.001;
P=8;

i=0;
while i<iterations
    % Take initial seed
    perm = randperm(size(match1,2));
    seed = perm(1:P);
    
    % Estimate F
    A = getA(match1(:,seed), match2(:,seed));
    [~,~,Vt] = svd(A);
    F = Vt(:,size(Vt,2));
    F = reshape(F,3,3);  
    
    % Find inliers using Sampson distance
    numer = (diag(match2' * (F*match1))').^2;
    Fm1 = F*match1;
    Fm2 = F'*match2;
    denom = sum([Fm1(1:2,:);Fm2(1:2,:)].^2);
    sd = numer./denom;
    seed = find(sd<threshold);
    
    % Use inliers to re-estimate F
    A = getA(match1(:,seed), match2(:,seed));
    [~,~,Vt] = svd(A);
    F = Vt(:,size(Vt,2));
    F = reshape(F,3,3);
    
    % Find inliers
    numer = (diag(match2' * (F*match1))').^2;
    Fm1 = F*match1;
    Fm2 = F'*match2;
    denom = sum([Fm1(1:2,:);Fm2(1:2,:)].^2);
    sd = numer./denom;
    inliers = find(sd<threshold);
    
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
    iterations = ceil( log(eps)/log(1-q));
    
    i = i+1;
    
end

disp(strcat(int2str(iterations), ' iterations used to estimate F'));

end

function A = getA(match1, match2)
A = [match1(1,:).*match2(1,:);...
     match1(1,:).*match2(2,:);...
     match1(1,:)             ;...
     match1(2,:).*match2(1,:);...
     match1(2,:).*match2(2,:);...
     match1(2,:)             ;...
     match2(1,:);...
     match2(2,:);...
     ones(1,size(match1,2))     ]';
end