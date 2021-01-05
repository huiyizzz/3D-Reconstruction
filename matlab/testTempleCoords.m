% A test script using templeCoords.mat
%
% Write your code here
close all;
clear all;
%% load data
im1 = imread('../data/im1.png');
im2 = imread('../data/im2.png');
points = load('../data/someCorresp.mat');
%% run eightpoint
F = eightpoint(points.pts1, points.pts2, points.M);
%displayEpipolarF(im1, im2, F);
%% get corrsponding points
temple = load('../data/templeCoords.mat');
temple_pts2 = epipolarCorrespondence(im1, im2, F, temple.pts1);
%[coordsIM1, coordsIM2] = epipolarMatchGUI(im1, im2, F);
%% essential matrix
intrinsics = load('../data/intrinsics.mat'); 
E = essentialMatrix(F, intrinsics.K1, intrinsics.K2);
%% project matrix
P1 = [eye(3), zeros(3,1)];
P2_candidates = camera2(E);
%% get correct P2
max_positive = 0;
correct_P2 = 0;
for n = 1:4
    P2 = P2_candidates(:,:,n);
    curr_pts3d = triangulate(intrinsics.K1*P1, temple.pts1, intrinsics.K2*P2, temple_pts2);
    positive = 0;
    for i = 1:size(curr_pts3d,1)
        x1 = intrinsics.K1 * P1 * [curr_pts3d(i,:),1].';
        if x1(3) > 0
            positive = positive + 1;
        end
        
        x2 = intrinsics.K2 * P2 * [curr_pts3d(i,:),1].';
        if x2(3) > 0
            positive = positive + 1;
        end
    end
    if positive >= max_positive
        max_positive = positive;
        correct_P2 = P2;
        pts3d = curr_pts3d;
    end
end
%% plot 3d points
plot3(pts3d(:,1), pts3d(:,2), pts3d(:,3), 'r.', 'MarkerSize', 10);
axis equal;
%% save extrinsic parameters
R1 = P1(:,1:3);
R2 = correct_P2(:,1:3);
t1 = P1(:,4);
t2 = correct_P2(:,4);
save('../data/extrinsics.mat', 'R1', 't1', 'R2', 't2');
