alllines=cat(3,lines_effect,effect1,effect2);
alllinesall=cat(1,flyLine,effectlineone,effectline2);
lines_effect=alllines;
flyLine=alllinesnames;
alllinesnames=flyLine(ind,1);
alllinesnames=alllinesnames{ind};
alllines=alllines(:,:,ind);
ind=ones(52,1);
ind([8,32,35,46,47,51])=0;
ind=logical(ind);
nLines=57
for lines=1:nLines
avg_effect_flies(lines,:)=mean(lines_effect(:,:,lines),1,'omitnan');
a=avg_effect_flies(lines,:);
exp_flies(lines)=sqrt(length(a(~isnan(a))));
end
total_effect_mean=mean(avg_effect_flies,2,'omitnan');
sem=std(avg_effect_flies,0,2,'omitnan')./exp_flies'; % standard error of the mean
[explines sort2]=sort(total_effect_mean(8:end),'descend');
u=1:7;
sorting=cat(1,u',sort2+7);
names=flyLine(sorting);
total_effect_mean2=cat(1,total_effect_mean(1:7),explines);
sem2=sem(sorting);

sem4=sem3(ind);
names3=names2(ind);
total_effect_mean3=total_effect_mean2(ind);

figure
bar(total_effect_mean3,'Facecolor',rand(1,3))
hold on
errorbar(total_effect_mean3,sem4,'.')
set(gca,'xtick',1:nLines);
set(gca,'XTickLabel',{names3{1:nLines}});
ax = gca;
ax.XTickLabelRotation = -45;
xlabel('Fly Line')
ylabel('Valence (Difference in occupancy time)')
title('Screen valence')

