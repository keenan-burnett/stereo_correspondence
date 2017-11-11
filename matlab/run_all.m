Il = imread('../images/books/books_image_05.png');
Ir = imread('../images/books/books_image_01.png');
load('../images/bboxes.mat');
bbox = books_01.bbox;
[Id] = stereo_disparity_fast(Il, Ir, bbox);
% It = 
% [N, rms] = stereo_disparity_score(It, Id)