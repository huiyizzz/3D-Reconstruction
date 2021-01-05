close all;
clear all;
im1 = imread('../data/im1.png');
im2 = imread('../data/im2.png');
points = load('../data/someCorresp.mat');
M = points.M;
%% test 3.1.1
F = eightpoint(points.pts1, points.pts2, points.M);
displayEpipolarF(im1, im2, F);
%% test 3.1.2
pts2 = epipolarCorrespondence(im1, im2, F, points.pts1);
[coordsIM1, coordsIM2] = epipolarMatchGUI(im1, im2, F);

%% test 3.1.3
intrinsics = load('../data/intrinsics.mat'); 
E = essentialMatrix(F, intrinsics.K1, intrinsics.K2);
%% test 3.1.4
P1 = [eye(3), zeros(3,1)];
P2_candidates = camera2(E);
max_positive = 0;
correct_P2 = 0;
for n = 1:4
    P2 = P2_candidates(:,:,n);
    temp_pts3d = triangulate(intrinsics.K1*P1, points.pts1, intrinsics.K2*P2, pts2);
    err1 = 0;
    err2 = 0;
    positive = 0;
    for i = 1:size(temp_pts3d,1)
        pt1 = intrinsics.K1 * P1 * [temp_pts3d(i,:),1].';
        if pt1(3) > 0
            positive = positive + 1;
        end
        pt1 = pt1(1:2)'/pt1(3);
        err1 = err1 + norm(pt1-points.pts1(i,:));
        pt2 = intrinsics.K2 * P2 * [temp_pts3d(i,:),1].';
        if pt2(3) > 0
            positive = positive + 1;
        end
        pt2 = pt2(1:2).'/pt2(3);
        err2 = err2 + norm(pt2-pts2(i,:));
    end
    if positive >= max_positive
        max_positive = positive;
        correct_P2 = P2;
        pts3d = temp_pts3d;
        mean_err1 = err1 / size(temp_pts3d,1);
        mean_err2 = err2 / size(temp_pts3d,1);
    end
end
fprintf('Re-pojection error for pts1 is %.4f\n',mean_err1);
fprintf('Re-pojection error for pts2 is %.4f\n',mean_err2);
