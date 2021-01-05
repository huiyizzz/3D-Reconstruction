close all;
clear all;
% load image
load('../data/PnP.mat');
% estimate matrices
P = estimate_pose(x, X);
[K, R, t] = estimate_params(P);
% project X onto image
projected_X = P * [X; ones(1, size(X,2))];
projected_X = projected_X(1:2,:) ./ projected_X(3,:);
% plot points
figure;
imshow(image); hold on; 
plot(x(1,:), x(2,:), 'greeno', 'MarkerSize', 15);
plot(projected_X(1,:), projected_X(2,:), 'black.', 'MarkerSize', 10);
% rotate and translate CAD
rotated_vertices = R * cad.vertices.' + t;
figure;
trimesh(cad.faces, rotated_vertices(1,:), rotated_vertices(2,:), rotated_vertices(3,:), 'edgecolor', 'blue');
% project CAD model
projected_model = P * [cad.vertices'; ones(1, size(cad.vertices,1))];
projected_model = projected_model(1:2,:) ./ projected_model(3,:);
figure; 
imshow(image); hold on;
patch('Faces', cad.faces, 'Vertices', projected_model.', 'FaceColor', 'red', 'FaceAlpha', .2, 'EdgeColor', 'None');
