function imOut = gaussianConv(image, sigma_x, sigma_y)
   kernel_x = gaussian(sigma_x);
   kernel_y = gaussian(sigma_y);
   
   imOut = conv2(kernel_y, kernel_x, image, 'same');
end