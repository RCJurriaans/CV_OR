function [] = reconstructiondemo()
%directory = 'modelCastlePNG/';
directory = 'modelHouse/';
%directory = 'TeddyBearPNG/';

Files=dir(strcat(directory, '*.png'));

n = length(Files);

% Calculate or load the view-point matrix VP, and the feature matrix F
if(exist(strcat(directory, 'Viewpointmatrix.mat')) && exist(strcat(directory, 'FeatureMatrix.mat')))
    load(strcat(directory, 'Viewpointmatrix.mat'));
    load(strcat(directory, 'FeatureMatrix.mat'));
else
    [VP, F] = chainImages(Files, directory);
    save(strcat(directory, 'Viewpointmatrix.mat'), 'VP');
    save(strcat(directory, 'FeatureMatrix.mat'),   'F');
end

% Affine Structure from Motion
Clouds = {};
%cams = zeros(size(VP,1) * 2, 3);
i = 1;
for numFrames=3:4 % How many consequtive frames to consider
    for iBegin = 1:n-(numFrames - 1) % Loop over blocks
        iEnd = iBegin + numFrames-1;
        
        % Select the frames
        VPframes = VP(iBegin:iEnd, :);
        %size(VPframes);
        
        % Select columns that do not have any zeros, for selected frames
        %colInds = sum(VPframes ~= 0, 1) == size(VPframes, 1)
        colInds = sum(VPframes == 0, 1) == 0;
        colInds = find(colInds);
        numPoints = size(colInds, 2);
        
        % % If no points are visible in all views of this block
        % If not enough points are visible in all views of this block

        if numPoints < 8
            continue
        end
        
        % Index the block
        VPblock = VPframes(:, colInds);
        
        % Create point-view matrix with coordinates,
        % instead of indices
        D = zeros(2 * numFrames, numPoints);
        for f = 1:numFrames
            for p = 1:numPoints
                D(2 * f - 1, p) = F{iBegin + f - 1}(1, VPblock(f, p));
                D(2 * f, p) = F{iBegin + f - 1}(2, VPblock(f, p));
            end
        end
        
        %numPts = size(D,2);
        DC = D - repmat( sum(D,2) / numPoints, 1, numPoints);
        
        % Factorize
        %iBegin
        %if cams(2 * iBegin - 1, :) == [0 0 0]
        %   cams(2 * iBegin - 1, :) = [1 0 0];
        %   cams(2 * iBegin, :) = [0 1 0];
        %end
        
        [M, S, p] = TomasiKanadeFactorization(DC)%, ...
                        %cams(2 * iBegin-1: 2 * iBegin, :));
                        
        if(i==1)
           M1 = M; 
           MeanFrame1 = sum(D,2)/numPoints;
        end
                        
        if ~p
            Clouds(i, :) = {M,S,colInds};
            
            
            %cams(2 * iBegin + 1: 2*iEnd, :) = M(3:end,:)
            
        %    for c = iBegin:iEnd
        %       
        %        if cams(2*c-1,:) == [0 0 0]
        %            
        %           j = c - iBegin + 1;
        %           cams(2*c-1,:) = M(2*j-1, :)
        %           cams(2*c  ,:) = M(2*j,:)
        %           
        %        end
        %    
        %    end
            
            
            %if cams(2 * iBegin - 1, :) == [0 0 0]
            %    cams( 2 * iBegin - 1, :) = M(1, :);
            %    cams( 2 * iBegin, :) = M(2, :);
            %end
            
            i = i + 1;
        end
    end
end
  
% Align the clouds using procrustes analysis
mergedCloud = zeros(3, size(VP,2)); %Clouds(1, 2);
mergedCloud(:, Clouds{1,3}) = Clouds{1, 2};
mergedInds = Clouds{1,3};
numClouds = size(Clouds,1);

for i = 2:numClouds
    % Get the points that are in the merged cloud and the new cloud:
    [sharedInds, ~, iClouds] = intersect(mergedInds, Clouds{i,3});
    sharedPoints = mergedCloud(:, sharedInds);
    if size(sharedPoints, 2) < 15
        continue
    end      
    
    % Find optimal transformation between shared points
    [d, Z, T] = procrustes(sharedPoints', Clouds{i,2}(:, iClouds)');
    
    % Transform new points
    % Z=procrustes(X,Y) gives: Z = T.b * Y * T.T + T.c
    % T.c is just a repeated 3D offset, so resample it to have more rows
    [iNew, iCloudsNew] = setdiff(Clouds{i, 3}, mergedInds);
    
    c = T.c(ones(size(iCloudsNew,2),1),:);
    mergedCloud(:, iNew) = (T.b * Clouds{i, 2}(:, iCloudsNew)' * T.T + c)';
    mergedInds = [mergedInds iNew];
end

% Plot the full cloud
X = mergedCloud(1,:)';
Y = mergedCloud(2,:)';
Z = mergedCloud(3,:)';
scatter3(X, Y, Z, 20, [1 0 0], 'filled');
axis( [-500 500 -500 500 -500 500] )
daspect([1 1 1])
rotate3d



% Bundle Adjustment


% Show surface with colors from images
surfaceRender(mergedCloud,M1, MeanFrame1, im2double(imread(strcat(directory, Files(1).name))));

end