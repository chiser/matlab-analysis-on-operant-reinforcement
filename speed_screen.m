cd('C:\Users\LocalAdmin\Desktop\Harvard data\screen')
nLines=57;
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
        flyTracks.currentarm=flyTracks.currentarm(:,~exclude);

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

        Indexes=cat(1,leftArm,middleArm,rightArm);
        Ind_format=nan(size(arm));
        dec_number=sum(~isnan(arm),1);
        for i=1:length(Indexes)
            Ind_format(1:dec_number(i),i)=sort(cat(1,Indexes{1:3,i}),1);
        end

        newRightTurns=nan(size(flyTracks.rightTurns));
        for i=1:length(Ind_format(1,:))
            for oo=1:(dec_number(i)-1)
                newRightTurns(Ind_format(oo,i):(Ind_format(oo+1,i)-1),i)=arm(oo,i);
            end
            newRightTurns(Ind_format(oo,i):end,i)=arm(dec_number(i),i);
        end


        speed=sqrt(squeeze(sum(diff(flyTracks.centroid(1:10:end,:,:)).^2,2))./repmat(diff(flyTracks.tStamps(1:10:end)),1,size(flyTracks.centroid,3)));
        speed_length=length(speed(:,1))*10;
        new_speed=nan(size(newRightTurns(1:(end-1),:,1)));
        for i=1:length(speed(1,:))
            speed2=repmat(speed(:,i),1,10)';
            new_speed(1:speed_length,i)=speed2(:)';
        end

        one_speed=cell(1,length(newRightTurns(1,:,1)));
        two_speed=cell(1,length(newRightTurns(1,:,1)));
        three_speed=cell(1,length(newRightTurns(1,:,1)));
        meanspeed=nan(3,length(newRightTurns(1,:,1)));

        for i=1:length(newRightTurns(1,:,1))
        a=new_speed(:,i);
        one_speed{1,i}=a(boolean(newRightTurns(1:(end-1),i)==1));
        two_speed{1,i}=a(boolean(newRightTurns(1:(end-1),i)==2));
        three_speed{1,i}=a(boolean(newRightTurns(1:(end-1),i)==3));
        meanspeed(:,i)=cat(1,mean(one_speed{1,i},'omitnan'),mean(two_speed{1,i},'omitnan'),mean(three_speed{1,i},'omitnan'));
        end

which_ind=zeros(1,3);
which_ind(ee)=1;
which_ind=logical(which_ind);
lines_effect(ee,1:sum(~exclude),lines)=meanspeed(which_ind,:)-mean(meanspeed(~which_ind,:),1,'omitnan');

% %Plot the overall fly speed in each arm
% figure
% boxplot(meanspeed');
% xlabel('Arm number')
% ylabel('Speed in pix/s')
% title('Average speed per arm')        
            
     end
        


    prompt='enter the name of the fly line:  ';
    x=input(prompt,'s');
    flyLine{lines}=x;

    
    
end

flyLine{1:51}=

flyLine={'5htr1b' '5htr1bchag80' '58e02' '58e02thg80' 'c061' 'hl8' 'mb025' 'mb032' 'mb056b' 'mb058b' 'mb060b' 'mb065b' 'mb109b' 'mb299c' 'mb301b' 'mb304b' 'mb315c'...
     'mb438b' 'mb439b' 'mz19' 'mz19chag80' 'mz840' 'mz840np6510' 'NorpaUASChrimson' 'NorpAUASChrimsonCo' 'np47' 'np47chag80' 'np1528' 'np2758' 'np5272' 'np5272mz840' 'np6510'...
      'np6510np5272' 'or42b' 'or42bco' 'thc1' 'thd1' 'thd4' 'thdprime' 'thf1' 'thf2' 'thf3' 'thg1' 'thchag80' 'trpa1gr28bd' 'trpa1gr28bdco' 'trpa1gr28bdmutants' 'ththg80' 'c061females' 'np2758females' 'mb060b2'};
% exclude(isnan(exclude))=1;
% exclude=logical(exclude);
% effect(exclude)=NaN;
% lines_effect(:,:,lines)=effect;
% 
% 
save speedinarm.mat lines_effect
save speedinarm_names.mat flyLine