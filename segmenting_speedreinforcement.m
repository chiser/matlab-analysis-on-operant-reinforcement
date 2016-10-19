function[baseline,below_is_lit,over_is_lit,speed_sort,speed_sort2,speed]=segmenting_speedreinforcement(flyTracks)


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
        
end