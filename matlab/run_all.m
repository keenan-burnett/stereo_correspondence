clear all;
close all;
Il = imread('../images/cones/cones_image_02.png');
Ir = imread('../images/cones/cones_image_06.png');
load('../images/bboxes.mat');
bbox = cones_02.bbox;
[Id] = stereo_disparity_fast(Il, Ir, bbox);
It = imread('../images/cones/cones_disp_true_02.png');
x1 = bbox(1,1);
x2 = bbox(1,2);
It = It(:,x1:x2);
figure(1);
imshow(uint8(Id));
figure(2);
imshow(uint8(It));
[N1, rms1] = stereo_disparity_score(It, Id);

Il = imread('../images/books/books_image_01.png');
Ir = imread('../images/books/books_image_05.png');
bbox = books_01.bbox;
[Id] = stereo_disparity_fast(Il, Ir, bbox);
It = imread('../images/books/books_disp_true_01.png');
x1 = bbox(1,1);
x2 = bbox(1,2);
It = It(:,x1:x2);
figure(3);
imshow(uint8(Id));
figure(4);
imshow(uint8(It));
[N2, rms2] = stereo_disparity_score(It, Id);

Il = imread('../images/teddy/teddy_image_02.png');
Ir = imread('../images/teddy/teddy_image_06.png');
bbox = teddy_02.bbox;
[Id] = stereo_disparity_fast(Il, Ir, bbox);
It = imread('../images/teddy/teddy_disp_true_06.png');
x1 = bbox(1,1);
x2 = bbox(1,2);
It = It(:,x1:x2);
figure(5);
imshow(uint8(Id));
figure(6);
imshow(uint8(It));
[N3, rms3] = stereo_disparity_score(It, Id);

avgN = (N1 + N2 + N3) / 3
avgrms = (rms1 + rms2 + rms3) / 3