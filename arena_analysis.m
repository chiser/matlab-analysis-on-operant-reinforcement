fly=4;
speed_thres=4;
mode_number=4;
seg_duration=480;
segment_number=max(flyTracks.tStamps)/seg_duration;
exp_duration=max(flyTracks.tStamps);

%Histograms for the intersampling intervals
%plot(diff(flyTracks.tStamps),'ro')
plot(histc(diff(flyTracks.tStamps),linspace(0,0.1,100))./sum(histc(diff(flyTracks.tStamps),linspace(0,0.1,100))))
%nhist(diff(flyTracks.tStamps))
% xlabel('Inter-Sampling Interval (ms)')
% ylabel('Probability of the given IFI')
% title('Sampling Overview')

%% Heat map
%{
allflies_x=cat(1,flyTracks.centroid(:,1,1:nFlies))

for fly=1:length(flyTracks.centroid(1,1,:))
bins = 50;
xbins = linspace(min(flyTracks.centroid(:,1,fly)),max(flyTracks.centroid(:,1,fly)),bins);
ybins = linspace(min(flyTracks.centroid(:,2,fly)),max(flyTracks.centroid(:,2,fly)),bins);
[nx,idxx] = histc(flyTracks.centroid(:,1,fly),xbins);
[ny,idxy] = histc(flyTracks.centroid(:,2,fly),ybins);
out = accumarray([idxx,idxy], 1);
figure(2);
hold on;
h=imagesc(xbins,ybins,flipud(out));
colorbar; 
axis([min(xbins) max(xbins) min(ybins) max(ybins)]);
hold off;
shg;
pause(1);
end
%}
%% Speed characterization
%{
%exclude=ind_speed<0.8;
exclude=flyTracks.speed<0.08;
%flyTracks.orientation=flyTracks.orientation(:,~exclude);
flyTracks.ROI_coords=flyTracks.ROI_coords(~exclude,:);
flyTracks.ROIcenters=flyTracks.ROIcenters(~exclude,:);
flyTracks.nFlies=flyTracks.nFlies-sum(exclude);
flyTracks.centroid=flyTracks.centroid(:,:,~exclude);
flyTracks.rPos=flyTracks.rPos(~exclude,:);
flyTracks.speed=flyTracks.speed(~exclude,:);
flyTracks.mu=flyTracks.mu(~exclude,:);
flyTracks.angHist=flyTracks.angHist(:,~exclude);
%}
% speed=sqrt(squeeze(sum(diff(flyTracks.centroid(1:15:end,:,:)).^2,2)))./repmat(diff(flyTracks.tStamps(1:15:end,:)),1,flyTracks.nFlies);
speed=flyTracks.speed2;
speed(speed>40)=10;

figure
plot(histcounts(speed,linspace(0,1,40)))
title('Histogram of speed distribution')

ind_speed=mean(speed,1);
% speed(speed>30)=0;
% plot(histcounts(speed(:,6),linspace(0,1,80)))
figure
distributionPlot(speed);
xlabel('Fly number')
ylabel('Speed in pix/s')
title('Speed distribution per fly')

figure
distributionPlot(mean(speed,1));
ylabel('Speed in pix/s')
title('Average speed')

figure
mseb(1:length(mean(speed,2)),mean(speed,2)',std(speed,1,2)')
xlabel('Time')
ylabel('Speed in pix/s')
title('Overall speed across time')

speed_seg=linspace(0,length(speed),segment_number+1);
a=discretize(1:length(speed),speed_seg);
bottomLine = mean(speed,2)';
topLine = mean(speed,2)';
middleLine = mean(speed,2)';
% speed_sort=cell(length(unique(a)),1);
speed_sort=nan(ceil(length(topLine)/length(unique(a))),length(unique(a)));
speed_sort2=nan(ceil(length(topLine)/length(unique(a))),length(unique(a)),length(speed(1,:)));
seg_stamp=nan(ceil(length(topLine)/length(unique(a))),length(unique(a)));
stamp=diff(flyTracks.tStamps(1:15:end));
% stamp=diff(flyTracks.tStamps(1:14:end));
%stamp(1:round(length(stamp)/length(stamp)-length(speed):end))=[];
% stamp=cat(1,[0],stamp,repmat(mean(stamp),abs(length(speed)-length(stamp)),1));
stamp=cat(1,[0],stamp);
for i=1:max(a)
%     seg_speed(i)=mean(speed(a==i)); This is wrong because it takes only
%     one fly if I dont index speed for all of them
    seg_length=length(speed(a==i));
    seg_stamp(1:seg_length,i)=stamp(a==i);
%     speed_sort{i}=topLine(a==i);
    speed_sort(1:seg_length,i)=topLine(a==i);
    for oo=1:length(speed(1,:))
        speed_sort2(1:seg_length,i,oo)=speed(a==i,oo);
    end
