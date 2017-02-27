function[MarkovPlot]=simple_markov(arm)

choice_after1=nan(2,size(arm,2));
choice_after2=nan(2,size(arm,2));
choice_after3=nan(2,size(arm,2));

for i=1:size(arm,2)

choice_1=arm(find(arm(:,i)==1)+1);
choice_1=choice_1(~isnan(choice_1));
choice_2=arm(find(arm(:,i)==2)+1);
choice_2=choice_2(~isnan(choice_2));
choice_3=arm(find(arm(:,i)==3)+1);
choice_3=choice_3(~isnan(choice_3));

if length(unique(choice_1))==2 
    choice_after1(1:length(unique(choice_1)),i)=histcounts(arm(find(arm(:,i)==1)+1),length(unique(choice_1)));
elseif length(unique(choice_1))==1
    if all(arm(find(arm(:,i)==1)+1)==2);
    choice_after1(1,i)=histcounts(arm(find(arm(:,i)==1)+1),length(unique(choice_1)));
    elseif all(arm(find(arm(:,i)==1)+1)==3);
    choice_after1(1,i)=histcounts(arm(find(arm(:,i)==1)+1),length(unique(choice_1)));
    end
end
    
if length(unique(choice_2))==2 
    choice_after2(1:length(unique(choice_2)),i)=histcounts(arm(find(arm(:,i)==2)+1),length(unique(choice_2)));
elseif length(unique(choice_2))==1
    if all(arm(find(arm(:,i)==2)+1)==1);
    choice_after2(1,i)=histcounts(arm(find(arm(:,i)==2)+1),length(unique(choice_2)));
    elseif all(arm(find(arm(:,i)==2)+1)==3);
    choice_after2(2,i)=histcounts(arm(find(arm(:,i)==2)+1),length(unique(choice_2)));
    end
end

if length(unique(choice_3))==2 
    choice_after3(1:length(unique(choice_3)),i)=histcounts(arm(find(arm(:,i)==3)+1),length(unique(choice_3)));
elseif length(unique(choice_3))==1
    if all(arm(find(arm(:,i)==3)+1)==1);
    choice_after3(1,i)=histcounts(arm(find(arm(:,i)==3)+1),length(unique(choice_3)));
    elseif all(arm(find(arm(:,i)==1)+1)==2);
    choice_after1(2,i)=histcounts(arm(find(arm(:,i)==3)+1),length(unique(choice_3)));
    end
end

end

MarkovPlot=cat(2,sum(choice_after1,2,'omitnan'),sum(choice_after2,2,'omitnan'),sum(choice_after3,2,'omitnan'))';
Markov_sem=std(avg_effect_flies,0,2,'omitnan')./exp_flies'; % standard error of the mean


MarkovPlot=cat(1,choice_after1,choice_after2,choice_after3);
figure
hb=bar(MarkovPlot);
set(hb(1), 'FaceColor','r')
set(hb(2), 'FaceColor','b')
xlabel('Arm')
ylabel('Number of entries')
title('Markov global probabilities')
legend('left arm','middle arm','right arm')

end