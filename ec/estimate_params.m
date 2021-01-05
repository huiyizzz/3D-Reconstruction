function [K, R, t] = estimate_params(P)
% ESTIMATE_PARAMS computes the intrinsic K, rotation R and translation t from
% given camera matrix P.
    [~, ~, V] = svd(P);
    c = V(1:3, end) / V(end);
    A = flip(eye(3));
    P = A * P(:,1:3);
    [Q, R] = qr(P.');
    K = A * R.' * A;
    R = A * Q.';

    D = diag(sign(diag(K)));
    K = K * D;
    R = D * R;

    if round(det(R))==-1
        R = -R;
    end
    t = -R * c;
end
