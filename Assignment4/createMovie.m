function [Vx,Vy,Px,Py] = createMovie()
% Make movie from all images in directory direc

direc = 'model house/';
Files=dir(strcat(direc, '*.jpg'));
%Files = Files(1:5)

% Note: This function will change due to Taco-ness
M = readMeasurementMatrix();
fig1=figure(1);
set(fig1,'NextPlot','replacechildren', 'visible', 'off')

[Vx,Vy,Px,Py] = LK_M(Files.name);

error = zeros(1,length(Files));
medianerror = zeros(1,length(Files));

for k=1:length(Files)
    subplot(2,2,[1,3]);
   imshow(im2double(imread(strcat(direc, Files(k).name))));
   hold on;
   scatter(M((k-1)*2+1,:),M((k-1)*2+2,:), 15, 'g');
   
   % Do opflow stuff
   %quiver(Px(:,k),Py(:,k), Vx(:,k),Vy(:,k),'x');
   scatter(Px(:,k),Py(:,k), 15, 'r');
   if k<length(Files)
       line([M((k-1)*2+1,:); Px(:,k)'], [M((k-1)*2+2,:); Py(:,k)']);
       error(k) = sqrt(sum( (M((k-1)*2+1,:)-Px(:,k)').^2 + (M((k-1)*2+2,:)-Py(:,k)').^2));
       medianerror(k) = sqrt(median( (M((k-1)*2+1,:)-Px(:,k)').^2 + (M((k-1)*2+2,:)-Py(:,k)').^2));
   end
   title('Green is ground truth, red is tracked points')
   drawnow;
   hold off;

   subplot(2,2,2);
   plot(error(1:k));
   axis([0 length(Files)-1 0 500]);
   title('Sum of squared errors')
   
   subplot(2,2,4);
   plot(medianerror(1:k));
   axis([0 length(Files)-1 0 50]);
   title('Median of squared errors')
   
   filename =  strcat('model house out/', Files(k).name);
   print('-djpeg72', filename);
end

error
medianerror
%mov = close(mov);

end