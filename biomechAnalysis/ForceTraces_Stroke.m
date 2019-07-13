%ForceTraces_Stroke
%CJS
%12/6/2017
%This function plots the early and late forces for a given condiiton in
%both the origonal and shifted state and then shows bar plots indicating
%how we are characterizing the ealry behaviors

close all
clear all

%% Edit
Stroke={'P0001_','P0002_','P0003_','P0004_','P0009_','P0010_','P0011_','P0012_','P0013_','P0014_','P0015_','P0016_','P0001','P0002','P0009','P0010','P0011','P0012','P0015','P0016','P0003','P0004','P0013','P0014'};
subject=Stroke{15};%

load([subject '.mat']);%load('LD0030.mat')
%cond='TM base'; params={'LFy', 'RFy'};
cond='Adap'; params={'LFy', 'RFy'};
cond='adaptation'; params={'LFy', 'RFy'};
%cond='slow base flat';params={'LFz', 'RFz'};
%cond='adaptation';params={'LFz', 'RFz'};
[striderSE, striderFE, LevelofInterest]=GetGRFTraces(expData, cond, params,  [1:20], 0);
[striderSL, striderFL, LevelofInterest]=GetGRFTraces(expData, cond, params,  [40], 1);
% Accounted for this in GetGRFTraces
% if LevelofInterest~=0
%     LevelofInterest=LevelofInterest/2;
% end
%% Compute averages for each gait cycle
% [ SBE SPE] = GetMeanAPForces(striderSE, LevelofInterest)
% [ FBE FPE] = GetMeanAPForces( striderFE, LevelofInterest)
% [ SBL SPL] = GetMeanAPForces(striderSL, LevelofInterest);
% [ FBL FPL] = GetMeanAPForces( striderFL, LevelofInterest);
 %% Compute averages for each gait cycle when the bias is not remobed
