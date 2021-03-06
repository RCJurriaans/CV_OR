function [r, c] = harris(im, sigma)
% Finds harris corners at integration-scale sigma.
% The row and column of each point is returned in r and c
% We choose the derivative scale automatically as gamma*sigma

gamma = .7; % The derivative-scale is gamma times the integration scale

% Calculate Gaussian Derivatives at derivative-scale
Ix =  ImageDerivatives(im, gamma*sigma, 'x');
Iy =  ImageDerivatives(im, gamma*sigma, 'y');

% Allocate an 3-channel image to hold the 3 parameters for each pixel
M = zeros(size(Ix,1), size(Ix,2), 3);

% Calculate M for each pixel
M(:,:,1) = Ix.^2;
M(:,:,2) = Ix.*Iy;
M(:,:,3) = Iy.^2;

% Smooth M with a gaussian at the integration scale sigma.
M = imfilter(M, fspecial('gaussian', ceil(sigma*6+1), sigma), 'replicate', 'same');

% Compute the cornerness R
trace = M(:,:,1) + M(:,:,3);
det = M(:,:,1) .* M(:,:,3)-M(:,:,2).^2;
R = det - 0.05 .* (trace).^2;

% Set threshold based on max R
threshold = 0.01*max(max(R));

% Find local maxima
% Dilation will alter every pixel except local maxima in a 3x3 square area.
% Also checks if R is above threshold
R = ((R>threshold) & ((imdilate(R, strel('square', 3))==R))) ; %.* sigma;

% Display corners
%figure
%imshow(R,[]);

% Return the coordinates
[r,c] = find(R);

end
