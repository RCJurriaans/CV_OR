function [match1, match2] = findMatches(im1,im2,threshold)
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
scatter(f1(1,:), f1(2,:), f1(3,:)*15, [1,1,0]);
hold on;
scatter(size(im1,2)+f2(1,:), f2(2,:), f2(3,:)*15, [1,1,0]);
drawnow;

% Create two arrays containing the points location in both images
match1 = [];
match2 = [];
% For-loops are horrible, but matrix operations can run out of memory
%fn2found = [];
for fn1=1:size(d1,2)
    fn1found = 0;
    for fn2=1:size(d2,2)
        desc1 = d1(:,fn1);
        desc2 = d2(:,fn2);
        dif = sqrt(sum((desc1-desc2).^2));
        
        % If difference is lower than the threshold, it's a match
        if dif<threshold && fn1found==0 %&& ~(sum(find(fn2found==fn2)))
            %fn2found = [fn2found fn2];
            crtf1 = f1(:,fn1);
            crtf2 = f2(:,fn2);
            % Draw line from image 1 to image2
            line([crtf1(1);size(im1,2)+crtf2(1)], [crtf1(2);crtf2(2)]);
            match1 = [match1, crtf1];
            match2 = [match2, crtf2];
            %fn1found=1;
            break;
            
        end
    end
    drawnow;
end



end

% This gives an out-of-memory error for low sigma
% d1rep = repmat(d1,1,size(d2,2));
% d2rep = reshape(repmat(d2,size(d1,2),1), size(d2,1), size(d1,2)*size(d2,2));
% dif = sum((d1rep-d2rep).^2);
% dif = (dif<threshold);
%
% locd1 = mod(find(dif)-1, size(d1,2))+1;
%
% locd2 = ceil(find(dif)/size(d2,2));
%
% size(f1(:,locd1))
% size(f2(:,locd2))