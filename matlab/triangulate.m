function pts3d = triangulate(P1, pts1, P2, pts2 )
    pts3d = [];
    for i = 1:size(pts1,1)
        A = [pts1(i,2)*P1(3,:) - P1(2,:);
             P1(1,:) - pts1(i,1)*P1(3,:);
             pts2(i,2)*P2(3,:) - P2(2,:);
             P2(1,:) - pts2(i,1)*P2(3,:)];
        [~,~,V] = svd(A);
        curr_3d = V(1:3,end).'/V(end);
        pts3d = [pts3d; curr_3d];
    end
end
