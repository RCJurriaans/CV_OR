function F= ImageDerivatives ( img , sigma , type )
   halfSize = ceil(3 * sigma);
   x = -halfSize:halfSize;
   G = gaussian(sigma);  
   
switch type
    case {'x', 'y', 'xy','yx'}
        Gd = gaussianDer(G, sigma);     
    case {'xx', 'yy'}
        Gdd = ( ( -(sigma^2) + (x.^2) ) ./ (sigma^4) ) .* G;
end

switch type
    case 'x'
        F = imfilter(img, Gd, 'replicate', 'same'); % conv2(img, Gd, 'same');        
    case 'y'
        F = imfilter(img, Gd', 'replicate', 'same'); %conv2(img, Gd', 'same');
    case 'xx'
        F = imfilter(img, Gdd, 'replicate', 'same'); %conv2(img, Gdd, 'same');
    case {'xy', 'yx'}
        F = imfilter(img, Gd, 'replicate', 'same'); %conv2(Gd, Gd, img, 'same');
        F = imfilter(F, Gd', 'replicate', 'same');
    case 'yy'
        F = imfilter(img, Gdd', 'replicate', 'same'); %conv2(img, Gdd', 'same');
    otherwise
        error('Unknown type: type must be in {x, y, xx, xy, yx, yy}');
end
end