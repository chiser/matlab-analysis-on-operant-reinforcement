
mazeNum=22;
selected_pixcam_ori=downward_middle(mazeNum,:);
selected_pixcam_end=centers(mazeNum+48,:);

%%The projector needs to cover the whole area of the Ymazes. Otherwise
%%there will be instances where it will try to project outside of the
%%pixels range (negative or over the max) and wont throw an error but
%%display anything instead
%proj_ori=[round(xfit(selected_pixcam_ori(1))), round(yfit(selected_pixcam_ori(2)))]
%proj_end=[round(xfit(selected_pixcam_end(1))), round(yfit(selected_pixcam_end(2)))]
projX=[round(xfit(selected_pixcam_ori(1))),round(xfit(selected_pixcam_end(1)))]
projY=[round(yfit(selected_pixcam_ori(2))),round(yfit(selected_pixcam_end(2)))]
Rect_coord=[cat(2,min(projX)-5,min(projY)-3,max(projX)+5,max(projY)+3)];

%%This is for making the orientation vector of the arms so that I can make
%%an orthogonal vector to wide the stimulation area

%stim_ori=[max(projX)-min(projX) max(projY)-min(projY)]
%widening_vector=[stim_ori(2) -stim_ori(1)]
%widening_vector*0.1

% Here we call some default settings for setting up Psychtoolbox
PsychDefaultSetup(2);

% Get the screen numbers
screens = Screen('Screens');

% Draw to the external screen if avaliable
screenNumber = max(screens);

% Define black and white
white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);
grey = white / 2;

% Open an on screen window
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, black);

% Get the size of the on screen window
[screenXpixels, screenYpixels] = Screen('WindowSize', window);

% Get the centre coordinate of the window
[xCenter, yCenter] = RectCenter(windowRect);
    
% Define refresh rate.
ifi = Screen('GetFlipInterval', window);
    
% Set the colors of each of our squares
Color = [1 0 0];

% Number of sides for our polygon
%numSides = 3;

% Angles at which our polygon vertices endpoints will be. We start at zero
% and then equally space vertex endpoints around the edge of a circle. The
% polygon is then defined by sequentially joining these end points.
%anglesDeg = linspace(0, 360, numSides + 1);
%anglesRad = anglesDeg * (pi / 180)+0.5;


%%%%%% I have to change this baseRect!! it is nowhere specified


maxDiameter = max(baseRect);
% X and Y coordinates of the points defining out polygon, centred on the
% centre of the screen
%yPosVector = sin(anglesRad) .* maxDiameter + (min(projY)+max(projY))/2;
%xPosVector = cos(anglesRad) .* maxDiameter + (min(projX)+max(projX))/2;
    
% Cue to tell PTB that the polygon is convex (concave polygons require much
% more processing)
%isConvex = 1;

% Draw the rect to the screen
%Screen('FillPoly', window, Color, [xPosVector; yPosVector]', isConvex);
        
    
% Draw the rect to the screen
Screen('FillOval', window, Color, Rect_coord, maxDiameter);

% Draw the rect to the screen
%Screen('FillRect', window, Color, Rect_coord);

% Flip to the screen
Screen('Flip', window);

% Wait for a key press
KbStrokeWait;

% Clear the screen
sca;