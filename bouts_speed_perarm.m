function[mean_first,mean_second,mean_third,speed,delete,bout_arm_discrete]=bouts_speed_perarm(flyTracks)

speed=squeeze(sqrt(sum(diff(flyTracks.centroid(1:10:end,:,:)).^2,2)))./repmat(diff(flyTracks.tStamps(1:10:end,:)),1,size(flyTracks.centroid,3));

new_speed=nan(length(speed(:,1))*10,size(speed,2));

for i=1:length(speed(1,:))
    speed2=repmat(speed(:,i),1,10)';
    new_speed(1:length(speed(:,1))*10,i)=speed2(:)';
end

trail_delete=length(flyTracks.currentarm)-length(new_speed);

arm_location=flyTracks.currentarm((trail_delete+1):end,:);

speed=new_speed;

changed_arm=diff(arm_location);

delete=nan(1,size(arm_location,2));
for i=1:size(arm_location,2)
delete(1,i)=any(changed_arm(:,i)~=0);
end

delete=logical(delete);
speed=speed(:,delete);
arm_location=arm_location(:,delete);
changed_arm=changed_arm(:,delete);

transitions=find(changed_arm~=0)+1;
arm_bouts=nan(length(transitions),max(diff(transitions)));
transitions=cat(1,1,transitions,numel(arm_location));

for i=1:(length(transitions)-1)
arm_bouts(i,1:(transitions(i+1)-transitions(i)))=speed(transitions(i):(transitions(i+1)-1));
end

bout_arm_discrete=arm_location(transitions(1:end-1));


first_arm_bouts=arm_bouts(bout_arm_discrete==1,:);
second_arm_bouts=arm_bouts(bout_arm_discrete==2,:);
third_arm_bouts=arm_bouts(bout_arm_discrete==3,:);

mean_first=mean(first_arm_bouts,1,'omitnan');
mean_second=mean(second_arm_bouts,1,'omitnan');
mean_third=mean(third_arm_bouts,1,'omitnan');

subplot(3,1,1)
plot(mean_first)
xlabel('Time (frames)')
ylabel('Speed in pix/s')
title('Speed while entering the first arm')
subplot(3,1,2)
plot(mean_second)
xlabel('Time (frames)')
ylabel('Speed in pix/s')
title('Speed while entering the second arm')
subplot(3,1,3)
plot(mean_third)
xlabel('Time (frames)')
ylabel('Speed in pix/s')
title('Speed while entering the third arm')

end