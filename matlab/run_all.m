Il = imread('../images/cones/cones_image_02.png');
Ir = imread('../images/cones/cones_image_06.png');
load('../images/bboxes.mat');
bbox = books_01.bbox;
[Id] = stereo_disparity_fast(Il, Ir, bbox);
% It = 
% [N, rms] = stereo_disparity_score(It, Id)