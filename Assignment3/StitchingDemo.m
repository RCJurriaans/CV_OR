% Image Stitching Demo
% Assignment 3.2

% Load left and right image
im1 = im2double(rgb2gray(imread('left.jpg')));
im2 = im2double(rgb2gray(imread('right.jpg')));

% Do Mosaic
imgout = mosaic(im1,im2);

% Show stitched image
figure;
imshow(imgout);