function [f,d] = sift(im, r,c,s)
fc = [c; r; s; zeros(size(s))];
[f,d] = vl_sift(im,'frames',fc, 'orientations') ;

end