function[area_speed_norm]=speed_map(flyTracks,speed,delete)

bins = 50;
area_speed=nan(bins-1,bins-1,size(speed,2));
trail_delete=length(flyTracks.currentarm)-length(speed);
flyTracks.centroid=flyTracks.centroid(:,:,delete);

for fly=1:size(speed,2)

 
xbins = linspace(min(flyTracks.centroid((trail_delete+1):end,1,fly)),max(flyTracks.centroid((trail_delete+1):end,1,fly)),bins);
ybins = linspace(min(flyTracks.centroid((trail_delete+1):end,2,fly)),max(flyTracks.centroid((trail_delete+1):end,2,fly)),bins);
[nx,edges,idxx] = histcounts(flyTracks.centroid((trail_delete+1):end,1,fly),xbins);
[ny,edges,idxy] = histcounts(flyTracks.centroid((trail_delete+1):end,2,fly),ybins);


for i=1:max(idxx)
    for oo=1:max(idxy)
area_speed(i,oo,fly)=mean(speed(idxx==i & idxy==oo,fly),'omitnan');
    end
end

for fly=1:size(speed,2)

 
xbins = linspace(min(flyTracks.centroid((trail_delete+1):end,1,fly)),max(flyTracks.centroid((trail_delete+1):end,1,fly)),bins);
ybins = linspace(min(flyTracks.centroid((trail_delete+1):end,2,fly)),max(flyTracks.centroid((trail_delete+1):end,2,fly)),bins);
[nx,edges,idxx] = histcounts(flyTracks.centroid((trail_delete+1):end,1,fly),xbins);
[ny,edges,idxy] = histcounts(flyTracks.centroid((trail_delete+1):end,2,fly),ybins);


for i=1:max(idxx)
    for oo=1:max(idxy)
area_speed(i,oo,fly)=mean(speed(idxx==i & idxy==oo,fly),'omitnan');
    end
end


total=max(max(area_speed(:,:,fly)));
area_speed_norm(:,:,fly)=area_speed(:,:,fly)./total;
    
figure(2);
hold on;
h=imagesc(xbins,ybins,flipud(area_speed_norm(:,:,fly)));
colorbar; 
axis([min(xbins) max(xbins) min(ybins) max(ybins)]);
hold off;
shg;
pause(1);

end


% The problem here is that if I want to plot alltogether I would have to
% align and scale every Y-maze


end