indicess=ones(1,48)
indicess(34)=0
indicess=logical(indicess)

flyLine={flyLine{indicess}}
total_effect_mean=total_effect_mean(indicess)

[corr_flyLine corr_number]=sort(flyLine3)
corr_mean=avg_effect_flies3(corr_number)

plot(typereinfvalencefit,corr_mean,total_effect_mean_valence,'.')
text(corr_mean,total_effect_mean_valence,corr_flyLine)

[typereinfvalencefit gof]=fit(corr_mean,total_effect_mean_valence,'poly1')

plot(speedvalence_fit,total_effect_valence,total_effect_speed,'.')
text(total_effect_valence,total_effect_speed,flyLine2)
xlabel('Valence effect')
ylabel('Reinforcement type not normalized')
title('Correlation in between speed reinforcement type difference and valence')

[speedvalence_fit conf]=fit(total_effect_valence,total_effect_speed, 'poly1');
figure
subplot(3,1,1)
plot(speedvalence_fit,dwellfit(:,1),dwellfit(:,2));