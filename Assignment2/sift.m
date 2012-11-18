function [f,d] = sift(im, r,c,s)
% Create sift descriptors for given corners
% Orientation is computed by vl_sift
fc = [c; r; s; zeros(size(s))];
[f,d] = vl_sift(im,'frames',fc, 'orientations') ;
end
