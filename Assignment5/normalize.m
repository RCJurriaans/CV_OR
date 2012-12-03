function [Pout, T] = normalize( Pin )

    means = mean(Pin, 2);    
    Pzm = Pin - repmat(mean(Pin, 2), 1, size(Pin, 2))
    d = sum(sqrt(sum(Pzm .^ 2, 1))) / size(Pin, 2)
    s = sqrt(2) / d
    T = [s 0 0; 0 s 0; 0 0 1] * [1 0 -mean(1); 0 1 -mean(2); 0 0 1]
    Pout = T * Pin
end