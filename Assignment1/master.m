

%im = im2double( rgb2gray( imread('zebra.png') ) );
im = im2double( imread('pn1.jpg') );

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

% 1.3 Difference between separated filter and original filter
figure(1)
set(gcf,'numbertitle','off','name','Separated Filter')
imshow(blurred1);
figure(2)
set(gcf,'numbertitle','off','name','Original Matlab Filter')
imshow(blurred2);

% 1.5.1 Magnitude and Orientation for different sigma
for sigma=[1,3,5,7,9]%,11,13,15,17,19 ]
    [mag,or] = gradmag(im,sigma);
    figure;
    namemag = sprintf('Magnitude for sigma %0.0f', sigma);
    set(gcf,'numbertitle','off','name',namemag)
    imshow(mag);
    colorbar;
    figure;
    namemag = sprintf('Orientation for sigma %0.0f', sigma);
    set(gcf,'numbertitle','off','name',namemag)
    imshow(or,[-pi,pi]);
    colormap(hsv);
    colorbar;
end

% 1.5.1 Quiver Plot for various sigma



% 1.5.3 Thresholded magnitude images for various sigma and thresholds
figure;
p=1;
set(gcf,'numbertitle','off','name','Magnitude images for various sigma and thresholds')
for sigma=[1,3,5,7,9]
    for threshold=[0.005, 0.01, 0.05, 0.1, 0.15]
        mag = gradmag(im,sigma)<threshold;
        namemag = sprintf('s=%0.0f, t= %0.3f', sigma, threshold);
        subplot(5,5,p);
        imshow(mag);
        title(namemag);
        
        p = p+1;
    end    
end

% 1.5.5 Impulse image with different order derivatives for different sigma
imp = zeros(30);
imp(15,15)=1;
figure;
set(gcf,'numbertitle','off','name','Different orders of derivatives over impulse image for different sigma')
for i=0:4
    
    subplot(5,5,i*5+1);
    imshow(ImageDerivatives(imp,i+1,'x'),[]);
    ylabel(i+1);
    if i==4
       xlabel('x') 
    end
        subplot(5,5,i*5+2);
    imshow(ImageDerivatives(imp,i+1,'y'),[]);
    if i==4
       xlabel('y') 
    end
        subplot(5,5,i*5+3);
    imshow(ImageDerivatives(imp,i+1,'xx'),[]);
    if i==4
       xlabel('xx') 
    end
        subplot(5,5,i*5+4);
    imshow(ImageDerivatives(imp,i+1,'xy'),[]);
    if i==4
       xlabel('xy') 
    end
        subplot(5,5,i*5+5);
    imshow(ImageDerivatives(imp,i+1,'yy'),[]);
    if i==4
       xlabel('yy') 
    end
end

