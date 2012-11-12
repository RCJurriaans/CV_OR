function [r,c] = harris(im)
threshold=0.0000001;
R = cornerness(im,3);


R = (R>threshold) & ((imdilate(R, strel('square', 3))-R)==0);
[r,c] = find(R);

end