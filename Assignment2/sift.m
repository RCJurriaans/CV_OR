function [f,d] = sift(im, r,c,s)
% Create sift descriptors for given corners
% Orientation is computed by vl_sift
fc = [c; r; 2*s+1; zeros(size(s))];
[f,d] = vl_sift(im,'frames',fc, 'orientations') ;
end
