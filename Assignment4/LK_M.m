function [Vx, Vy, Px, Py] = LK_M(varargin)

% Varargin is a list of names of files
% Note: This function will change due to Taco-ness
M = readMeasurementMatrix();

% Calculate the number of patches
patch_size = 15;
num_patches = size(M,2);

points = [M(1,:);M(2,:)];
% Vx, Vy, Px, Py
Vx = zeros(num_patches, nargin);
Vy = zeros(num_patches, nargin);
Px = zeros(num_patches, nargin);
Py = zeros(num_patches, nargin);


% Create temporal and spatial derivative filters
sigmaSpace = 1;
X = -1:1;
GderSpace = gaussianDer(X, sigmaSpace);

sigmaTime = 1;
T = [-1, 1];
GderTime = gaussianDer(T, sigmaTime);

% For each 2 images
for i = 1:nargin-1
    % Get 2 images
    
    images(:,:,1) = padarray(im2double(imread(strcat('model house/', varargin{(i)}))), [15,15], 'replicate');
    images(:,:,2) = padarray(im2double(imread(strcat('model house/', varargin{(i+1)}))), [15,15], 'replicate');
    
    % Take spatial and temporal derivatives
    Dx = imfilter(images, GderSpace, 'replicate', 'same');
    Dy = imfilter(images, GderSpace', 'replicate', 'same');
    Dt = permute(imfilter(permute(images, [2 3 1]), GderTime, 'replicate', 'same'), [3 1 2]);
    
    % Reshape into 3xNxM,
    % where N is the number of pixels in a window
    % and M is the number of windows
    for x = 1:num_patches
        Ax{x} = Dx(floor(points(2,x))-7:floor(points(2,x))+7, floor(points(1,x))-7:floor(points(1,x))+7);
        Ay{x} = Dy(floor(points(2,x))-7:floor(points(2,x))+7, floor(points(1,x))-7:floor(points(1,x))+7);
        At{x} = Dt(floor(points(2,x))-7:floor(points(2,x))+7, floor(points(1,x))-7:floor(points(1,x))+7);
    end
    
    % Loop over windows, and solve
    for x = 1:num_patches
        A = [reshape(Ax{x}, patch_size*patch_size, 1, 1), reshape(Ay{x}, patch_size*patch_size, 1, 1)];
        b = -reshape(At{x}, patch_size*patch_size, 1, 1);
        v = pinv(A(:,:,1))*b(:,:,1);
        Vx(x,i) = v(1);
        Vy(x,i) = v(2);
        Px(x,i) = points(1,x);
        Py(x,i) = points(2,x);
        points(1,x) = points(1,x)+v(1);
        points(2,x) = points(2,x)+v(2);
    end
end
end