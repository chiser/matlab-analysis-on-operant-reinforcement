  
        uiopen('*.mat');
        
        speed_thres=4;
        mode_number=4;
        seg_duration=480;
       
        segment_number=max(flyTracks.tStamps)/seg_duration;
        exp_duration=3840;%max(flyTracks.tStamps);
        speed=flyTracks.speed2;
        speed(speed>40)=10;

        speed_seg=linspace(0,length(speed),segment_number+1);
        a=discretize(1:length(speed),speed_seg);
        baseline = mean(speed,2)';
        below_is_lit = mean(speed,2)';
        over_is_lit = mean(speed,2)';
        % speed_sort=cell(length(unique(a)),1);
        speed_sort=nan(ceil(length(below_is_lit)/length(unique(a))),length(unique(a)));
        speed_sort2=nan(ceil(length(below_is_lit)/length(unique(a))),length(unique(a)),length(speed(1,:)));
        seg_stamp=nan(ceil(length(below_is_lit)/length(unique(a))),length(unique(a)));
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
            speed_sort(1:seg_length,i)=below_is_lit(a==i);
            for oo=1:length(speed(1,:))
                speed_sort2(1:seg_length,i,oo)=speed(a==i,oo);
            end
        end

        baseline = speed;
        below_is_lit = speed;
        over_is_lit = speed;
        baseline(mod(a,4)==0 | mod(a,4)==2,:) = NaN;
        below_is_lit(mod(a,4)==1 | mod(a,4)==2 | mod(a,4)==3,:) = NaN;
        over_is_lit(mod(a,4)==0 | mod(a,4)==3 | mod(a,4)==1,:) = NaN;

%% Length of bouts over and below the speed threshold in the three experimental modes. Speed reinforcement
        
[segregated_bouts_top,bout_length_top,fit_bout_length_top,fit_bout_length_top2]=speedsort(below_is_lit,speed);

figure
subplot(3,2,1);
plot(fit_bout_length_top,[1:length(bout_length_top(1:2:end))],bout_length_top(1:2:end),'o')
title('below speed threshold')
subplot(3,2,2);
plot(fit_bout_length_top2,[1:length(bout_length_top(2:2:end))],bout_length_top(2:2:end),'o')
title('over speed threshold')

[segregated_bouts_middle,bout_length_middle,fit_bout_length_middle,fit_bout_length_middle2]=speedsort(over_is_lit,speed);


subplot(3,2,3);
plot(fit_bout_length_middle,[1:length(bout_length_middle(1:2:end))],bout_length_middle(1:2:end),'o')
title('below speed threshold')
subplot(3,2,4);
plot(fit_bout_length_middle2,[1:length(bout_length_middle(2:2:end))],bout_length_middle(2:2:end),'o')
title('over speed threshold')

[segregated_bouts_bot,bout_length_bot,fit_bout_length_bot,fit_bout_length_bot2]=speedsort(baseline,speed);

subplot(3,2,5);
plot(fit_bout_length_bot,[1:length(bout_length_bot(1:2:end))],bout_length_bot(1:2:end),'o')
title('below speed threshold')
subplot(3,2,6);
plot(fit_bout_length_bot2,[1:length(bout_length_bot(2:2:end))],bout_length_bot(2:2:end),'o')
title('over speed threshold')

%% Showing light on to off transitions and viceversa. Speed reinforcement
[first_left_top,second_left_top,first_right_top,second_right_top]=convoluting_light_presentation(segregated_bouts_top);
[first_left_middle,second_left_middle,first_right_middle,second_right_middle]=convoluting_light_presentation(segregated_bouts_middle);
[first_left_bot,second_left_bot,first_right_bot,second_right_bot]=convoluting_light_presentation(segregated_bouts_bot);


%% Speed in each arm showed as a mean bout. Arm reinforcement
[mean_first,mean_second,mean_third,speed,delete]=bouts_speed_perarm(flyTracks);


%% Speed in a heat map and shape (preprocessing for a future alignment). Arm reinforcement
area_speed_norm=speed_map(flyTracks,speed,delete);
Ymaze_shape=nan(size(area_speed_norm));

for i=1:size(area_speed_norm,3)
    single_Ymaze_shape=area_speed_norm(:,:,i);
    Ymaze_shape(:,:,i)=logical(~isnan(single_Ymaze_shape));
end

third_arm=flyTracks.currentarm(:,1)==3;
croscorr=xcorr(flyTracks.currentarm(:,1),[1 1 1 1 1 1 1]);