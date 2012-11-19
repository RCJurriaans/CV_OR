function x = imageAlign(im1, im2)

[f1, d1] = vl_sift(single(im1));
[f2, d2] = vl_sift(single(im2));

[matches] = vl_ubcmatch(d1,d2);

x = ransacA(f1(1:2,matches(1,:)), f2(1:2,matches(2,:)));

figure;
% Original Image
subplot(2,1,1);

imshow([im1 im2]);
hold on;
perm = randperm(size(matches,2));
seed = perm(1:50);
A = [f1(1:2,matches(1,seed))', zeros(50 , 2) ones(50, 1) ,zeros(50 ,1);...
    zeros(50 , 2), f1(1:2,matches(1,seed))', zeros(50 ,1), ones(50, 1)];
b2 = A*x;
b2 = reshape(b2, 50,2)';

line([f1(1,matches(1,seed)); size(im1,2)+b2(1,:)],...
    [f1(2,matches(1,seed)); b2(2,:)]);

title('Image 1 and 2')

% First Image transformed
subplot(2,2,4);

% Do the transformation
tform = maketform('affine', inv([reshape(x(1:4),2,2) x(5:6) ; 0 0 1])' );
im1b = imtransform(im1,tform, 'bicubic');
imshow(im1b);
title('Image 1 transformed to image 2')
% Second Image transformed
subplot(2,2,3);

% Do the transformation
tform = maketform('affine', [reshape(x(1:4),2,2) x(5:6) ; 0 0 1]' );
im2b = imtransform(im2,tform, 'bicubic');
imshow(im2b);
title('Image 2 transformed to image 1')

end