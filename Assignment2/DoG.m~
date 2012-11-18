
function D = DoG(im, sigma_start, num_levels, scale_factor)
% Computes the difference of Gaussians (DoG) for image im.
% sigma_start is the lowest blur level
% The n-th scale-level is sigma_start * scale_factor^n
% The function returns the difference of subsequent scale levels at
% num_levels.

    % Compute the scale levels at which to blur
    scales = sigma_start * (scale_factor .^ (0:num_levels));
    
    % Allocate output images
    D = zeros(size(im,1), size(im,2), num_levels);
    
    for i = 1:num_levels+1
        % Blur the image at the appropriate scale
        G = gaussian(scales(i));
        Gx = imfilter(im, G, 'replicate', 'same');
        current = imfilter(Gx, G', 'replicate', 'same');
        
        % If we're not at the lowest scale, calculate difference
        if i > 1
            D(:,:,i-1) = current - previous;
            %figure
            %imshow(D(:,:,i-1), []);
        end
        
        previous = current;
    end

end