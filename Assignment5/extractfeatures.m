Files=dir(strcat('TeddyBearPNG/*.png'));

for i=1:length(Files)
   file = Files(i);
   command = './extract_features.ln -haraff -i ';
   command = [command strcat('TeddyBearPNG/', file.name)];
   command = strcat(command, ' -sift');
   command
   system(command);
    
end