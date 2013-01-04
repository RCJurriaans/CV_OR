function [] = surfaceRender(pointcloud, M, Mean, img)
%img = rgb2gray(img);
% Point cloud
pointcloud = unique(pointcloud', 'rows')';
X = pointcloud(1,:)';
Y = pointcloud(2,:)';
Z = pointcloud(3,:)';

ti = -400:400;
[qx,qy] = meshgrid(ti,ti);

% Surface generation
figure;
F = TriScatteredInterp(X,Y,Z);
qz = F(qx,qy);

qxrow = reshape(qx, 1, prod(size((qx))));
qyrow = reshape(qy, 1, prod(size((qy))));
qzrow = reshape(qz, 1, prod(size((qz))));

M = M(1:2,:);

xy2 = M * [qxrow; qyrow; qzrow];
xi2 = xy2(1,:)+Mean(1);
yi2 = xy2(2,:)+Mean(2);

xi2(isnan(xi2))=1;
yi2(isnan(xi2))=1;
xi2(isnan(yi2))=1;
yi2(isnan(yi2))=1;

if(size(img,3)==3)
    imgr = img(:,:,1);
    imgg = img(:,:,2);
    imgb = img(:,:,3);
    Cr = imgr(sub2ind(size(imgr), round(yi2), round(xi2)));
    Cg = imgg(sub2ind(size(imgg), round(yi2), round(xi2)));
    Cb = imgb(sub2ind(size(imgb), round(yi2), round(xi2)));
    qc(:,:,1) = reshape(Cr,size(qx));
    qc(:,:,2) = reshape(Cr,size(qy));
    qc(:,:,3) = reshape(Cr,size(qz));
else
    C = img(sub2ind(size(img), round(yi2), round(xi2)));
    qc = reshape(C,size(qx));
    colormap gray
end

surf(qx, qy, qz, qc);

camlight right

% Render parameters
axis( [-500 500 -500 500 -500 500] );
daspect([1 1 1]);
rotate3d;

shading flat;


end