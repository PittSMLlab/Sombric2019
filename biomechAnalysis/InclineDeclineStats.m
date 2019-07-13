%Stats for the incline decline study

%% FOR COM CALC
Young={'LN0002'}
%Young={'LD0015','LD0017','LD0019','LD0020','LD0021','LD0029','LD0030','LD0031'};
%Young={'LN0002','LN0003','LN0004','LN0005','LN0006','LN0007','LN0008','LN0009', 'LI0013','LI0016','LI0018','LI0023','LI0024','LI0026','LI0027','LI0028','LD0015','LD0017','LD0019','LD0020','LD0021','LD0029','LD0030','LD0031'};
%Young={'LN0002','LN0003','LN0004','LN0005','LN0006','LN0007','LN0008','LN0009', 'LI0013','LI0016','LI0018','LI0023','LI0024','LI0026','LI0027','LI0028'};
%Young={'LD0030'};
updateParams(Young,[],0)
load('LI0018params.mat')
oldNames=adaptData.metaData.conditionName;
newNames={'slow flat','fast flat','TM base flat','slow','catch','fast','TM base','adaptation','TM post','flat post'};
load('DumbTester7.mat')
inclinePeople={'LI0013','LI0016','LI0018','LI0023','LI0024','LI0026','LI0027','LI0028'};
changeCondName(inclinePeople,oldNames,newNames);

oldNames={'50 strides at 0.5 m/s','50 strides at 1.5 m/s','50 strides at 1.0 m/s','50 strides at 0.5 m/s w/ treadmill at 8.5 deg decline','10 strides 3:1 w/ treadmill at 8.5 deg decline','50 strides at 1.5 m/s w/ treadmill at 8.5 deg decline','50 strides at 1.0 m/s w/ treadmill at 8.5 deg decline','200 strides 3:1 w/ treadmill at 8.5 deg decline ','200 strides at 1.0 m/s w/ treadmill at 8.5 deg incline','200 strides at 1.0 m/s w/ treadmill flat'};
newNames={'50 strides at 0.5 m/s','50 strides at 1.5 m/s','50 strides at 1.0 m/s','50 strides at 0.5 m/s w/ treadmill at 8.5 deg decline','10 strides 3:1 w/ treadmill at 8.5 deg decline','50 strides at 1.5 m/s w/ treadmill at 8.5 deg decline','50 strides at 1.0 m/s w/ treadmill at 8.5 deg decline','200 strides 3:1 w/ treadmill at 8.5 deg decline ','200 strides at 1.0 m/s w/ treadmill at 8.5 deg decline','200 strides at 1.0 m/s w/ treadmill flat'};
ChangeCondNameInExpData('LD0030', oldNames, newNames);
updateParams('LD0030',[],0)
display('DONT FORGET TO DumbTester7=makeSMatrixV2')

return
bugar
%% Stroke Recompute
%FixStroke
Stroke={'P0001_','P0002_','P0003_','P0004_','P0009_','P0010_','P0011_','P0012_','P0013_','P0014_','P0015_','P0016_','P0001','P0002','P0009','P0010','P0011','P0012','P0015','P0016','P0003','P0004','P0013','P0014'};
% Stroke={'C0001','C0002','C0009','C0010','C0011','C0012','C0015','C0016','C0003','C0004','C0013','C0014'};
% Stroke={'Nim001','Nim002','Nim003','Nim004','Nim006','Nim007','Nim008','Nim010','Nim011'};
%Stroke={'P0012','P0015','P0016','P0003','P0004','P0013','P0014'};
%Stroke={'P0013', 'P0014'};
%Stroke={'P0011_'};
updateParams(Stroke,[],0)
display('DONT FORGET TO DumbTester7=makeSMatrixV2')
%return

FixConsistentStroke

load('C0001params.mat')
IDNew=adaptData.metaData.ID
load('C0003params.mat')
adaptData.metaData.ID=IDNew
save(['C0003params.mat'],'adaptData','-v7.3')
load('C0014params.mat')
adaptData.metaData.ID=IDNew
save(['C0014params.mat'],'adaptData','-v7.3')

oldNames={'OG Base'	'TM slow'	'TM mid'	'Short exposure'	'TM base'	'Adaptation'	'Washout'	'OG washout'};
newNames={'OG Base'	'TM slow'	'TM mid'	'Short exposure'	'TM base'	'adaptation'	'TM post'	'OG washout'};
changeCondName({'C0001','C0002','C0003','C0004','C0009','C0010','C0011','C0012','C0013','C0014','C0015','C0016'},oldNames,newNames);

