cd('C:\Users\debivortlab\Desktop\screen')
nLines=50;
lines_effect=nan(3,120,nLines);
flyLine=cell(nLines,1);
effect=nan(nLines,120);

for lines=1:nLines
exclude=nan(3,120);
    for ee=1:3
        uiopen('*.mat');
        indiv_markov=nan(6,120);
        
%         exclude(ee,1:size(flyTracks.rightTurns,2))=flyTracks.numTurns<14;
        exclude=logical(flyTracks.numTurns<14);
        
        flyTracks.tSeq=flyTracks.tSeq(:,~exclude);
        flyTracks.centroid=flyTracks.centroid(:,:,~exclude);
        flyTracks.numTurns=flyTracks.numTurns(:,~exclude);
        flyTracks.rBias=flyTracks.rBias(:,~exclude);
        flyTracks.rightTurns=flyTracks.rightTurns(:,~exclude);
      

         %% Time stamps and where of each decision
        arm=nan(max(flyTracks.numTurns),length(flyTracks.rightTurns(1,:)));
        leftArm=[];
        middleArm=[];
        rightArm=[];
        left_dwell_time=[];
        middle_dwell_time=[];
        right_dwell_time=[];
        StampsTurns=[];
        order=[];
        for i=1:length(flyTracks.rightTurns(1,:))

        leftArm{i}=find(flyTracks.rightTurns(:,i)==1);
        middleArm{i}=find(flyTracks.rightTurns(:,i)==2);
        rightArm{i}=find(flyTracks.rightTurns(:,i)==3);
        Time=flyTracks.tStamps;
        [StampsTurns{i} order{i}]=sort(Time(cat(1,leftArm{i},middleArm{i},rightArm{i})));

        Stamps=StampsTurns{i};

        for oo=1:length(Stamps)
        if any(Stamps(oo)== Time(leftArm{i}))
            arm(oo,i)=1;
        elseif any(Stamps(oo)== Time(middleArm{i}))
            arm(oo,i)=2;
        elseif any(Stamps(oo)== Time(rightArm{i}))
            arm(oo,i)=3;
            end
        end

        StampsTime=diff(cat(1,Stamps,Time(end)));
        left_dwell_time(i)=sum(StampsTime(arm(:,i)==1));
        middle_dwell_time(i)=sum(StampsTime(arm(:,i)==2));
        right_dwell_time(i)=sum(StampsTime(arm(:,i)==3));

        end

        indiv_markov(:,1:sum(~exclude))=simple_markov_indiv(arm);
        
 
%         indiv_markov(:,~which_ind,:,which_ind)
% 
%     which_ind=zeros(1,3);
%     which_ind(ee)=1;
%     which_ind=logical(which_ind);
    
    
    if ee==1 
        lines_effect(ee,:,lines)=sum(indiv_markov([3 5],:)-indiv_markov([4 6],:));
    elseif ee==2
        lines_effect(ee,:,lines)=sum(indiv_markov([1 6],:)-indiv_markov([2 5],:));
    elseif ee==3
        lines_effect(ee,:,lines)=sum(indiv_markov([2 4],:)-indiv_markov([1 3],:));
    end
% %Plot the overall fly speed in each arm
% figure
% boxplot(meanspeed');
% xlabel('Arm number')
% ylabel('Speed in pix/s')
% title('Average speed per arm')        
            
    end

    prompt='enter the name of the fly line: ';
    x=input(prompt,'s');
    flyLine{lines}=x; 
    
end


lines_effect2=squeeze(mean(lines_effect,1,'omitnan'));

lines_effect2_mean=mean(lines_effect2,1,'omitnan');

for i=1:nLines
    expflies(i)=sum(~isnan(lines_effect2(:,i)))
end

lines_effect2_sem=std(lines_effect2,0,1,'omitnan')./expflies; 


figure
bar(lines_effect2_mean,'Facecolor',rand(1,3))
hold on
errorbar(lines_effect2_mean,lines_effect2_sem,'.')
set(gca,'xtick',1:nLines);
set(gca,'XTickLabel',{flyLine{1:nLines}});
ax = gca;
ax.XTickLabelRotation = -45;
xlabel('Fly Line')
ylabel('Valence (Difference in occupancy time)')
title('Screen valence')
