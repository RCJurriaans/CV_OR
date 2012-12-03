function Fout = singularizeF( Fin )
% Makes the fundamental matrix singular, by zeroing the smallest singular
% value
    [U,S,V] = svd(Fin);
    S(3,3) = 0;
    Fout = U*S*V';

end