end

moving=nan(length(seg_stamp(1,:)),length(speed(1,:)));
for i=1:length(seg_stamp(1,:))
    u=seg_stamp(:,i);
    for oo=1:length(speed(1,:))
    o=speed_sort2(:,i,oo);
    h=sum(u(o>speed_thres));
    moving(i,oo)=h;
    end
end

figure
aboxplot(speed_sort)
xlabel('Segment')
ylabel('Speed in pix/s')
title('Speed across different segments')

%% Activity time

stamp=repmat(stamp,1,length(speed(1,:)));
active=stamp(speed>speed_thres);
act_time=sum(stamp(speed>speed_thres));
inact_time=sum(stamp(speed<speed_thres));
act_time_across=sum(stamp(speed>speed_thres),1);
inact_time_across=sum(stamp(speed<speed_thres),1);

Activity=cat(1,act_time,inact_time);
figure
hb=bar(Activity);
set(hb(1), 'FaceColor','b')
% set(hb(2), 'FaceColor','b')
ylabel('Stamps count')
title('Active vs inactive time')
set(gca,'XTickLabel',{'Active', 'Inactive'})


time_seg=seg_duration*ones(size(moving));
activity=cat(2,mean(moving,2),mean(time_seg-moving,2));
figure
hb=bar(activity,'stacked');
set(hb(1), 'FaceColor','b')
% set(hb(2), 'FaceColor','b')
xlabel('Active vs Inactive')
ylabel('Stamps count')
title('Active vs inactive time')
legend('Active','Inactive')
%{
%This does not work because it averages across flies, which destroys the
speed threshold

for i=1:length(speed_sort(1,:))
    r=speed_sort(:,i);
    act_seg(i)=sum(r(r>speed_thres));
    inact_seg(i)=sum(r(r<speed_thres));
end

activity=cat(1,act_seg,inact_seg);
figure
hb=bar(activity);
set(hb(1), 'FaceColor','b')
% set(hb(2), 'FaceColor','b')
xlabel('Active vs Inactive')
ylabel('Stamps count')
title('Active vs inactive time')
set(gca,'XTickLabel',{'Active', 'Inactive'})
%}

%% Effect size
seg_speed=mean(speed_sort,1,'omitnan');
for i=2:2:length(speed_sort(1,:))
    if i~=length(speed_sort(1,:)) 
        effect_size(i/2)=seg_speed(i)-mean(cat(1,seg_speed(i-1),seg_speed(i+1)));
    else
        effect_size(i/2)=seg_speed(i)-seg_speed(i-1);
    end
end

effect_diff=diff(effect_size);
first_effect=mean(effect_size(1:2:end));
sec_effect=mean(effect_size(2:2:end));

if first_effect-sec_effect>0
    effect_diff(1:2:end)=-1*effect_diff(1:2:end);
elseif first_effect-sec_effect<0
     effect_diff(2:2:end)=-1*effect_diff(2:2:end);
else
    warning('No effect of speed mode reinforcement');
end

figure
plot(effect_size)
xlabel('Segment')
ylabel('Effect (a.u.)')
title('Effect size compared to baseline')

figure
plot(effect_diff)
xlabel('Segment')
ylabel('Effect (a.u.)')
title('Effect size across the two reinforcement methods')

%% Change effect size per time lit
lit=moving;
lit(1:2:end,:)=0;
lit(4:4:end,:)=time_seg(4:4:end,:)-moving(4:4:end,:);
lit_time=mean(cumsum(lit(2:2:end,:)),2);

