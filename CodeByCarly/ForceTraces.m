%ForceTraces
%CJS
%This function plots the early and late forces for a given condition, the
%peak braking and propuslion force behavior, and the Delta behavior for an
%example subject.
%This function assumes that you are in the correct foulder with all the
%individual subject Data

close all
clear all

%% Edit
Young={'LN0002','LN0003','LN0004','LN0005','LN0006','LN0007','LN0008','LN0009','LI0013','LI0016','LI0018','LI0023','LI0024','LI0026','LI0027','LI0028','LD0015','LD0017','LD0019','LD0020','LD0021','LD0029','LD0030','LD0031'};
subject=Young{1};%10 doesnt work?
subject=Young{23};% A representative subject, also consider indices(6, 16, 18, 19, 20)

load([subject '.mat']);
cond='TM base'; params={'LFy', 'RFy'};
[striderSE, striderFE, LevelofInterest]=GetGRFTraces(expData, cond, params,  [1:20], 0);
[striderSL, striderFL, LevelofInterest]=GetGRFTraces(expData, cond, params,  [40], 1);

%% Compute MAX behavior for each gait cycle
[ SBE SPE SBEindex SPEindex] = GetMaxAPForces(striderSE, LevelofInterest);
[ FBE FPE FBEindex FPEindex] = GetMaxAPForces( striderFE, LevelofInterest);
[ SBL SPL SBLindex SPLindex] = GetMaxAPForces(striderSL, LevelofInterest);
[ FBL FPL FBLindex FPLindex] = GetMaxAPForces( striderFL, LevelofInterest);
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%% 
figure
ax11=subplot(1, 3, 1);
plot(striderSE'-LevelofInterest, 'b')
hold on
plot(striderSL'-LevelofInterest, 'r')
scatter(SBEindex-LevelofInterest, SBE, '.k')
scatter(SPEindex-LevelofInterest, SPE, '.k')
scatter(SBLindex-LevelofInterest, SBL, '.k')
scatter(SPLindex-LevelofInterest, SPL, '.k')
hline = refline([0 0]);
hline.Color = 'k';
xlabel('Time (ms)')
ylabel('Force (%BW)')
title([subject ': Shifted AP-Forces'])
xlim([0 100])

YYY=ylim;

subplot(1, 3, 2)
DataData=[nanmean(SBE)  nanmean(SBL); nanmean(SPE) nanmean(SPL)];
Datastd=[nanstd(SBE)  nanstd(SBL); nanstd(SPE) nanstd(SPL)];
b=bar(DataData); hold on
errorbar([.85 1.15; 1.85 2.15],DataData, Datastd, '.k');
Labels = {'Braking', 'Propuslion'};
   set(gca, 'XTick', 1:2, 'XTickLabel', Labels);
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
set(gca,'xticklabel',{'Braking', 'Propulsion'})
ylabel({'Change of Force (%BW)'; 'during adpatation'})
title('Change in Braking and Propulsion')
ylim(YYY)

set(gcf,'color','w');
set(gcf, 'render', 'painter')