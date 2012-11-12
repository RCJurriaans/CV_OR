function M = calculateM(im,sigma)

Ix =  ImageDerivatives(im, sigma, 'x');
Iy =  ImageDerivatives(im, sigma, 'y');

M = zeros(size(Ix,1), size(Ix,2), 3);

M(:,:,1) = Ix.^2;
M(:,:,3) = Iy.^2;

end
