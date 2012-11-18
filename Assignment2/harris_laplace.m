function [rows,cols,sigmas] = harris_laplace(im, mode)

% Scale invariant implementation of harris detector
% Uses Laplacian to detect corners on multiple scales
% mode can be either LoG or DoG.

    if nargin < 2
        mode = 'LoG';
    end

    sigma_array = 1 * 1.6 .^ (0:12);
    numScales = size(sigma_array, 2);
   
    corners = zeros(0, 3); % Rows, corners, scale_num
    L = zeros(size(im,1), size(im,2), numScales); % LoG or DoG images
    
    % Compute corners and Laplacian at each scale
    for i=1:numScales,
        sigma = sigma_array(i);
        
        [r,c] = harris(im, sigma);
        num_corners = size(r, 1);
        corners(end+1:end+num_corners,:) = [r,c,ones(num_corners, 1)*i];
        
        % Calculate the scale-normalized LoG
        if mode == 'LoG'
            L(:,:,i) = imfilter(im, sigma^2 * fspecial('log', 2*ceil(3*sigma)+1, sigma), 'replicate', 'same');
            %figure
            %imshow(L(:,:,i), []);
        end
    end
    
    if mode == 'DoG'
        L = DoG(im, sigma_array(1), numScales, 1.6);
    end
    
    num_corners = size(corners,1)
    lpts = 0; % Number of points that are LoG maxima
    for i = 1:num_corners,
       
        r = corners(i, 1);
        c = corners(i, 2);
        s = corners(i, 3);
        
        %if L(r,c,s) > -0.1
        %    continue
        %end
        
        % Check if we're at a maximum LoG value in scale
        %if s > 1
        %    if L(r,c,s) <= L(r,c,s-1)
        %        continue
        %    end
        %end
        %if s < numScales
        %    if L(r,c,s) <= L(r,c,s+1)
        %        continue
        %    end
        %end
        
        % Check if we're at an extremum LoG value in scale
        if s > 1 & s < numScales
            if L(r,c,s) <= L(r,c,s-1) & L(r,c,s) >= L(r,c,s+1)
                continue
            end
            if L(r,c,s) >= L(r,c,s-1) & L(r,c,s) <= L(r,c,s+1)
                continue
            end
        else
            continue
        end
        
        % Add the point
        lpts = lpts+1;
        rows(lpts) = r;
        cols(lpts) = c;
        sigmas(lpts) = s;
        
    end
    
    % Return actual scale values, not the indices
    sigmas = sigma_array(sigmas);

end
