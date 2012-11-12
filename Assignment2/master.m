%im = im2double(rgb2gray(imread('landscape-a.jpg')));
%im = im2double(rgb2gray(imread('landscape-b.jpg')));
im = im2double((imread('cameraman1.png')));
[r,c,s] = harris(im);
figure;
imshow(im,[]);
hold on;
scatter(c,r, s.*10, [.5 .5 0])



