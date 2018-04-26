% Find best translation between 2 images
function y = myRANSACAffine(I1, I2, pointsFirst, pointsSecond)
thresh = 5;

%% check 100 random pairs
numOfPoints = size(pointsFirst, 1);
loopNum = numOfPoints;
if loopNum > 100
    loopNum = 100;
end

maxOffNumber = 0;
maxOffIdx = 0;
maxOffIdx2 = 0;
maxOffIdx3 = 0;
for i = 1 : loopNum
    % find temp offset
    randNum = randi([1 numOfPoints],3,1);
    if randNum(1) == randNum(2) || randNum(1) == randNum(3) || randNum(2) == randNum(3)
        loopNum = loopNum + 1
        continue;
    end
    x0 = pointsSecond(randNum(1),1); y0 = pointsSecond(randNum(1),2);
    x1 = pointsSecond(randNum(2),1); y1 = pointsSecond(randNum(2),2);
    x2 = pointsSecond(randNum(3),1); y2 = pointsSecond(randNum(3),2);
    A = [x0 y0 1 0 0 0; 0 0 0 x0 y0 1; x1 y1 1 0 0 0; 0 0 0 x1 y1 1; x2 y2 1 0 0 0; 0 0 0 x2 y2 1];
    b = [pointsFirst(randNum(1),1); pointsFirst(randNum(1),2); pointsFirst(randNum(2),1); pointsFirst(randNum(2),2); pointsFirst(randNum(3),1); pointsFirst(randNum(3),2)];
    x = A\b;
    
    % find similarity transform matrix
    M = [x(1) x(2) x(3); x(4) x(5) x(6)]; 
    
    % find consensus set size
    newFirst = M * [pointsSecond'; ones(1, numOfPoints)];
    
    errorX = abs(newFirst(1,:)' - pointsFirst(:,1));
    errorY = abs(newFirst(2,:)' - pointsFirst(:,2));
    errorX = double(errorX<=thresh);
    errorY = double(errorY<=thresh);
    tempNum = errorX' * errorY;
    
    
    % Check if best set
    if tempNum > maxOffNumber
        maxOffNumber = tempNum;
        maxOffIdx = randNum(1);
        maxOffIdx2 = randNum(2);
        maxOffIdx3 = randNum(3);
    end
end

%% Find consensus set corresponding points
x0 = pointsSecond(randNum(1),1); y0 = pointsSecond(randNum(1),2);
x1 = pointsSecond(randNum(2),1); y1 = pointsSecond(randNum(2),2);
x2 = pointsSecond(randNum(3),1); y2 = pointsSecond(randNum(3),2);
A = [x0 y0 1 0 0 0; 0 0 0 x0 y0 1; x1 y1 1 0 0 0; 0 0 0 x1 y1 1; x2 y2 1 0 0 0; 0 0 0 x2 y2 1];
b = [pointsFirst(randNum(1),1); pointsFirst(randNum(1),2); pointsFirst(randNum(2),1); pointsFirst(randNum(2),2); pointsFirst(randNum(3),1); pointsFirst(randNum(3),2)];
x = A\b;

% find similarity transform matrix
M = [x(1) x(2) x(3); x(4) x(5) x(6)]; 
y = M;

% find consensus set size
newFirst = M * [pointsSecond'; ones(1, numOfPoints)];

errorX = abs(newFirst(1,:)' - pointsFirst(:,1));
errorY = abs(newFirst(2,:)' - pointsFirst(:,2));

ya = zeros(maxOffNumber, 2);
yb = zeros(maxOffNumber, 2);
j = 1;
for i = 1 : numOfPoints
    if errorX(i) <= thresh && errorY(i) <= thresh
        ya(j,:) = pointsFirst(i,:); 
        yb(j,:) = pointsSecond(i,:);
        j = j + 1;
    end
end

%% Plot best set
figure
imshow(cat(2, I1, I2))
percentOfTotalMatches = maxOffNumber/numOfPoints * 100;
title(['Best found consensus set: ', num2str(percentOfTotalMatches), '% of total matches']);
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

%% Warp two images (translation)
%create Reference2D object
Rout = imref2d(size(I2));

% Apply translation and warp
% affine2d takes input as -> [s*cos8 s*sin8 0; -s*sin8 s*cos8 0; t1 t2 1]
% => tform = M'
tform = affine2d([x(1) x(4) 0; x(2) x(5) 0; x(3) x(6) 1]);
I2new = imwarp(I2, tform,'outputView', Rout);
combinedI = imfuse(I1,I2new,'blend','Scaling','joint');

figure
imshow(combinedI)

end