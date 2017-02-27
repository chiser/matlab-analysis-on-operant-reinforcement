cd('C:/Users/debivortlab/Desktop/screen')
nLines=5;
lines_effect=nan(3,120,nLines);
flyLine=cell(nLines,1);
for lines=1:nLines

exclude=nan(3,120);
    for ee=1:3
        uiopen('*.mat');
        
        
        exclude(ee,1:size(flyTracks.rightTurns,2))=flyTracks.numTurns<14;
        %{
        flyTracks.tSeq=flyTracks.tSeq(:,exclude);
        flyTracks.centroid=flyTracks.centroid(:,:,exclude);
        flyTracks.numTurns=flyTracks.numTurns(:,exclude);
        flyTracks.rBias=flyTracks.rBias(:,exclude);
        flyTracks.rightTurns=flyTracks.rightTurns(:,exclude);
        %}
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

        arm_times=cat(1,left_dwell_time,middle_dwell_time,right_dwell_time);
        
        for uu=1:size(flyTracks.rightTurns,2)
            ind=[1 1 1];
            ind(ee)=0;
            ind=logical(ind);
%             ind2=zeros(1,size(arm_times,2));
%             ind2(uu)=1;
            effect(ee,uu)=arm_times(ee,uu)-mean(arm_times(ind,uu),'omitnan');
            
            
        end
        
    end

prompt='enter the name of the fly line: ';
x=input(prompt,'s');
flyLine{lines}=x;    
exclude(isnan(exclude))=1;
exclude=logical(exclude);
effect(exclude)=NaN;
lines_effect(:,:,lines)=effect;
end

save speedarm_sortedclean.mat total_effect_mean3
save expline2.mat flyLine