display('DONT FORGET TO DumbTester7=makeSMatrixV2')
display('If something breaks it is P0015_')
return
bugar


%% Stroke and Young Results Compared
close all
clear all
clc
load('M:\Carly\InclineDeclineStudyDataCode_Active\COM ALL THAT CAN\StrokeParams\DumbTester7.mat')
groups = {'NoDescription','InclineStroke'};
adaptDataList = {DumbTester7.NoDescription.adaptData, DumbTester7.InclineStroke.adaptData};%, DumbTester7.EXP.adaptData
binWidth = 5;
trialMarkerFlag = [0  0  0];
indivSubFlag = 0;
IndivSubList = 0;

params = {'netContributionNorm2','stepLengthFast', 'stepLengthSlow', 'stepLengthSlow'}; removeBias =0;
conds = {'TM base','adaptation','TM post'};%
epochs={'EarlyA', 'DelFAdapt'}
groups = {'NoDescription','FlatYoungAbrupt', 'EXP'};
RF=getForceResults_Stroke(DumbTester7,params,groups,0, 0, 0, 1);
YoungStrokeFigure(adaptDataList,params,conds,binWidth,trialMarkerFlag,indivSubFlag,IndivSubList,removeBias,groups, DumbTester7, RF, epochs)
% % %
% % groups = {'NoDescription','InclineStroke','DeclineYoungAbrupt','FlatYoungAbrupt','InclineYoungAbrupt'};
% % RF=getForceResults_Stroke(DumbTester7,params,groups,0, 0, 0, 1);
% % YoungStrokeFigure(adaptDataList,params,conds,binWidth,trialMarkerFlag,indivSubFlag,IndivSubList,removeBias,groups, DumbTester7, RF, epochs)


% % 
% % 
% % params = {'FyPmaxSym','FyBSmax','FyBFmax','FyPSmax','FyPFmax', 'FyPmaxSym', 'FyBmaxSym', 'stepLengthFast', 'stepLengthSlow', 'netContributionNorm2', 'XSlow', 'XFast', 'alphaSlow', 'alphaFast'};%, 'SYZmag', 'FYZMag',  'FzFmax', 'FzSmax'};
% % RF=getForceResults_Stroke(DumbTester7,params,groups,0, 0, 0, 1);
% % RF.EarlyA.indiv.FyPmaxSym(25:end, :)=[];
% % params = {'spatialContributionNorm2','stepTimeContributionNorm2','velocityContributionNorm2','netContributionNorm2', 'stepLengthFast', 'stepLengthSlow'};
% % RK=getForceResults_Stroke(DumbTester7,params,groups,0, 0, 0, 1);
% % InclineDeclineFigure6(DumbTester7,RF, RK, groups)


%% 
close all
clear all
clc
load('M:\Carly\InclineDeclineStudyDataCode_Active\COM ALL THAT CAN\HipCOM\DumbTester7.mat')
groups = {'FlatYoungAbrupt', 'InclineYoungAbrupt'};
params = {'FyBSmax','FyBFmax','FyPSmax','FyPFmax', 'FyPmaxSym', 'FyBmaxSym', 'stepLengthFast', 'stepLengthSlow', 'netContributionNorm2', 'XSlow', 'XFast', 'alphaSlow', 'alphaFast'};%, 'SYZmag', 'FYZMag',  'FzFmax', 'FzSmax'};
RF=getForceResults(DumbTester7,params,groups,0, 0, 0, 1);
params = {'spatialContributionNorm2','stepTimeContributionNorm2','velocityContributionNorm2','netContributionNorm2', 'stepLengthFast', 'stepLengthSlow'};
RK=getResults(DumbTester7,params,groups,0, 0, 0, 1);
InclineDeclineFigure6(DumbTester7,RF, RK, groups)

