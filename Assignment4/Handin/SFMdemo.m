
% Get ground-truth
[~,DC] = readMeasurementMatrix();

% Get tracking results
P = LK_P();

% Get structure and plot
TomasiKanadeFactorization(DC); % Plots Affine, Euclidean for ground-truth
TomasiKanadeFactorization(P);  % Plots Affine, Euclidean for L-K results
