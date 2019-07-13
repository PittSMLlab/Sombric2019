%InclineDeclineStudyMultipleLinearRegressions

close all
clear all
clc
load('StudyData.mat'); groups = { 'DeclineYoungAbrupt','FlatYoungAbrupt','InclineYoungAbrupt'};
params = {'FyBSmax','FyBFmax','FyPSmax','FyPFmax','netContributionNorm2', 'TMAngle','FyBmaxSym', 'FyPmaxSym', 'stepLengthFast', 'stepLengthSlow','FyImpactMagS','FyImpactMagF', 'FySBmaxQS','FySPmaxQS','FyFBmaxQS','FyFPmaxQS'};

RF=getForceResults(StudyData,params,groups,0, 0, 0, 1);

poster_colors;
colorOrder=[p_red;  p_orange;p_fade_green; p_fade_blue; p_plum; p_green; p_blue; p_fade_red; p_lime; p_yellow; [0 0 0]; p_red; p_orange; p_fade_green; p_fade_blue; p_plum];

%% REAL LINEAR REGRESSION
SLA=RF.TMafter.indiv.netContributionNorm2(:,2);

GrpMeanSLA=[];GrpMeanSLA_ODD=[];GrpMeanSLA_EVEN=[];
for g=1:length(groups)
    grp=find(RF.TMafter.indiv.netContributionNorm2(:,1)==g);% NEW 11/17/2018
    GrpMeanSLA=[GrpMeanSLA; ones(length(grp), 1)*nanmean(SLA(grp, 1))];
    ENDERS(g)=grp(end);
    STARTERS(g)=grp(1);
    clear grp
end

SLA=RF.TMafter.indiv.netContributionNorm2(:,2);% NEW 11/17/2018
incline=RF.MidBase.indiv.TMAngle(:,2);
incline=incline/8.5;

%% Propulsion Prediction Model
SPpert=RF.SpeedAdapDiscont.indiv.FyPSmax(:,2);
FPpert=RF.SpeedAdapDiscont.indiv.FyPFmax(:,2);
SPbase=RF.MidBase.indiv.FyPSmax(:,2);
FPbase=RF.MidBase.indiv.FyPFmax(:,2);
FB_Psym=RF.FastBase.indiv.FyPmaxSym(:,2);

%% SL-Prediciton Model
SSLpert=RF.SpeedAdapDiscont.indiv.stepLengthSlow(:,2);
FSLpert=RF.SpeedAdapDiscont.indiv.stepLengthFast(:,2);
SSLbase=RF.MidBase.indiv.stepLengthSlow(:,2);
FSLbase=RF.MidBase.indiv.stepLengthFast(:,2);
SLAbase=RF.FastBase.indiv.netContributionNorm2(:,2);

%% Braking Prediciton Model
SBpert=RF.SpeedAdapDiscont.indiv.FyBSmax(:,2);
FBpert=RF.SpeedAdapDiscont.indiv.FyBFmax(:,2);
SBbase=RF.MidBase.indiv.FyBSmax(:,2);
FBbase=RF.MidBase.indiv.FyBFmax(:,2);
FB_Bsym=RF.FastBase.indiv.FyBmaxSym(:,2);
SB_Bsym=RF.SlowBase.indiv.FyBmaxSym(:,2);

%% Running the models to see which predictors are signficant
% Just early Adaptation behavior
tblAll = table(incline, SPpert,FPpert,SBpert,FBpert, SLA, 'VariableNames',{'Slope', 'SPpert','FPpert','SBpert','FBpert','SLA_AE'});tblAll.Slope = categorical(tblAll.Slope);lm = fitlm(tblAll,'linear');
tblAll = table(SPpert,FPpert,SBpert,FBpert, SLA, 'VariableNames',{'SPpert','FPpert','SBpert','FBpert','SLA_AE'});lm = fitlm(tblAll,'linear')
mdl = stepwiselm(tblAll,'interactions');


% Propulsion-Prediction Model
tblAll = table(incline, SPpert,FPpert,SPbase,FPbase, FB_Psym, SLA, 'VariableNames',{'Slope', 'SPpert','FPpert','SPbase','FPbase', 'FastBase_PSym','SLA_AE'});tblAll.Slope = categorical(tblAll.Slope);lm = fitlm(tblAll,'linear');

