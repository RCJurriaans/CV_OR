function [magnitude, orientation] = gradmag(img, sigma)

    G = gaussian(sigma);
    kernel = gaussianDer(G, sigma);
    Gx = conv2(img, kernel, 'same');
    Gy = conv2(img, kernel', 'same');
    
    magnitude = sqrt( Gx .* Gx + Gy .* Gy );
    orientation = atan2(Gx,Gy);
    
    %orientation = zeros(size(Gx,1), size(Gx,2), 2);
    %orientation(:,:,1) = Gx;
    %orientation(:,:,2) = Gy;
    %figure;
    %quiver(flipdim(Gx,1), flipdim(Gy,1));

end