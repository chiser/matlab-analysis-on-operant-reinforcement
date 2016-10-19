
% Make a sweep line of Pixwidth by the whole y axis
firstRect = [startX startY screenXpixels Pixwidth];
% Set the color and set loop to the number of Y pixels to cover the whole
% projector range

proj_range_y=zeros(1,screenYpixels);

%Allocating the projector displayed data and the camera acquisition data
%proj_output=nan(4,screenYpixels);

i=0;
jump=700;

while i<screenYpixels 
i=i+1;

if i>1
    if proj_range_y(1,i-1) && i<jump
        firstRect([2 4])=firstRect([2 4])+jump;
        i=i+jump;
        disp('detecting')
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

%Only if any blobs are detected, get the ratio length(y)/length(x) for each
%of them. If the area of the blob is bigger than 1000 pixels and the ratio
%YX bigger than 15, then this is considered the sweeping line
if ~isempty(sweepprops)
    ratioXY=bounds(3,:)./bounds(4,:);
    if any([sweepprops.Area]>1000 & ratioXY>15)
    proj_range_y(1,i)=1;
    end
end

%Add the pixels to the x coordinate so that it advances along the screen
firstRect([2 4])=firstRect([2 4])+lineSep;

end

%Store the lower and higher x coordinates of the projector that are in the
%ROI, that is within the white sheet.
min_proj_y=min(find(proj_range_y))-(Pixwidth-1);
max_proj_y=max(find(proj_range_y));
