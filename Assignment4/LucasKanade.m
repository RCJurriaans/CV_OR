function [Vx, Vy, Px, Py] = LucasKanade(varargin)

    % 
    %imshow(varargin{1})
    %figure
    %imshow(varargin{2})
    
    images = zeros(size(varargin{1}, 1), size(varargin{2},2), nargin);
    for i= 1:nargin
        images(:,:,i) = varargin{i};
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
    Dt = permute(imfilter(permute(images, [2 3 1]), GderTime, 'replicate', 'full'), [3 1 2]);
    
    imshow(Dt(:,:,1),[])
    figure
    imshow(Dt(:,:,2),[])
    %figure
    %imshow(im)
    %Dy = 
    %Dt = 

    % Reshape into 3xNxM,
    % where N is the number of pixels in a window
    % and M is the number of windows
    A = reshape(
    
    % Loop over windows, and solve
    
    
    
end