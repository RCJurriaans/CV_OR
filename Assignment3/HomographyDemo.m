% Homography Stitching Demo
% Extra Credit

% Load left and right image
im2 = im2double(rgb2gray(imread('left.jpg')));
im1 = im2double(rgb2gray(imread('right.jpg')));
%im1 = im2double(rgb2gray(imread('stitch_03.png')));
%im2 = im2double(rgb2gray(imread('stitch_04.png')));

% Find matches
[f1, d1] = vl_sift(single(im1));
[f2, d2] = vl_sift(single(im2));
[matches] = vl_ubcmatch(d1,d2);

imnew = im2;
imtarget = im1;


w = size(imnew,2);
h = size(imnew,1);

corners = [1 1 1; w 1 1; 1 h 1; w h 1]';

A = zeros(3,3,nargin);
A(:,:,1) = eye(3);
accA = A;

% Get transformation A from new image to target
newx = ransacH(f1(1:2,matches(1,:)), f2(1:2,matches(2,:)));
A(:,:,2) = [ newx(1) newx(2) newx(3);...
    newx(4) newx(5) newx(6);...
    newx(7) newx(8) newx(9)]./newx(9);

accA(:,:,2) = A(:,:,2)*accA(:,:,1);
w = size(imtarget,2);
h = size(imtarget,1);

corners = [corners (accA(:,:,2))*[1 1 1; w 1 1; 1 h 1; w h 1]'];
corners(1,:) = corners(1,:)./corners(3,:);
corners(2,:) = corners(2,:)./corners(3,:);
corners(3,:) = corners(3,:)./corners(3,:);


% Find size of output image
minx = floor(min(corners(1,:)));
maxx = ceil(max(corners(1,:)));
miny = floor(min(corners(2,:)));
maxy = ceil(max(corners(2,:)));

% Offset translation
%T = [1 0 1-minx; 0 1 1-miny; 0 0 1];
tx= floor(1-minx);
ty= floor(1-miny);

% Output image
imgout = zeros(maxy-miny+1, maxx-minx+1, 2);

xdata = [minx, maxx];
ydata = [miny, maxy];


tform = maketform('projective', (accA(:,:,1))' );
newtimg = imtransform(im2, tform, 'bicubic',...
    'XData', xdata, 'YData', ydata,...
    'FillValues', NaN);
imgout(:,:,1) = newtimg;

tform = maketform('projective', (accA(:,:,2))' );
newtimg = imtransform(im1, tform, 'bicubic',...
    'XData', xdata, 'YData', ydata,...
    'FillValues', NaN);
imgout(:,:,2) = newtimg;

% Different bleding methods
% nanmedian seems to be the most stable
imgout = nanmean(imgout,3);
% imgout = nanmedian(imgout,3);
% imgout = nanmin(imgout,[],3);
% imgout = max(imgout,[],3);

figure;
imshow(imgout);