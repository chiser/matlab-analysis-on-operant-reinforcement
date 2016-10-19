%load('C:\Users\debivortlab\Documents\MATLAB\data.mat')

%Histograms for the intersampling intervals
%plot(diff(flyTracks.tStamps),'ro')
figure
plot(histc(diff(flyTracks.tStamps),linspace(0,0.1,100))./sum(histc(diff(flyTracks.tStamps),linspace(0,0.1,100))))
%nhist(diff(flyTracks.tStamps))
% xlabel('Inter-Sampling Interval (ms)')
% ylabel('Probability of the given IFI')
% title('Sampling Overview')
%Excluding inactive Y-mazes
exclude=flyTracks.numTurns>14;
flyTracks.tSeq=flyTracks.tSeq(:,exclude);
%flyTracks.orientation=flyTracks.orientation(:,~exclude);
flyTracks.centroid=flyTracks.centroid(:,:,exclude);
flyTracks.numTurns=flyTracks.numTurns(:,exclude);
flyTracks.rBias=flyTracks.rBias(:,exclude);
flyTracks.rightTurns=flyTracks.rightTurns(:,exclude);


%% Number of total turns whole experiment
%{
boxplot(flyTracks.numTurns)
xlabel('All experimental flies')
ylabel('Total number of turns per fly')
title('Total experiment turns per fly')
% Number of total turns for each fly
plot(1:length(flyTracks.numTurns),flyTracks.numTurns,'ro')
line([0 120], [mean(flyTracks.numTurns) mean(flyTracks.numTurns)])
xlabel('Fly (random assigned numbers)')
ylabel('Number of turns')
title('Turns per fly')
%% Orientation time series for each fly
for i=1:length(flyTracks.orientation(1,:))
plot(flyTracks.orientation(1:4000,i))
xlabel('Measured points')
ylabel('Orientation (degrees)')
title('Orientiation across the experiment')
shg
pause(1)
end

% Orientation time series for all flies
plot(mean(flyTracks.orientation,2))
xlabel('Measured points')
ylabel('Orientation (degrees)')
title('Averaged orientiation across the experiment')
% Average orientation per fly. Very interesting pattern

e = std(flyTracks.orientation,1,1);
figure;
hE     = errorbar(1:length(mean(flyTracks.orientation,1)),mean(flyTracks.orientation,1),e);
set(hE                            , ...
  'LineStyle'       , '-'      , ...
  'LineWidth'       , 1           , ...
  'Marker'          , '.'         , ...
  'MarkerSize'      , 9           , ...
  'Color'           , [.3 .3 .3]  , ...
  'MarkerEdgeColor' , [1 .2 .2]  , ...
  'MarkerFaceColor' , [1 0 1]  );

mseb(1:length(mean(flyTracks.orientation,1)),mean(flyTracks.orientation,1),std(flyTracks.orientation,1,1))
xlabel('Measured points')
ylabel('Orientation (degrees)')
title('Averaged orientiation across the experiment')

%% Main analysis part
%shadedErrorBar(1:length(flyTracks.tSeq),flyTracks.tSeq,errobar(1:length(flyTracks.tSeq),flyTracks.tSeq);

%Turning bias for all the flies across time
mseb(1:length(mean(flyTracks.tSeq,2,'omitnan')),mean(flyTracks.tSeq,2,'omitnan')',std(flyTracks.tSeq,1,2,'omitnan')')
xlabel('Decision points')
ylabel('Rights&Lefts (1&0)')
title('Averaged turning sequence acroos time')
%}

% Orientation time series for all flies
% figure
% plot(mean(flyTracks.orientation,2))
% xlabel('Measured points')
% ylabel('Orientation (degrees)')
% title('Averaged orientiation across the experiment')
% Average orientation per fly. Very interesting pattern

% e = std(flyTracks.orientation,1,1);
% figure;
% hE     = errorbar(1:length(mean(flyTracks.orientation,1)),mean(flyTracks.orientation,1),e);
% set(hE                            , ...
%   'LineStyle'       , '-'      , ...
%   'LineWidth'       , 1           , ...
%   'Marker'          , '.'         , ...
%   'MarkerSize'      , 9           , ...
%   'Color'           , [.3 .3 .3]  , ...
%   'MarkerEdgeColor' , [1 .2 .2]  , ...
%   'MarkerFaceColor' , [1 0 1]  );
% figure
% mseb(1:length(mean(flyTracks.orientation,1)),mean(flyTracks.orientation,1),std(flyTracks.orientation,1,1))
% xlabel('Measured points')
% ylabel('Orientation (degrees)')
% title('Averaged orientiation across the experiment')

%Number of entries en each arm alltogether
left_entries=sum(flyTracks.rightTurns(:,:)==1);
middle_entries=sum(flyTracks.rightTurns(:,:)==2);
right_entries=sum(flyTracks.rightTurns(:,:)==3);

figure
distributionPlot(cat(2,left_entries',middle_entries',right_entries'),'addSpread',true,'colormap',copper)
%aboxplot(cat(2,left_entries',middle_entries',right_entries'),'labels',{'Left','Middle','Right'},'Colorgrad','blue_down',...
%    'Colorrev',true,'OutlierMarker','o','OutlierMarkerSize',7)
xlabel('Entered arm')
ylabel('Number of arm entries')
title('Total number of entries in each arm')
%{
%Iteration across each single fly for their choices along time
for i=1:length(flyTracks.rightTurns(1,:))
plot(flyTracks.rightTurns(:,i),'ro')
xlabel('Decision points')
ylabel('Entered arm')
title('Sucession of entered arms')
pause(1)
end
%}
%Average distribution of the global decisions along time
binning= linspace(1,3,3);
arm_distrib=histc(flyTracks.rightTurns,binning);

%{
dist_alongtime=mean(flyTracks.rightTurns,2,'omitnan');
figure
subplot(1,2,1)
distributionPlot(dist_alongtime,'colormap',copper)
subplot(1,2,2)
plot(dist_alongtime,'o','Markersize',3)
xlabel('Decision points')
ylabel('Entered arm')
title('Averaged sucession of entered arms')
%}
%% Time stamps and where of each decision
arm=nan(max(flyTracks.numTurns),length(flyTracks.rightTurns(1,:)));
leftArm=[];
middleArm=[];
rightArm=[];
left_dwell_time=[];
middle_dwell_time=[];
right_dwell_time=[];
StampsTurns=[];
order=[];
for i=1:length(flyTracks.rightTurns(1,:))
    
leftArm{i}=find(flyTracks.rightTurns(:,i)==1);
middleArm{i}=find(flyTracks.rightTurns(:,i)==2);
rightArm{i}=find(flyTracks.rightTurns(:,i)==3);
Time=flyTracks.tStamps;
[StampsTurns{i} order{i}]=sort(Time(cat(1,leftArm{i},middleArm{i},rightArm{i})));

Stamps=StampsTurns{i};

for oo=1:length(Stamps)
if any(Stamps(oo)== Time(leftArm{i}))
    arm(oo,i)=1;
elseif any(Stamps(oo)== Time(middleArm{i}))
    arm(oo,i)=2;
elseif any(Stamps(oo)== Time(rightArm{i}))
    arm(oo,i)=3;
    end
end

StampsTime=diff(cat(1,Stamps,Time(end)));
left_dwell_time(i)=sum(StampsTime(arm(:,i)==1));
middle_dwell_time(i)=sum(StampsTime(arm(:,i)==2));
right_dwell_time(i)=sum(StampsTime(arm(:,i)==3));

end

%Total experiment time spent in each arm
arm_times=cat(1,left_dwell_time,middle_dwell_time,right_dwell_time);
figure
aboxplot(arm_times','labels',{'Left','Middle','Right'},'Colorgrad','blue_down',...
    'Colorrev',true,'OutlierMarker','o','OutlierMarkerSize',7)
xlabel('Arm')
ylabel('Time (s)')
title('Total experiment time spent in each arm')

%Average time spent in each arm per bout
arm_avg_time=arm_times./arm_distrib;
figure
aboxplot(arm_avg_time','labels',{'Left','Middle','Right'},'Colorgrad','blue_down',...
    'Colorrev',true,'OutlierMarker','o','OutlierMarkerSize',7)
xlabel('Arm')
ylabel('Time (s)')
title('Average time spent in each arm per bout')
%The same but in histogram
%{
figure
plot(histc(arm_avg_time',linspace(0,250,25)),'LineWidth',2)
xlabel('Time (s)')
ylabel('Bouts')
title('Histogram of the average time spent in each arm per bout')
legend('left','middle','right')
%}
%%Occupated arm at each time point. Not just the decisions like in
%%rightTurns but where they stay to make it continuous
Indexes=cat(1,leftArm,middleArm,rightArm);
Ind_format=nan(size(arm));
dec_number=sum(~isnan(arm),1);
for i=1:length(Indexes)
    Ind_format(1:dec_number(i),i)=sort(cat(1,Indexes{1:3,i}),1);
end

newRightTurns=nan(size(flyTracks.rightTurns));
for i=1:length(Ind_format(1,:))
    for oo=1:(dec_number(i)-1)
        newRightTurns(Ind_format(oo,i):(Ind_format(oo+1,i)-1),i)=arm(oo,i);
    end
    newRightTurns(Ind_format(oo,i):end,i)=arm(dec_number(i),i);
end
%{
plot(mean(newRightTurns,2))
xlabel('Decision points')
ylabel('Averaged entered arm')
title('Decision of flies by order of choices (not by time)')

for i=1:length(newRightTurns(1,:))
    plot(newRightTurns(:,i))
    xlabel('Decision points')
    ylabel('Entered arm')
    title('Sucession of entered arms')
    pause(0.5);
end
%}

%% Kinda Markov model. There are less choices than in the total amount of choices because the first choice is not counted cause there is conditional to bind with
choice_1=arm(find(arm==1)+1);
choice_1=choice_1(~isnan(choice_1));
choice_2=arm(find(arm==2)+1);
choice_2=choice_2(~isnan(choice_2));
choice_3=arm(find(arm==3)+1);
choice_3=choice_3(~isnan(choice_3));

choice_after1=histcounts(arm(find(arm==1)+1),length(unique(choice_1)));
choice_after2=histcounts(arm(find(arm==2)+1),length(unique(choice_2)));
choice_after3=histcounts(arm(find(arm==3)+1),length(unique(choice_3)));
long= diff([length(choice_after1) length(choice_after2) length(choice_after3)]);
if long(1)<0 & long(2)==0
    choice_after1=cat(2,0,choice_after1);
elseif long(1)>0 & long(2)==0
    choice_after2= [choice_after2(1) 0 choice_after2(2)];
    choice_after3= [choice_after3(1) choice_after3(2) 0];
elseif long(1)==0 & long(2)>0
    choice_after2= [choice_after2(1) 0 choice_after2(2)];
    choice_after1= [0 choice_after1(1) choice_after1(2)];    
elseif long(1)==0 & long(2)<0
    choice_after3= [choice_after3(1) choice_after3(2) 0];
end
    
MarkovPlot=cat(1,choice_after1,choice_after2,choice_after3);
figure
hb=bar(MarkovPlot);
set(hb(1), 'FaceColor','r')
set(hb(2), 'FaceColor','b')
xlabel('Arm')
ylabel('Number of entries')
title('Markov global probabilities')
legend('left arm','middle arm','right arm')
%% TODO: Put an inactivity threshold and do statistics with pause and activity

%% Centroids and heat map. There is a cumulative scaling of the colorbar that I have to change
%{
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

%%Extracting the dwelling time of each fly for each decision
    
leftArm_dwell=nan(max(dec_number),length(Ind_format(1,:)));
middleArm_dwell=nan(max(dec_number),length(Ind_format(1,:)));
rightArm_dwell=nan(max(dec_number),length(Ind_format(1,:)));
    
for i=1:length(Ind_format(1,:))
    stamping=diff(cat(1,StampsTurns{1,i},max(Time)));
    for oo=1:dec_number(i)
        if arm(oo,i)==1
            leftArm_dwell(oo,i)=stamping(oo);
        elseif arm(oo,i)==2
            middleArm_dwell(oo,i)=stamping(oo);
        elseif arm(oo,i)==3
            rightArm_dwell(oo,i)=stamping(oo);
        end
    end
    
end
left=cell(1,117);
middle=cell(1,117);
right=cell(1,117);
for i=1:length(Ind_format(1,:))
    ex_left=isnan(leftArm_dwell(:,i));
    left{1,i}=leftArm_dwell(~ex_left,i);
    ex_middle=isnan(middleArm_dwell(:,i));
    middle{1,i}=middleArm_dwell(~ex_middle,i);
    ex_right=isnan(rightArm_dwell(:,i));
    right{1,i}=rightArm_dwell(~ex_right,i);
end

%Histogram of time bouts with a fly per colour (if transposed a measured time per colour)
%{
figure
distributionPlot(cat(2,(reshape(leftArm_dwell,1,numel(leftArm_dwell)))',(reshape(middleArm_dwell,1,numel(middleArm_dwell)))',(reshape(rightArm_dwell,1,numel(rightArm_dwell)))'),'colormap',copper)
%plot(histc(leftArm_dwell,linspace(0,ceil(max(max(leftArm_dwell))),20)))
ylabel('Time(s)')
xlabel('Arm')
title('Dwelling time in each arm')

plot(histc(middleArm_dwell,linspace(0,ceil(max(max(middleArm_dwell))),20)))
xlabel('Normalized time distribution (histogram bins)')
ylabel('Histogram counts')
title('Time bout distribution')
plot(histc(rightArm_dwell,linspace(0,ceil(max(max(rightArm_dwell))),20)))
%}
%Each fly bout distribution
figure
subplot(3,1,1)
boxplot(leftArm_dwell)
title('Variability across flies in time bouts')
subplot(3,1,2)
boxplot(middleArm_dwell)
ylabel('Time bouts in arm')
subplot(3,1,3)
boxplot(rightArm_dwell)
xlabel('Fly Y-maze number')
%{
%Overall fly distribution across time
dwellfit(:,2)=reshape(leftArm_dwell,1,numel(leftArm_dwell));
dwellfit(:,1)=repmat((1:length(leftArm_dwell(:,1)))',length(leftArm_dwell(1,:)),1);
dwell_ex=isnan(dwellfit(:,2));
dwellfit=dwellfit(~dwell_ex,:);
[dwell_lfit conf]=fit(dwellfit(:,1),dwellfit(:,2), 'poly5');
figure
subplot(3,1,1)
plot(dwell_lfit,dwellfit(:,1),dwellfit(:,2));
conf;
xlabel('Decision points')
ylabel('Left Arm time bouts')
title('Temporal change in time bouts in arm')

dwellfit=[];
dwell_ex=[];
dwell_lfit=[];

dwellfit(:,2)=reshape(middleArm_dwell,1,numel(middleArm_dwell));
dwellfit(:,1)=repmat((1:length(middleArm_dwell(:,1)))',length(middleArm_dwell(1,:)),1);
dwell_ex=isnan(dwellfit(:,2));
dwellfit=dwellfit(~dwell_ex,:);
[dwell_lfit conf]=fit(dwellfit(:,1),dwellfit(:,2), 'poly5');
subplot(3,1,2)
plot(dwell_lfit,dwellfit(:,1),dwellfit(:,2));
conf;
xlabel('Decision points')
ylabel('Middle Arm time bouts')
title('Temporal change in time bouts in arm')

dwellfit=[];
dwell_ex=[];
dwell_lfit=[];

dwellfit(:,2)=reshape(rightArm_dwell,1,numel(rightArm_dwell));
dwellfit(:,1)=repmat((1:length(rightArm_dwell(:,1)))',length(rightArm_dwell(1,:)),1);
dwell_ex=isnan(dwellfit(:,2));
dwellfit=dwellfit(~dwell_ex,:);
[dwell_lfit conf]=fit(dwellfit(:,1),dwellfit(:,2), 'poly5');
subplot(3,1,3)
plot(dwell_lfit,dwellfit(:,1),dwellfit(:,2));
conf;
xlabel('Decision points')
ylabel('Right Arm time bouts')
title('Temporal change in time bouts in arm')
%}
%% Check the orientation while in different arms, as well as velocities

%%To delete if the following code is able to outperform this one
%{
centroids=permute(flyTracks.centroid,[1,3,2]);
centroids_x=centroids(:,:,1);
centroids_y=centroids(:,:,2);

timming=repmat(flyTracks.tStamps,1,length(newRightTurns(1,:)));
timming=diff(timming(find(newRightTurns==1)));

ONE_xy=cell(1,117);
TWO_xy=cell(1,117);
THREE_xy=cell(1,117);
ONE_speed=cell(1,117);
TWO_speed=cell(1,117);
THREE_speed=cell(1,117);
meanspeed=nan(3,length(centroids_x(1,:)));

for i=1:length(centroids_x(1,:))
    column_x=centroids_x(:,i);
    column_y=centroids_y(:,i);
    ONE_speed{1,i}=sqrt(sum((ONE_xy{1,i}.^2),2))./diff(flyTracks.tStamps(find(newRightTurns(:,i)==1)));

    ONE_xy{1,i}=cat(2,diff(column_x),diff(column_y),diff(ori));
    ONE_speed{1,i}=sqrt(sum((ONE_xy{1,i}.^2),2))./diff(flyTracks.tStamps(find(newRightTurns(:,i)==1)));
    TWO_xy{1,i}=cat(2,diff(column_x(find(newRightTurns(:,i)==2))),diff(column_y(find(newRightTurns(:,i)==2))),diff(ori(find(newRightTurns(:,i)==2))));
    TWO_speed{1,i}=sqrt(sum((TWO_xy{1,i}.^2),2))./diff(flyTracks.tStamps(find(newRightTurns(:,i)==2)));
    THREE_xy{1,i}=cat(2,diff(column_x(find(newRightTurns(:,i)==3))),diff(column_y(find(newRightTurns(:,i)==3))),diff(ori(find(newRightTurns(:,i)==3))));
    THREE_speed{1,i}=sqrt(sum((THREE_xy{1,i}.^2),2))./diff(flyTracks.tStamps(find(newRightTurns(:,i)==3)));
    meanspeed(:,i)=cat(1,mean(ONE_speed{1,i}),mean(TWO_speed{1,i}),mean(THREE_speed{1,i}));
end
%}

%Plot the speed of a given fly across time. Warning!! If the experiment
%takes longer than 1000segs the diff is wrong (short format)
% newRightTurns(:,:,2)=flyTracks.orientation(:,1:length(flyTracks.tSeq(1,:)));
newRightTurns(:,:,3:4)=permute(flyTracks.centroid,[1 3 2]);
newRightTurns(:,:,5)=repmat(flyTracks.tStamps,1,length(flyTracks.tSeq(1,:)));

% speed=sqrt(sum(diff(newRightTurns(:,:,3:4)).^2,3)./diff(newRightTurns(:,:,5)));
speed=sqrt(sum(diff(newRightTurns(1:10:end,:,3:4)).^2,3))./diff(newRightTurns(1:10:end,:,5));
speed_length=length(speed(:,1))*10;
new_speed=nan(size(newRightTurns(1:(end-1),:,1)));
for i=1:length(speed(1,:))
    speed2=repmat(speed(:,i),1,10)';
    new_speed(1:speed_length,i)=speed2(:)';
end
% plot(speed)
one_speed=cell(1,length(newRightTurns(1,:,1)));
two_speed=cell(1,length(newRightTurns(1,:,1)));
three_speed=cell(1,length(newRightTurns(1,:,1)));
orient=newRightTurns(:,:,2);

for i=1:length(newRightTurns(1,:,1))
a=new_speed(:,i);
b=orient(:,i);
one_speed{1,i}=a(boolean(newRightTurns(1:(end-1),i,1)==1));
two_speed{1,i}=a(boolean(newRightTurns(1:(end-1),i,1)==2));
three_speed{1,i}=a(boolean(newRightTurns(1:(end-1),i,1)==3));
meanspeed(:,i)=cat(1,mean(one_speed{1,i},'omitnan'),mean(two_speed{1,i},'omitnan'),mean(three_speed{1,i},'omitnan'));
one_ori{1,i}=b(newRightTurns(:,i,1)==1);
two_ori{1,i}=b(newRightTurns(:,i,1)==2);
three_ori{1,i}=b(newRightTurns(:,i,1)==3);
meanori(:,i)=cat(1,mean(one_ori{1,i},'omitnan'),mean(two_ori{1,i},'omitnan'),mean(three_ori{1,i},'omitnan'));
end

%Plot the overall fly speed in each arm
figure
distributionPlot(meanspeed');
xlabel('Arm number')
ylabel('Speed in pix/s')
title('Average speed per arm')

figure
distributionPlot(meanori');
xlabel('Arm number')
ylabel('Orientation (degrees)')
title('Average orientation per arm')

figure
mseb(1:length(mean(speed,2)),mean(speed,2)',std(speed,1,2)')
% plot(mean(speed,2))
xlabel('Time')
ylabel('Speed in pix/s')
title('Overall speed across time')
%{
%{
figure
plot(one_speed{1,1});


%Plot the orientation 
figure
plot(one_ori{1,1});
figure
distributionPlot(meanori');
figure
plot(diff(one_ori{1,1}));


figure
plot(flyTracks.rBias,'ro')
boxplot(flyTracks.rBias)
plot(mean(flyTracks.tSeq,2,'omitnan'))
%}

%% Vector of moving
dir_change=nan(length(flyTracks.centroid(:,1,1))-1,length(flyTracks.centroid(1,1,:)));
for i=2:length(flyTracks.centroid(:,1,1))
    for oo=1:length(flyTracks.centroid(1,1,:))
        dir_change(i,oo)=atan2d(flyTracks.centroid(i,2,oo),flyTracks.centroid(i,1,oo))-atan2d(flyTracks.centroid(i-1,2,oo),flyTracks.centroid(i-1,1,oo));   %5
    end
end
figure
plot(dir_change)
figure
plot(mean(dir_change,1))
figure
plot(mean(dir_change,2))

%% Plot histograms of the turnBias

inc=0.05;
bins=-inc/2:inc:1+inc/2;   % Bins centered from 0 to 1 

c=histc(flyTracks.rBias(flyTracks.numTurns>40),bins); % histogram
mad(flyTracks.rBias(flyTracks.numTurns>40))           % MAD of right turn prob
c=c./(sum(c));
c(end)=[];
figure
plot(c,'Linewidth',2);
set(gca,'Xtick',(1:length(c)),'XtickLabel',0:inc:1);
axis([0 length(bins) 0 max(c)+0.05]);

% Generate legend labels
strain='';
treatment='';
if iscellstr(flyTracks.labels{1,1})
    strain=flyTracks.labels{1,1}{:};
end
if iscellstr(flyTracks.labels{1,3})
    treatment=flyTracks.labels{1,3}{:};
end
legend([strain ' ' treatment ' (u=' num2str(mean(flyTracks.rBias(flyTracks.numTurns>40)))...
    ', n=' num2str(sum(flyTracks.numTurns>40)) ')']);
shg
%}