lit_fit=fit(lit_time,effect_size', 'poly1');

figure
plot(lit_fit,lit_time,effect_size)
xlabel('Segment')
ylabel('Effect (a.u.)')
title('Effect size across different segments')

lit_fit_diff=fit(lit_time(1:(end-1)),effect_diff', 'poly1');

figure
plot(lit_fit_diff,lit_time(1:(end-1)),effect_diff)
xlabel('Segment')
ylabel('Effect (a.u.)')
title('Effect size across different segments')

%% Plotting the speed in the segments
bottomLine = mean(speed,2)';
topLine = mean(speed,2)';
middleLine = mean(speed,2)';
bottomLine(mod(a,4)==0 | mod(a,4)==2) = NaN;
topLine(mod(a,4)==1 | mod(a,4)==2 | mod(a,4)==3) = NaN;
middleLine(mod(a,4)==0 | mod(a,4)==3 | mod(a,4)==1) = NaN;

figure
plot(bottomLine,'b');
hold on
plot(topLine,'r');
plot(middleLine,'c');
xlabel('Time')
ylabel('Speed in pix/s')
title('Overall speed across time')
hold off

x=nan(2*length(speed_seg),1);
x(1:2:2*length(speed_seg)) = speed_seg;
x(2:2:2*length(speed_seg)) = speed_seg;
xx(1:2:4*length(speed_seg)) = x;
xx(2:2:4*length(speed_seg)) = x;
xx=xx(3:(end-2));
y = repmat([0 18 18 0]',segment_number,1);

patch(xx',y,'red','FaceAlpha',.3)

figure
aboxplot(cat(2,bottomLine',topLine',middleLine'))
xlabel('Reinforcement type')
ylabel('Speed in pix/s')
title('Reinforcing moving vs stopping')
set(gca,'XTickLabel',{'baseline','lit when moving','lit when stopping'})

baselinemeanspeed=mean(bottomLine,'omitnan');
litmovingmeanspeed=mean(topLine,'omitnan');
litstoppingmeanspeed=mean(middleLine,'omitnan');

effect_neuron=-1*(mean(cat(1,litmovingmeanspeed,litstoppingmeanspeed))-baselinemeanspeed)
effect_typereinf=(litstoppingmeanspeed-litmovingmeanspeed)/effect_neuron

figure
distributionPlot(mean(speed,2));
ylabel('Speed in pix/s')
title('Average speed')

%{
%% Vector of moving
jump=20;
dir_change=nan(length(flyTracks.centroid(1:jump:end,1,1))-1,length(flyTracks.centroid(1,1,:)));
mov_ori=nan(length(flyTracks.centroid(1:jump:end,1,1))-1,length(flyTracks.centroid(1,1,:)));
for i=1:length(flyTracks.centroid(1:jump:end,1,1))-1
    for oo=1:length(flyTracks.centroid(1,1,:))
        dir_change(i,oo)=atan2d(flyTracks.centroid((i*jump)+1,2,oo)-flyTracks.centroid(((i-1)*jump)+1,2,oo),flyTracks.centroid((i*jump)+1,1,oo)-flyTracks.centroid(((i-1)*jump)+1,1,oo)); 
        mov_ori(i,oo)=atan2d(flyTracks.centroid((i*jump)+1,2,oo),flyTracks.centroid((i*jump)+1,1,oo));
    end
end


figure
plot(dir_change(:,fly))
xlabel('Time')
ylabel('Angle (degrees)')
title('Vector of moving relative to its previous position')

figure
mseb(1:length(mean(dir_change,2)),mean(dir_change,2)',std(dir_change,1,2)')
% plot(mean(speed,2))
xlabel('Time')
ylabel('Direction movement (degrees)')
title('Change in direction movement')

direction=squeeze(cat(3,sum(dir_change>0),sum(dir_change<0)));
figure
hb=bar(direction);
set(hb(1), 'FaceColor','b')
set(hb(2), 'FaceColor','r')
xlabel('Fly number')
ylabel('Cumulative direction change (degrees)')
title('Right vs Left cumulative change (degrees)')
legend('Right','Left')

figure
plot(mov_ori(:,fly))
xlabel('Time')
ylabel('Angle (degrees)')
title('Vector of moving relative to the center')

figure
plot(flyTracks.centroid(1:jump:end,1,fly),flyTracks.centroid(1:jump:end,2,fly));
xlabel('x coordinates')
ylabel('y coordinates')
title('Experimental fly trace')

centroid=flyTracks.centroid(11:10:end,:,:);
centroid_x=centroid(:,1,fly);
centroid_y=centroid(:,2,fly);

figure
plot(centroid_x(speed(:,fly)>1),centroid_y(speed(:,fly)>1));
xlabel('x coordinates')
ylabel('y coordinates')
title('Experimental fly trace with speed>1')

figure
plot(centroid_x(speed(:,fly)<1),centroid_y(speed(:,fly)<1));
xlabel('x coordinates')
ylabel('y coordinates')
title('Experimental fly trace with speed<1')

figure
for fly=1:length(flyTracks.centroid(1,1,:))
plot(flyTracks.centroid(:,1,fly),flyTracks.centroid(:,2,fly));
pause(1);
end
%{
%}

%% Occupancy
lefthalf=nan(1,29);
righthalf=nan(1,29);
for i=1:flyTracks.nFlies
lefthalf(i)=sum(flyTracks.centroid(:,1,i)<flyTracks.ROIcenters(i,1));
righthalf(i)=sum(flyTracks.centroid(:,1,i)>flyTracks.ROIcenters(i,1));
end

aboxplot(cat(2,lefthalf',righthalf'));
xlabel('Left   Right')
ylabel('Counts in each side')
title('LeftvsRight half distribution')

To try at some point
x = 0:.05:2*pi;
y = sin(x);
z = zeros(size(x));
col = x;  % This is the color, vary with x in this case.
surface([x;x],[y;y],[z;z],[col;col],...
        'facecol','no',...
        'edgecol','interp',...
        'linew',2);
%}