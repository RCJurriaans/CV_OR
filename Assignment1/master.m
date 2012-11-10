

im = im2double( rgb2gray( imread('zebra.png') ) );
%im = im2double( imread('pn1.jpg') );

% Compare our gaussian to matlab's
sigma = 5;
tic
blurred1 = gaussianConv(im, sigma, sigma);
toc
tic
blurred2 = conv2 ( im, fspecial('gaussian', 6 * sigma +1, sigma), 'same');
toc

error = sqrt( sum(sum( (blurred1-blurred2).^2 ) ) )

numdifferent = sum(sum( blurred1 ~= blurred2 ) )

figure(1)
imshow(blurred1);
figure(2)
imshow(blurred2);