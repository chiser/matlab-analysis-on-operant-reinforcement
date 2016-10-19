% Get the centre coordinate of the window
[xCenter, yCenter] = RectCenter(windowRect);

%% Set the length of the square in pixels and the separation to the following square
SqPixsize=12;
SqSep=SqPixsize*2;

%It is not the smallest diagonal, rather the Y range
smalldiag=(max_proj_y-min_proj_y)+1;

%Storing how many whole cicles (square-blank) fit in the projector x coordinate
%within the ROI
end_begin_x=SqSep*floor((max_proj_x-min_proj_x)/SqSep);

%Starting projector coordinates within the ROI
startXdiag=min_proj_x;
startYdiag=min_proj_y;

% Make a base Rect of SqPixsize by SqPixsize pixels
baseRect = [0 0 SqPixsize SqPixsize];

%Number of squares fitting from begining to end of the Y coordinate. Y is
%allways the reference (fixed Y coordinates)
diagSquares = floor(smalldiag/SqPixsize);

% Get all the X and Y positions of our rectangles
squareXori = (startXdiag-1):SqSep:(max_proj_x-SqPixsize);
squareYori = (startYdiag-1):SqSep:(max_proj_y-SqPixsize);

% In case the ROI X axis is shorter, put the last squares that doesnt fit
% at the end, at the beginning of the ROI (left).
if (abs(length(squareXori)-length(squareYori)))==1
    squareXori(end+1)=squareXori(end)+SqSep-end_begin_x;
elseif (abs(length(squareXori)-length(squareYori)))==2
    squareXori(end+1)=squareXori(end)+SqSep-end_begin_x;
    squareXori(end+1)=squareXori(end-1)+2*SqSep-end_begin_x;
else
    ch=abs(length(squareXori)-length(squareYori));
    for oo=1:ch
    squareXori(end+1)=squareXori(end-(oo-1))+oo*SqSep-end_begin_x;
    end
end

%Get the number square that will be displayed and calculate their centers
numSq=max(size(squareYori));
squareXcen=squareXori+SqPixsize/2;
squareYcen=squareYori+SqPixsize/2;

% Make our initial rectangle coordinates
allRects = nan(4, numSq);
for i = 1:numSq
    allRects(:, i) = CenterRectOnPointd(baseRect, squareXcen(i), squareYcen(i));
end