% Step Length-Prediciton Model
tblAll = table(incline, SSLpert,FSLpert,SSLbase,FSLbase, SLAbase, SLA, 'VariableNames',{'Slope', 'SSLpert','FSLpert','SSLbase','FSLbase', 'SLA_FBase','SLA_AE'});tblAll.Slope = categorical(tblAll.Slope);lm = fitlm(tblAll,'linear');

% Group mean-model
tblgrp = table(incline, SLA, 'VariableNames',{'Slope', 'SLA_AE'});tblgrp.Slope = categorical(tblgrp.Slope);lmgrp = fitlm(tblgrp,'linear')

% Braking-Prediciton Model
tblAll = table(incline, SBpert,FBpert,SBbase,FBbase, FB_Bsym, SLA, 'VariableNames',{'Slope', 'SBpert','FBpert','SBbase','FBbase', 'FastBase_BSym','SLA_AE'});tblAll.Slope = categorical(tblAll.Slope);lm = fitlm(tblAll,'linear');

%% Calculating the BIC models

% Propulsion Prediction Model
tbl_ASAS = table(SPpert,SPbase, FB_Psym, SLA, 'VariableNames',{'SPpert','SPbase', 'FastBase_PSym','SLA_AE'});lm_ASAS = fitlm(tbl_ASAS,'linear')
eval(['SLA_ASAS=@(x, y, z) ' num2str(lm_ASAS.Coefficients{1, 1}) '+' num2str(lm_ASAS.Coefficients{2, 1}) '*x + ' num2str(lm_ASAS.Coefficients{3, 1}) '*y+ ' num2str(lm_ASAS.Coefficients{4, 1}) '*z;'])
PredictedSLA_ASAS=SLA_ASAS(RF.SpeedAdapDiscont.indiv.FyPSmax(:,2), RF.MidBase.indiv.FyPSmax(:,2), RF.FastBase.indiv.FyPmaxSym(:,2));
residersMeanMDL_ASAS=GrpMeanSLA-SLA;
residersMyMDL_ASAS=PredictedSLA_ASAS-SLA;

% Step Length Prediction Model
tblSL = table( SSLpert,SLA, 'VariableNames',{'SSLpert','SLA_AE'});lmSL = fitlm(tblSL,'linear');
eval(['SLA_SL=@(x) ' num2str(lmSL.Coefficients{1, 1}) '+' num2str(lmSL.Coefficients{2, 1}) '*x;'])
PredictedSLA_SL=SLA_SL(RF.SpeedAdapDiscont.indiv.stepLengthSlow(:,2));
residersMyMDL_SL=PredictedSLA_SL-SLA;

