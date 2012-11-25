% Finds the matches between the two landscape images
im1 = im2double(rgb2gray(imread('landscape-a.jpg')));
im2 = im2double(rgb2gray(imread('landscape-b.jpg')));

[match1, match2] = findMatches(im1,im2,250);


