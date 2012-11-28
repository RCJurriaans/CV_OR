function Files = createMovie()
% Make movie from all images in directory direc

direc = 'model house/';
Files=dir(strcat(direc, '*.jpg'));
M = readMeasurementMatrix();

fig1=figure(1);
set(fig1,'NextPlot','replacechildren', 'visible', 'off')

mov = avifile('test.avi','fps',30);

for k=1:length(Files)
   imshow(im2double(imread(strcat(direc, Files(k).name))));
   hold on;
   scatter(M((k-1)*2+1,:),M((k-1)*2+2,:), 15, 'y');
   
   % Do opflow stuff
   
   
   hold off;
   mov = addframe(mov, fig1);
end

mov = close(mov);

end