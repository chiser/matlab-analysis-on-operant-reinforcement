  
uiopen('*.mat');

%% Deleting low energy flies. Arm reinforcement

exclude=flyTracks.numTurns>14;
flyTracks.tSeq=flyTracks.tSeq(:,exclude);
%flyTracks.orientation=flyTracks.orientation(:,~exclude);
flyTracks.centroid=flyTracks.centroid(:,:,exclude);
flyTracks.numTurns=flyTracks.numTurns(:,exclude);
flyTracks.rBias=flyTracks.rBias(:,exclude);
flyTracks.rightTurns=flyTracks.rightTurns(:,exclude);
flyTracks.currentarm=flyTracks.currentarm(:,exclude);

%% Segmenting the experiment in the three experimental modes. Speed reinforcement

[baseline,below_is_lit,over_is_lit,speed_sort,speed_sort2,speed]=segmenting_speedreinforcement(flyTracks);
        

%% Length of bouts over and below the speed threshold in the three experimental modes. Speed reinforcement
        
[segregated_bouts_below,bout_length_below,fit_bout_length_below,fit_bout_length_below2,starting_running_below]=speedsort(below_is_lit,speed);

if starting_running_below==1
running_below=mean(bout_length_below(1:2:end));
stopping_below=mean(bout_length_below(2:2:end));
elseif starting_running_below==0
running_below=mean(bout_length_below(2:2:end));
stopping_below=mean(bout_length_below(1:2:end));
end

figure
subplot(3,2,1);
plot(fit_bout_length_below,[1:length(bout_length_below(1:2:end))],bout_length_below(1:2:end),'o')
title('below speed threshold')
ylabel('below is lit')
xlabel(['mean is ' num2str(stopping_below)])
subplot(3,2,2);
plot(fit_bout_length_below2,[1:length(bout_length_below(2:2:end))],bout_length_below(2:2:end),'o')
title('over speed threshold')
xlabel(['mean is ' num2str(running_below)])


[segregated_bouts_over,bout_length_over,fit_bout_length_over,fit_bout_length_over2,starting_running_over]=speedsort(over_is_lit,speed);

if starting_running_over==1
running_over=mean(bout_length_over(1:2:end));
stopping_over=mean(bout_length_over(2:2:end));
elseif starting_running_over==0
running_over=mean(bout_length_over(2:2:end));
stopping_over=mean(bout_length_over(1:2:end));
end

subplot(3,2,3);
plot(fit_bout_length_over,[1:length(bout_length_over(1:2:end))],bout_length_over(1:2:end),'o')
ylabel('over is lit')
xlabel(['mean is ' num2str(stopping_over)])
subplot(3,2,4);
plot(fit_bout_length_over2,[1:length(bout_length_over(2:2:end))],bout_length_over(2:2:end),'o')
xlabel(['mean is ' num2str(running_over)])

[segregated_bouts_base,bout_length_base,fit_bout_length_base,fit_bout_length_base2,starting_running_base]=speedsort(baseline,speed);

if starting_running_base==1
running_base=mean(bout_length_base(1:2:end));
stopping_base=mean(bout_length_base(2:2:end));
elseif starting_running_base==0
running_base=mean(bout_length_base(2:2:end));
stopping_base=mean(bout_length_base(1:2:end));
end

subplot(3,2,5);
plot(fit_bout_length_base,[1:length(bout_length_base(1:2:end))],bout_length_base(1:2:end),'o')
ylabel('Light is allways off')
xlabel(['mean is ' num2str(stopping_base)])
subplot(3,2,6);
plot(fit_bout_length_base2,[1:length(bout_length_base(2:2:end))],bout_length_base(2:2:end),'o')
xlabel(['mean is ' num2str(running_base)])



%% Showing light on to off transitions and viceversa. Speed reinforcement
[first_left_below,second_left_below,first_right_below,second_right_below]=convoluting_light_presentation(segregated_bouts_below);
[first_left_over,second_left_over,first_right_over,second_right_over]=convoluting_light_presentation(segregated_bouts_over);
[first_left_base,second_left_base,first_right_base,second_right_base]=convoluting_light_presentation(segregated_bouts_base);


%% Speed in each arm showed as a mean bout. Arm reinforcement

exclude=flyTracks.numTurns>14;
flyTracks.tSeq=flyTracks.tSeq(:,exclude);
flyTracks.centroid=flyTracks.centroid(:,:,exclude);
flyTracks.numTurns=flyTracks.numTurns(:,exclude);
flyTracks.rBias=flyTracks.rBias(:,exclude);
flyTracks.rightTurns=flyTracks.rightTurns(:,exclude);
flyTracks.currentarm=flyTracks.currentarm(:,exclude);

[mean_first,mean_second,mean_third,speed,delete,arm_from_currentarm]=bouts_speed_perarm(flyTracks);

%% Speed in a heat map and shape (preprocessing for a future alignment). Arm reinforcement
area_speed_norm=speed_map(flyTracks,speed,delete);
Ymaze_shape=nan(size(area_speed_norm));

