function [magnitude, orientation] = gradmag(img, sigma)

    G = gaussian(sigma);
    kernel = gaussianDer(G, sigma)
    Gx = conv2(img, kernel, 'same');
    Gy = conv2(img, kernel', 'same');
    
    size(Gx)
    size(Gy)
    size(img)
    
    magnitude = sqrt( Gx .* Gx + Gy .* Gy );
    orientation = zeros(size(Gx,1), size(Gx,2), 2);
    orientation(:,:,1) = Gx;
    orientation(:,:,2) = Gy;
    
    %[Gx, Gy];

end