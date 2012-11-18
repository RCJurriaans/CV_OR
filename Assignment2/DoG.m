
function D = DoG(im, sigma_start, num_levels, scale_factor)

    scales = sigma_start * (scale_factor.^ (0:num_levels))
    
    D = zeros(size(im,1), size(im,2), num_levels);
    
    for i = 1:num_levels+1
        G = gaussian(scales(i));
        Gx = imfilter(im, G, 'replicate', 'same');
        current = imfilter(Gx, G', 'replicate', 'same');
        
        if i > 1
            D(:,:,i-1) = current - previous;
            
            figure
            imshow(D(:,:,i-1), []);
        end
        
        previous = current;
    end

end