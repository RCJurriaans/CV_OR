function [M, MC] = readMeasurementMatrix( )
    M = textread('model house/measurement_matrix.txt');
       
    numPts = size(M,1) / 2;
    numCams = size(M,2);
        
    xMask = repmat( [1 0]', numPts, numCams );
    yMask = repmat( [0 1]', numPts, numCams );
        
    xAvgs = sum(xMask .* M) / numPts;
    yAvgs = sum(yMask .* M) / numPts;
       
    MC = M - (repmat(xAvgs, numPts*2, 1) .* xMask) - (repmat(yAvgs, numPts*2, 1) .* yMask);
    
end