function[arm,newRightTurns]=optimizing_arm_matrix(numTurns,rightTurns,arm_distrib,tStamps)

arm=nan(max(numTurns),length(rightTurns(1,:)));
leftArm=[];
middleArm=[];
rightArm=[];
left_dwell_time=[];
middle_dwell_time=[];
right_dwell_time=[];
StampsTurns=[];
order=[];
for i=1:length(rightTurns(1,:))
    
leftArm{i}=find(rightTurns(:,i)==1);
middleArm{i}=find(rightTurns(:,i)==2);
rightArm{i}=find(rightTurns(:,i)==3);
Time=tStamps;
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
boxplot(arm_times')
% aboxplot(arm_times','labels',{'Left','Middle','Right'},'Colorgrad','blue_down',...
%     'Colorrev',true,'OutlierMarker','o','OutlierMarkerSize',7)
xlabel('Arm')
ylabel('Time (s)')
title('Total experiment time spent in each arm')

%Average time spent in each arm per bout
arm_avg_time=arm_times./arm_distrib;
figure
% aboxplot(arm_avg_time','labels',{'Left','Middle','Right'},'Colorgrad','blue_down',...
%     'Colorrev',true,'OutlierMarker','o','OutlierMarkerSize',7)
boxplot(arm_avg_time')
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
decision_number=sum(~isnan(arm),1);
for i=1:length(Indexes)
    Ind_format(1:decision_number(i),i)=sort(cat(1,Indexes{1:3,i}),1);
end

newRightTurns=nan(size(rightTurns));
for i=1:length(Ind_format(1,:))
    for oo=1:(decision_number(i)-1)
        newRightTurns(Ind_format(oo,i):(Ind_format(oo+1,i)-1),i)=arm(oo,i);
    end
    newRightTurns(Ind_format(oo,i):end,i)=arm(decision_number(i),i);
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
end