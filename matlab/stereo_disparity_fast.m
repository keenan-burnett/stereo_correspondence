function [Id] = stereo_disparity_fast(Il, Ir, bbox)
% STEREO_DISPARITY_FAST Fast stereo correspondence algorithm.
%
%  Id = STEREO_DISPARITY_FAST(Il, Ir, bbox) computes a stereo disparity image
%  from left stereo image Il and right stereo image Ir.
%
%  Inputs:
%  -------
%   Il    - Left stereo image, m x n pixels, colour or greyscale.
%   Ir    - Right stereo image, m x n pixels, colour or greyscale.
%   bbox  - Bounding box, relative to left image, top left corner, bottom
%           right corner (inclusive). Width is v.
%
%  Outputs:
%  --------
%   Id  - Disparity image (map), m x v pixels, greyscale.

% Hints:
%
%  - Loop over each image row, computing the local similarity measure, then
%    aggregate. At the border, you may replicate edge pixels, or just avoid
%    using values outside of the image.
%
%  - You may hard-code any parameters you require (e.g., disparity range) in
%    this function.
%
%  - Use whatever window size you think might be suitable.
%
%  - Don't optimize for runtime, optimize for clarity.
%
%  - If you think it will be useful, you may use functions from the Image
%    Processing toolbox for this project.

%--- FILL ME IN ---

W = 7;
p = floor(W/2);
max_d = 63;

shiftX = bbox(1,1);
shiftY = bbox(2,1);

if size(Il,3) > 1
    gL = rgb2gray(Il);
end
if size(Ir,3) > 1
    gR = rgb2gray(Ir);
end

gL = double(gL);
gR = double(gR);

bw = mask(gL, bbox);

Id = zeros(size(gL));

gL = pad_replicate(gL, p);
gR = pad_replicate(gR, p);
bw = pad_replicate(bw,p);   % breaks if bbox = size of image

[h,w] = size(gL);

% Loop over each pixel in left image, find it's match using local SAD
[row,col] = find(bw);
[len,~] = size(row);
for iter = 1:len
    i = col(iter);
    j = row(iter);

% for i = p+1:h-p
%     for j = p+1:w-p        
        % Search for the best pixel match using SAD
        patchL = gL(i-p:i+p,j-p:j+p);
        
        ssd = zeros(1,w-2*p);
        indices = p+1:w-p;
        q = 1;
        for k = p+1:w-p
            patchR = gR(i-p:i+p,k-p:k+p);
            diff = abs(patchL - patchR);
            ssd(q) = sum(diff(:));
            q = q + 1;
        end
        
        [~,idx] = min(ssd);
        best = indices(1,idx);
        disparity = abs(best - j);
        Id(i,j) = disparity;
%     end
end

Id = Id(p+1:h-p,p+1:w-p);
maximum = max(Id(:));
imshow(uint8(Id * 255 / maximum));
        

  
%------------------
  
end

function out = mask(img, bbox)
    out = zeros(size(img));
    x1 = bbox(1,1);
    y1 = bbox(2,1);
    x2 = bbox(1,2);
    y2 = bbox(2,2);
    out(y1:y2,x1:x2) = 1;
end

function out = pad_replicate(img, P)
    [m,n] = size(img);
    L = img(:,1);
    R = img(:,n);
    L = repmat(L,1,P);
    R = repmat(R,1,P);
    out = [L img R];
    T = out(1,:);
    B = out(m,:);
    T = repmat(T,P,1);
    B = repmat(B,P,1);
    out = [T ; out ; B];
end


