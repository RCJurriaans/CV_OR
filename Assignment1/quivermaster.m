%img = im2double( imread('pn1.jpg') );
img = fspecial('gaussian', 50, 5);
figure;
imshow(img,[]);
for sigma=[1,3,5,7,9]
    G = gaussian(sigma);
    kernel = gaussianDer(G, sigma);
    Gx = conv2(img, kernel, 'same');
    Gy = conv2(img, kernel', 'same');
    figure;
    quiver(Gx,Gy);
    namemag = sprintf('Quiver image for sigma %0.0f', sigma);
    set(gcf,'numbertitle','off','name',namemag)    
end