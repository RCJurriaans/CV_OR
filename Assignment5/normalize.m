function [Pout, T] = normalize( Pin )
% Center the points
means = mean(Pin(1:2,:), 2);
Pzm = Pin - repmat(means, 1, size(Pin, 2));

% Compute the scaling
d = sum(sqrt(sum(Pzm .^ 2, 1))) / size(Pin, 2);
s = sqrt(2) / d;

% Compute the transformation matrix, and transform the inputs
T = [s 0 0; 0 s 0; 0 0 1] * [1 0 -means(1); 0 1 -means(2); 0 0 1];
Pout = T * [Pin; ones(1,size(Pin,2))];

end