function[segregated_bouts,bout_length,fit_bout_length,fit_bout_length2,starting_running]=speedsort(segment,speed)

delete=isnan(segment);

speed=speed(~delete);

segment_clean=segment(~delete);

segment_clean_on=segment_clean(speed>4);
segment_clean_off=segment_clean(speed<4);

bouts=diff(speed>4);
transitions=find(bouts~=0)+1;
segregated_bouts=nan(length(transitions),max(diff(transitions)));
transitions=cat(1,transitions,length(segment_clean));
bout_length=diff(transitions);

if bouts(transitions(1)-1)==-1
    starting_running=1;
elseif bouts(transitions(1)-1)==1
    starting_running=0;
else
    warning('starting mode (running/idle) not clear');
end

for i=1:(length(transitions)-1)
segregated_bouts(i,1:(transitions(i+1)-transitions(i)))=segment_clean(transitions(i):transitions(i+1)-1);
end

fit_bout_length=fit([1:length(bout_length(1:2:end))]',bout_length(1:2:end),'poly1');
fit_bout_length2=fit([1:length(bout_length(2:2:end))]',bout_length(2:2:end),'poly1');
end