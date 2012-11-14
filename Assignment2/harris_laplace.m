function [rows,cols,sigmas] = harris_laplace(im)
    
    sigma_array = [1.5:0.5:4];
    numScales = size(sigma_array, 2);
   
    corners = zeros(0, 3); % Rows, corners, scale_num
    L = zeros(size(im,1), size(im,2), numScales); % LoG images
    
    for i=1:numScales,
        sigma = sigma_array(i);% i*0.5;
        
        [r,c] = harris(im, sigma);
        num_corners = size(r, 1);
        corners(end+1:end+num_corners,:) = [r,c,ones(num_corners, 1)*i];
        
        % Calculate the scale-normalized LoG
        L(:,:,i) = imfilter(im, sigma^2 * fspecial('log', 2*ceil(3*sigma)+1, sigma), 'same'); %laplace(im, sigma);
        %figure
        %imshow(L(:,:,i), []);
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
        if s > 1
            if L(r,c,s) <= L(r,c,s-1)
                continue
            end
        end
        if s < numScales
            if L(r,c,s) <= L(r,c,s+1)
                continue
            end
        end
        
        %if s>1 & s < numScales
        %    sprintf( 'test %f, %f, %f', L(r,c,s-1), L(r,c,s), L(r,c,s+1))
        %end
       
        
        % Add the point
        lpts = lpts+1;
        rows(lpts) = r;
        cols(lpts) = c;
        sigmas(lpts) = s;
        
    end
    
    
    tst = zeros(size(im));
    tst(sub2ind(size(im), rows, cols)) = 1;
    figure
    imshow(tst, []);
    
    imshow(im, []);
    hold on;
    scatter(cols, rows, sigma_array(sigmas) * 15, [1,1,0]);
    
    %C = (imdilate(C, ones(3,3,3)) == L);
    %figure
    %imshow(C(:,:,1),[]);
    %figure
    %imshow(C(:,:,2),[]);
    %figure
    %imshow(C(:,:,3),[]);
    
    %for i=1:numScales,
       
        % Find corner point coords
    %    [r,c,s] = find(R);
        
        % For every corner point
    %    for j=1:size(r,1),
            % 
    %    end
        
    %end


%R = cornerness(im,1);
%R = (R>threshold) & ((imdilate(R, strel('square', 3))-R)==0);
%   figure;
%   imshow(R);

%done = 0;
%sigma = 2;
%while 1
   % Determine cornerpoints for sigma
%   newR = cornerness(im,sigma);
%   newR = (newR>threshold) & ((imdilate(newR, strel('square', 3))-newR)==0);
   % Check if already present
%   newR = ((newR-(imdilate(R, strel('square', 3))))>0)*sigma;
   %figure;
   %imshow(newR);
%   if sum(sum(newR))==0
%       break;
%   else
%       R = R+newR;
%       sigma=sigma+1;
%   end
%   pause(1)
%end

%[r,c,s] = find(R);

end