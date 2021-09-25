function[first_leftshifted,second_leftshifted,first_rightshifted,second_rightshifted]=convoluting_light_presentation(segregated_bouts)

for i=1:2:(size(segregated_bouts,1)-1)

number(1,i-floor(i/2))= length(segregated_bouts(i,~isnan(segregated_bouts(i,:))));
number(2,i-floor(i/2))= length(segregated_bouts(i+1,~isnan(segregated_bouts(i+1,:))));

end

first_leftshifted= segregated_bouts(1:2:end,:);
first_rightshifted= nan(length(first_leftshifted),max(number(1,:)));
second_leftshifted= segregated_bouts(2:2:end,:);
second_rightshifted= nan(length(second_leftshifted),max(number(2,:)));


for i=1:2:(size(segregated_bouts,1)-1)

first_rightshifted(i-floor(i/2),(max(number(1,:))-max(find(~isnan(segregated_bouts(i,:)))))+[find(~isnan(segregated_bouts(i,:)))])=segregated_bouts(i,find(~isnan(segregated_bouts(i,:))));
second_rightshifted(i-floor(i/2),(max(number(2,:))-max(find(~isnan(segregated_bouts(i+1,:)))))+[find(~isnan(segregated_bouts(i+1,:)))])=segregated_bouts(i+1,find(~isnan(segregated_bouts(i+1,:))));

end

right2=mean(second_rightshifted,1,'omitnan');
right1=mean(first_rightshifted,1,'omitnan');
left1=mean(first_leftshifted,1,'omitnan');
left2=mean(second_leftshifted,1,'omitnan');

subplot(2,1,1)
plot(cat(2,right1,left2))
yaxis=get(gca,'ylim');
xaxis=get(gca,'xlim');
patch([xaxis(1) xaxis(1) size(first_rightshifted,2) size(first_rightshifted,2)],[yaxis(1) yaxis(2) yaxis(2) yaxis(1)],'red','FaceAlpha',.3)
subplot(2,1,2)
plot(cat(2,right2,left1))
yaxis=get(gca,'ylim');
xaxis=get(gca,'xlim');
patch([size(second_rightshifted,2) size(second_rightshifted,2) xaxis(2) xaxis(2)],[yaxis(1) yaxis(2) yaxis(2) yaxis(1)],'red','FaceAlpha',.3)

end