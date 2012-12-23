function [] = reconstructiondemo()
%directory = 'modelCastlePNG/';
directory = 'modelHouse/';
Files=dir(strcat(directory, '*.png'));

n = length(Files);

if(exist(strcat(directory, 'Viewpointmatrix.mat')) && exist(strcat(directory, 'FeatureMatrix.mat')))
    load(strcat(directory, 'Viewpointmatrix.mat'));
    load(strcat(directory, 'FeatureMatrix.mat'));
else

[VP, F] = chainImages(Files, directory);
save(strcat(directory, 'Viewpointmatrix.mat'), 'VP');
save(strcat(directory, 'FeatureMatrix.mat'),   'F');
end

% Affine Structure from Motion
% 3 Blocks
for i1=1:n
   i2 = mod(i1,  n)+1; 
   i3 = mod(i1+1,n)+1;
   ind1 = find(VP(i1,:));
   ind2 = find(VP(i2,:));
   ind3 = find(VP(i3,:));
   indices = intersect(ind1,intersect(ind2,ind3));
   
   % Save the three images with the points that are visible in all three
   h =    figure('units','normalized','outerposition',[0 0 1 1]);
   set(0, 'DefaultFigureVisible', 'off');
   set(0, 'DefaultAxesVisible', 'off');
   subplot(1,3,1);
   imshow(im2double(imread(strcat(directory, Files(i1).name))));
   hold on;
   features = F{i1};
   features = features(1:2,VP(i1,indices));
   scatter(features(1,:), features(2,:));
   
   subplot(1,3,2);
   imshow(im2double(imread(strcat(directory, Files(i2).name))));
   hold on;
   features = F{i2};
   features = features(1:2,VP(i2,indices));
   scatter(features(1,:), features(2,:));
   
   subplot(1,3,3);
   imshow(im2double(imread(strcat(directory, Files(i3).name))));
   hold on;
   features = F{i3};
   features = features(1:2,VP(i3,indices));
   scatter(features(1,:), features(2,:));

print(h, strcat('out', directory, '3Block_', Files(i1).name), '-dpng');
   close(h);
   
end

% Bundle Adjustment

% Eliminate Affine Ambiguity

% Show surface with colors from images


end