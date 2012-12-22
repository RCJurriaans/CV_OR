% Extract the features using extract_features.ln
% Only works on linux

Files=dir(strcat('modelHouse/*.png'));

for i=1:length(Files)
   file = Files(i);
   command = './extract_features.ln -haraff -i ';
   command = [command strcat('modelHouse/', file.name)];
   command = strcat(command, ' -sift');
   disp(command);
   system(command);
    
end