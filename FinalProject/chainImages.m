function [M, F] = chainImages(Files)
% Find visibility matrix M
% run as:   M = chainImages(Files);
% with:     Files=dir(strcat('TeddyBearPNG/*.png'));

% Run on all 16 sideviews
frames = length(Files);

% Initialize M
M = zeros(frames,0);

% First file to process
im2 = Files(1);
[feat2,desc2,~,~] = loadFeatures(strcat('modelCastlePNG/', im2.name, '.haraff.sift'));

for i=1:frames
    nexti = mod(i,frames)+1;
    
    % Replace old image
    im1 = im2;
    feat1 = feat2;
    desc1 = desc2;
    
    % Save the features
    F{i}   = feat1(1:2, :); %#ok<AGROW>

    % Load new image
    im2 = Files(nexti);
    
    disp(strcat('Working on: ', im1.name, ', ', im2.name));
    
    % Read Features and Descriptors for new image
    [feat2,desc2,~,~] = loadFeatures(strcat('modelCastlePNG/', im2.name, '.haraff.sift'));
    
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
        M(nexti,IB) = newmatches(2,IA);
        
        % Find new points
        [diff, IA] = setdiff(newmatches(1,:)', prevmatches);
        start = size(M,2)+1;
        M = [M zeros(frames, size(diff,2))];
        M(i, start:end) = diff';
        M(nexti, start:end) = newmatches(1,IA);
    end
    
    disp(strcat(int2str(size(M,2)), ' points in pointview matrix so far'));

end

end