%% Plotting
C = repmat(linspace(1,0.1,length(groups)).',1,3);

DeltaBIC=lmgrp.ModelCriterion.BIC-lm_ASAS.ModelCriterion.BIC;
BF=exp(DeltaBIC/2);

DeltaBIC_SL=lmSL.ModelCriterion.BIC-lm_ASAS.ModelCriterion.BIC;
BF_SL=exp(DeltaBIC_SL/2);

hh=0.25;
figure;
subplot(2, 2, 1)% All subjects, All Stides
for g=1:length(groups)
    area([STARTERS(g)-.5 ENDERS(g)+.5], [hh hh], 'FaceColor', C(g, :), 'FaceAlpha', 0.2); hold on
end
plot(abs(residersMyMDL_ASAS), 'm', 'LineWidth', 4); line([0 25], [mean(abs(residersMyMDL_ASAS)) mean(abs(residersMyMDL_ASAS))], 'LineStyle', '--', 'Color', 'm');
plot(abs(residersMeanMDL_ASAS), 'y', 'LineWidth', 4); line([0 25], [mean(abs(residersMeanMDL_ASAS)) mean(abs(residersMeanMDL_ASAS))], 'LineStyle', '--', 'Color', 'y');
legend(groups{:}, 'My Model','My Model: |Res|','Mean Model','Mean Model: |Res|', 'FontSize',20, 'Location', 'eastoutside');
xlabel('EACH Subject', 'FontSize', 12)
title({['All Subjects, All Stides (5)']; [lm_ASAS.Formula.LinearPredictor]; ['DelBIC = ', num2str(DeltaBIC), '; ~BF=', num2str(BF)]; ['My Mean |Error| :' num2str(nanmean(abs(residersMyMDL_ASAS))) ' Vs. Group Mean |Error| :' num2str(nanmean(abs(residersMeanMDL_ASAS)))]}, 'FontSize', 12)
[~, p]=ttest(abs(residersMyMDL_ASAS), abs(residersMeanMDL_ASAS), 'Tail', 'left');
ylabel(['|Residuals|; ttest --> p = ', num2str(p)], 'FontSize', 12)

subplot(2, 2, 2)
for g=1:3
    grp=find(incline==(g-2));
scatter(SLA(grp), PredictedSLA_ASAS(grp),'o', 'MarkerFaceColor', colorOrder(g, :), 'MarkerEdgeColor', 'k'); hold on
scatter(SLA(grp), GrpMeanSLA(grp), '^', 'MarkerEdgeColor', colorOrder(g, :), 'MarkerFaceColor', 'k');
clear grp
end
legend(['Propulsion Predicitons: ' groups{1}], ['Mean Learning Preditions' groups{1}],  groups{2},groups{2},groups{3},groups{3})
line([0.1 .65], [0.1 .65], 'Color', 'k')
xlim([0.1 .65])
ylim([0.1 .65])
xlabel('Actual SLA Learning')
ylabel('Predicted Learning')
axis square

subplot(2, 2, 3)% SL MODEL
for g=1:length(groups)
    area([STARTERS(g)-.5 ENDERS(g)+.5], [hh hh], 'FaceColor', C(g, :), 'FaceAlpha', 0.2); hold on
end
plot(abs(residersMyMDL_ASAS), 'm', 'LineWidth', 4); line([0 25], [mean(abs(residersMyMDL_ASAS)) mean(abs(residersMyMDL_ASAS))], 'LineStyle', '--', 'Color', 'm');
plot(abs(residersMyMDL_SL), 'y', 'LineWidth', 4); line([0 25], [mean(abs(residersMyMDL_SL)) mean(abs(residersMyMDL_SL))], 'LineStyle', '--', 'Color', 'y');
legend(groups{:}, 'My Model','My Model: |Res|','SL Model','Mean Model: |Res|', 'FontSize',20, 'Location', 'eastoutside');
xlabel('EACH Subject', 'FontSize', 12)
title({['Compare Propulsion with SL model']; [lmSL.Formula.LinearPredictor]; ['DelBIC_SL = ', num2str(DeltaBIC_SL), '; ~BF_SL=', num2str(BF_SL)]; ['My Mean |Error| :' num2str(nanmean(abs(residersMyMDL_ASAS))) ' Vs. Group Mean |Error| :' num2str(nanmean(abs(residersMyMDL_SL)))]}, 'FontSize', 12)
[~, p]=ttest(abs(residersMyMDL_ASAS), abs(residersMyMDL_SL), 'Tail', 'left');
ylabel(['|Residuals|; ttest --> p = ', num2str(p)], 'FontSize', 12)

subplot(2, 2, 4)
for g=1:3
    grp=find(incline==(g-2));
scatter(SLA(grp), PredictedSLA_ASAS(grp),'o', 'MarkerFaceColor', colorOrder(g, :), 'MarkerEdgeColor', 'k'); hold on
scatter(SLA(grp), GrpMeanSLA(grp), '^', 'MarkerEdgeColor', colorOrder(g, :), 'MarkerFaceColor', 'k');
scatter(SLA(grp), PredictedSLA_SL(grp), 'o',  'MarkerEdgeColor',colorOrder(g, :), 'MarkerFaceColor', 'w');
clear grp
end
legend(['Propulsion Predicitons: ' groups{1}], ['Mean Learning Preditions' groups{1}], ['SL Predictions: ' groups{1}],  groups{2},groups{2},groups{2}, groups{3},groups{3},groups{3})
line([0.1 .65], [0.1 .65], 'Color', 'k')
xlim([0.1 .65])
ylim([0.1 .65])
xlabel('Actual SLA Learning')
ylabel('Predicted Learning')
axis square
set(gcf,'renderer','painters')
return
%%
