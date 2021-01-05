function [pts2] = epipolarCorrespondence(im1, im2, F, pts1)
    pad = 8;
    padded_im1 = padarray(im1, [pad pad], 0, 'both');
    padded_im2 = padarray(im2, [pad pad], 0, 'both');
    pts2 = [];
    for i = 1:size(pts1, 1)
        x1 = pts1(i,1);
        y1 = pts1(i,2);
        line = F * [x1; y1; 1];
        window_im1 = double(padded_im1(y1:y1+2*pad,x1:x1+2*pad));
        min_distance = Inf;
        for j = 1:size(im2, 2)
            y = round((-line(1)*j-line(3)) / line(2));
            window_im2 = double(padded_im2(y:y+2*pad,j:j+2*pad));
            distance = norm(window_im2 - window_im1);
            if distance < min_distance
                min_distance = distance;
                candidate = [j, y];
            end
        end
        pts2 = [pts2; candidate];
    end
end