if max(max(allRects([1 3],:)))>(end_begin_x+min_proj_x)
allRects([1 3],allRects(3,:)>(end_begin_x+min_proj_x))=...
    repmat([min_proj_x min_proj_x+SqPixsize]',1,sum(allRects(3,:)>(end_begin_x+min_proj_x)));
end
% Set the color
Color = [0 0 0];

%Set the loop to the number of iterations we want the sweeping
loop=1:30;
thres=20;
% Maximum priority level
topPriorityLevel = MaxPriority(window);
Priority(topPriorityLevel);

% Allocate the camera and the projector data
proj_output=nan(4,numSq,max(loop));
reg_bounds=nan(4,numSq,max(loop));

fh=imshow(blank_ref);

%Start the sweeping
for i=loop

% Draw the rect to the screen
Screen('FillRect', window, Color, allRects);

% Flip to the screen
Screen('Flip', window);
pause(0.2)

% Take single frame
tmpIm=peekdata(vid,1);
imagedata=tmpIm(:,:,3);    

% Saved what is displayed
proj_output(:,:,i)=allRects;

%% Extract coordinates from image

rectIm=blank_ref-imagedata>thres;
reg_props = regionprops(rectIm,'Area','BoundingBox','Centroid');

%% Exclude ROIs that are too large or too small. 
reg_Areas = [reg_props.Area];
reg_BoundingBoxes = reshape([reg_props.BoundingBox],4,length(reg_Areas));

median_reg=median(reg_Areas);
areaThresh=reg_Areas>1.4*median_reg|reg_Areas<0.6*median_reg;
%low=reg_Areas<0.25*median_reg;
%high=reg_Areas>2*median_reg;
WHratio=reg_BoundingBoxes(3,:)./reg_BoundingBoxes(4,:);
WHratio_thresh=WHratio<0.5|WHratio>2;
exclude_reg= areaThresh|WHratio_thresh;
size(reg_props,1)
reg_props(exclude_reg)=[];
reg_cen=reshape([reg_props.Centroid],2,length(reg_props));

% Check to see if numBlobs-numExclude=numSquares
if size(reg_props,1)==numSq

reg_Areas = reg_Areas(~exclude_reg);
reg_BoundingBoxes = reg_BoundingBoxes(:,~exclude_reg);

%% Sort coords to match camera rectangles to projector rectangles

[v,j]=sort(reg_BoundingBoxes(2,:));
reg_bounds(:,1:size(reg_BoundingBoxes,2),i)=reg_BoundingBoxes(:,j);
reg_bounds(3,:,i)=reg_bounds(1,:,i)+reg_bounds(3,:,i);
reg_bounds(4,:,i)=reg_bounds(2,:,i)+reg_bounds(4,:,i);
else
reg_bounds(:,:,i)=NaN;
end

imshow(rectIm);
hold on
plot(reg_cen(1,:),reg_cen(2,:),'o');
hold off
drawnow


%% Update squares to display

% Shift the squares to the right by adding the specified SqSep value just
% to the X coordinate
allRects(1:2:4,:)=allRects(1:2:4,:)+SqSep;

% This is needed in order to put all the squares that shift out of the ROI
% back to the ROI starting again from the left side.
% TODO: this shifting only works in some cases. I have to find a better
% algorithm to decide when the square move to the beginning
if max(max(allRects([1 3],:)))>(end_begin_x+min_proj_x)
allRects([1 3],allRects(3,:)>(end_begin_x+min_proj_x))=...
    repmat([min_proj_x min_proj_x+SqPixsize]',1,sum(allRects(3,:)>(end_begin_x+min_proj_x)));
end

%{
first=allRects(1,:);
third=allRects(3,:);

if (third>(end_begin_x+min_proj_x))
%first(first>=(end_begin_x+add))=first(first>=(end_begin_x+add))-end_begin_x;

first(first>=(end_begin_x+min_proj_x))=min_proj_x; 
third(third>(end_begin_x+min_proj_x))=min_proj_x+SqPixsize;
end

allRects(1,:)=first;
allRects(3,:)=third;
%}

end

if(any(isnan(reg_bounds)))
    warning('there are nans in reg_bounds, which means missing detected squares');
end
max_x_cam=max(max(max(reg_bounds(1:2:4,:,:))));
min_x_cam=min(min(min(reg_bounds(1:2:4,:,:))));
max_y_cam=max(max(max(reg_bounds(2:2:4,:,:))));
min_y_cam=min(min(min(reg_bounds(2:2:4,:,:))));

%%Sorting them according to the first Y-axis coordinate
for i=loop
reg_bounds(:,:,i)=transpose(sortrows(transpose(reg_bounds(:,:,i)),2));
end

cam_input=reg_bounds;

x_cam=cam_input([1 3],:,:);
x_cam=x_cam(:);
y_cam=cam_input([2 4],:,:);
y_cam=y_cam(:);
x_proj=proj_output([1 3],:,:);
x_proj=x_proj(:);
y_proj=proj_output([2 4],:,:);
y_proj=y_proj(:);

% Delete any NaNs
nanExclude=isnan(x_cam);
x_cam(nanExclude)=[];
y_cam(nanExclude)=[];
x_proj(nanExclude)=[];
y_proj(nanExclude)=[];

%{
x_cam=reshape(x_cam,numel(x_cam),1);
y_cam=reshape(y_cam,numel(y_cam),1);
x_proj=reshape(x_proj,numel(x_proj),1);
y_proj=reshape(y_proj,numel(y_proj),1);
%}
[xfit,gofx]=fit(cat(2,x_cam,y_cam), x_proj , 'poly55','Normalize','on');
plot(xfit,cat(2,x_cam,y_cam), x_proj)
gofx

[yfit,gofy]=fit(cat(2,x_cam,y_cam), y_proj , 'poly55');
figure();
plot(yfit,cat(2,x_cam,y_cam), y_proj)
gofy
%[xfit gofx]=fit(x_cam, x_proj , 'poly2');
%[yfit gofy]=fit(y_cam, y_proj, 'poly2');



%{
cam4plot=reshape(reg_bounds,4,numSq*max(loop));
proj4plot=reshape(proj_output,4,numSq*max(loop));
plot(y_cam,y_proj,'ro')
hold on
plot(yfit)
hold off

figure();
plot(x_cam,x_proj,'bo')
hold on
plot(xfit)
hold off
%}
if (gofx.rsquare<0.99 || gofy.rsquare<0.99)
    warning ('the r squared is below 0.99');
end

min_cam_x=round(min(min(cam_input(1:2:4,:,:))));
max_cam_x=round(max(max(cam_input(1:2:4,:,:))));
min_cam_y=round(min(min(cam_input(2:2:4,:,:))));
max_cam_y=round(max(max(cam_input(2:2:4,:,:))));

%% This can be used for the array indexing method
%cam_values_x=transpose(round(min_cam_x:max_cam_x));
%cam_values_y=transpose(round(min_cam_y:max_cam_y));
%proj_values_x=round(xfit(min_cam_x:max_cam_x));
%proj_values_y=round(yfit(min_cam_y:max_cam_y));

%fly_cam_pos=[300,200];

%[minX indexX]=min(abs(cam_values_x-fly_cam_pos(1)));
%[minY indexY]=min(abs(cam_values_y-fly_cam_pos(2)));
%fly_proj_pos=[proj_values_x(indexX),proj_values_y(indexY)]

% Clear the screen
sca;
stop(vid);

%for i=1:40
%plot(reg_bounds(:,:,i)','ro')
%pause(1)
%end