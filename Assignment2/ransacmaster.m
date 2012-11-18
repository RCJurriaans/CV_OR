%im1 = im2double(rgb2gray(imread('b.jpg')));
%im2 = im2double(rgb2gray(imread('c.jpg')));
%im1 = im2double((imread('ah2.jpg')));
%im2 = im2double((imread('ah1.jpg')));
im1 = im2double(rgb2gray(imread('landscape-a.jpg')));
im2 = im2double(rgb2gray(imread('landscape-b.jpg')));


close all;
[match1, match2] = findMatches(im1,im2,30);
num_matches = size(match1,2)
H = ransac(match1, match2);
mosaic(im1,im2,H);