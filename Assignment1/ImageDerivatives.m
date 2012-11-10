function F= ImageDerivatives ( img , sigma , type )
   halfSize = floor(1.5 * sigma);
   x = -halfSize:halfSize;
   
   G = gaussian(sigma);  
   kernel = -(((x.^2) - (sigma^2) )./ (sigma^4)) .* G;

switch type
    case 'x'
        F = conv2(img, kernel, 'same');
    case 'y'
        F = conv2(img', kernel, 'same')';
    case 'xx'
        F = conv2(conv2(img, kernel, 'same'),kernel, 'same');
    case 'xy'
        F = conv2(conv2(img, kernel, 'same')',kernel, 'same')';
    case 'yx'
        F = conv2(conv2(img', kernel, 'same')',kernel, 'same');
    case 'yy'
        F = conv2(conv2(img', kernel, 'same'),kernel, 'same')';

end