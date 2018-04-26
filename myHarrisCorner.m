function [y, thetaI] = myHarrisCorner(I, alpha, gaussianSize, computeOrientation)
%% Calculate Gradients of image
gaussian = fspecial('gaussian', 5, .5);

% Use separability of Sobel mask
gaussianX = imfilter(gaussian, [1, 0, -1]);
imageX = imfilter(double(I), gaussianX);
imageX = imfilter(imageX, [1; 2; 1]);

gaussianY = imfilter(gaussian, [1, 2, 1]);
imageY = imfilter(double(I), gaussianY);
imageY = imfilter(imageY, [1; 0; -1]);

% Compute gradient orientation
thetaI = [];
if computeOrientation == 1
    thetaI = atan2(imageY, imageX);
end

%% Construct the structure tensor
imageXY = imageX .* imageY;
imageX2 = imageX.^2;
imageY2 = imageY.^2;

% Apply Gaussian kernel for window function
imageXY = imgaussfilt(imageXY, 'FilterSize', gaussianSize);
imageX2 = imgaussfilt(imageX2, 'FilterSize', gaussianSize);
imageY2 = imgaussfilt(imageY2, 'FilterSize', gaussianSize);

%% Compute Harris Responce value 'R'
detM = imageX2 .* imageY2 - imageXY.^2;
traceM = imageX2 + imageY2;

R = detM - alpha * traceM.^2;

%% Apply threshold
thresh = 2*5000*10000;
R(R<thresh) = 0;

%% Non-maximum Suppression
nmxSize = 5;
nmxSizeH = floor(nmxSize/2);
[rows, cols] = size(R);
for i = 1 : rows
    for j = 1 : cols
        % search through all non-zero values
        if R(i,j) == 0
            continue;
        end
        
        % Set search window
        if j - nmxSizeH <= 0, borderLeft = 1; else borderLeft = j - nmxSizeH; end
        if j + nmxSizeH >= cols, borderRight = cols; else borderRight = j + nmxSizeH; end
        if i - nmxSizeH <= 0, borderTop = 1; else borderTop = i - nmxSizeH; end
        if i + nmxSizeH >= rows, borderBottom = rows; else borderBottom = i + nmxSizeH; end
               
        % Suppress value if non-max
        for col = borderLeft : borderRight
            for row = borderTop : borderBottom
                if R(row, col) <= R(i,j) && (i ~= row || j ~= col)
                    R(row,col) = 0;
                elseif i ~= row && j ~= col
                    R(i,j) = 0;
                end
            end
        end
    end
end

% find non-zero elements of R matrix
[row, col] = find(R);
y = [row col];

figure
imshow(I)
hold on
plot(col, row, 'rx', 'LineWidth', 2, 'MarkerSize', 1);
title('Harris Corners');
hold off
end