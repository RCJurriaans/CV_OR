function [M, F] = chainImages(Files, directory)
% Find visibility matrix M
% run as:   M = chainImages(Files);
% with:     Files=dir(strcat('TeddyBearPNG/*.png'));

% Run on all 16 sideviews
frames = length(Files);

% Initialize M
M = zeros(frames,0);

% Load all features and descriptors
tic;
for i=1:frames
    [feat1,desc1,~,~] = loadFeatures(strcat(directory, Files(i).name, '.haraff.sift'));
    [feat2,desc2,~,~] = loadFeatures(strcat(directory, Files(i).name, '.hesaff.sift'));
    
    %[~, I, J] = unique(round([feat1';feat2']), 'rows');
%     
%     feat = [feat1, feat2];
%     feat1 = feat(:,I);
%     desc = [desc1, desc2];
%     desc1 = desc(:,I);

    feat1 = [feat1 feat2];
    desc1 = [desc1 desc2];
    
    F{i} = feat1(1:2, :);
    D{i} = desc1;
end


for i=1:frames
    toc;
    tic;
    nexti = mod(i,frames)+1;
    
    feat1 = F{i};
    desc1 = D{i};
    
    feat2 = F{nexti};
    desc2 = D{nexti};
    
    disp(strcat('Working on: ', Files(i).name, ', ', Files(nexti).name));
    
    disp('Matching Descriptors');drawnow('update')
    [matches, ~] = vl_ubcmatch(desc1,desc2);
    disp(strcat( int2str(size(matches,2)), ' matches found'));drawnow('update')
    
    % Get X,Y coordinates of features
    f1 = feat1(1:2,matches(1,:));
    f2 = feat2(1:2,matches(2,:));
    
    % Find inliers according to F
    [~, inliers] = estimateFundamental(f1,f2);
    drawnow('update')
    newmatches = matches(:,inliers);
    
    % First batch can not be compared to previous matches
    if i==1
        M(i,1:size(inliers,2)) = newmatches(1,:)';
        M(nexti,1:size(inliers,2)) = newmatches(2,:)';
    elseif i<frames
        prevmatches = M(i,:);
        
        % Find already found points
        [ints, IA, IB] = intersect(newmatches(1,:)', prevmatches);
        % M(i,IB)     = ints;
        M(i+1,IB) = newmatches(2,IA);
        
        % Find new points
        [diff, IA] = setdiff(newmatches(1,:)', prevmatches);
        start = size(M,2)+1;
        M = [M zeros(frames, size(diff,2))]; %#ok<AGROW>
        M(i, start:end) = diff';
        M(i+1, start:end) = newmatches(2,IA);
    else
        matches1 = M(1,:);
        matchesn = M(frames,:);
        
        % Find points in last frame that are also in frame 1
        [~, IA1, IB1] = intersect(newmatches(1,:)', matchesn);
        [~, IA2, IB2] = intersect(newmatches(2,:)', matches1);
        [~,IA,IB] = intersect(IA1,IA2);

        % Select the positions in frame n that are also in frame 1
        IB1 = IB1(:,IA);
        IB2 = IB2(:,IB);
        
        % Move non-zero entries in columns IA to positions IB
        assert(sum(sum(((M(:,IB2)~=0).*(M(:,IB1)~=0))))==0,...
            'Overlap in columns resulting in wrong viewpoint matrix');
        M(:,IB2) = M(:,IB1) + M(:,IB2);
        M(:, IB1) = [];

        
    end
    
    disp(strcat(int2str(size(M,2)), ' points in pointview matrix so far'));

end
toc;
end