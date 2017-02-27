cd('C:\Users\Students\Desktop')
nLines=1;
lines_effect=nan(3,120,nLines);
flyLine=cell(nLines,1);
effect=nan(nLines,120);

for lines=1:nLines

exclude=nan(3,120);
    for ee=1:3
        uiopen('*.mat');
        
        
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

        [MarkovPlot]=simple_markov(arm)
        
        

    which_ind=zeros(1,3);
    which_ind(ee)=1;
    which_ind=logical(which_ind);
    
    
    if ee==1 
        lines_effect(ee,1:sum(~exclude),lines)=sum(MarkovPlot([2 3])-MarkovPlot([5 6]));
    elseif ee==2
        lines_effect(ee,1:sum(~exclude),lines)=sum(MarkovPlot([1 3])-MarkovPlot([4 6]));
    elseif ee==3
        lines_effect(ee,1:sum(~exclude),lines)=sum(MarkovPlot([1 2])-MarkovPlot([4 5]));
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
    
    effect(lines,:)=mean(lines_effect(ee,:),1,'omitnan');
    mean_effect=mean(effect,1,'omitnan');
    std_error=std(effect)/sqrt(~isnan(effect))
    
    
end


% exclude(isnan(exclude))=1;
% exclude=logical(exclude);
% effect(exclude)=NaN;
% lines_effect(:,:,lines)=effect;
% 
% 
% save exp2.mat lines_effect
% save expline2.mat flyLine