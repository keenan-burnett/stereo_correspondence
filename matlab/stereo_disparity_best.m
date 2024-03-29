function [Id] = stereo_disparity_best(Il, Ir, bbox)
% STEREO_DISPARITY_BEST Alternative stereo correspondence algorithm.
%
%  Id = STEREO_DISPARITY_BEST(Il, Ir, bbox) computes a stereo disparity image 
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

W = 3;            % Window Size
lambda = 225;     % Tune: higher = more regularization
max_d = 63;

% Convert to grayscale
if size(Il,3) > 1
    gL = rgb2gray(Il);
end
if size(Ir,3) > 1
    gR = rgb2gray(Ir);
end
gL = double(gL);
gR = double(gR);

% Compute squared difference at different disparities
[m,n] = size(gL);
Co = zeros(m,n,max_d+1);
Co(:,:,1) = (gL - gR).^2;
gR_s = gR;
for i = 2:max_d+1
    % Shift
    gR_s = [zeros(m,1) gR_s];
    gR_s = gR_s(:,1:n);
    Ci = (gL - gR_s).^2;
    % Pad left side
    L = Ci(:,i);
    L = repmat(L,1,i-1);
    Ci(:,1:i-1) = L;
    % Update Co
    Co(:,:,i) = Ci;
end

% Compute SSD using separated horizontal and vertical sum filters
H = ones(1,W);
V = ones(W,1);
C = zeros(m,n,max_d+1);
for i = 1:max_d+1
    C(:,:,i) = conv2(Co(:,:,i),H, 'same');
    C(:,:,i) = conv2(C(:,:,i),V, 'same');
end

% Dynamic Programming Global Optimization
Id = zeros(m,n);
% For each row, use DP to find globally optimal disparity values
for y = 1:m
    Sbest = zeros(max_d+1,n);
    dbest = zeros(max_d+1,n);
    Sbest(:,1) = reshape(C(1,y,:),max_d+1,1); % initialize x = 1
    % Loop over each column x starting at col 2
    for x = 2:n
        % For each disparity value at this column:
        for d = 1:max_d+1
            % Find previous x(d) which minimizes cost function
            Smin = Inf;
            dmin = 1;
            for d_1 = 1:max_d+1
                m_x_1 = Sbest(d_1,x-1);
                smooth_cost = lambda * (d - d_1)^2;
                S = m_x_1 + smooth_cost;
                if S < Smin
                    Smin = S;
                    dmin = d_1;
                end
            end
            m_x = C(y,x,d);     % Cost at this (x,d)
            Sbest(d,x) = Smin + m_x;
            dbest(d,x) = dmin;
        end 
    end
    % Now we backtrack from the end to obtain the optimal row values
    dx = dmin;
    disparity_row = zeros(1,n);
    disparity_row(n) = dx;
    for x = n:-1:2
        dx = dbest(dx,x);
        disparity_row(x-1) = dx;
    end
    Id(y,:) = disparity_row;
end

% Mask the output columns based on bbox
x1 = bbox(1,1);
x2 = bbox(1,2);
Id = Id(:,x1:x2);
%------------------
  
end