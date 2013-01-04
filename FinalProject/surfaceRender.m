function [] = surfaceRender(pointcloud, M, Mean, img)
%img = rgb2gray(img);
% Point cloud
pointcloud = unique(pointcloud', 'rows')';
X = pointcloud(1,:)';
Y = pointcloud(2,:)';
Z = pointcloud(3,:)';

ti = -300:300;
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
    Cr = diag(img(floor(yi2), floor(xi2),1));
    Cg = diag(img(floor(yi2), floor(xi2),2));
    Cb = diag(img(floor(yi2), floor(xi2),3));
    qc(:,:,1) = reshape(Cr,size(qx));
    qc(:,:,2) = reshape(Cr,size(qy));
    qc(:,:,3) = reshape(Cr,size(qz));
else
    C = img(sub2ind(size(img), round(yi2), round(xi2)));
    qc = reshape(C,size(qx));
    colormap gray
end

surf(qx, qy, qz, qc);

% Render parameters
axis( [-300 300 -300 300 -300 300] );
daspect([1 1 1]);
rotate3d;
%shading interp;
shading flat;
%camlight left;
%lighting phong;


end