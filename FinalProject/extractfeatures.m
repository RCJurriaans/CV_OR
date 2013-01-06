% Extract the features using extract_features.ln
% Only works on linux

Files=dir(strcat('modelCastlePNG/*.png'));
%Files=dir(strcat('modelHouse/*.png'));
%Files=dir(strcat('TeddyBearPNG/*.png'));

for i=1:length(Files)
   file = Files(i);
   %command = './extract_features_64bit.ln -hesaff -i ';
   command = './extract_features_64bit.ln -haraff -i ';
   
   command = [command strcat('modelCastlePNG/', file.name)];
   %command = [command strcat('modelHouse/', file.name)];
   %command = [command strcat('TeddyBearPNG/', file.name)];
   
<<<<<<< HEAD
   %command = strcat(command, ' -sift');
   command = strcat(command, ' -sift thres 1000');
=======
   command = strcat(command, ' -sift thres 1500');
>>>>>>> 081ebd6462be72185a4a49309e82231772fca1ee
   disp(command);
   system(command);
    
end