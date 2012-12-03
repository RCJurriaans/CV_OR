function Gd = gaussianDer(X, sigma)

   %halfSize = ceil(3 * sigma);
   %x = -halfSize:halfSize;
   
   Gd = -(X / sigma^2) .* gaussian(X,sigma);

   %Gd = Gd./sum(abs(Gd));
end