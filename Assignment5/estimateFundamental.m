function bestF = estimateFundamental(match1, match2)
F = zeros(9,1);
bestcount = 0;

iterations = 50;
threshold  = 10;

for i=1:iterations
   % Take initial seed
   perm = randperm(size(match1,2));
   seed = perm(1:4);
   
   % Estimate F
   % Estimate A
   A = getA(match1(:,seed), match2(:,seed));
   [~,~,Vt] = svd(A);   
   F = Vt(:,9);
   F = reshape(F,3,3)';
   
   % Find inliers
   match2est = F*match1;
   estimates = abs(diag(match2est' * match2))';
   seed = find(estimates<threshold);

   % Use inliers to re-estimate F
   A = getA(match1(:,seed), match2(:,seed));
   [~,~,Vt] = svd(A);   
   F = Vt(:,9);
   F = reshape(F,3,3)';
   
   % Find inliers
   match2est = F*match1;
   estimates = abs(diag(match2est' * match2))';
   inliers = find(estimates<threshold);
   
   % if inlier count< best sofar, use new F
   if size(inliers,2)>bestcount
      bestcount=size(inliers,2);
      bestF = reshape(F,3,3)';       
   end
end
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