% % groups = {'NoDescription','InclineStroke', 'EXP','FlatYoungAbrupt'};
% % adaptDataList = {DumbTester7.NoDescription.adaptData, DumbTester7.InclineStroke.adaptData, DumbTester7.EXP.adaptData, DumbTester7.FlatYoungAbrupt.adaptData};%
% % conds = {'TM base','adaptation','TM post'};%
% % params = {'stepLengthFast', 'stepLengthSlow'}; removeBias =1;
% % % params = {'XFast','XSlow','XFast','XSlow'}; removeBias =0;
% % RSL=getForceResults_Stroke(DumbTester7,params,groups,0, 0, 0, removeBias);
% % InclineDeclineFigure5(adaptDataList,params,conds,binWidth,trialMarkerFlag,indivSubFlag,IndivSubList,removeBias,groups, DumbTester7, RSL, [])
% % 
% % epochs={'DelFAdapt', 'DelFDeAdapt2Base','SpeedAdapDiscont'};
% % InclineDeclineFigureSLV2(adaptDataList,params,conds,binWidth,trialMarkerFlag,indivSubFlag,IndivSubList,removeBias,groups, DumbTester7, RSL, epochs)
% % epochs={'TMSteady', 'DelFAdapt','TMSteadyWBias'};
% % InclineDeclineFigure2(adaptDataList,params,conds,binWidth,trialMarkerFlag,indivSubFlag,IndivSubList,removeBias,groups, DumbTester7, RSL, epochs)

%% Stroke Results
close all
clear all
clc
load('M:\Carly\InclineDeclineStudyDataCode_Active\COM ALL THAT CAN\StrokeParams\DumbTester7.mat')
groups = {'NoDescription','InclineStroke'};
adaptDataList = {DumbTester7.NoDescription.adaptData, DumbTester7.InclineStroke.adaptData};%, DumbTester7.EXP.adaptData
binWidth = 5;
trialMarkerFlag = [0  0  0];
indivSubFlag = 0;
IndivSubList = 0;


params = {'FyPmaxSym', 'FyBmaxSym','PsumSym','BsumSym'}; removeBias =1;
%params = {'SBsum', 'FBsum','SPsum','FPsum'}; removeBias =1;
%params = {'FyBSmax','FyBFmax','FyPSmax','FyPFmax'}; removeBias =1;
%params ={'SPDef', 'FPDef','SBDef','FBDef'};removeBias =0;
%params ={'SPDefSum','FPDefSum','SBDefSum','FBDefSum'};removeBias =0;
%params = {'KinDef','KinDefSum','KinDef','KinDefSum'}; removeBias =0;
% params = {'netContributionNorm2','stepLengthFast', 'stepLengthSlow','FyPFmax'}; removeBias =1;
conds = {'TM base','adaptation'};%,'TM post'
RF=getForceResults_Stroke(DumbTester7,params,groups,0, 0, 0, removeBias);
epochs={'DelFAdapt', 'TMSteady', 'DelFDeAdapt2Base', 'TMafter'};
InclineDeclineFigure2_Stroke(adaptDataList,params,conds,binWidth,trialMarkerFlag,indivSubFlag,IndivSubList,removeBias,groups, DumbTester7, RF, epochs)
%InclineDeclineFigure2V2(adaptDataList,params,conds,binWidth,trialMarkerFlag,indivSubFlag,IndivSubList,removeBias,groups, DumbTester7, RF, epochs)


params = {'netContributionNorm2'}; removeBias =1;
%params = {'spatialContributionNorm2'}; removeBias =1;
%params = {'stepTimeContributionNorm2'}; removeBias =1;
%params = {'velocityContributionNorm2'}; removeBias =1;
%params = {'FyPSmax'}; removeBias =1;
RF_K=getForceResults_Stroke(DumbTester7,params,groups,0, 0, 0, 1);
epochs={'TMSteady', 'EarlyA', 'TMafter', 'DelFAdapt'};
conds = { 'TM base','adaptation'};%,'flat post','TM post'
%InclineDeclineFigure3(adaptDataList,params,conds,binWidth,trialMarkerFlag,indivSubFlag,IndivSubList,removeBias,groups, DumbTester7, RF_K, epochs)
InclineDeclineFigure3V2(adaptDataList,params,conds,binWidth,trialMarkerFlag,indivSubFlag,IndivSubList,removeBias,groups, DumbTester7, RF_K, epochs)

% Ankle Ranges
StepLengthVis_Stroke

% Figure 6
params = {'FyBSmax','FyBFmax','FyPSmax','FyPFmax', 'stepLengthSlow','stepLengthFast','netContributionNorm2', 'FyPmaxSym','FyBmaxSym',};
%  params = {'FyBSmax','FyBFmax','FyPSmax','FyPFmax', 'stepLengthSlow','stepLengthFast','netContributionNorm2',...
%      'SPmaxPer', 'FPmaxPer', 'FYPmaxSymNorm', 'FyPmaxRatio', 'FyPmaxSym', 'FyPsym', 'FyBf', 'FyBS', 'FyPS', 'FyBSmax', 'FyPSmax'};
RF=getForceResults_Stroke(DumbTester7,params,groups,0, 0, 0, 1);
InclineDeclineFigure6_Stroke(DumbTester7,RF, [], groups)

