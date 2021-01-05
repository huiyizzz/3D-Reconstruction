function F = eightpoint(pts1, pts2, M)
    pts1 = pts1/M;
    pts2 = pts2/M;
    s = [1/M, 0, 0; 0, 1/M, 0; 0, 0, 1];
    A = [];
    for i = 1:size(pts1,1)
        temp = [pts2(i,1)*pts1(i,1), pts2(i,1)*pts1(i,2), pts2(i,1), pts2(i,2)*pts1(i,1),...
                pts2(i,2)*pts1(i,2), pts2(i,2), pts1(i,1), pts1(i,2), 1];
        A = [A; temp];
    end
    [~,~,V] = svd(A);
    F = reshape(V(:,end), 3, 3).';
    [U,S,V] = svd(F);
    new_S = S;
    new_S(3,3) = 0;
    new_F = U * new_S * V.';
    refined_F = refineF(new_F, pts1, pts2);
    F = s.' * refined_F * s;
end
