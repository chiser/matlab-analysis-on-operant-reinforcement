cd('C:/Users/debivortlab/Desktop/screen')
nLines=5;
lines_effect=nan(3,120,nLines);
flyLine=cell(nLines,1);
for lines=1:nLines

exclude=nan(3,120);
    for ee=1:3
        uiopen('*.mat');
        
        
        exclude(ee,1:size(flyTracks.rightTurns,2))=flyTracks.numTurns<14;
        %{
        flyTracks.tSeq=flyTracks.tSeq(:,exclude);
        flyTracks.centroid=flyTracks.centroid(:,:,exclude);
        flyTracks.numTurns=flyTracks.numTurns(:,exclude);
        flyTracks.rBias=flyTracks.rBias(:,exclude);
        flyTracks.rightTurns=flyTracks.rightTurns(:,exclude);
        %}
 % speed=sqrt(sum(diff(newRightTurns(:,:,3:4)).^2,3)./diff(newRightTurns(:,:,5)));
 
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

            
            
        end
        
    

prompt='enter the name of the fly line: ';
x=input(prompt,'s');
flyLine{lines}=x;    
exclude(isnan(exclude))=1;
exclude=logical(exclude);
effect(exclude)=NaN;
lines_effect(:,:,lines)=effect;
end

save exp2.mat lines_effect
save expline2.mat flyLine