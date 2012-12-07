function M = chainImages(Files)
% Find visibility matrix M
% run as:   M = chainImages(Files);
% with:     Files=dir(strcat('TeddyBearPNG/*.png'));

% Run on all 16 sideviews
frames = 16;

% Initialize M
M = zeros(frames,0);

% First file to process
im2 = Files(1);
[feat2,desc2,~,~] = loadFeatures(strcat('TeddyBearPNG/', im2.name, '.haraff.sift'));

for i=1:frames
    % Replace old image
    im1 = im2;
    feat1 = feat2;
    desc1 = desc2;
    
    % Load new image
    im2 = Files(mod(i,frames)+1);
    
    disp(strcat('Working on: ', im1.name, ', ', im2.name));
    
    % Read Features and Descriptors for new image
    [feat2,desc2,~,~] = loadFeatures(strcat('TeddyBearPNG/', im2.name, '.haraff.sift'));
    
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
    else
        prevmatches = M(i-1,:);
        
        % Find already found points
        [ints, ~, IB] = intersect(newmatches(1,:)', prevmatches);
        M(i,IB) = ints;
        
        % Find new points
        diff = setdiff(newmatches(1,:)', prevmatches);
        start = size(M,2)+1;
        M = [M zeros(frames, size(diff,2))];
        M(i, start:end) = diff';
    end
end

end