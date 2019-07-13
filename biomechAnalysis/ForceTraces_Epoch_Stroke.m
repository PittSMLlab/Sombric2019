%ForceTraces_Epoch_Stroke
%CJS
%2/9/2018
%THis function is to help me understand what my stroke subjects are up to
%both in terms of baseline and slopw, adaptaiton, and PA behavior

close all
clear all

%% Edit
StrokeFlat={'P0001_','P0002_','P0003_','P0004_','P0009_','P0010_','P0011_','P0012_','P0013_','P0014_','P0015_','P0016_'};
StrokeIncline={'P0001','P0002','P0003','P0004','P0009','P0010','P0011','P0012','P0013','P0014','P0015','P0016'};
subNum=8;%7
params={'LFy', 'RFy'};

 
cond_B='TM base';
cond_A='Adaptation';
cond_PA='Washout';
% cond_A='Adap';
% %cond_PA='Post-adap';
% cond_PA='Washout';

% Flat Testing Session
load([StrokeFlat{subNum} '.mat']);
[striderSL_FlatB, striderFL_FlatB, LevelofInterest]=GetGRFTraces(expData, cond_B, params,  [40], 1);
[striderSL_FlatA, striderFL_FlatA, LevelofInterest]=GetGRFTraces(expData, cond_A, params,  [40], 1);
[striderSL_FlatPA, striderFL_FlatPA, LevelofInterest]=GetGRFTraces(expData, cond_PA, params,  [1:5], 0);
clear expData

if LevelofInterest~=0
    keyboard
end

%% Incline Testing Session
cond_B='TM base';
cond_A='adaptation';
cond_PA='TM Post';

% cond_A='adaptation';
 cond_PA='TM Washout';

load([StrokeIncline{subNum} '.mat']);
[striderSL_InclineB, striderFL_InclineB, LevelofInterest]=GetGRFTraces(expData, cond_B, params,  [40], 1);
[striderSL_InclineA, striderFL_InclineA, LevelofInterest]=GetGRFTraces(expData, cond_A, params,  [40], 1);
[striderSL_InclinePA, striderFL_InclinePA, LevelofInterest]=GetGRFTraces(expData, cond_PA, params,  [1:5], 0);

if LevelofInterest==0
    keyboard
end

%%
figure
subplot(2, 4, 1) % Flat baseline
plot(striderSL_FlatB', ':b')
hold on
plot(striderFL_FlatB', ':r')
title('Flat Baseline Behavior')
ylabel({[StrokeFlat{subNum}]; 'Norm Fy'})
xlabel('% Stance')
ylim([-.2 .2]);

subplot(2, 4, 5) % Slope baseline
plot(striderSL_InclineB'-LevelofInterest, 'b')
hold on
plot(striderFL_InclineB'-LevelofInterest, 'r')
title('Sloped Baseline Behavior')
ylabel({[StrokeIncline{subNum}]; 'Norm Fy'})
xlabel('% Stance')
ylim([-.2 .2]);

subplot(2, 4, 2) % Slow Leg baseline
plot(striderSL_FlatB', ':k')
hold on
plot(striderSL_InclineB'-LevelofInterest, 'b')
title('Slow/Paretic Baseline')
ylim([-.2 .2]);

subplot(2, 4, 6) % Slope baseline
plot(striderFL_FlatB', ':k')
hold on
plot(striderFL_InclineB'-LevelofInterest, 'r')
title('Fast/Intact Baseline')
ylim([-.2 .2]);

subplot(2, 4, 3) % Slow Leg baseline
plot(striderSL_FlatA', ':k')
hold on
plot(striderSL_InclineA'-LevelofInterest, 'b')
title('Slow/Paretic SS Adaptation')
ylim([-.2 .2]);

subplot(2, 4, 7) % Slope baseline
plot(striderFL_FlatA', ':k')
hold on
plot(striderFL_InclineA'-LevelofInterest, 'r')
title('Fast/Intact SS Adaptation')
ylim([-.2 .2]);

subplot(2, 4, 4) % Slow Leg baseline
plot(striderSL_FlatPA', ':k')
hold on
plot(striderSL_InclinePA'-LevelofInterest, 'b')
title('Slow/Paretic AE')
ylim([-.2 .2]);

subplot(2, 4, 8) % Slope baseline
plot(striderFL_FlatPA', ':k')
hold on
plot(striderFL_InclinePA'-LevelofInterest, 'r')
title('Fast/Intact AE')
ylim([-.2 .2]);
return
