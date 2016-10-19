analysis_plot=2;
% effect_not_normalized=lines_effect(:,:,2).*lines_effect(:,:,1);
% lines_effect(:,:,2)=effect_not_normalized;

for lines=1:nLines
avg_effect_flies(lines,:)=mean(lines_effect(lines,:,:),'omitnan');
a=lines_effect(lines,:,analysis_plot);
exp_flies=sqrt(length(a(~isnan(a))));
sem(lines)=std(lines_effect(lines,:,analysis_plot),0,'omitnan')/exp_flies; % standard error of the mean
end

[expflies sort2]=sort(avg_effect_flies(7:end,analysis_plot));
avg_effect_flies2=cat(1,avg_effect_flies(1:6,analysis_plot),expflies);
u=1:6;
sorting=cat(1,u',sort2+6);
sem2=sem(sorting);
flyLine2=flyLine(sorting);

ind=ones(49,1);
ind([8,11,16,46])=0;
ind=logical(ind);
avg_effect_flies3=avg_effect_flies2(ind);
sem3=sem2(ind);
flyLine3=flyLine2(ind);

figure
bar(avg_effect_flies3,'Facecolor',rand(1,3))
hold on
errorbar(avg_effect_flies3,sem3,'.')
set(gca,'xtick',1:45);
set(gca,'XTickLabel',{flyLine3{1:45}});
ax = gca;
ax.XTickLabelRotation = -45;
xlabel('Fly Line')
ylabel('Difference in speed reinforcement mode not normalized (Difference in speed)')
title('Screen valence')

