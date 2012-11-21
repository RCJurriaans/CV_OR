% Image Stitching Demo
% Assignment 3.2

% Load left and right image
im1 = im2double(rgb2gray(imread('left.jpg')));
im2 = im2double(rgb2gray(imread('right.jpg')));

%im1 = im2double(rgb2gray(imread('b.jpg')));
%im2 = im2double(rgb2gray(imread('c.jpg')));

%im1 = im2double((imread('boat/img1.pgm')));
%im2 = im2double((imread('boat/img2.pgm')));
%im3 = im2double((imread('boat/img3.pgm')));
%im4 = im2double((imread('boat/img4.pgm')));

% Do Mosaic
imgout = mosaic(im1,im2);

% Show stitched image
figure;
imshow(imgout);