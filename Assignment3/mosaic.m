function imgout = mosaic(varargin)

imtarget = varargin{1};

w = size(imtarget,2);
h = size(imtarget,1);

corners = [1 1 1; w 1 1; 1 h 1; w h 1]';

A = zeros(3,3,nargin);
A(:,:,1) = eye(3);
accA = A;

% get transformed corners of all images
for i=2:nargin
    % Load next image
    imnew = varargin{i};
    
    % Get transformation A from new image to target
    x = imageAlign(imnew, varargin{i-1});
    A(:,:,i) = [reshape(x(1:4),2,2), x(5:6); 0 0 1];
    accA(:,:,i) = accA(:,:,i-1)*A(:,:,i);
    w = size(imnew,2);
    h = size(imnew,1);
    
    corners = [corners accA(:,:,i)*[1 1 1; w 1 1; 1 h 1; w h 1]'];
end

% Find size of output image
minx = min(corners(1,:));
maxx = max(corners(1,:));
miny = min(corners(2,:));
maxy = max(corners(2,:));

% Offset translation
%T = [1 0 1-minx; 0 1 1-miny; 0 0 1];
tx= floor(1-minx)
ty= floor(1-miny)

% Output image
imgout = zeros(maxy-miny, maxx-minx);

for i=1:nargin
    tform = maketform('affine', inv(accA(:,:,i))' );
    [newtimg, xdata, ydata] = imtransform(varargin{i}, tform, 'bicubic', 'UData', [tx, tx+size(varargin{i},2)], 'VData', [ty, ty+size(varargin{i},1)]);
    
end

end
