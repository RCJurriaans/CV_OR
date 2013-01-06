% Extract the features using extract_features.ln
% Only works on linux

%Files=dir(strcat('modelCastlePNG/*.png'));
Files=dir(strcat('modelHouse/*.png'));
%Files=dir(strcat('TeddyBearPNG/*.png'));

for i=1:length(Files)
   file = Files(i);
   command = './extract_features_64bit.ln -hesaff -i ';
   %command = './extract_features_64bit.ln -haraff -i ';
   
   %command = [command strcat('modelCastlePNG/', file.name)];
   command = [command strcat('modelHouse/', file.name)];
   %command = [command strcat('TeddyBearPNG/', file.name)];


   %command = strcat(command, ' -sift');
   command = strcat(command, ' -sift thres 1000');
   disp(command);
   system(command);
    
end
