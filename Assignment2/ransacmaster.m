% Master file to make mosaic between two images
% Finds matches and uses RANSAC to compute homography matrix
% Mosaic images using homography
im1 = im2double(rgb2gray(imread('b.jpg')));
im2 = im2double(rgb2gray(imread('c.jpg')));

%im1 = im2double(rgb2gray(imread('landscape-a.jpg')));
%im2 = im2double(rgb2gray(imread('landscape-b.jpg')));

close all;
[match1, match2] = findMatches(im1,im2,500);
H = ransac(match1, match2);
mosaic(im1,im2,H);