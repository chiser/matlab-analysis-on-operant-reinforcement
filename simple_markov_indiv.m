function[indiv_markov]=simple_markov_indiv(arm)

choice_after1=nan(2,size(arm,2));
choice_after2=nan(2,size(arm,2));
choice_after3=nan(2,size(arm,2));

for i=1:size(arm,2)

choice_1=arm(find(arm(1:(end-1),i)==1)+1,i);
choice_1=choice_1(~isnan(choice_1));
choice_2=arm(find(arm(1:(end-1),i)==2)+1,i);
choice_2=choice_2(~isnan(choice_2));
choice_3=arm(find(arm(1:(end-1),i)==3)+1,i);
choice_3=choice_3(~isnan(choice_3));

if length(unique(choice_1))==2 
    choice_after1(1:length(unique(choice_1)),i)=histcounts(choice_1,length(unique(choice_1)));
elseif length(unique(choice_1))==1
    if all(choice_1==2);
    choice_after1(1,i)=histcounts(choice_1,length(unique(choice_1)));
    elseif all(choice_1==3);
    choice_after1(1,i)=histcounts(choice_1,length(unique(choice_1)));
    end
end
    
if length(unique(choice_2))==2 
    choice_after2(1:length(unique(choice_2)),i)=histcounts(choice_2,length(unique(choice_2)));
elseif length(unique(choice_2))==1
    if all(choice_2==1);
    choice_after2(1,i)=histcounts(choice_2,length(unique(choice_2)));
    elseif all(choice_2==3);
    choice_after2(2,i)=histcounts(choice_2,length(unique(choice_2)));
    end
end

if length(unique(choice_3))==2 
    choice_after3(1:length(unique(choice_3)),i)=histcounts(choice_3,length(unique(choice_3)));
elseif length(unique(choice_3))==1
    if all(choice_3==1);
    choice_after3(1,i)=histcounts(choice_3,length(unique(choice_3)));
    elseif all(choice_3==2);
    choice_after1(2,i)=histcounts(choice_3,length(unique(choice_3)));
    end
end

end

indiv_markov=cat(1,choice_after1,choice_after2,choice_after3);

% indiv_markov=permute(indiv_markov,[1 3 2]);

end