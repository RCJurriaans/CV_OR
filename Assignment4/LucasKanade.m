function [Vx, Vy, Px, Py] = LucasKanade(varargin)

    % 
    %imshow(varargin{1})
    %figure
    %imshow(varargin{2})
    
    % Calculate the number of patches
    patch_size = 15;
    num_patches_x = floor(size(varargin{1}, 2) / patch_size)
    num_patches_y = floor(size(varargin{1}, 1) / patch_size)
    cropped_width = patch_size * num_patches_x
    cropped_height = patch_size * num_patches_y
    
    images = zeros(cropped_height, cropped_width, nargin);
    for i= 1:nargin
        images(:,:,i) = varargin{i}(1:cropped_height, 1:cropped_width);
    end

    % Create temporal and spatial derivative filters
    sigmaSpace = 2;
    X = -1:1;
    GderSpace = gaussianDer(X, sigmaSpace)
    
    sigmaTime = 1;
    T = [-1, 1];
    GderTime = gaussianDer(T, sigmaTime)
    
    % Take spatial and temporal derivatives
    Dx = imfilter(images, GderSpace, 'replicate', 'same');
    Dy = imfilter(images, GderSpace', 'replicate', 'same');
    Dt = permute(imfilter(permute(images, [2 3 1]), GderTime, 'replicate', 'same'), [3 1 2]);
    
    % Reshape into 3xNxM,
    % where N is the number of pixels in a window
    % and M is the number of windows
    Ax = mat2cell( Dx, ones(1, num_patches_y) * patch_size, ones(1, num_patches_x) * patch_size, nargin);
    Ay = mat2cell( Dy, ones(1, num_patches_y) * patch_size, ones(1, num_patches_x) * patch_size, nargin);
    At = mat2cell( Dt, ones(1, num_patches_y) * patch_size, ones(1, num_patches_x) * patch_size, nargin);
    
    % Loop over windows, and solve
    for x = 1:num_patches_x
        for y = 1:num_patches_y
            A = [reshape(Ax{x, y}, 1, patch_size*patch_size, nargin), reshape(Ay{x, y}, 1, patch_size*patch_size, nargin)];
            b = -reshape(At{x, y}, 1, patch_size*patch_size, nargin);
            for t = 1:nargin-1
                v = pinv(A)*b
            end
        end
    end
    
    
    
end