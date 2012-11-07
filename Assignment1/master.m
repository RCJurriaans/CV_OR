

im = im2double( rgb2gray( imread('get-a-brain.jpg') ) );



% Compare our gaussian to matlab's
sigma = 20;
tic
blurred1 = gaussianConv(im, sigma, sigma);
toc
tic
blurred2 = conv2 ( im, fspecial('gaussian', 2 * floor(1.5 * sigma) + 1, sigma), 'same');
toc

error = sqrt( sum(sum( (blurred1-blurred2).^2 ) ) )

numdifferent = sum(sum( blurred1 ~= blurred2 ) )

figure(1)
imshow(blurred1);
figure(2)
imshow(blurred2);