function [M, F] = chainImages(Files, directory)
% Find visibility matrix M
% run as:   M = chainImages(Files);
% with:     Files=dir(strcat('TeddyBearPNG/*.png'));

% Run on all 16 sideviews
frames = length(Files);

% Initialize M
M = zeros(frames+1,0);

% Load all features and descriptors
for i=1:frames
    [feat1,desc1,~,~] = loadFeatures(strcat(directory, Files(i).name, '.haraff.sift'));
    F{i} = feat1(1:2, :);
    D{i} = desc1;
end

for i=1:frames
    nexti = mod(i,frames)+1;
    
    feat1 = F{i};
    desc1 = D{i};
    
    feat2 = F{nexti};
    desc2 = D{nexti};
    
    disp(strcat('Working on: ', Files(i).name, ', ', Files(nexti).name));
    
    disp('Matching Descriptors');
    [matches, ~] = vl_ubcmatch(desc1,desc2);
    disp(strcat( int2str(size(matches,2)), ' matches found'));
    
    % Get X,Y coordinates of features
    f1 = feat1(1:2,matches(1,:));
    f2 = feat2(1:2,matches(2,:));
    
    % Find inliers according to F
    [~, inliers] = estimateFundamental(f1,f2);
    newmatches = matches(:,inliers);
    
    % First batch can not be compared to previous matches
    if i==1
        M(i,1:size(inliers,2)) = newmatches(1,:)';
        M(nexti,1:size(inliers,2)) = newmatches(2,:)';
    else
        prevmatches = M(i,:);
        
        % Find already found points
        [ints, IA, IB] = intersect(newmatches(1,:)', prevmatches);
        % M(i,IB)     = ints;
        M(i+1,IB) = newmatches(2,IA);
        
        % Find new points
        [diff, IA] = setdiff(newmatches(1,:)', prevmatches);
        start = size(M,2)+1;
        M = [M zeros(frames+1, size(diff,2))]; %#ok<AGROW>
        M(i, start:end) = diff';
        M(i+1, start:end) = newmatches(2,IA);
    end
    
    disp(strcat(int2str(size(M,2)), ' points in pointview matrix so far'));

end

end