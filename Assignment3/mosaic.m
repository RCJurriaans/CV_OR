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
    
    A(:,:,i) = [[x(1) x(2) x(5); x(3) x(4) x(6)] ; 0 0 1];
    
    accA(:,:,i) = A(:,:,i)*accA(:,:,i-1);
    w = size(imnew,2);
    h = size(imnew,1);
    
    corners = [corners (accA(:,:,i))*[1 1 1; w 1 1; 1 h 1; w h 1]'];
end

% Find size of output image
minx = floor(min(corners(1,:)));
maxx = ceil(max(corners(1,:)));
miny = floor(min(corners(2,:)));
maxy = ceil(max(corners(2,:)));

% Offset translation\verb+nanmean+,
%T = [1 0 1-minx; 0 1 1-miny; 0 0 1];
tx= floor(1-minx);
ty= floor(1-miny);

% Output image
imgout = zeros(maxy-miny+1, maxx-minx+1, nargin);

xdata = [minx, maxx];
ydata = [miny, maxy];

for i=1:nargin
    tform = maketform('affine', (accA(:,:,i))' );
    newtimg = imtransform(varargin{i}, tform, 'bicubic',...
        'XData', xdata, 'YData', ydata,...
        'FillValues', NaN);
    imgout(:,:,i) = newtimg;
end


% Different bleding methods
% nanmedian seems to be the most stable
 imgout = nanmean(imgout,3);
%imgout = nanmedian(imgout,3);
% imgout = nanmin(imgout,[],3);
% imgout = max(imgout,[],3);




end
