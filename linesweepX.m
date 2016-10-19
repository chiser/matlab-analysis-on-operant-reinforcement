% Clear the workspace and the screen
sca;

%% Setup the camera and video object
imaqreset
pause(0.2);
% Camera mode set to 8-bit with 664x524 resolution
vid = initializeCamerasweep('pointgrey',1,'F7_BayerRG8_664x524_Mode1');
pause(0.2);

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

% Draw the rect to the screen
Screen('FillRect', window, [1 1 1], windowRect);
    
% Flip to the screen
Screen('Flip', window);
%A reasonable time is needed in order to get a proper blank. Otherwise the
%whole following processing might not work that well
pause(0.3)

% Take single frame
blank_ref=peekdata(vid,1);
blank_ref=blank_ref(:,:,3);

figure
while get(handles.checkbox1,'value')~=1;

proj_bounds_thresh=get(handles.slider1,'value');
improps=regionprops(blank_ref>proj_bounds_thresh,'BoundingBox','Area');
[v proj_blob]=sort([improps.Area]);
proj_blob=proj_blob(end);
proj_rect=improps(proj_blob).BoundingBox;

imshow(blank_ref>proj_bounds_thresh)
shg
hold on
rectangle('Position',proj_rect,'EdgeColor','r')
hold off
drawnow
end
%Store the lower and higher x coordinates of the projector that are in the
%ROI, that is within the white sheet.
min_cam_x=proj_rect(1);
max_cam_x=proj_rect(3)+min_cam_x;
min_cam_y=proj_rect(2);
max_cam_y=proj_rect(4)+min_cam_y;


%% Set the width of the line in pixels, the separation to the following line and the starting points
Pixwidth=5;
lineSep=1;
startX=0;
startY=0;

% Make a sweep line of Pixwidth by the whole x axis
firstRect = [startX startY Pixwidth screenYpixels];
% Set the color and set loop to the number of X pixels to cover the whole
% projector range
Color = [0 0 0];

% Maximum priority level
topPriorityLevel = MaxPriority(window);
Priority(topPriorityLevel);

%Set the threshold for the binary image and allocate the vector that shows
%where is the sweeping line detected
thres=4;
proj_range_x=zeros(1,screenXpixels);

%Allocating the projector displayed data and the camera acquisition data
%proj_output=nan(4,max(loop));
figure();
i=0;
jump=800;
%Loop to sweep the line across the X axis
while i<(screenXpixels -100) 
i=i+1;

if i>1
    if proj_range_x(1,i-1) && i<jump
        firstRect([1 3])=firstRect([1 3])+jump;
        i=i+jump;
    end  
end

% Draw the rect to the screen
Screen('FillRect', window, Color, firstRect);

% Flip to the screen
Screen('Flip', window);

% Take single frame and store it in location
im=peekdata(vid,1);
tmpIm=im(:,:,3);

%Creating a binary image    
substr=(blank_ref-tmpIm)>thres;

%Extract the features of the detected blobs
sweepprops=regionprops(substr,'Area','BoundingBox','Centroid');

%Set the Bounding boxes in a format for further processing
bounds=reshape([sweepprops.BoundingBox],4, length(sweepprops));
exclude_bounds=bounds(1,:)<min_cam_x|(bounds(1,:)+bounds(3,:))>max_cam_x;
sweepprops(exclude_bounds)=[];
bounds(:,exclude_bounds)=[];

%Only if any blobs are detected, get the ratio length(y)/length(x) for each
%of them. If the area of the blob is bigger than 1000 pixels and the ratio
%YX bigger than 15, then this is considered the sweeping line
if ~isempty(sweepprops)
    ratioYX=bounds(4,:)./bounds(3,:);
    if any([sweepprops.Area]>500 & ratioYX>10)
    proj_range_x(1,i)=1;
    end
end

firstRect([1 3])=firstRect([1 3])+lineSep;
%{
imshow(substr);
if ~isempty(sweepprops)
    sweep_cen=[sweepprops.Centroid];
hold on
plot(sweep_cen(:,1),sweep_cen(:,2),'o');
hold off
drawnow
shg
end
%}
%Add the pixels to the x coordinate so that it advances along the screen
   

end

%Store the lower and higher x coordinates of the projector that are in the
%ROI, that is within the white sheet.
min_proj_x=min(find(proj_range_x))-(Pixwidth-1);
max_proj_x=max(find(proj_range_x));
