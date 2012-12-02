function P = LK_P()
% Does Lucas-Kanade to track point as given by M
% Returns tracked points in same format as M

% Get M
direc = 'model house/';
Files=dir(strcat(direc, '*.jpg'));
M = readMeasurementMatrix();

% Do opflow
[~,~,Px,Py] = LK_M(Files.name);

% Create a 'measurement matrix' in the same format as the one in
% measurement_matrix.txt
P = reshape([Px; Py], size(M,2), size(M,1))';

% Center it
P = P - repmat( sum(P,2) / size(P,2), 1, size(P,2));

end