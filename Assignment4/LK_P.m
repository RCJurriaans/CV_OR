function P = LK_P()
% Does Lucas-Kanade to track point as given by M
% Returns tracked points in same format as M


direc = 'model house/';
Files=dir(strcat(direc, '*.jpg'));

M = readMeasurementMatrix();

[~,~,Px,Py] = LK_M(Files.name);

P = reshape([Px; Py], size(M,2), size(M,1))';

end