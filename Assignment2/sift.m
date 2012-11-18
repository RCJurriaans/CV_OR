function [f,d] = sift(im, r,c,s)
fc = [c; r; 2.*s+1; zeros(size(s))];
[f,d] = vl_sift(im,'frames',fc, 'orientations') ;

end