for i=1:size(area_speed_norm,3)
    single_Ymaze_shape=area_speed_norm(:,:,i);
    Ymaze_shape(:,:,i)=logical(~isnan(single_Ymaze_shape));
end

third_arm=flyTracks.currentarm(:,1)==3;
croscorr=xcorr(flyTracks.currentarm(:,1),[1 1 1 1 1 1 1]);

%% Time spent in each arm in total and in bouts. Arm reinforcement
binning= linspace(1,3,3);
arm_distrib=histc(flyTracks.rightTurns,binning);
[arm,newRightTurns]=optimizing_arm_matrix(flyTracks.numTurns,flyTracks.rightTurns,arm_distrib,flyTracks.tStamps);  %If errors, check if the excluding of low energy flies was done


%% Rearranging flyTracks.currentarm for seeing time spent in each arm and total. Arm reinforcement
arm_from_currentarm=nan(numel(flyTracks.currentarm),1);
index=find(diff(flyTracks.currentarm)~=0)+1;
arm_from_currentarm(index)=flyTracks.currentarm(index);
arm_from_currentarm=reshape(arm_from_currentarm,size(flyTracks.currentarm));

arm_distrib_current=histc(arm_from_currentarm,binning);
max_number_turns_current=max(sum(arm_distrib_current,1));
[arm_current,newRightTurns_currentarm]=optimizing_arm_matrix(max_number_turns_current,arm_from_currentarm,arm_distrib_current,flyTracks.tStamps);

[MarkovPlot]=simple_markov(arm);
[MarkovPlot]=simple_markov(arm_current);

%% Plotting the traces in the transitions from one arm to the other. Arm reinforcement
transition_posib=cat(1,[1 2],[1 3],[2 1],[2 3],[3 1],[3 2]);

transition=nan(300,size(speed,2),length(transition_posib));

for u=1:length(transition_posib)
    for o=1:size(speed,2)
        transition_tmp=findstr(newRightTurns(:,o)',transition_posib(u,:));    
        transition(1:length(transition_tmp),o,u)=transition_tmp;
    end
end


for u=1:length(transition_posib)

    for i=1:length(transition)
        figure
        plot(flyTracks.centroid(transition(i)-100:transition(i)-30,1,1),flyTracks.centroid(transition(i)-100:transition(i)-30,2,1),'Color',[0 0 0]) %first points in blue
        hold on
        plot(flyTracks.centroid(transition(i)-30:transition(i)+30,1,1),flyTracks.centroid(transition(i)-30:transition(i)+30,2,1),'Color',[0.5 0 0]) %first points in blue
        hold on
        plot(flyTracks.centroid(transition(i)+30:transition(i)+100,1,1),flyTracks.centroid(transition(i)+30:transition(i)+100,2,1),'Color',[1 0 0]) %first points in blue
    end
end

% for i=1:length(transition)
%     figure
%     for oo=-100:100
%        
%         color=[(oo+100)/length(-100:100) 0 0];
%         plot(flyTracks.centroid(transition(i)-oo,1,1),flyTracks.centroid(transition(i)-oo,2,1),'o','Color',color, 'LineWidth',20);
%         hold on
%     end
% end
if all(all(all(transition(~isnan(transition))>7)))
    transition=transition-(length(newRightTurns)-length(speed));
else
    warning('I have to adjust manually the length of speed and newRightTurns')
end

transition_speed=nan(201,length(transition(~isnan(transition(:,o,u)))),size(speed,2),length(transition_posib));
for u=1:length(transition_posib)
    for o=1:size(speed,2)
        for i=1:length(transition(~isnan(transition(:,o,u))))
            if transition(i,o,u)-100<0
            transition_speed(1:(201+(transition(i,o,u)-101)),i,o,u)=speed(1:transition(i,o,u)+100);
            elseif transition(i,o,u)+100>length(speed)
            transition_speed(1:(201-(transition(i,o,u)+100-length(speed))),i,o,u)=speed(transition(i,o,u)-100:length(speed));
            else
            transition_speed(1:201,i,o,u)=speed(transition(i,o,u)-100:transition(i,o,u)+100);
            end
        end
    end
end

lit_arm=3;

if lit_arm==3
    select=[2 4 5 6];
elseif lit_arm==2
    select=[1 6 3 4];
elseif lit_arm==1
    select=[3 5 1 2];
end

one2three=squeeze(mean(transition_speed(:,:,:,select(1)),2,'omitnan'));
subplot(2,2,1)
plot(mean(one2three,2,'omitnan'))
ylabel('out-in')

two2three=squeeze(mean(transition_speed(:,:,:,select(2)),2,'omitnan'));
subplot(2,2,2)
plot(mean(two2three,2,'omitnan'))

three2one=squeeze(mean(transition_speed(:,:,:,select(3)),2,'omitnan'));
subplot(2,2,3)
plot(mean(three2one,2,'omitnan'))
ylabel('in-out')

three2two=squeeze(mean(transition_speed(:,:,:,select(4)),2,'omitnan'));
subplot(2,2,4)
plot(mean(three2two,2,'omitnan'))