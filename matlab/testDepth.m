clear all ;
% Load image and paramters
im1 = imread('../data/im1.png');
im2 = imread('../data/im2.png');
im1 = rgb2gray(im1);
im2 = rgb2gray(im2);
load('rectify.mat', 'M1', 'M2', 'K1n', 'K2n', 'R1n', 'R2n', 't1n', 't2n');

maxDisp = 20; 
windowSize = 3;
dispM = get_disparity(im1, im2, maxDisp, windowSize);

% --------------------  get depth map

depthM = get_depth(dispM, K1n, K2n, R1n, R2n, t1n, t2n);

% --------------------  Display

figure; imagesc(dispM.*(im1>40)); colormap(gray); axis image;
figure; imagesc(depthM.*(im1>40)); colormap(gray); axis image;
%%
% after rectification 
[rectIL, rectIR, bbL, bbR] = warp_stereo(im1, im2, M1, M2);
mid_img = size(im1,1)/2;
mid_rect = size(rectIL,1)/2;
rectIL = rectIL(mid_rect-mid_img+1:mid_rect+mid_img,end-size(im1,2)+1:end);
rectIR = rectIR(mid_rect-mid_img+1:mid_rect+mid_img,1:size(im1,2));
rect_dispM = get_disparity(rectIL, rectIR, maxDisp, windowSize);
rect_depthM = get_depth(rect_dispM, K1n, K2n, R1n, R2n, t1n, t2n);
figure; imagesc(rect_dispM.*(rectIL>40)); colormap(gray); axis image;
figure; imagesc(rect_depthM.*(rectIL>40)); colormap(gray); axis image;
