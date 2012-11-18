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

        F = imfilter(img, Gd, 'same', 'replicate');
    case 'y'
        F = imfilter(img, Gd', 'same', 'replicate');
    case 'xx'
        F = imfilter(img, Gdd, 'same', 'replicate');
    case {'xy', 'yx'}
        F = imfilter(Gd, Gd, img, 'same', 'replicate');
    case 'yy'
        F = imfilter(img, Gdd', 'same', 'replicate');
    otherwise
        error('Unknown type: type must be in {x, y, xx, xy, yx, yy}');
end
end
