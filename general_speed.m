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