function imgout = mosaic(im2,im1,H)
% Mosaics two images using homography H

% Do the transformation
tform = maketform('projective',H');
im21 = imtransform(im2,tform, 'bicubic');

% Calculate the offset of the new image
[M1 N1] = size(im1);
[M2 N2] = size(im2);
pt = zeros(3,4);
pt(:,1) = H*[1;1;1];
pt(:,2) = H*[N2;1;1];
pt(:,3) = H*[N2;M2;1];
pt(:,4) = H*[1;M2;1];
x2 = pt(1,:)./pt(3,:);
y2 = pt(2,:)./pt(3,:);

up = round(min(y2));
Yoffset = 0;
if up <= 0
	Yoffset = -up+1;
	up = 1;
end

left = round(min(x2));
Xoffset = 0;
if left<=0
	Xoffset = -left+1;
	left = 1;
end

% Use the offsets to create the output image
[M3 N3] = size(im21);
imgout(up:up+M3-1,left:left+N3-1,:) = im21;
imgout(Yoffset+1:Yoffset+M1,Xoffset+1:Xoffset+N1,:) = im1;

% Show output image
figure;
imshow(imgout);


end