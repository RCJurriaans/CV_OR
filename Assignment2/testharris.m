function [r,c,s] = testharris(im)
sigma = 5;
R = cornerness(im,sigma);
threshold = 0.01*max(max(R));
R = ((R>threshold) & ((imdilate(R, strel('square', 3))==R))).*sigma;
[r,c,s] = find(R);

end