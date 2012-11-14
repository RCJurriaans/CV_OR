function [r,c,s] = harris(im)
    threshold=0.000005;

    numScales = 3;
    R = zeros(size(im,1), size(im,2), numScales); % Cornerness images
    L = zeros(size(im,1), size(im,2), numScales); % LoG images
    C = zeros(size(im,1), size(im,2), numScales); % Combined
    for i=1:numScales,
        R(:,:,i) = cornerness(im,i);

        % Show cornerness
        %figure
        %imshow(R(:,:,i),[]); 

        % Show thresholded image
        %figure
        %imshow( (R(:,:,i)>threshold) .* R(:,:,i), []);

        % Calculate maxima in the thresholded image
        R(:,:,i) = (R(:,:,i)>threshold) & ((imdilate(R(:,:,i), strel('square', 3))==R(:,:,i)));
        %figure
        %imshow(R(:,:,i), []);

        % Calculate the LoG
        L(:,:,i) = gradmag(im, i);%TODO:multiply by sigma^2
        %figure
        %imshow(L(:,:,i),[]);
        
        C(:,:,i) = L(:,:,i).*R(:,:,i);
        figure
        imshow(C(:,:,i),[]);
    end

    C = imdilate(C, ones(3,3,3)) == C;
    figure
    imshow(C(:,:,1),[]);
    figure
    imshow(C(:,:,2),[]);
    figure
    imshow(C(:,:,3),[]);
    
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
