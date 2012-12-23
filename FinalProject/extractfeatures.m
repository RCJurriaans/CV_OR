% Extract the features using extract_features.ln
% Only works on linux

Files=dir(strcat('modelCastlePNG/*.png'));

for i=1:length(Files)
   file = Files(i);
   command = './extract_features_64bit.ln -hesaff -i ';
   command = [command strcat('modelCastlePNG/', file.name)];
   command = strcat(command, ' -sift');
   disp(command);
   system(command);
    
end