% [ SBE_NotShifted SPE_NotShifted] = GetMeanAPForces(striderSE, 0)
% [ FBE_NotShifted FPE_NotShifted] = GetMeanAPForces( striderFE, 0)
% [ SBL_NotShifted SPL_NotShifted] = GetMeanAPForces(striderSL, 0);
% [ FBL_NotShifted FPL_NotShifted] = GetMeanAPForces( striderFL, 0);
%% Compute MAX for each gait cycle
[ SBE SPE SBEindex SPEindex] = GetMaxAPForces(striderSE, LevelofInterest)
[ FBE FPE FBEindex FPEindex] = GetMaxAPForces( striderFE, LevelofInterest)
[ SBL SPL SBLindex SPLindex] = GetMaxAPForces(striderSL, LevelofInterest);
[ FBL FPL FBLindex FPLindex] = GetMaxAPForces( striderFL, LevelofInterest);
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%% 
figure
ax11=subplot(1, 3, 1)
plot(striderSE'-LevelofInterest, 'b')
hold on
plot(striderSL'-LevelofInterest, 'r')
scatter(SBEindex-LevelofInterest, SBE, '.k')
scatter(SPEindex-LevelofInterest, SPE, '.k')
% scatter(FBEindex-LevelofInterest, FBE, '.k')
% scatter(FPEindex-LevelofInterest, FPE, '.k')
scatter(SBLindex-LevelofInterest, SBL, '.k')
scatter(SPLindex-LevelofInterest, SPL, '.k')
% scatter(FBLindex-LevelofInterest, FBL, '.k')
% scatter(FPLindex-LevelofInterest, FPL, '.k')
hline = refline([0 0]);
hline.Color = 'k';
xlabel('Time (ms)')
ylabel('Force (%BW)')
title([subject ': Shifted AP-Forces'])

YYY=ylim;

subplot(1, 3, 2)
DataData=[nanmean(SBE)  nanmean(SBL); nanmean(SPE) nanmean(SPL)];
Datastd=[nanstd(SBE)  nanstd(SBL); nanstd(SPE) nanstd(SPL)];
b=bar(DataData); hold on
%errorbar([-0.1508 0.0805; -0.08402 0.08986],DataData, Datastd, '.k');
errorbar([.85 1.15; 1.85 2.15],DataData, Datastd, '.k');
Labels = {'Braking', 'Propuslion'};
   set(gca, 'XTick', 1:2, 'XTickLabel', Labels);
% b(1).FaceColor='b';
% b(2).FaceColor='r';
% b(3).FaceColor='b';
% b(4).FaceColor='r';
set(gca,'xticklabel',{'Braking', 'Propulsion'})
ylabel('Force (%BW)')
title('Mean Max Braking and Propulsion')
ylim(YYY)
legend({'Early Adaptaiton', 'Late Adaptation'})

subplot(1, 3, 3)
DataData=[nanmean(SBE)-nanmean(SBL) ; nanmean(SPL)-nanmean(SPE) ];
b=bar(DataData);
Labels = {'Braking', 'Propuslion'};
   set(gca, 'XTick', 1:2, 'XTickLabel', Labels);
% b(1).FaceColor='c';
% b(2).FaceColor='c';
set(gca,'xticklabel',{'Braking', 'Propulsion'})
ylabel({'Change of Force (%BW)'; 'during adpatation'})
title('Change in Braking and Propulsion')
ylim(YYY)
% %%  Origonal Old Figures
% figure
% ax1=subplot(1, 3, 1)
% %plot(striderSE', 'b')
% hold on
% plot(striderSL', 'r')
% hline = refline([0 LevelofInterest]);
% hline.Color = 'k';
% hline1 = refline([0 0]);
% hline.Color = 'k';
% set(hline1,'LineStyle',':')
% xlabel('Time (ms)')
% ylabel('Force (%BW)')
% title([subject ': AP-Forces'])
% 
% ax2=subplot(1, 3, 2)
% %plot(striderSE'-LevelofInterest, 'b')
% hold on
% plot(striderSL'-LevelofInterest, 'r')
% hline = refline([0 0]);
% hline.Color = 'k';
% %line([0 600], [0 0])
% xlabel('Time (ms)')
% ylabel('Force (%BW)')
% title([subject ': Shifted AP-Forces'])
% 
% A=min([ax1.YLim ax2.YLim]);
% B=max([ax1.YLim ax2.YLim]);
% ylim(ax1,[A B])
% ylim(ax2,[A B])
% %linkaxes([ax1,ax2],'xy')
% 
% 
% subplot(1, 3, 3)
% DataData=[nanmean(SBE_NotShifted)  nanmean(SBL_NotShifted) nanmean(SBL_NotShifted)-nanmean(SBE_NotShifted) nanmean(SBE)  nanmean(SBL) nanmean(SBL)-nanmean(SBE);...
%     nanmean(SPE_NotShifted) nanmean(SPL_NotShifted) nanmean(SPL_NotShifted)-nanmean(SPE_NotShifted) nanmean(SPE) nanmean(SPL) nanmean(SPL)-nanmean(SPE)];
% b=bar(DataData);
% b(1).FaceColor='b';
% b(2).FaceColor='r';
% b(3).FaceColor='k';
% b(1).EdgeColor = 'c';b(1).LineWidth = 3;
% b(2).EdgeColor = 'c';b(2).LineWidth = 3;
% b(3).EdgeColor = 'c';b(3).LineWidth = 3;
% b(4).FaceColor='b';
% b(5).FaceColor='r';
% b(6).FaceColor='k';
% b(4).EdgeColor = 'k';b(4).LineWidth = 3;
% b(5).EdgeColor = 'k';b(5).LineWidth = 3;
% b(6).EdgeColor = 'k';b(6).LineWidth = 3;
% 
% set(gca,'xticklabel',{'Braking', 'Propulsion'})
% legend({'Early Adaptation Not Shifted', 'Late Adaptation Not Shifted', 'Shifted Late-Early', 'Early Adaptation', 'Late Adaptation', 'Late-Early'})
% ylabel('Force (%BW)')
% title('Mean Braking and Propulsion')
