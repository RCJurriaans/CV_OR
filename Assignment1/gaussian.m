function G = gaussian(sigma)

% Filter size is about 3*sigma, but must be odd
halfSize = floor(1.5 * sigma);
kernelSize = 2 * halfSize + 1;

x = -halfSize:halfSize;

% Calculate the unnormalized y values
G = exp(-(x.^2 / (2 * sigma^2)));

% Normalize the kernel so it sums to one
G = G / sum(G);

end