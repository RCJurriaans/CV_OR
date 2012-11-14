function [r, c] = harris(im, sigma)

gamma = 0.7;
threshold = 0.000005;

Ix =  ImageDerivatives(im, gamma*sigma, 'x');
Iy =  ImageDerivatives(im, gamma*sigma, 'y');
M = zeros(size(Ix,1), size(Ix,2), 3);

M(:,:,1) = Ix.^2;
M(:,:,2) = Ix.*Iy;
M(:,:,3) = Iy.^2;

M = imfilter(M, fspecial('gaussian', ceil(sigma*6+1), sigma), 'same');

trace = M(:,:,1) + M(:,:,3);
det = M(:,:,1) .* M(:,:,3)-M(:,:,2).^2;
R = det - 0.05 .* (trace).^2;

% Find local maxima
R = ((R>threshold) & ((imdilate(R, strel('square', 3))==R))) ; %.* sigma;

% TODO: set threshold automatically: 0.2*maxR


figure
imshow(R,[]);

% Return the coordinates
[r,c] = find(R);

end
