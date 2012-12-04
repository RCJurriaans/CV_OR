function F = Fdemo()
% Demo for assignment 5
% Computes Fundamental Matrix using the normalized Eight-Point Algorithm
tic;
% Read images
disp('Reading images');
img1 = im2double(rgb2gray(imread('TeddyBearPNG/obj02_001.png')));
img2 = im2double(rgb2gray(imread('TeddyBearPNG/obj02_015.png')));

% Read Features and Descriptors
[feat1,desc1,~,~] = loadFeatures('TeddyBearPNG/obj02_001.png.haraff.sift');
[feat2,desc2,~,~] = loadFeatures('TeddyBearPNG/obj02_015.png.haraff.sift');

% img1 = im2double(rgb2gray(imread('BoxPNG/left.png')));
% img2 = im2double(rgb2gray(imread('BoxPNG/right.png')));
% 
% % Read Features and Descriptors
% [feat1,desc1,~,~] = loadFeatures('BoxPNG/left.png.haraff.sift');
% [feat2,desc2,~,~] = loadFeatures('BoxPNG/right.png.haraff.sift');

% Match Descriptors
disp('Matching Descriptors');
[matches, ~] = vl_ubcmatch(desc1,desc2);
disp(strcat( int2str(size(matches,2)), ' matches found'));

%perm = randperm(size(matches,2));
%matches = matches(:,perm(1:20));

% Get X,Y coordinates of features
f1 = feat1(1:2,matches(1,:));
f2 = feat2(1:2,matches(2,:));

% Normalize X,Y
disp('Normalizing coordinates');

% Estimate Fundamental Matrix, singularize and retransform using T and T'
disp('Estimating F');
[F inliers] = estimateFundamental(f1,f2);

disp(strcat(int2str(size(inliers,2)), ' inliers found'));

F
toc
% Show the images with matched points
figure;
imshow([img1,img2],'InitialMagnification', 'fit');
hold on;

scatter(f1(1,inliers),f1(2,inliers), 'y');
scatter(size(img1,2)+f2(1,inliers),f2(2,inliers) ,'r');
line([f1(1,inliers);size(img1,2)+f2(1,inliers)], [f1(2,inliers);f2(2,inliers)], 'Color', 'b');

outliers = setdiff(1:size(matches,2),inliers);
line([f1(1,outliers);size(img1,2)+f2(1,outliers)], [f1(2,outliers);f2(2,outliers)], 'Color', 'r');

figure;
% Visualize epipoles
subplot(1,2,1);
imshow(img1,'InitialMagnification', 'fit');
title('Epipolar line for the yellow point of right image')
hold on;
subplot(1,2,2);
imshow(img2,'InitialMagnification', 'fit');
title('Epipolar line for the yellow point of left image')
hold on;

%midpointL = [floor(size(img1,2)/2), floor(size(img1,1)/2),1]';
%midpointR = [floor(size(img2,2)/2), floor(size(img2,1)/2),1]';
a=1;
b=size(matches,2);
rL = floor(a + (b-a).*rand(1,1));
rR = floor(a + (b-a).*rand(1,1));
pointL = [f1(:,rL);1];
pointR = [f2(:,rR);1];

subplot(1,2,1);
scatter(pointL(1),pointL(2),15,'y');
subplot(1,2,2);
scatter(pointR(1),pointR(2),15,'y');

epiR = F*pointL;
plot(-(epiR(1)*(1:size(img2,2))+epiR(3))./epiR(2), 'r')


epiL = F'*pointR;
subplot(1,2,1);
plot(-(epiL(1)*(1:size(img1,2))+epiL(3))./epiL(2), 'r')

