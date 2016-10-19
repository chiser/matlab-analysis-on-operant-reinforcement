    
    effect(lines,:)=mean(lines_effect(ee,:),1,'omitnan');
    mean_effect=mean(effect,'omitnan');
    std_error=std(effect(~isnan(effect)))/sqrt(sum(~isnan(effect)));
    
%     alllines=cat(3,lines_effect,effect1,effect2);
% alllinesall=cat(1,flyLine,effectlineone,effectline2);
% lines_effect=alllines;
% flyLine=alllinesnames;
% alllinesnames=flyLine(ind,1);
% alllinesnames=alllinesnames{ind};
% alllines=alllines(:,:,ind);
% ind=ones(52,1);
% ind([8,32,35,46,47,51])=0;
% ind=logical(ind);
nLines=51
for lines=1:nLines
avg_effect_flies(lines,:)=mean(lines_effect(:,:,lines),1,'omitnan');
a=avg_effect_flies(lines,:);
exp_flies(lines)=sqrt(length(a(~isnan(a))));
end
total_effect_mean=mean(avg_effect_flies,2,'omitnan');
sem=std(avg_effect_flies,0,2,'omitnan')./exp_flies'; % standard error of the mean

ordering_index=ones(1,51);
ordering_index([24 25 34 35 45 46 47])=0;
ordering_index=logical(ordering_index);
[explines sort2]=sort(total_effect_mean(ordering_index),'ascend');
u=[24 25 34 35 45 46 47];
sorting=cat(1,u',sort2+7);

names1=flyLine(u);
names_pre=flyLine(ordering_index);
names2=names_pre(sort2);
naming=cat(2,names1,names2);

total_effect_mean_pre=total_effect_mean(ordering_index);

total_effect_mean2=cat(1,total_effect_mean(u),total_effect_mean_pre(sort2));

sem_pre=sem(ordering_index);

sem2=cat(1,sem(u),sem_pre(sort2));

ind=ones(1,51);
ind([9 26 34 43 46])=0;
ind=logical(ind);

sem4=sem2(ind);
names3=naming(ind);
total_effect_mean3=total_effect_mean2(ind);

figure
bar(total_effect_mean3,'Facecolor',rand(1,3))
hold on
errorbar(total_effect_mean3,sem4,'.')
set(gca,'xtick',1:46);
set(gca,'XTickLabel',{names3{1:46}});
ax = gca;
ax.XTickLabelRotation = -45;
xlabel('Fly Line')
ylabel('Arm speed difference (a.u.)')
title('Screen valence')


figure
bar(total_effect_mean2,'Facecolor',rand(1,3))
hold on
errorbar(total_effect_mean2,sem2,'.')
set(gca,'xtick',1:nLines);
set(gca,'XTickLabel',{naming{1:nLines}});
ax = gca;
ax.XTickLabelRotation = -45;
xlabel('Fly Line')
ylabel('Arm speed difference (a.u.)')
title('Screen valence')