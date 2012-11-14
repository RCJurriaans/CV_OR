im1 = im2double(rgb2gray(imread('landscape-a.jpg')));
%im2 = im2double(rgb2gray(imread('landscape-b.jpg')));
im2 = imrotate(im1,5,'crop');
%im2 = flipdim(im1,2);
%im = im2double((imread('cameraman1.png')));

%im1 = im2double(imread('ah1.jpg'));
%im2 = im2double(imread('ah2.jpg'));

% im1 = zeros(100);
% im1(30:50,30:50) = 1;
% im2 = zeros(100);
% im2(50:80,50:80) = 1;

[match1, match2] = findMatches(im1,im2,40)

% [r,c,s] = testharris(im);
% figure;
% imshow(im,[]);
% hold on;
% %scatter(c,r);
% 
% [f,d] = sift(single(im),r,c, s);
% 
% h1 = vl_plotframe(f) ;
% h2 = vl_plotframe(f) ;
% set(h1,'color','k','linewidth',3) ;
% set(h2,'color','y','linewidth',2) ;
% %h3 = vl_plotsiftdescriptor(d,f) ;
% %set(h3,'color','g') ;
% 
% 
