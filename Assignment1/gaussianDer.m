function Gd = gaussianDer(G, sigma)
   halfSize = floor(1.5 * sigma);
   x = -halfSize:halfSize;
   Gd = -(x / sigma^2) .* G;
end