% Testing random things for figure 6
params={'netContributionNorm2', 'SPmaxPer', 'FPmaxPer', 'FyPmaxSymNorm', 'FyPmaxRatio', 'FyPmaxSym', 'FyPSym', 'FyBF', 'FyBS', 'FyPS', 'FyBSmax', 'FyPSmax','FyBFmax', 'FyPFmax', 'stepLengthSlow','stepLengthFast','SBsum', 'FBsum','SPsum','FPsum'};
RF_test=getForceResults_Stroke(DumbTester7,params,groups,0, 0, 0, 1);
InclineDeclineFigure6_Stroke_testing(DumbTester7,RF_test, [], groups)

% Baseline Analysis -- Are the forces or the step lengths or asymmetries
% different from flat to incline baseline on the same day?
groups = {'InclineStroke'};
%params = {'FyBSmax','FyBFmax','FyPSmax','FyPFmax', 'stepLengthSlow','stepLengthFast','netContributionNorm2'};
params = {'alphaSlow','alphaFast','XSlow','XFast', 'stepLengthSlow','stepLengthFast','netContributionNorm2'};%spatialContributionNorm2 %stepLengthDiff
RF_incline=getForceResults_Stroke(DumbTester7,params,groups,0, 0, 0, 0);
InclineFlatBaseline_Stroke(DumbTester7,RF_incline, params, groups)
%% Multiple Linear Regression
InclineStrokeStudyMultipleLinearRegressions

%%Stroke Baseline
Stroke_BaselineAnalysis
ForceTraces_Epoch_Stroke
Stroke_BaselineAnalysisV2
Stroke_BaselineAnalysisV3
Stroke_BaselineAnalysisV4_Polar
%% Young Methods Figure
ForceTraces
%% Young Figure 2, 3, 5
clear all
close all
clc
load('M:\Carly\InclineDeclineStudyDataCode_Active\COM ALL THAT CAN\HipCOM\DumbTester7.mat')
adaptDataList = {DumbTester7.DeclineYoungAbrupt.adaptData,DumbTester7.FlatYoungAbrupt.adaptData,DumbTester7.InclineYoungAbrupt.adaptData};
binWidth = 5;
trialMarkerFlag = [0  0  0];
indivSubFlag = 0;
IndivSubList = 0;
groups = {'DeclineYoungAbrupt','FlatYoungAbrupt','InclineYoungAbrupt'};
%adaptationData.plotAvgTimeCourse(adaptDataList,params,conds,binWidth,trialMarkerFlag,indivSubFlag,IndivSubList,[],0,removeBias,groups,0,0)

params = {'FyBSmax','FyBFmax','FyPSmax','FyPFmax'}; removeBias =0;
conds = {'slow', 'fast', 'TM base','adaptation','TM post'};
RF=getForceResults(DumbTester7,params,groups,0, 0, 0, 1);
epochs={'SpeedAdapDiscont',  'TMafter','DelFAdapt'}; %Which should be the same as.. epochs={'SpeedAdapDiscont',  'DelFDeAdapt2Base','DelFAdapt'};
%epochs={'SpeedAdapDiscont',  'DelFDeAdapt2Base','TMafter'};
InclineDeclineFigure2(adaptDataList,params,conds,binWidth,trialMarkerFlag,indivSubFlag,IndivSubList,removeBias,groups, DumbTester7, RF, epochs)
%InclineDeclineFigure2V2(adaptDataList,params,conds,binWidth,trialMarkerFlag,indivSubFlag,IndivSubList,removeBias,groups, DumbTester7, RF, epochs)



params = {'netContributionNorm2'}; removeBias =1;
RF_K=getForceResults(DumbTester7,params,groups,0, 0, 0, removeBias);
epochs={'TMSteady', 'EarlyA', 'TMafter', 'DelFAdapt'};
conds = {'TM base','adaptation','TM post'};
% RK=getResults(DumbTester7,params,groups,0, 0, 0, 1);
% epochs={'TMsteady', 'EarlyA', 'TMafter', 'DeltaAdapt'};
%InclineDeclineFigure3(adaptDataList,params,conds,binWidth,trialMarkerFlag,indivSubFlag,IndivSubList,removeBias,groups, DumbTester7, RF_K, epochs)
InclineDeclineFigure3_Rate(adaptDataList,params,conds,binWidth,trialMarkerFlag,indivSubFlag,IndivSubList,removeBias,groups, DumbTester7, RF_K, epochs)
InclineDeclineFigure3V2(adaptDataList,params,conds,binWidth,trialMarkerFlag,indivSubFlag,IndivSubList,removeBias,groups, DumbTester7, RF_K, epochs)

