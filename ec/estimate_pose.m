function P = estimate_pose(x, X)
% ESTIMATE_POSE computes the pose matrix (camera matrix) P given 2D and 3D
% points.
%   Args:
%       x: 2D points with shape [2, N]
%       X: 3D points with shape [3, N]
A=[];
for i = 1:size(x,2)
    trans_X = [X(:,i); 1].';
    temp = [trans_X, zeros(1,4), -x(1,i)*trans_X;
            zeros(1,4), trans_X, -x(2,i)*trans_X];
    A = [A;temp];
end
[~, ~, V] = svd(A);
P = reshape(V(:, end), 4, 3).';
end
