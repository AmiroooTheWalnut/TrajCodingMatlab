clc
clear
dists=[20	30	40	50	60	70	80	90	100	110	120	130	140	150];
timePercentages=[0.25,0.5,0.75];
epsilon=[0.1,0.5,1,2,3,4,5];
load("resultWorkspace_Dist_TimePercent_Epsilon_Repeat_NumObfuscated_2.mat")
meanProtected=mean(resultsTotalIsolated,4);
figure(1)
clf
hold on
[X,Y]=meshgrid(dists,epsilon);
Z=1-(squeeze(meanProtected(:,3,:))/1696);
h=bar3(Z);
yticks(1:size(dists,2))
get(gca,"XTick")
%xlim([dists(1) dists(end)]);
set(gca, 'YTickLabel', dists);
ylabel("Obfuscation distance")
%ylim([epsilon(1) epsilon(end)]);
set(gca, 'XTickLabel', epsilon);
tempLabels=get(gca, 'XTickLabel');
xLabels=repmat('0.0',size(epsilon,2)+2,1);
for i=1:size(epsilon,2)
    xLabels(i+1,:)=tempLabels(i,:);
end
xLabels(1,1)=' ';
xLabels(1,2)=' ';
xLabels(1,3)=' ';
xLabels(size(epsilon,2)+2,1)=' ';
xLabels(size(epsilon,2)+2,2)=' ';
xLabels(size(epsilon,2)+2,3)=' ';
xlabel("Epsilon")
set(gca, 'XTickLabel', xLabels);
zlim([0,1])
zticks(0:0.1:1)
set(gca, 'ZTickLabel', 0:0.1:1);
zlabel("Percent of obfuscated cars")
grid on
ax = gca;
ax.XTickLabelMode = 'manual';
ax.YTickLabelMode = 'manual';
ax.ZTickLabelMode = 'manual';
ax.XTickMode = 'manual';
ax.YTickMode = 'manual';
ax.ZTickMode = 'manual';
% ax.XTickLabelRotationMode = 'manual';
% ax.YTickLabelRotationMode = 'manual';
% ax.ZTickLabelRotationMode = 'manual';

[X, Y] = meshgrid(1:size(epsilon,2), 1:size(dists,2));

labels = num2str(Z(:), '%0.2f');

% text((X(:)), (Y(:)), Z(:), labels, ...
%     'HorizontalAlignment', 'center', ...
%     'VerticalAlignment', 'bottom', 'BackgroundColor', 'w', 'FontName', 'Times New Roman');

ax.View=[-43.75,47.778132678132664];
ax.CameraPosition=[-28.195177513257306,-55.55910222851322,6.913354386837342];
set(gca,'FontName','Times New Roman');
set(gcf, 'Position', [2908,430,439,334])
exportgraphics(gcf, 'dist_epsilon_numObfuscate_timerPercent0.75.pdf','ContentType','vector')