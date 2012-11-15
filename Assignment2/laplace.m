function [ L ] = laplace( im, sigma )
% Calculates the scale-normalized laplacian of im.

    %halfSize = ceil(3 * sigma);
    %x = -halfSize:halfSize;
    %G = gaussian(sigma);  
    %Gdd = sigma^2 * ( ( -(sigma^2) + (x.^2) ) ./ (sigma^4) ) .* G;
    
    
    
    L = imfilter(im, sigma^2*fspecial('log', 2*ceil(3*sigma)+1, sigma), 'replicate', 'same');
    %Lyy = conv2(Lxx, Gdd', 'same');
    %imshow(Lxx);
    %figure
    %imshow(Lyy);
    
    %L = Lyy;
    %L = conv2(Gdd, im, 'same') + conv2(Gdd', im, 'same');
end
