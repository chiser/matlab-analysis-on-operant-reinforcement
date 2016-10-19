cd('C:/Users/debivortlab/Desktop/screen')
nLines=1;
lines_effect=nan(nLines,31,2);
flyLine=cell(nLines,1);
speed_thres=4;
mode_number=4;
seg_duration=480;

for lines=1:nLines

        exclude=nan(1,120);    
        uiopen('*.mat');
        prompt='enter the name of the fly line: ';
        x=input(prompt,'s');
        flyLine{lines}=x;

        exp_duration=3840;%max(flyTracks.tStamps);
        segment_number=exp_duration/seg_duration;
        speed=flyTracks.speed2;
        speed(speed>40)=10;

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

        bottomLine = speed;
        topLine = speed;
        middleLine = speed;
        bottomLine(mod(a,4)==0 | mod(a,4)==2,:) = NaN;
        topLine(mod(a,4)==1 | mod(a,4)==2 | mod(a,4)==3,:) = NaN;
        middleLine(mod(a,4)==0 | mod(a,4)==3 | mod(a,4)==1,:) = NaN;

        baselinemeanspeed=mean(bottomLine,1,'omitnan');
        litmovingmeanspeed=mean(topLine,1,'omitnan');
        litstoppingmeanspeed=mean(middleLine,1,'omitnan');

        effect_neuron=mean(cat(1,litmovingmeanspeed,litstoppingmeanspeed),1)-baselinemeanspeed;
        effect_typereinf=(litstoppingmeanspeed-litmovingmeanspeed)./effect_neuron;
        lines_effect(lines,1:size(effect_neuron,2),1)=effect_neuron;
        lines_effect(lines,1:size(effect_typereinf,2),2)=effect_typereinf;
end