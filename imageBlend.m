%% Install VLFeat 
% type 'vl_version verbose' command to check if installed correctly
run('vlfeat-0.9.17/toolbox/vl_setup')


%% Read Images
%I1 = imread('input/transA.jpg');
%I2 = imread('input/transB.jpg');
I1 = imread('input/simA.jpg');
I2 = imread('input/simB.jpg');

%% Calculate Harris Corners
[y1, thetaI1] = myHarrisCorner(I1, 0.04, 5, 1);
[y2, thetaI2] = myHarrisCorner(I2, 0.04, 5, 1);

%% Calculate f matrix containing features location, scale and orientation
scale = 10;
fSize1 = size(y1,1);
f1 = zeros(fSize1, 4);
for i = 1 : fSize1
    tempy = y1(i,:);
    f1(i,:) = [tempy(2) tempy(1) scale thetaI1(tempy(1), tempy(2))];
end

fSize2 = size(y2,1);
f2 = zeros(fSize2, 4);
for i = 1 : fSize2
    tempy = y2(i,:);
    f2(i,:) = [tempy(2) tempy(1) scale thetaI2(tempy(1), tempy(2))];
end

%% Calculate SIFT descriptors
smoothedI1 = imgaussfilt(I1, .5, 'FilterSize', 5);
smoothedI2 = imgaussfilt(I2, .5, 'FilterSize', 5);
[F_out1, D_out1] = vl_sift(single(smoothedI1), 'frames', f1');
[F_out2, D_out2] = vl_sift(single(smoothedI2), 'frames', f2');

%% Match and draw features
M = vl_ubcmatch(D_out1, D_out2);

% Find locations of found features
ya = f1(M(1,:), 1:2);
yb = f2(M(2,:), 1:2);

% Draw found matches
figure
imshow(cat(2, I1, I2))
title('Found matches of sift descriptors');
ybDraw = yb;
ybDraw(:,1) = yb(:,1) + size(I1,2);
hold on
plot(ya(:,1), ya(:,2), 'rx', 'LineWidth', 2, 'MarkerSize', 1);  
plot(ybDraw(:,1), ybDraw(:,2), 'rx', 'LineWidth', 2, 'MarkerSize', 1);
hold on
for i = 1 : size(ybDraw,1)
    plot([ya(i,1) ybDraw(i,1)], [ya(i,2) ybDraw(i,2)]);
end
hold off

%% RANSAC
myRANSACSimilarity(I1, I2,ya, yb);
