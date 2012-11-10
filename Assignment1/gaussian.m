%
% Returns 1-d gaussian kernel
% Kernel size is calculated by 2* floor(1.5*sigma) +1
%

function G = gaussian(sigma)

if sigma == 0
    G = 1;
    return
end

% Filter size is about 3*sigma, but must be odd
halfSize = 3* sigma;

x = -halfSize:halfSize;

% Calculate the unnormalized y values
G = (1/(sigma*sqrt(2*pi))) * exp(-(x.^2 / (2 * sigma^2)));

% Normalize the kernel so it sums to one
%G = G / sum(G);

end