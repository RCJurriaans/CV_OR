function [x, match1, match2] = imageAlign(im1, im2)
% Align two images using sift matches
% Use RANSAC to get the affine transformation

% Sift from vl_feat 0.9.16
[f1, d1] = vl_sift(single(im1));
[f2, d2] = vl_sift(single(im2));
[matches] = vl_ubcmatch(d1,d2);

% Find affine transformation
x = ransacA(f1(1:2,matches(1,:)), f2(1:2,matches(2,:)));

% Return matches
match1 = f1(1:2,matches(1,:));
match2 = f2(1:2,matches(2,:));
end