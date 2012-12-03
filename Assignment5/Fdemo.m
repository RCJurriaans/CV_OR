function F = Fdemo()
% Demo for assignment 5
% Computes Fundamental Matrix using the normalized Eight-Point Algorithm

% Read images
disp('Reading images');
img1 = im2double(rgb2gray(imread('TeddyBearPNG/obj02_001.png')));
img2 = im2double(rgb2gray(imread('TeddyBearPNG/obj02_002.png')));

% Read Features and Descriptors
[feat1,desc1,~,~] = loadFeatures('TeddyBearPNG/obj02_001.png.haraff.sift');
[feat2,desc2,~,~] = loadFeatures('TeddyBearPNG/obj02_002.png.haraff.sift');

% Match Descriptors
disp('Matching Descriptors');
matches = vl_ubcmatch(desc1,desc2);

% Get X,Y coordinates of features
f1 = feat1(1:2,matches(1,:));
f2 = feat2(1:2,matches(2,:));

% Normalize X,Y
disp('Normalizing coordinates');
[f1n,T1] = normalize(f1);
[f2n,T2] = normalize(f2);

% Estimate Fundamental Matrix, singularize and retransform using T and T'
disp('Estimating F');
[F inliers] = estimateFundamental(f1n,f2n);
F = singularizeF(F);
F = T2'*F*T1;

disp(strcat(int2str(size(inliers,2)), ' inliers found'));

% Show the images with matched points
figure;
imshow([img1,img2]);
hold on;

scatter(f1(1,inliers),f1(2,inliers), 'y');
scatter(size(img1,2)+f2(1,inliers),f2(2,inliers) ,'r');
line([f1(1,inliers);size(img1,2)+f2(1,inliers)], [f1(2,inliers);f2(2,inliers)], 'Color', 'b');