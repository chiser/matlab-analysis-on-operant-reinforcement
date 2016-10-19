
sca;

% Here we call some default settings for setting up Psychtoolbox
PsychDefaultSetup(2);

% Seed the random number generator. Here we use the an older way to be
% compatible with older systems. Newer syntax would be rng('shuffle'). Look
% at the help function of rand "help rand" for more information
rand('seed', sum(100 * clock));

% Screen Number
screenNumber = max(Screen('Screens'));
%screenNumber = 1;

% Define black, white and grey
white = WhiteIndex(screenNumber);
grey = white / 2;
black = BlackIndex(screenNumber);

% Open the screen
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, black);
Screen('Flip', window);

% Query the frame duration
ifi = Screen('GetFlipInterval', window);

% Maximum priority level
topPriorityLevel = MaxPriority(window);

% Perform initial flip to gray background and sync us to the retrace:
stimProps.vbl = Screen('Flip', window);

% Numer of frames to wait before re-drawing
waitframes = 2;

% Set priority level
topPriorityLevel = 2;
Priority(topPriorityLevel);

% Translate requested speed of the grating (in cycles per second) into
% a shift value in "pixels per frame"
waitDuration = waitframes * ifi;

% Draw the rect to the screen
Screen('FillRect', window, [0 0 0], windowRect);

stimProps.black=black;
stimProps.grey=grey;
stimProps.ifi=ifi;
stimProps.screenNumber=screenNumber;
stimProps.white=white;
stimProps.window=window;
stimProps.windowRect=windowRect;
stimProps.waitframes=waitframes;
stimProps.ifi=ifi;
stimProps.waitframes = waitframes;    

    
% Check to see if stimulus is in ON or OFF part of part of pulse
%pulseChange=mod(floor((tElapsed)/(1/(stimFreq*2))),2);                        % Will be true where time elapsed > 0.5*period

while ~KbCheck
activeStim=repmat([1 0 0],1,40);
activeStim=boolean(activeStim);        
% Pulse ON if it was already on and didn't change, OR if it wasn't on and
% did change
pulseON=(activeStim);
stimCoords=900*rand(40,2);
% Generate rectangle colors
colors=zeros(sum(activeStim),3);
if any(activeStim)
red=pulseON(activeStim);
colors(red,1)=1;
end

baseRect=[0 0 50 50];
dstRects=NaN(4,size(stimCoords,1));
for i=1:size(stimCoords,1)
    dstRects(:,i)=CenterRectOnPointd(baseRect, stimCoords(i,1), stimCoords(i,2));
end

% Draw the rect to the screen
%Screen('FillRect', , colors', dstRects);
Screen('FillOval', stimProps.window, colors', dstRects);
Screen('DrawingFinished', stimProps.window);
% Flip to the screen
Screen('Flip', stimProps.window,stimProps.vbl + (stimProps.waitframes - 0.5) * stimProps.ifi, 0, 2);
end
%[stimProps.vbl,StimulusOnsetTime,FlipTimestamp,Missed Beampos]=
%stimProps.vbl
%StimulusOnsetTime
%FlipTimestamp
%Missed
%Beampos

