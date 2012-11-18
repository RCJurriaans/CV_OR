function [match1, match2] = findMatches(im1,im2,threshold)
% Finds matching SIFT descriptors at Harris corner points in two images.

% Find features and make descriptor of image 1
[r1,c1,s1] = harris_laplace(im1);
[f1,d1] = sift(single(im1),r1,c1, s1);

% Find features and make descriptor of image 1
[r2,c2,s2] = harris_laplace(im2);
[f2,d2] = sift(single(im2),r2,c2, s2);

% Show images with scatter plot on each image for the features
% Note: Images must be same size
figure;
imshow([im1,im2]);
hold on;
scatter(f1(1,:), f1(2,:), f1(3,:), [1,1,0]);
hold on;
scatter(size(im1,2)+f2(1,:), f2(2,:), f2(3,:), [1,1,0]);
drawnow;

% Create two arrays containing the points location in both images
match1 = [];
match2 = [];

matches = vl_ubcmatch(d1, d2);
match1 = f1(:,matches(1,:));
match2 = f2(:,matches(2,:));

line([match1(1,:);size(im1,2)+match2(1,:)],[match1(2,:);match2(2,:)]);
drawnow;

% For-loops are horrible, but matrix operations can run out of memory
%fn2found = [];
% for fn1=1:size(d1,2)
%     bestmatch = [0 0];
%     bestdis = Inf;
%     %secbestmatch = [0 0];
%     secbestdis = Inf;
%     for fn2=1:size(d2,2)
%         desc1 = d1(:,fn1);
%         desc2 = d2(:,fn2);
%         dif = sqrt(sum((desc1-desc2).^2));
%         
%         % 
%         if dif<threshold
%             if secbestdis>dif
%                 if bestdis>dif
%                     secbestdis=bestdis;
%                     bestdis=dif;
%                     bestmatch=[fn1 fn2];
%                 else
%                     secbestdis = dif;
%                 end
%             end
%         end
%     end
% 
%     % Lowe, D. G., “Distinctive Image Features from Scale-Invariant
%     % Keypoints”
%     % Reject matches where the distance ratio is greater than 0.8
%     if (bestdis/secbestdis)<0.8
%         crtf1 = f1(:,bestmatch(1));
%         crtf2 = f2(:,bestmatch(2));
%         line([crtf1(1);size(im1,2)+crtf2(1)], [crtf1(2);crtf2(2)]);
%         match1 = [match1, crtf1];
%         match2 = [match2, crtf2];
%         drawnow;
%     end
%     
%     
%     
%     
% end

end
