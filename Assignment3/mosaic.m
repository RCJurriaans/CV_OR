function imgout = mosaic(varargin)
% Stitch multiple images in sequence
% Can be used as mosaic(im1,im2,im3,...);

% Begin with first image
imtarget = varargin{1};

% Find corners from image
w = size(imtarget,2);
h = size(imtarget,1);
corners = [1 1 1; w 1 1; 1 h 1; w h 1]';

% First image is not transformed
A = zeros(3,3,nargin);
A(:,:,1) = eye(3);
accA = A;

% For all other images
for i=2:nargin
    % Load next image
    imnew = varargin{i};
    
    % Get transformation A from new image to previous image
    x = imageAlign(imnew, varargin{i-1});
    
    % Make the affine transformation
    A(:,:,i) = [[x(1) x(2) x(5); x(3) x(4) x(6)] ; 0 0 1];
    
    % Combine the affine transformation with all previous matrices
    % to get the transformation to the first image
    accA(:,:,i) = A(:,:,i)*accA(:,:,i-1);
    
    % Add the corners of this image
    w = size(imnew,2);
    h = size(imnew,1);
    corners = [corners (accA(:,:,i))*[1 1 1; w 1 1; 1 h 1; w h 1]'];
end

% Find size of output image
minx = floor(min(corners(1,:)));
maxx = ceil(max(corners(1,:)));
miny = floor(min(corners(2,:)));
maxy = ceil(max(corners(2,:)));

% Output image
imgout = zeros(maxy-miny+1, maxx-minx+1, nargin);

% Output image coordinate system
xdata = [minx, maxx];
ydata = [miny, maxy];

% Transform each image to the coordinate system
for i=1:nargin
    tform = maketform('affine', (accA(:,:,i))' );
    newtimg = imtransform(varargin{i}, tform, 'bicubic',...
        'XData', xdata, 'YData', ydata,...
        'FillValues', NaN);
    imgout(:,:,i) = newtimg;
end


% Different blending methods
% nanmedian seems to be the most stable for longer sequences of images
 imgout = nanmean(imgout,3);
%imgout = nanmedian(imgout,3);
% imgout = nanmin(imgout,[],3);
% imgout = max(imgout,[],3);

end
