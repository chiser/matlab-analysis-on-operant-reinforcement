function[MarkovPlot]=simple_markov(arm)


choice_1=arm(find(arm==1)+1);
choice_1=choice_1(~isnan(choice_1));
choice_2=arm(find(arm==2)+1);
choice_2=choice_2(~isnan(choice_2));
choice_3=arm(find(arm==3)+1);
choice_3=choice_3(~isnan(choice_3));

choice_after1=histcounts(arm(find(arm==1)+1),length(unique(choice_1)));
choice_after2=histcounts(arm(find(arm==2)+1),length(unique(choice_2)));
choice_after3=histcounts(arm(find(arm==3)+1),length(unique(choice_3)));

long= diff([length(choice_after1) length(choice_after2) length(choice_after3)]);
if long(1)<0 & long(2)==0
    choice_after1=cat(2,0,choice_after1);
elseif long(1)>0 & long(2)==0
    choice_after2= [choice_after2(1) 0 choice_after2(2)];
    choice_after3= [choice_after3(1) choice_after3(2) 0];
elseif long(1)==0 & long(2)>0
    choice_after2= [choice_after2(1) 0 choice_after2(2)];
    choice_after1= [0 choice_after1(1) choice_after1(2)];    
elseif long(1)==0 & long(2)<0
    choice_after3= [choice_after3(1) choice_after3(2) 0];
end
    
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