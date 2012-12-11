function [] = reconstructiondemo()
directory = 'modelCastlePNG/';
Files=dir(strcat(directory, '*.png'));

n = length(Files);
[VP, F] = chainImages(Files);

% Affine Structure from Motion

% Bundle Adjustment

% Eliminate Affine Ambiguity

% Show surface with colors from images


end