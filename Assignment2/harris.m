function [r,c,s] = harris(im)
threshold=0.0000005;

R = cornerness(im,1);
R = (R>threshold) & ((imdilate(R, strel('square', 3))-R)==0);
%   figure;
%   imshow(R);
done = 0;
sigma = 2;
while 1
   % Determine cornerpoints for sigma
   newR = cornerness(im,sigma);
   newR = (newR>threshold) & ((imdilate(newR, strel('square', 3))-newR)==0);
   % Check if already present
   newR = ((newR-(imdilate(R, strel('square', 3))))>0)*sigma;
   %figure;
   %imshow(newR);
   if sum(sum(newR))==0
       break;
   else
       R = R+newR;
       sigma=sigma+1;
   end
   pause(1)
end




[r,c,s] = find(R);

end