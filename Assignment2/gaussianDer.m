function Gd = gaussianDer(G, sigma)
   halfSize = ceil(3 * sigma);
   x = -halfSize:halfSize;
   Gd = -(x / sigma^2) .* G;
end