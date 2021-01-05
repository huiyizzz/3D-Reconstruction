function dispM = get_disparity(im1, im2, maxDisp, windowSize)
% GET_DISPARITY creates a disparity map from a pair of rectified images im1 and
%   im2, given the maximum disparity MAXDISP and the window size WINDOWSIZE
    all_dispM(:,:,1) = conv2((double(im1)-double(im2)).^2, ones(windowSize), 'same');
    for d = 1:maxDisp
        temp = circshift(im2, d, 2);
        temp(:,1:d) = Inf;
        all_dispM(:,:,d+1) = conv2((double(im1)-double(temp)).^2, ones(windowSize), 'same');
    end
    [~, index] = min(all_dispM, [], 3);
    dispM = index - 1;
end
