function R = cornerness(im, sigma)

gamma = 2;

Ix =  ImageDerivatives(im, sigma, 'x');
Iy =  ImageDerivatives(im, sigma, 'y');
M = zeros(size(Ix,1), size(Ix,2), 3);

M(:,:,1) = Ix.^2;
M(:,:,2) = Ix.*Iy;
M(:,:,3) = Iy.^2;

M = imfilter(M, fspecial('gaussian', ceil((gamma^2)*sigma*6+1), sigma), 'same');

trace = M(:,:,1)+M(:,:,3);
det = M(:,:,1).*M(:,:,3)-M(:,:,2).^2;
R = det - 0.05.*(trace).^2;
end