params = {'stepLengthSlow','stepLengthFast', 'stepLengthSlow','stepLengthFast'}; removeBias =0;
%params = {'alphaSlow','alphaFast','XFast','XSlow'}; removeBias =0;
% params = {'FyBSmax','FyBFmax','FyPSmax','FyPFmax'}; removeBias =0;
% params = {'FyBSmax','FyBFmax','FyBSmax','FyBFmax'}; removeBias =0;
% params = {'FyPSmax','FyPFmax','FyBSmax','FyBFmax'}; removeBias =0;
% params = {'stepTimeSlow', 'stepTimeFast','stepTimeSlow', 'stepTimeFast'};
conds = {'slow', 'fast', 'TM base','adaptation','TM post'};
RF=getForceResults(DumbTester7,params,groups,0, 0, 0, removeBias);
% epochs={'DelFAdapt', 'DelFDeAdapt2Base','SpeedAdapDiscont'};
% InclineDeclineFigureSLV2(adaptDataList,params,conds,binWidth,trialMarkerFlag,indivSubFlag,IndivSubList,removeBias,groups, DumbTester7, RF, epochs)
% epochs={'TMSteady', 'DelFAdapt','TMSteadyWBias'};
epochs={'EarlyA', 'DelFAdapt', 'TMSteady'};
InclineDeclineFigure2(adaptDataList,params,conds,binWidth,trialMarkerFlag,indivSubFlag,IndivSubList,removeBias,groups, DumbTester7, RF, epochs)


conds = {'slow', 'fast', 'TM base', 'adaptation','TM post'};
params = {'stepLengthFast', 'stepLengthSlow'}; removeBias =0;
RSL=getForceResults(DumbTester7,params,groups,0, 0, 0, 0);
InclineDeclineFigure5(adaptDataList,params,conds,binWidth,trialMarkerFlag,indivSubFlag,IndivSubList,removeBias,groups, DumbTester7, RSL, [])


%% REAL LINEAR REGRESSION
InclineDeclineStudyMultipleLinearRegressions
%% Step Length Visualization
StepLengthVis
%% Figure 6:
close all
clear all
clc
load('M:\Carly\InclineDeclineStudyDataCode_Active\COM ALL THAT CAN\HipCOM\DumbTester7.mat')
%groups = {'DeclineYoungAbrupt','FlatYoungAbrupt','InclineYoungAbrupt','YoungAbrupt'};
groups = {'DeclineYoungAbrupt','FlatYoungAbrupt', 'InclineYoungAbrupt'};
%params = {'FyBSmax','FyBFmax','FyPSmax','FyPFmax','FyBmaxRatio','FyPmaxRatio','FyBmaxSymNorm','FyPmaxSymNorm','FBmaxPer','SBmaxPer','FPmaxPer','SPmaxPer','stepLengthFast', 'stepLengthSlow', 'netContributionNorm2'};
params = {'FyBSmax','FyBFmax','FyPSmax','FyPFmax', 'FyPmaxSym', 'FyBmaxSym', 'stepLengthFast', 'stepLengthSlow', 'netContributionNorm2', 'XSlow', 'XFast', 'alphaSlow', 'alphaFast'};%, 'SYZmag', 'FYZMag',  'FzFmax', 'FzSmax'};
RF=getForceResults(DumbTester7,params,groups,0, 0, 0, 1);
params = {'spatialContributionNorm2','stepTimeContributionNorm2','velocityContributionNorm2','netContributionNorm2', 'stepLengthFast', 'stepLengthSlow'};
RK=getResults(DumbTester7,params,groups,0, 0, 0, 1);

InclineDeclineFigure6(DumbTester7,RF, RK, groups)
% InclineDeclineFigureMisc(DumbTester7,RF, RK, groups)
% InclineDeclineFigureMisc2(DumbTester7,RF, RK, groups)
% InclineDeclineFigureMisc3(DumbTester7,RF, RK, groups)
% InclineDeclineFigure_XP(DumbTester7,RF, RK, groups)
% InclineDeclineFigure_B(DumbTester7,RF, RK, groups)
% % Single leg parameter vs symmetry parameters perturbation predict step
% % length adaptation
% InclineDeclineFigure_SingleVsSym(DumbTester7,RF, groups)
