function [x, match1, match2] = imageAlign(im1, im2)

[f1, d1] = vl_sift(single(im1));
[f2, d2] = vl_sift(single(im2));

[matches] = vl_ubcmatch(d1,d2,1.1);

x = ransacA(f1(1:2,matches(1,:)), f2(1:2,matches(2,:)));
match1 = f1(1:2,matches(1,:));
match2 = f2(1:2,matches(2,:));



end