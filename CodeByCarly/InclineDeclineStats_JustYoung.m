%Figures and Stats for Sombric et al. 2019

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Note that you need to change your current directory to have the data
% files and this code present.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Young Methods Figure -- Figure 1 in the final paper
ForceTraces

%% Young Figure 2, 3, 5
clear all
close all
clc
load('StudyData.mat')
adaptDataList = {StudyData.DeclineYoungAbrupt.adaptData,StudyData.FlatYoungAbrupt.adaptData,StudyData.InclineYoungAbrupt.adaptData};
binWidth = 5;
trialMarkerFlag = [0  0  0];
indivSubFlag = 0;
IndivSubList = 0;
groups = {'DeclineYoungAbrupt','FlatYoungAbrupt','InclineYoungAbrupt'};

% Step Length Visualization -- Figure 4 in the final paper
StepLengthVis(StudyData, groups)

%Figure 5 in the final paper
params = {'FyBSmax','FyBFmax','FyPSmax','FyPFmax'}; removeBias =0;
epochs={'SpeedAdapDiscont',  'TMafter','DelFAdapt'}; %Which should be the same as.. epochs={'SpeedAdapDiscont',  'DelFDeAdapt2Base','DelFAdapt'};
RF=getForceResults(StudyData,params,groups,0, 0, 0, 1);
conds = {'adaptation', 'TM post'};
InclineDeclineFigure2V3(adaptDataList,params,conds,binWidth,trialMarkerFlag,indivSubFlag,IndivSubList,removeBias,groups, StudyData, RF, epochs)

%Figure 2 in the final paper
params = {'netContributionNorm2'}; removeBias =1;
RF_K=getForceResults(StudyData,params,groups,0, 0, 0, removeBias);
epochs={'TMSteady', 'EarlyA', 'TMafter', 'DelFAdapt'};
conds = {'TM base','adaptation','TM post'};
InclineDeclineFigure3V3(adaptDataList,params,conds,binWidth,trialMarkerFlag,indivSubFlag,IndivSubList,removeBias,groups, StudyData, RF_K, epochs)

%Figure 3 in the final paper
params = {'stepLengthSlow','stepLengthFast'}; removeBias =0;
conds = {'slow', 'fast', 'TM base','adaptation','TM post'};
RF=getForceResults(StudyData,params,groups,0, 0, 0, removeBias);
RF_NoBias=getForceResults(StudyData,params,groups,0, 0, 0, 1);
InclineDeclineFigure5V3(adaptDataList,params,conds,binWidth,trialMarkerFlag,indivSubFlag,IndivSubList,removeBias,groups,  RF, RF_NoBias)

% Figure 6 in the final paper
params = {'FyBSmax','FyBFmax','FyPSmax','FyPFmax', 'FyPmaxSym', 'FyBmaxSym', 'stepLengthFast', 'stepLengthSlow', 'netContributionNorm2', 'XSlow', 'XFast', 'alphaSlow', 'alphaFast'};%, 'SYZmag', 'FYZMag',  'FzFmax', 'FzSmax'};,  'FySBmaxQS','FySPmaxQS','FyFBmaxQS','FyFPmaxQS'
RF=getForceResults(StudyData,params,groups,0, 0, 0, 1);
params = {'spatialContributionNorm2','stepTimeContributionNorm2','velocityContributionNorm2','netContributionNorm2', 'stepLengthFast', 'stepLengthSlow'};
RK=getResults(StudyData,params,groups,0, 0, 0, 1);
InclineDeclineFigure6V2(StudyData,RF, RK, groups)

%% LINEAR REGRESSION-- Analysis Not included in the paper
InclineDeclineStudyMultipleLinearRegressionsV2


