% Clear the workspace and the screen
sca;
%$close all;
%clearvars;

%% Setup the camera and video object
imaqreset
pause(0.5);
% Camera mode set to 8-bit with 664x524 resolution
vid = initializeCameraChristianCustom('pointgrey',1,'F7_BayerRG8_664x524_Mode1');
pause(0.5);

% Here we call some default settings for setting up Psychtoolbox
PsychDefaultSetup(2);

% Get the screen numbers
screens = Screen('Screens');

% Draw to the external screen if avaliable
screenNumber = max(screens);

% Define black and white
white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);

%Screen('Preference','SkipSyncTests', 0);
% Open an on screen window
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, white);

% Get the size of the on screen window
[screenXpixels, screenYpixels] = Screen('WindowSize', window);
ifi = Screen('GetFlipInterval', window);
% Get the centre coordinate of the window
[xCenter, yCenter] = RectCenter(windowRect);

SqPixsize=24;
%SqSep=SqPixsize*2;
smalldiag=min(windowRect(3:4));
end_begin_x=SqPixsize*floor(screenXpixels/SqPixsize);
startXdiag=0;
startYdiag=0;
% Make a base Rect of SqPixsize by SqPixsize pixels
baseRect = [0 0 SqPixsize SqPixsize];
diagSquares = smalldiag/SqPixsize;
% Screen X positions of our rectangles
squareYori = [startXdiag:SqSep:(smalldiag-SqPixsize)];
squareXori = squareYori;
numSq=max(size(squareYori));
squareXcen=squareXori+SqPixsize/2;
squareYcen=squareYori+SqPixsize/2;
% Set the color
Color = [0 0 0];

% Draw the rect to the screen
Screen('FillRect', window, [1 1 1], windowRect);
    
% Flip to the screen
Screen('Flip', window);
pause(0.1)

    %take an image with the camera
    % Take single frame
    tmpIm=peekdata(vid,1);
    ref=tmpIm(:,:,1);

loop=1:20;
% Make our rectangle coordinates
allRects = nan(4, numSq);
for i = 1:numSq
    allRects(:, i) = CenterRectOnPointd(baseRect, squareXcen(i), squareYcen(i));
end

proj_output=nan(4,numSq,max(loop));
waitframes = 10;

% Maximum priority level
topPriorityLevel = MaxPriority(window);
Priority(topPriorityLevel);


% Wait for a key press
%KbStrokeWait;

% Loop the animation until a key is pressed
imagedata=uint8(zeros(524, 664,max(loop)));
for i=loop
%while ~KbCheck

% Draw the rect to the screen
Screen('FillRect', window, Color, allRects);

% Flip to the screen
Screen('Flip', window);
pause(0.1)

%take an image with the camera
% Take single frame
tmpIm=peekdata(vid,1);
imagedata(:,:,i)=tmpIm(:,:,1);    

proj_output(:,:,i)=allRects;
allRects(1:2:3,:)=allRects(1:2:3,:)+SqSep;
first=allRects(1,:);
third=allRects(3,:);
first(first>=end_begin_x)=first(first>=end_begin_x)-end_begin_x;    
third(third>end_begin_x)=third(third>end_begin_x)-end_begin_x;
allRects(1,:)=first;
allRects(3,:)=third;

% Wait for a key press
%KbStrokeWait;
end
% Clear the screen
sca;
stop(vid);