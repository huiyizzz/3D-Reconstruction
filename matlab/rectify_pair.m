function [M1, M2, K1n, K2n, R1n, R2n, t1n, t2n] = ...
                        rectify_pair(K1, K2, R1, R2, t1, t2)
    % center
    c1 = -inv(K1*R1) * (K1*t1);
    c2 = -inv(K2*R2) * (K2*t2);
    % rotation
    r1 = (c1-c2) / norm(c1-c2);
    r2 = cross(R1(3,:).', r1);
    r3 = cross(r2, r1);
    R = [r1, r2, r3].';
    R1n = R;
    R2n = R;
    % new K
    K = K2;
    K1n = K;
    K2n = K;
    % new translation
    t1n = -R * c1;
    t2n = -R * c2;
    M1 = (K*R) / (K1*R1);
    M2 = (K*R) / (K2*R2);
end
