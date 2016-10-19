%% Setting the regions and G4 expression patterns
cd('C:/Users/debivortlab/Desktop/screengraphs')

MBregion={'y1(PPL1)MP1','ped(PPL1)MP1','a2(PPL1)V1','a`2(PPL1)V1','a`1(PPL1)V1/MV1','y2(PPL1,PAM)MV1','a3(PPL1)','a`3(PPL1)',...
'b2(PAM)M3','b`2(PAM)M3','b1(PAM)','a1(PAM)','b`1(PAM)','y5(PAM)','y4(PAM)','y3(PAM)','ca(PPL2ab)'};

% th =[0.9 0.9 0.9 0.9 0.9 0.9 0.9 0.9 0.6 0.3 0 0.9 0 0.3 0 0 0.6];
thchag80 =[0.9 0.9 0.9 0.9 0.9 0.9 0.9 0.3 0 0 0 0 0 0 0 0 0.3];
hl8 =[0.3 0 0 0 0 0 0 0.6 0.9 0.3 0.6 0.9 0.9 0.9 0.9 0.6 0.6];
np47mbg80 =[0.9 0.6 0.9 0.9 0.9 0.9 0 0 0 0 0 0 0 0 0 0 0];
htr1b =[0 0 0.9 0.9 0.6 0.6 0 0 0 0 0 0 0 0 0 0 0];
htr1bchag80 =[0 0 0.6 0.6 0.6 0 0 0 0 0 0 0 0 0 0 0 0];
mz840 =[0 0 0.9 0.9 0.9 0 0 0 0 0 0 0 0 0 0 0 0];
mz19chag80 =[0 0 0 0 0 0 0 0 0 0.6 0 0 0 0.6 0 0 0];
np6510 =[0 0.6 0 0 0 0 0 0 0.9 0.9 0.6 0 0 0 0 0 0];
np5272 =[0 0 0 0 0 0 0 0 0.9 0.3 0 0 0 0 0 0 0];
np1528 =[0 0 0 0 0 0 0 0 0.9 0.3 0 0 0 0 0 0 0];
mb315c =[0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0];
mb109b =[0 0 0 0 0 0 0 0 0 0.5 0 0 0 0 0 0 0];
mb301b =[0 0 0 0 0 0 0 0 0.3 0.3 0 0 0 0 0 0 0];
mb056b =[0 0 0 0 0 0 0 0 0 0.7 0 0 0 0 0 0 0];
mb032b =[0 0 0 0 0 0 0 0 0 0.6 0 0 0 0 0 0 0];
mb299b =[0 0 0 0 0 0 0 0 0 0 0 0.4 0 0 0 0 0];
mb025b =[0 0 0 0 0 0 0 0 0 0 0 0 0.6 0 0 0 0];
mb438b =[0.1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
mb439b =[0 0 0 0 0.1 0.1 0 0 0 0 0 0 0 0 0 0 0];
mb304b =[0 0 0 0 0 0 0 0.1 0 0 0 0 0 0 0 0 0];
mb058b =[0 0 0.1 0.1 0 0 0 0 0 0 0 0 0 0 0 0 0];
mb065b =[0 0 0 0 0 0 0.1 0 0 0 0 0 0 0 0 0 0];
mb060b =[0 0 0 0 0 0 0.1 0 0 0 0 0 0 0 0 0 0];
np6510np5272 =[0 0.6 0 0 0 0 0 0 1 1 0.6 0 0 0 0 0 0];
mz840np6510 =[0 0.6 0.9 0.9 0.9 0 0 0 0.9 0.9 0.6 0 0 0 0 0 0];
np5272mz840 =[0 0 0.9 0.9 0.9 0 0 0 0.9 0.3 0 0 0 0 0 0 0];
a58e02=[0.9 0.9 0 0 0 0.9 0 0 0.9 0.9 0.9 0.9 0.3 0.9 0.9 0.3 0];
a58e02thg80=[0 0 0 0 0 0 0 0 0.3 0.6 0.9 0 0.3 0.6 0.9 0.3 0];

expression_table=cat(1,thchag80,hl8,np47mbg80,htr1b,htr1bchag80,mz840,mz19chag80,np6510,np5272,np1528,mb315c,... 
mb109b,mb301b,mb056b,mb032b,mb299b,mb025b,mb438b,mb439b,mb304b,mb058b,mb065b,mb060b,np6510np5272,mz840np6510,np5272mz840,a58e02,a58e02thg80);

G4={'thchag80','hl8','np47mbg80','5htr1b','5htr1bchag80','mz840','mz19chag80','np6510','np5272','np1528','mb315c',... 
'mb109b','mb301b','mb056b','mb032b','mb299b','mb025b','mb438b','mb439b','mb304b','mb058b','mb065b','mb060b',...
'np6510np5272','mz840np6510','np5272mz840','58e02','58e02thg80'};
[G4 order1]=sort(G4);
expression_table=expression_table(order1,:);

%Sorting G4s
dirty_G4=[1 2 3 4 5 19 20 21 22 23 24 25 26 27 28];
split_G4=[6:18];

% Selecting the lines to make the model from
expression_table=expression_table(split_G4,:);
G4={G4{split_G4}};

%% PCA from G4 expression
[coeff,score,latent]=pca(expression_table);
figure
bar(latent)
title('weighted')

binary_expression_table=logical(expression_table);
[coeff,score,latent]=pca(binary_expression_table);
figure
bar(latent)
title('binary')

imagesc(corrcoef(expression_table));
colorbar;

%% Deleting columns
newcolumn345=mean(binary_expression_table(:,[3 4 5]),2);
binary_expression_table(:,3)=newcolumn345;
binary_expression_table(:,5)=[];

newcolumn1415=mean(expression_table(:,14:15),2);
expression_table(:,14)=newcolumn1415;
expression_table(:,15)=[];


%% Sorting and deleting the G4s and MB regions
[sorted_G4_names order_G4]=sort(G4);
sorted_G4_expression=expression_table(order_G4,:);


%Eliminating the flyLine and total_effect_mean lines not present in the
%expression table
exclude=ones(1,48);
exclude([1 2 3 4 5 6 7 12 27 31 34 39 40 41 42 43 44 45 46 47])=0;
exclude=logical(exclude);
flyLine2={flyLine{exclude}};
total_effect_mean2=total_effect_mean(exclude);

[sorted_G4_arena_names order_G4_arena]=sort(flyLine2);
sorted_G4_arena_names=sorted_G4_arena_names(split_G4);
sorted_G4_arena_mean=total_effect_mean2(order_G4_arena);
sorted_G4_arena_mean=sorted_G4_arena_mean(split_G4);
%% Expression table
image_expression=imagesc(mat2gray(sorted_G4_expression, [0 1])); colormap(flipud(gray)); colorbar;
hold on
set(gca,'xtick',1:17);
set(gca,'XTickLabel',MBregion);
ax = gca;
ax.XTickLabelRotation = -45;
set(gca,'ytick',1:length(G4));
set(gca,'YTickLabel',G4);
hold off

sorted_G4_expression=logical(sorted_G4_expression);
%% Solving the linear system
parameter_value = sorted_G4_expression\sorted_G4_arena_mean;
% parameter_value = mldivide(sorted_G4_expression,sorted_G4_valence_mean)

predicted_mean=sorted_G4_expression*parameter_value;

%%Plotting the valences of DANs
figure
bar(parameter_value,'Facecolor',rand(1,3))
hold on
set(gca,'xtick',1:length(MBregion));
set(gca,'XTickLabel',MBregion);
% set(gca,'XTickLabel',{MBregion{[1 2 3 5 6 7 8 9 10 11 12 13 14 15 17]}});
ax = gca;
ax.XTickLabelRotation = -45;
xlabel('MB inervation (DAN cell body location)')
ylabel('Arm occupancy ratio')
title('Contribution of DANs to arm occupancy in Ymazes')
hold off


%%Plotting the predicted valences of DANs and the observed
plot_predictedobserved=cat(2,sorted_G4_arena_mean,predicted_mean);

figure
bar(plot_predictedobserved)
hold on
set(gca,'xtick',1:length(G4'));
set(gca,'XTickLabel',G4);
ax = gca;
ax.XTickLabelRotation = -45;
xlabel('G4 line')
ylabel('Arm occupancy ratio')
title('Predicted vs Observed arm occupancies')
legend('Observed','Predicted')
hold off

%% RMSE for the fit
RMSE=sqrt(mean(sorted_G4_arena_mean-predicted_mean).^2)

%% Forward stepwise selection for the model

[betahat,se,pval,inmodel,stats] = ...
          stepwisefit(sorted_G4_expression,sorted_G4_arena_mean,...
                      'penter',.05,'premove',0.40,...
                      'display','on');
                  %                       'inmodel',initialModel,...
RMSE = stats.rmse
                  
stepwise(sorted_G4_expression,sorted_G4_arena_mean);
%% Lasso model
  
[B FitInfo] = lasso(sorted_G4_expression,sorted_G4_arena_mean,'CV',10,'Alpha',0.01);
[B FitInfo] = lasso(sorted_G4_expression,sorted_G4_arena_mean,'CV',10);


lassoPlot(B,FitInfo,'PlotType','CV','PredictorNames',MBregion);
lassoPlot(B,FitInfo,'PlotType','Lambda','PredictorNames',MBregion);
lassoPlot(B,FitInfo,'PlotType','L1','PredictorNames',MBregion);


figure
bar(B(:,15),'Facecolor',rand(1,3))
hold on
set(gca,'xtick',1:length(MBregion));
set(gca,'XTickLabel',MBregion);
% set(gca,'XTickLabel',{MBregion{[1 2 3 5 6 7 8 9 10 11 12 13 14 15 17]}});
ax = gca;
ax.XTickLabelRotation = -45;
xlabel('MB inervation (DAN cell body location)')
ylabel('Arm occupancy ratio')
title('Contribution of DANs to arm occupancy in Ymazes')
hold off

%% Modelling with PCA output

% DANs_from_PCA=coeff*latent;
% % DANs_from_PCA=sum(repmat(latent,1,17)'.*coeff,2);
% figure
% bar(DANs_from_PCA,'Facecolor',rand(1,3))
% hold on
% set(gca,'xtick',1:length(MBregion));
% set(gca,'XTickLabel',MBregion);
% % set(gca,'XTickLabel',{MBregion{[1 2 3 5 6 7 8 9 10 11 12 13 14 15 17]}});
% ax = gca;
% ax.XTickLabelRotation = -45;
% xlabel('MB inervation (DAN cell body location)')
% ylabel('sum of each dimension weights')
% title('Total weight of each cluster mixed for all PCs')
% hold off


parameter_value = score\sorted_G4_arena_mean;
% parameter_value = mldivide(sorted_G4_expression,sorted_G4_valence_mean)

predicted_mean=score*parameter_value;

%%Plotting the valences of DANs
figure
bar(parameter_value,'Facecolor',rand(1,3))
hold on
set(gca,'xtick',1:length(MBregion));
% set(gca,'XTickLabel',MBregion);
% set(gca,'XTickLabel',{MBregion{[1 2 3 5 6 7 8 9 10 11 12 13 14 15 17]}});
ax = gca;
ax.XTickLabelRotation = -45;
xlabel('PC')
ylabel('Arm occupancy ratio')
title('Contribution of PC to arm occupancy in Ymazes')
hold off


%%Plotting the predicted valences of DANs and the observed
plot_predictedobserved=cat(2,sorted_G4_arena_mean,predicted_mean);

figure
bar(plot_predictedobserved)
hold on
set(gca,'xtick',1:length(G4'));
set(gca,'XTickLabel',G4);
ax = gca;
ax.XTickLabelRotation = -45;
xlabel('G4 line')
ylabel('Arm occupancy ratio')
title('Predicted vs Observed arm occupancies')
legend('Observed','Predicted')
hold off

DANs_rebuild=coeff*parameter_value
figure
bar(DANs_rebuild,'Facecolor',rand(1,3))
hold on
set(gca,'xtick',1:length(MBregion));
set(gca,'XTickLabel',MBregion);
% set(gca,'XTickLabel',{MBregion{[1 2 3 5 6 7 8 9 10 11 12 13 14 15 17]}});
ax = gca;
ax.XTickLabelRotation = -45;
xlabel('MB inervation (DAN cell body location)')
ylabel('Arm occupancy ratio')
title('Contribution of DANs to arm occupancy in Ymazes')
hold off