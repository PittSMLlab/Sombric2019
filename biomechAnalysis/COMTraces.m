%COMTraces
%CJS
%4/25/2017
%This function plots the early and late forces for a given condiiton in
%both the origonal and shifted state and then shows bar plots indicating
%how we are characterizing the ealry behaviors

close all
clear all
 %Flat={'LN0005','LN0006','LN0007','LN0008','LN0009'};
%Flat={'LN0005','LN0007','LN0008','LN0009'}; % 9 won't run for some reason
Flat={'LN0005','LN0007','LN0008'};
 %Flat={'LN0002','LN0003','LN0004','LN0005','LN0006','LN0007','LN0008','LN0009'};
 %Incline={'LI0013','LI0016','LI0018','LI0023','LI0024','LI0026','LI0027','LI0028'};
 %Decline={'LD0015','LD0017','LD0019','LD0020','LD0021','LD0029','LD0030','LD0031'};
cond={'slow', 'fast', 'TM base', 'adaptation', 'TM post'};
%params={'COPy', 'COPx'};
params={};

% for s=1:length(Decline)
%load([Decline{s} '.mat']);%load('LD0030.mat')
% for s=1:length(Incline)
% load([Incline{s} '.mat']);%load('LD0030.mat')
for s=1:length(Flat)
load([Flat{s} '.mat']);%load('LD0030.mat')
[Data.Position.fastY.slowBase(:, s), Data.Position.slowY.slowBase(:, s), Data.Position.fastZ.slowBase(:, s), Data.Position.slowZ.slowBase(:, s), Data.Velocity.fastY.slowBase(:, s), Data.Velocity.slowY.slowBase(:, s), Data.Velocity.fastZ.slowBase(:, s), Data.Velocity.slowZ.slowBase(:, s)]=GetCOMTraces(expData, cond{1}, params,  [40], 1);
[Data.Position.fastY.fastBase, Data.Position.slowY.fastBase, Data.Position.fastZ.fastBase(:, s),Data.Position.slowZ.fastBase(:, s), Data.Velocity.fastY.fastBase(:, s), Data.Velocity.slowY.fastBase(:, s), Data.Velocity.fastZ.fastBase(:, s), Data.Velocity.slowZ.fastBase(:, s)]=GetCOMTraces(expData, cond{2}, params,  [40], 1);
[Data.Position.fastY.Base(:, s), Data.Position.slowY.Base(:, s), Data.Position.fastZ.Base(:, s),Data.Position.slowZ.Base(:, s), Data.Velocity.fastY.Base(:, s), Data.Velocity.slowY.Base(:, s), Data.Velocity.fastZ.Base(:, s), Data.Velocity.slowZ.Base(:, s)]=GetCOMTraces(expData, cond{3}, params,  [40], 1);
[Data.Position.fastY.EA(:, s), Data.Position.slowY.EA(:, s), Data.Position.fastZ.EA(:, s),Data.Position.slowZ.EA(:, s), Data.Velocity.fastY.EA(:, s), Data.Velocity.slowY.EA(:, s), Data.Velocity.fastZ.EA(:, s), Data.Velocity.slowZ.EA(:, s)]=GetCOMTraces(expData, cond{4}, params,  [6:26], 0);
[Data.Position.fastY.LA(:, s), Data.Position.slowY.LA(:, s), Data.Position.fastZ.LA(:, s),Data.Position.slowZ.LA(:, s), Data.Velocity.fastY.LA(:, s), Data.Velocity.slowY.LA(:, s), Data.Velocity.fastZ.LA(:, s), Data.Velocity.slowZ.LA(:, s)]=GetCOMTraces(expData, cond{4}, params,  [40], 0);
[Data.Position.fastY.EP(:, s), Data.Position.slowY.EP(:, s), Data.Position.fastZ.EP(:, s),Data.Position.slowZ.EP(:, s), Data.Velocity.fastY.EP(:, s), Data.Velocity.slowY.EP(:, s), Data.Velocity.fastZ.EP(:, s), Data.Velocity.slowZ.EP(:, s)]=GetCOMTraces(expData, cond{5}, params,  [1:5], 0);
display([Flat{s}])
% [Data.PositionFY.slowBase(:, s), Data.VelocityFY.slowBase(:, s), Data.PositionSY.slowBase(:, s), Data.VelocitySY.slowBase(:, s)]=GetCOPTraces(expData, cond{1}, [40], 1);
% [Data.PositionFY.fastBase, Data.VelocityFY.fastBase(:, s), Data.PositionSY.fastBase, Data.VelocitySY.fastBase(:, s)]=GetCOPTraces(expData, cond{2}, [40], 1);
% [Data.PositionFY.Base(:, s), Data.VelocityFY.Base(:, s), Data.PositionSY.Base(:, s), Data.VelocitySY.Base(:, s)]=GetCOPTraces(expData, cond{3}, [40], 1);
% [Data.PositionFY.EA(:, s), Data.VelocityFY.EA(:, s), Data.PositionSY.EA(:, s), Data.VelocitySY.EA(:, s)]=GetCOPTraces(expData, cond{4},  [6:26], 0);
% [Data.PositionFY.LA(:, s), Data.VelocityFY.LA(:, s), Data.PositionSY.LA(:, s), Data.VelocitySY.LA(:, s)]=GetCOPTraces(expData, cond{4},   [40], 0);
% [Data.PositionFY.EP(:, s), Data.VelocityFY.EP(:, s), Data.PositionSY.EP(:, s), Data.VelocitySY.EP(:, s)]=GetCOPTraces(expData, cond{5},   [1:5], 0);
clear expData
end

bugar

GroupCOPTracePlots

%% Group Plotting
% %%%%%%%%%%%%% ROTATED
load('FLAT_COM.mat')
load('INCLINE_COM.mat')
load('DECLINE_COM.mat')
% %%%%%%%%%%%%% UNROTATED
% load('FLAT_COM_Global.mat')
% load('INCLINE_COM_Global.mat')
% load('DECLINE_COM_Global.mat')
% FLAT_COM=Flat_COM_Global;
% INCLINE_COM=INCLINE_COM_Global;
% DECLINE_COM=DECLINE_COM_Global;
%%%%%%%%%%%%%%%%%%%%%
figure
ax11=subplot(2, 4, 1)
plot(nanmean(FLAT_COM.Position.fastY.EA,2), 'k')
hold on
plot(nanmean(FLAT_COM.Position.fastY.LA,2), '--k')
plot(nanmean(FLAT_COM.Position.fastY.EP,2), ':k')
plot(nanmean(INCLINE_COM.Position.fastY.EA,2), 'r')
plot(nanmean(INCLINE_COM.Position.fastY.LA,2), '--r')
plot(nanmean(INCLINE_COM.Position.fastY.EP,2), ':r')
plot(-1.*nanmean(DECLINE_COM.Position.fastY.EA,2), 'b')
plot(-1.*nanmean(DECLINE_COM.Position.fastY.LA,2), '--b')
plot(-1.*nanmean(DECLINE_COM.Position.fastY.EP,2), ':b')
title(['Position -- Fast Y'])
xlabel('% Stride')
ylabel('Rotated Position')
legend({'Flat:EA', 'Flat:LA', 'Flat:EP', 'Incline:EA', 'Incline:LA', 'Incline:EP','Decline:EA', 'Decline:LA', 'Decline:EP'})
ax12=subplot(2, 4, 2)
plot(nanmean(FLAT_COM.Position.slowY.EA,2), 'k')
hold on
plot(nanmean(FLAT_COM.Position.slowY.LA,2), '--k')
plot(nanmean(FLAT_COM.Position.slowY.EP,2), ':k')
plot(nanmean(INCLINE_COM.Position.slowY.EA,2), 'r')
plot(nanmean(INCLINE_COM.Position.slowY.LA,2), '--r')
plot(nanmean(INCLINE_COM.Position.slowY.EP,2), ':r')
plot(-1.*nanmean(DECLINE_COM.Position.slowY.EA,2), 'b')
plot(-1.*nanmean(DECLINE_COM.Position.slowY.LA,2), '--b')
plot(-1.*nanmean(DECLINE_COM.Position.slowY.EP,2), ':b')
title(['Position -- Slow Y'])
xlabel('% Stride')
ylabel('Rotated Position')
ax13=subplot(2, 4, 3)
plot(nanmean(FLAT_COM.Position.fastZ.PFz_EA,2), 'k')
hold on
plot(nanmean(FLAT_COM.Position.fastZ.PFz_LA,2), '--k')
plot(nanmean(FLAT_COM.Position.fastZ.PFz_EP,2), ':k')
plot(nanmean(INCLINE_COM.Position.fastZ.PFz_EA,2), 'r')
plot(nanmean(INCLINE_COM.Position.fastZ.PFz_LA,2), '--r')
plot(nanmean(INCLINE_COM.Position.fastZ.PFz_EP,2), ':r')
plot(1.*nanmean(DECLINE_COM.Position.fastZ.PFz_EA,2), 'b')
plot(1.*nanmean(DECLINE_COM.Position.fastZ.PFz_LA,2), '--b')
plot(1.*nanmean(DECLINE_COM.Position.fastZ.PFz_EP,2), ':b')
title(['Position -- Fast Z'])
xlabel('% Stride')
ylabel('Rotated Position')
legend({'Flat:EA', 'Flat:LA', 'Flat:EP', 'Incline:EA', 'Incline:LA', 'Incline:EP','Decline:EA', 'Decline:LA', 'Decline:EP'})
ax14=subplot(2, 4, 4)
plot(nanmean(FLAT_COM.Position.slowZ.EA,2), 'k')
hold on
plot(nanmean(FLAT_COM.Position.slowZ.LA,2), '--k')
plot(nanmean(FLAT_COM.Position.slowZ.EP,2), ':k')
plot(nanmean(INCLINE_COM.Position.slowZ.EA,2), 'r')
plot(nanmean(INCLINE_COM.Position.slowZ.LA,2), '--r')
plot(nanmean(INCLINE_COM.Position.slowZ.EP,2), ':r')
plot(1.*nanmean(DECLINE_COM.Position.slowZ.EA,2), 'b')
plot(1.*nanmean(DECLINE_COM.Position.slowZ.LA,2), '--b')
plot(1.*nanmean(DECLINE_COM.Position.slowZ.EP,2), ':b')
title(['Position -- Slow Y'])
xlabel('% Stride')
ylabel('Rotated Position')

ax15=subplot(2, 4, 5)
plot(nanmean(FLAT_COM.Velocity.fastY.EA,2), 'k')
hold on
plot(nanmean(FLAT_COM.Velocity.fastY.LA,2), '--k')
plot(nanmean(FLAT_COM.Velocity.fastY.EP,2), ':k')
plot(nanmean(INCLINE_COM.Velocity.fastY.EA,2), 'r')
plot(nanmean(INCLINE_COM.Velocity.fastY.LA,2), '--r')
plot(nanmean(INCLINE_COM.Velocity.fastY.EP,2), ':r')
plot(-1.*nanmean(DECLINE_COM.Velocity.fastY.EA,2), 'b')
plot(-1.*nanmean(DECLINE_COM.Velocity.fastY.LA,2), '--b')
plot(-1.*nanmean(DECLINE_COM.Velocity.fastY.EP,2), ':b')
title(['Velocity -- Fast Y'])
xlabel('% Stride')
ylabel('Rotated Velocity')
legend({'Flat:EA', 'Flat:LA', 'Flat:EP', 'Incline:EA', 'Incline:LA', 'Incline:EP','Decline:EA', 'Decline:LA', 'Decline:EP'})
ax16=subplot(2, 4, 6)
plot(nanmean(FLAT_COM.Velocity.slowY.EA,2), 'k')
hold on
plot(nanmean(FLAT_COM.Velocity.slowY.LA,2), '--k')
plot(nanmean(FLAT_COM.Velocity.slowY.EP,2), ':k')
plot(nanmean(INCLINE_COM.Velocity.slowY.EA,2), 'r')
plot(nanmean(INCLINE_COM.Velocity.slowY.LA,2), '--r')
plot(nanmean(INCLINE_COM.Velocity.slowY.EP,2), ':r')
plot(-1.*nanmean(DECLINE_COM.Velocity.slowY.EA,2), 'b')
plot(-1.*nanmean(DECLINE_COM.Velocity.slowY.LA,2), '--b')
plot(-1.*nanmean(DECLINE_COM.Velocity.slowY.EP,2), ':b')
title(['Velocity -- Slow Y'])
xlabel('% Stride')
ylabel('Rotated Velocity')
ax17=subplot(2, 4, 7)
plot(nanmean(FLAT_COM.Velocity.fastZ.EA,2), 'k')
hold on
plot(nanmean(FLAT_COM.Velocity.fastZ.LA,2), '--k')
plot(nanmean(FLAT_COM.Velocity.fastZ.EP,2), ':k')
plot(nanmean(INCLINE_COM.Velocity.fastZ.EA,2), 'r')
plot(nanmean(INCLINE_COM.Velocity.fastZ.LA,2), '--r')
plot(nanmean(INCLINE_COM.Velocity.fastZ.EP,2), ':r')
plot(1.*nanmean(DECLINE_COM.Velocity.fastZ.EA,2), 'b')
plot(1.*nanmean(DECLINE_COM.Velocity.fastZ.LA,2), '--b')
plot(1.*nanmean(DECLINE_COM.Velocity.fastZ.EP,2), ':b')
title(['Velocity -- Fast Z'])
xlabel('% Stride')
ylabel('Rotated Velocity')
legend({'Flat:EA', 'Flat:LA', 'Flat:EP', 'Incline:EA', 'Incline:LA', 'Incline:EP','Decline:EA', 'Decline:LA', 'Decline:EP'})
ax18=subplot(2, 4, 8)
plot(nanmean(FLAT_COM.Velocity.slowZ.EA,2), 'k')
hold on
plot(nanmean(FLAT_COM.Velocity.slowZ.LA,2), '--k')
plot(nanmean(FLAT_COM.Velocity.slowZ.EP,2), ':k')
plot(nanmean(INCLINE_COM.Velocity.slowZ.EA,2), 'r')
plot(nanmean(INCLINE_COM.Velocity.slowZ.LA,2), '--r')
plot(nanmean(INCLINE_COM.Velocity.slowZ.EP,2), ':r')
plot(1.*nanmean(DECLINE_COM.Velocity.slowZ.EA,2), 'b')
plot(1.*nanmean(DECLINE_COM.Velocity.slowZ.LA,2), '--b')
plot(1.*nanmean(DECLINE_COM.Velocity.slowZ.EP,2), ':b')
title(['Velocity -- Slow Y'])
xlabel('% Stride')
ylabel('Rotated Velocity')
linkaxes([ax11 ax12 ], 'y')
linkaxes([ax13 ax14], 'y')
linkaxes([ax15 ax16], 'y')
linkaxes([ax17 ax18], 'y')
subplot(2, 4, 1); line([15 15], [-5000 5000],'Color','k'); line([45 45], [-5000 5000],'Color','k'); line([60 60], [-5000 5000],'Color','k');
subplot(2, 4, 2); line([15 15], [-5000 5000],'Color','k'); line([45 45], [-5000 5000],'Color','k'); line([60 60], [-5000 5000],'Color','k');
subplot(2, 4, 3); line([15 15], [-5000 5000],'Color','k'); line([45 45], [-5000 5000],'Color','k'); line([60 60], [-5000 5000],'Color','k');
subplot(2, 4, 4); line([15 15], [-5000 5000],'Color','k'); line([45 45], [-5000 5000],'Color','k'); line([60 60], [-5000 5000],'Color','k');
subplot(2, 4, 5); line([15 15], [-5000 5000],'Color','k'); line([45 45], [-5000 5000],'Color','k'); line([60 60], [-5000 5000],'Color','k');
subplot(2, 4, 6); line([15 15], [-5000 5000],'Color','k'); line([45 45], [-5000 5000],'Color','k'); line([60 60], [-5000 5000],'Color','k');
subplot(2, 4, 7); line([15 15], [-5000 5000],'Color','k'); line([45 45], [-5000 5000],'Color','k'); line([60 60], [-5000 5000],'Color','k');
subplot(2, 4, 8); line([15 15], [-5000 5000],'Color','k'); line([45 45], [-5000 5000],'Color','k'); line([60 60], [-5000 5000],'Color','k');

%%
figure
ax111=subplot(1, 4, 1)
plot(nanmean(FLAT_COM.Position.fastY.EA,2), 'k')
hold on
plot(nanmean(FLAT_COM.Position.fastY.LA,2), '--k')
plot(nanmean(FLAT_COM.Position.fastY.EP,2), ':k')
plot(nanmean(INCLINE_COM.Position.fastY.EA,2), 'r')
plot(nanmean(INCLINE_COM.Position.fastY.LA,2), '--r')
plot(nanmean(INCLINE_COM.Position.fastY.EP,2), ':r')
plot(-1.*nanmean(DECLINE_COM.Position.fastY.EA,2), 'b')
plot(-1.*nanmean(DECLINE_COM.Position.fastY.LA,2), '--b')
plot(-1.*nanmean(DECLINE_COM.Position.fastY.EP,2), ':b')
title(['Position -- Fast Y'])
xlabel('% Stride')
ylabel('Rotated Position')
legend({'Flat:EA', 'Flat:LA', 'Flat:EP', 'Incline:EA', 'Incline:LA', 'Incline:EP','Decline:EA', 'Decline:LA', 'Decline:EP'})
ax122=subplot(1, 4, 2)
plot(nanmean(FLAT_COM.Position.slowY.EA,2), 'k')
hold on
plot(nanmean(FLAT_COM.Position.slowY.LA,2), '--k')
plot(nanmean(FLAT_COM.Position.slowY.EP,2), ':k')
plot(nanmean(INCLINE_COM.Position.slowY.EA,2), 'r')
plot(nanmean(INCLINE_COM.Position.slowY.LA,2), '--r')
plot(nanmean(INCLINE_COM.Position.slowY.EP,2), ':r')
plot(-1.*nanmean(DECLINE_COM.Position.slowY.EA,2), 'b')
plot(-1.*nanmean(DECLINE_COM.Position.slowY.LA,2), '--b')
plot(-1.*nanmean(DECLINE_COM.Position.slowY.EP,2), ':b')
title(['Position -- Slow Y'])
xlabel('% Stride')
ylabel('Rotated Position')

ax113=subplot(1, 4, 3)
plot(nanmean(FLAT_COM.Position.fastY.EA-FLAT_COM.Position.fastY.Base,2), 'k')
hold on
plot(nanmean(FLAT_COM.Position.fastY.LA-FLAT_COM.Position.fastY.Base,2), '--k')
plot(nanmean(FLAT_COM.Position.fastY.EP-FLAT_COM.Position.fastY.Base,2), ':k')
plot(nanmean(INCLINE_COM.Position.fastY.EA-INCLINE_COM.Position.fastY.Base,2), 'r')
plot(nanmean(INCLINE_COM.Position.fastY.LA-INCLINE_COM.Position.fastY.Base,2), '--r')
plot(nanmean(INCLINE_COM.Position.fastY.EP-INCLINE_COM.Position.fastY.Base,2), ':r')
plot(-1.*nanmean(DECLINE_COM.Position.fastY.EA-DECLINE_COM.Position.fastY.Base,2), 'b')
plot(-1.*nanmean(DECLINE_COM.Position.fastY.LA-DECLINE_COM.Position.fastY.Base,2), '--b')
plot(-1.*nanmean(DECLINE_COM.Position.fastY.EP-DECLINE_COM.Position.fastY.Base,2), ':b')
title(['Unbiased Position -- Fast Y'])
xlabel('% Stride')
ylabel('Rotated Position')
legend({'Flat:EA', 'Flat:LA', 'Flat:EP', 'Incline:EA', 'Incline:LA', 'Incline:EP','Decline:EA', 'Decline:LA', 'Decline:EP'})
ax124=subplot(1, 4, 4)
plot(nanmean(FLAT_COM.Position.slowY.EA-FLAT_COM.Position.fastY.Base,2), 'k')
hold on
plot(nanmean(FLAT_COM.Position.slowY.LA-FLAT_COM.Position.fastY.Base,2), '--k')
plot(nanmean(FLAT_COM.Position.slowY.EP-FLAT_COM.Position.fastY.Base,2), ':k')
plot(nanmean(INCLINE_COM.Position.slowY.EA-INCLINE_COM.Position.fastY.Base,2), 'r')
plot(nanmean(INCLINE_COM.Position.slowY.LA-INCLINE_COM.Position.fastY.Base,2), '--r')
plot(nanmean(INCLINE_COM.Position.slowY.EP-INCLINE_COM.Position.fastY.Base,2), ':r')
plot(-1.*nanmean(DECLINE_COM.Position.slowY.EA-DECLINE_COM.Position.fastY.Base,2), 'b')
plot(-1.*nanmean(DECLINE_COM.Position.slowY.LA-DECLINE_COM.Position.fastY.Base,2), '--b')
plot(-1.*nanmean(DECLINE_COM.Position.slowY.EP-DECLINE_COM.Position.fastY.Base,2), ':b')
title(['Unbiased Position -- Slow Y'])
xlabel('% Stride')
ylabel('Rotated Position')

subplot(1, 4, 1); line([15 15], [-500 500],'Color','k'); line([45 45], [-500 500],'Color','k'); line([60 60], [-500 500],'Color','k');
subplot(1, 4, 2); line([15 15], [-500 500],'Color','k'); line([45 45], [-500 500],'Color','k'); line([60 60], [-500 500],'Color','k');
subplot(1, 4, 3); line([15 15], [-500 500],'Color','k'); line([45 45], [-500 500],'Color','k'); line([60 60], [-500 500],'Color','k');
subplot(1, 4, 4); line([15 15], [-500 500],'Color','k'); line([45 45], [-500 500],'Color','k'); line([60 60], [-500 500],'Color','k');
return
%% Edit
subjectD='LD0015';% 15, 20, 19 and 16 seemed a bit better looking?
subjectI='LI0024';%18 isnt bad, 26
subjectF='LN0008';%LN7 isnt bad either 
% Young={'LN0002','LN0003','LN0004','LN0005','LN0006','LN0007','LN0008','LN0009','LI0013','LI0016','LI0018','LI0023','LI0024','LI0026','LI0027','LI0028','LD0015','LD0017','LD0019','LD0020','LD0021','LD0029','LD0030','LD0031'};
% subject=Young{10};%10 doesnt work?
cond={'slow', 'fast', 'TM base', 'adaptation'};
%params={'BCOMy', 'BCOMz'};
params={'COPy', 'COPx'};

%%
% load([subjectF '.mat']);%load('LD0030.mat')
% [PFy_slowBase, PSy_slowBase, PFz_slowBase,PSz_slowBase]=GetCOPTraces(expData, cond{1}, params,  [40], 1);
% [PFy_fastBase, PSy_fastBase, PFz_fastBase,PSz_fastBase]=GetCOPTraces(expData, cond{2}, params,  [40], 1);
% [PFy_Base, PSy_Base, PFz_Base,PSz_Base]=GetCOPTraces(expData, cond{3}, params,  [40], 1);
% [PFy_EA, PSy_EA, PFz_EA,PSz_EA]=GetCOPTraces(expData, cond{4}, params,  [6:26], 0);
% [PFy_LA, PSy_LA, PFz_LA,PSz_LA]=GetCOPTraces(expData, cond{4}, params,  [40], 0);
% clear expData

load([subjectF '.mat']);%load('LD0030.mat')
[PFy_slowBase, PSy_slowBase, PFz_slowBase,PSz_slowBase, VFy_slowBase, VSy_slowBase, VFz_slowBase, VSz_slowBase]=GetCOMTraces(expData, cond{1}, params,  [40], 1);
[PFy_fastBase, PSy_fastBase, PFz_fastBase,PSz_fastBase, VFy_fastBase, VSy_fastBase, VFz_fastBase, VSz_fastBase]=GetCOMTraces(expData, cond{2}, params,  [40], 1);
[PFy_Base, PSy_Base, PFz_Base,PSz_Base, VFy_Base, VSy_Base, VFz_Base, VSz_Base]=GetCOMTraces(expData, cond{3}, params,  [40], 1);
[PFy_EA, PSy_EA, PFz_EA,PSz_EA, VFy_EA, VSy_EA, VFz_EA, VSz_EA]=GetCOMTraces(expData, cond{4}, params,  [6:26], 0);
[PFy_LA, PSy_LA, PFz_LA,PSz_LA, VFy_LA, VSy_LA, VFz_LA, VSz_LA]=GetCOMTraces(expData, cond{4}, params,  [40], 0);
clear expData

load([subjectI '.mat']);%load('LD0030.mat')
[PFy_slowBaseI, PSy_slowBaseI, PFz_slowBaseI,PSz_slowBaseI, VFy_slowBaseI, VSy_slowBaseI, VFz_slowBaseI, VSz_slowBaseI]=GetCOMTraces(expData, cond{1}, params,  [40], 1);
[PFy_fastBaseI, PSy_fastBaseI, PFz_fastBaseI,PSz_fastBaseI, VFy_fastBaseI, VSy_fastBaseI, VFz_fastBaseI, VSz_fastBaseI]=GetCOMTraces(expData, cond{2}, params,  [40], 1);
[PFy_BaseI, PSy_BaseI, PFz_BaseI,PSz_BaseI, VFy_BaseI, VSy_BaseI, VFz_BaseI, VSz_BaseI]=GetCOMTraces(expData, cond{3}, params,  [40], 1);
[PFy_EAI, PSy_EAI, PFz_EAI,PSz_EAI, VFy_EAI, VSy_EAI, VFz_EAI, VSz_EAI]=GetCOMTraces(expData, cond{4}, params,  [6:26], 0);
[PFy_LAI, PSy_LAI, PFz_LAI,PSz_LAI, VFy_LAI, VSy_LAI, VFz_LAI, VSz_LAI]=GetCOMTraces(expData, cond{4}, params,  [40], 0);
clear expData

load([subjectD '.mat']);%load('LD0030.mat')
[PFy_slowBaseD, PSy_slowBaseD, PFz_slowBaseD,PSz_slowBaseD, VFy_slowBaseD, VSy_slowBaseD, VFz_slowBaseD, VSz_slowBaseD]=GetCOMTraces(expData, cond{1}, params,  [40], 1);
[PFy_fastBaseD, PSy_fastBaseD, PFz_fastBaseD,PSz_fastBaseD, VFy_fastBaseD, VSy_fastBaseD, VFz_fastBaseD, VSz_fastBaseD]=GetCOMTraces(expData, cond{2}, params,  [40], 1);
[PFy_BaseD, PSy_BaseD, PFz_BaseD,PSz_BaseD, VFy_BaseD, VSy_BaseD, VFz_BaseD, VSz_BaseD]=GetCOMTraces(expData, cond{3}, params,  [40], 1);
[PFy_EAD, PSy_EAD, PFz_EAD,PSz_EAD, VFy_EAD, VSy_EAD, VFz_EAD, VSz_EAD]=GetCOMTraces(expData, cond{4}, params,  [6:26], 0);
[PFy_LAD, PSy_LAD, PFz_LAD,PSz_LAD, VFy_LAD, VSy_LAD, VFz_LAD, VSz_LAD]=GetCOMTraces(expData, cond{4}, params,  [40], 0);

PFy_slowBaseD=-1.*PFy_slowBaseD;
PSy_slowBaseD=-1.*PSy_slowBaseD;

PFy_fastBaseD=-1.*PFy_fastBaseD;
PSy_fastBaseD=-1.*PSy_fastBaseD;

PFy_BaseD=-1.*PFy_BaseD;
PSy_BaseD=-1.*PSy_BaseD;

PFy_EAD=-1.*PFy_EAD;
PSy_EAD=-1.*PSy_EAD;

PFy_LAD=-1.*PFy_LAD;
PSy_LAD=-1.*PSy_LAD;
%% Position and Velocity
figure
ax11=subplot(2, 4, 1)
plot(PFy_fastBase, ':r')
hold on
plot(PFy_EA, 'r')
plot(PFy_LA, '--r')
plot(PFy_Base, 'k')
title([subjectF ': Position -- Fast Y'])
xlabel('% Stride')
ylabel('Rotated Position')
legend({'Base F', 'EA','LA', 'Base'})
ax12=subplot(2, 4, 2)
plot(PSy_slowBase, ':b')
hold on
plot(PSy_EA, 'b')
plot(PSy_LA, '--b')
plot(PSy_Base, 'k')
title('Position -- Slow Y')
xlabel('% Stride')
ylabel('Rotated Position')
legend({'Base S', 'EA','LA', 'Base'})
ax13=subplot(2, 4, 3)
plot(PFz_fastBase, ':r')
hold on
plot(PFz_EA, 'r')
plot(PFz_LA, '--r')
plot(PFz_Base, 'k')
title('Position -- Fast Z')
xlabel('% Stride')
ylabel('Rotated Position')
ax14=subplot(2, 4, 4)
plot(PSz_slowBase, ':b')
hold on
plot(PSz_EA, 'b')
plot(PSz_LA, '--b')
plot(PSz_Base, 'k')
title('Position -- Slow Z')
xlabel('% Stride')
ylabel('Rotated Position')
ax15=subplot(2, 4, 5)
plot(VFy_fastBase, ':r')
hold on
plot(VFy_EA, 'r')
plot(VFy_LA, '--r')
plot(VFy_Base, 'k')
title('Velocity -- Fast Y')
xlabel('% Stride')
ylabel('Rotated Velocity')
legend({'Base F', 'EA','LA', 'Base'})
ax16=subplot(2, 4, 6)
plot(VSy_slowBase, ':b')
hold on
plot(VSy_EA, 'b')
plot(VSy_LA, '--b')
plot(VSy_Base, 'k')
title('Velocity -- Slow Y')
xlabel('% Stride')
ylabel('Rotated Velocity')
legend({'Base S', 'EA','LA', 'Base'})
ax17=subplot(2, 4, 7)
plot(VFz_fastBase, ':r')
hold on
plot(VFz_EA, 'r')
plot(VFz_LA, '--r')
plot(VFz_Base, 'k')
title('Velocity -- Fast Z')
xlabel('% Stride')
ylabel('Rotated Velocity')
ax18=subplot(2, 4, 8)
plot(VSz_slowBase, ':b')
hold on
plot(VSz_EA, 'b')
plot(VSz_LA, '--b')
plot(VSz_Base, 'k')
title('Velocity -- Slow Z')
xlabel('% Stride')
ylabel('Rotated Velocity')

linkaxes([ax11 ax12 ], 'y')
linkaxes([ax13 ax14], 'y')
linkaxes([ax15 ax16], 'y')
linkaxes([ax17 ax18], 'y')
subplot(2, 4, 1); line([15 15], [-5000 5000]); line([45 45], [-5000 5000]); line([60 60], [-5000 5000]);
subplot(2, 4, 2); line([15 15], [-5000 5000]); line([45 45], [-5000 5000]); line([60 60], [-5000 5000]);
subplot(2, 4, 3); line([15 15], [-5000 5000]); line([45 45], [-5000 5000]); line([60 60], [-5000 5000]);
subplot(2, 4, 4); line([15 15], [-5000 5000]); line([45 45], [-5000 5000]); line([60 60], [-5000 5000]);
subplot(2, 4, 5); line([15 15], [-5000 5000]); line([45 45], [-5000 5000]); line([60 60], [-5000 5000]);
subplot(2, 4, 6); line([15 15], [-5000 5000]); line([45 45], [-5000 5000]); line([60 60], [-5000 5000]);
subplot(2, 4, 7); line([15 15], [-5000 5000]); line([45 45], [-5000 5000]); line([60 60], [-5000 5000]);
subplot(2, 4, 8); line([15 15], [-5000 5000]); line([45 45], [-5000 5000]); line([60 60], [-5000 5000]);

figure
ax21=subplot(2, 4, 1)
plot(PFy_fastBaseI, ':r')
hold on
plot(PFy_EAI, 'r')
plot(PFy_LAI, '--r')
plot(PFy_BaseI, 'k')
title([subjectI ': Position -- Fast Y'])
xlabel('% Stride')
ylabel('Rotated Position')
legend({'Base F', 'EA','LA', 'Base'})
ax22=subplot(2, 4, 2)
plot(PSy_slowBaseI, ':b')
hold on
plot(PSy_EAI, 'b')
plot(PSy_LAI, '--b')
plot(PSy_BaseI, 'k')
title('Position -- Slow Y')
xlabel('% Stride')
ylabel('Rotated Position')
legend({'Base S', 'EA','LA', 'Base'})
ax23=subplot(2, 4, 3)
plot(PFz_fastBaseI, ':r')
hold on
plot(PFz_EAI, 'r')
plot(PFz_LAI, '--r')
plot(PFz_BaseI, 'k')
title('Position -- Fast Z')
xlabel('% Stride')
ylabel('Rotated Position')
ax24=subplot(2, 4, 4)
plot(PSz_slowBaseI, ':b')
hold on
plot(PSz_EAI, 'b')
plot(PSz_LAI, '--b')
plot(PSz_BaseI, 'k')
title('Position -- Slow Z')
xlabel('% Stride')
ylabel('Rotated Position')
ax25=subplot(2, 4, 5)
plot(VFy_fastBaseI, ':r')
hold on
plot(VFy_EAI, 'r')
plot(VFy_LAI, '--r')
plot(VFy_BaseI, 'k')
title('Velocity -- Fast Y')
xlabel('% Stride')
ylabel('Rotated Velocity')
legend({'Base F', 'EA','LA', 'Base'})
ax26=subplot(2, 4, 6)
plot(VSy_slowBaseI, ':b')
hold on
plot(VSy_EAI, 'b')
plot(VSy_LAI, '--b')
plot(VSy_BaseI, 'k')
title('Velocity -- Slow Y')
xlabel('% Stride')
ylabel('Rotated Velocity')
legend({'Base S', 'EA','LA', 'Base'})
ax27=subplot(2, 4, 7)
plot(VFz_fastBaseI, ':r')
hold on
plot(VFz_EAI, 'r')
plot(VFz_LAI, '--r')
plot(VFz_BaseI, 'k')
title('Velocity -- Fast Z')
xlabel('% Stride')
ylabel('Rotated Velocity')
ax28=subplot(2, 4, 8)
plot(VSz_slowBaseI, ':b')
hold on
plot(VSz_EAI, 'b')
plot(VSz_LAI, '--b')
plot(VSz_BaseI, 'k')
title('Velocity -- Slow Z')
xlabel('% Stride')
ylabel('Rotated Velocity')

linkaxes([ax21 ax22 ], 'y')
linkaxes([ax23 ax24], 'y')
linkaxes([ax25 ax26], 'y')
linkaxes([ax27 ax28], 'y')
subplot(2, 4, 1); line([15 15], [-5000 5000]); line([45 45], [-5000 5000]); line([60 60], [-5000 5000]);
subplot(2, 4, 2); line([15 15], [-5000 5000]); line([45 45], [-5000 5000]); line([60 60], [-5000 5000]);
subplot(2, 4, 3); line([15 15], [-5000 5000]); line([45 45], [-5000 5000]); line([60 60], [-5000 5000]);
subplot(2, 4, 4); line([15 15], [-5000 5000]); line([45 45], [-5000 5000]); line([60 60], [-5000 5000]);
subplot(2, 4, 5); line([15 15], [-5000 5000]); line([45 45], [-5000 5000]); line([60 60], [-5000 5000]);
subplot(2, 4, 6); line([15 15], [-5000 5000]); line([45 45], [-5000 5000]); line([60 60], [-5000 5000]);
subplot(2, 4, 7); line([15 15], [-5000 5000]); line([45 45], [-5000 5000]); line([60 60], [-5000 5000]);
subplot(2, 4, 8); line([15 15], [-5000 5000]); line([45 45], [-5000 5000]); line([60 60], [-5000 5000]);


figure
ax31=subplot(2, 4, 1)
plot(PFy_fastBaseD, ':r')
hold on
plot(PFy_EAD, 'r')
plot(PFy_LAD, '--r')
plot(PFy_BaseD, 'k')
title([subjectD ': Position -- Fast Y'])
xlabel('% Stride')
ylabel('Rotated Position')
legend({'Base F', 'EA','LA', 'Base'})
ax32=subplot(2, 4, 2)
plot(PSy_slowBaseD, ':b')
hold on
plot(PSy_EAD, 'b')
plot(PSy_LAD, '--b')
plot(PSy_BaseD, 'k')
title('Position -- Slow Y')
xlabel('% Stride')
ylabel('Rotated Position')
legend({'Base S', 'EA','LA', 'Base'})
ax33=subplot(2, 4, 3)
plot(PFz_fastBaseD, ':r')
hold on
plot(PFz_EAD, 'r')
plot(PFz_LAD, '--r')
plot(PFz_BaseD, 'k')
title('Position -- Fast Z')
xlabel('% Stride')
ylabel('Rotated Position')
ax34=subplot(2, 4, 4)
plot(PSz_slowBaseD, ':b')
hold on
plot(PSz_EAD, 'b')
plot(PSz_LAD, '--b')
plot(PSz_BaseD, 'k')
title('Position -- Slow Z')
xlabel('% Stride')
ylabel('Rotated Position')
ax35=subplot(2, 4, 5)
plot(VFy_fastBaseD, ':r')
hold on
plot(VFy_EAD, 'r')
plot(VFy_LAD, '--r')
plot(VFy_BaseD, 'k')
title('Velocity -- Fast Y')
xlabel('% Stride')
ylabel('Rotated Velocity')
legend({'Base F', 'EA','LA', 'Base'})
ax36=subplot(2, 4, 6)
plot(VSy_slowBaseD, ':b')
hold on
plot(VSy_EAD, 'b')
plot(VSy_LAD, '--b')
plot(VSy_BaseD, 'k')
title('Velocity -- Slow Y')
xlabel('% Stride')
ylabel('Rotated Velocity')
legend({'Base S', 'EA','LA', 'Base'})
ax37=subplot(2, 4, 7)
plot(VFz_fastBaseD, ':r')
hold on
plot(VFz_EAD, 'r')
plot(VFz_LAD, '--r')
plot(VFz_BaseD, 'k')
title('Velocity -- Fast Z')
xlabel('% Stride')
ylabel('Rotated Velocity')
ax38=subplot(2, 4, 8)
plot(VSz_slowBaseD, ':b')
hold on
plot(VSz_EAD, 'b')
plot(VSz_LAD, '--b')
plot(VSz_BaseD, 'k')
title('Velocity -- Slow Z')
xlabel('% Stride')
ylabel('Rotated Velocity')

linkaxes([ax31 ax32 ], 'y')
linkaxes([ax33 ax34], 'y')
linkaxes([ax35 ax36], 'y')
linkaxes([ax37 ax38], 'y')
subplot(2, 4, 1); line([15 15], [-5000 5000]); line([45 45], [-5000 5000]); line([60 60], [-5000 5000]);
subplot(2, 4, 2); line([15 15], [-5000 5000]); line([45 45], [-5000 5000]); line([60 60], [-5000 5000]);
subplot(2, 4, 3); line([15 15], [-5000 5000]); line([45 45], [-5000 5000]); line([60 60], [-5000 5000]);
subplot(2, 4, 4); line([15 15], [-5000 5000]); line([45 45], [-5000 5000]); line([60 60], [-5000 5000]);
subplot(2, 4, 5); line([15 15], [-5000 5000]); line([45 45], [-5000 5000]); line([60 60], [-5000 5000]);
subplot(2, 4, 6); line([15 15], [-5000 5000]); line([45 45], [-5000 5000]); line([60 60], [-5000 5000]);
subplot(2, 4, 7); line([15 15], [-5000 5000]); line([45 45], [-5000 5000]); line([60 60], [-5000 5000]);
subplot(2, 4, 8); line([15 15], [-5000 5000]); line([45 45], [-5000 5000]); line([60 60], [-5000 5000]);
%% 
% figure
% ax11=subplot(2, 4, 1)
% plot(PFy_slowBase, 'b')
% hold on
% plot(PFy_fastBase, 'r')
% plot(PFy_Base, 'k')
% title([subjectF '-- Position -- Fast Y'])
% xlabel('% Stride')
% ylabel('Rotated Position')
% legend({'Base S', 'Base F', 'Base'})
% ax12=subplot(2, 4, 2)
% plot(PSy_slowBase, 'b')
% hold on
% plot(PSy_fastBase, 'r')
% plot(PSy_Base, 'k')
% title('Position -- Slow Y')
% xlabel('% Stride')
% ylabel('Rotated Position')
% ax13=subplot(2, 4, 3)
% plot(PFz_slowBase, 'b')
% hold on
% plot(PFz_fastBase, 'r')
% plot(PFz_Base, 'k')
% title('Position -- Fast Z')
% xlabel('% Stride')
% ylabel('Rotated Position')
% ax14=subplot(2, 4, 4)
% plot(PSz_slowBase, 'b')
% hold on
% plot(PSz_fastBase, 'r')
% plot(PSz_Base, 'k')
% title('Position -- Slow Z')
% xlabel('% Stride')
% ylabel('Rotated Position')
% 
% % % subplot(2, 4, [3 4  7 8])
% % % plot(PFy_Base, 'k')
% % % hold on
% % % plot(PSy_Base, 'k')
% % % plot(PSy_EA, 'b')
% % % plot(PSy_LA, '--b')
% % % plot(PFy_EA, 'r')
% % % plot(PFy_LA, '--r')
% % % legend({'TM Base','TM Base', 'EA Slow','LA Slow', 'EA Fast','LA Fasy'})
% 
% ax15=subplot(2, 4, 5)
% plot(PFy_fastBase, ':r')
% hold on
% plot(PFy_EA, 'r')
% plot(PFy_LA, '--r')
% plot(PFy_Base, 'k')
% title('Position -- Fast Y')
% xlabel('% Stride')
% ylabel('Rotated Position')
% legend({'Base F', 'EA','LA', 'Base'})
% ax16=subplot(2, 4, 6)
% plot(PSy_slowBase, ':b')
% hold on
% plot(PSy_EA, 'b')
% plot(PSy_LA, '--b')
% plot(PSy_Base, 'k')
% title('Position -- Slow Y')
% xlabel('% Stride')
% ylabel('Rotated Position')
% legend({'Base S', 'EA','LA', 'Base'})
% 
% ax17=subplot(2, 4, 7)
% plot(PFz_fastBase, ':r')
% hold on
% plot(PFz_EA, 'r')
% plot(PFz_LA, '--r')
% plot(PFz_Base, 'k')
% title('Position -- Fast Z')
% xlabel('% Stride')
% ylabel('Rotated Position')
% ax18=subplot(2, 4, 8)
% plot(PSz_slowBase, ':b')
% hold on
% plot(PSz_EA, 'b')
% plot(PSz_LA, '--b')
% plot(PSz_Base, 'k')
% title('Position -- Slow Z')
% xlabel('% Stride')
% ylabel('Rotated Position')
% 
% linkaxes([ax11 ax12 ax15 ax16], 'xy')
% linkaxes([ax13 ax14 ax17 ax18], 'xy')
% 
% figure
% ax21=subplot(3, 4, 1)
% plot(PFy_slowBase, 'k')
% hold on
% plot(PFy_slowBaseI, 'r')
% plot(PFy_slowBaseD, 'b')
% title(['Slow Baseline -- Fast Y'])
% xlabel('% Stride')
% ylabel('Rotated Position')
% legend({'Flat', 'Incline', 'Decline'})
% ax22=subplot(3, 4, 2)
% plot(PSy_slowBase, 'k')
% hold on
% plot(PSy_slowBaseI, 'r')
% plot(PSy_slowBaseD, 'b')
% title(['Slow Baseline -- Slow Y'])
% xlabel('% Stride')
% ylabel('Rotated Position')
% ax23=subplot(3, 4, 3)
% plot(PFz_slowBase, 'k')
% hold on
% plot(PFz_slowBaseI, 'r')
% plot(PFz_slowBaseD, 'b')
% title(['Slow Baseline -- Fast Z'])
% xlabel('% Stride')
% ylabel('Rotated Position')
% ax24=subplot(3, 4, 4)
% plot(PSz_slowBase, 'k')
% hold on
% plot(PSz_slowBaseI, 'r')
% plot(PSz_slowBaseD, 'b')
% title(['Slow Baseline -- Slow Z'])
% xlabel('% Stride')
% ylabel('Rotated Position')
% %%
% ax25=subplot(3, 4, 5)
% plot(PFy_Base, 'k')
% hold on
% plot(PFy_BaseI, 'r')
% plot(PFy_BaseD, 'b')
% title(['TM Baseline -- Fast Y'])
% xlabel('% Stride')
% ylabel('Rotated Position')
% legend({'Flat', 'Incline', 'Decline'})
% ax26=subplot(3, 4, 6)
% plot(PSy_Base, 'k')
% hold on
% plot(PSy_BaseI, 'r')
% plot(PSy_BaseD, 'b')
% title(['TM Baseline -- Slow Y'])
% xlabel('% Stride')
% ylabel('Rotated Position')
% ax27=subplot(3, 4, 7)
% plot(PFz_Base, 'k')
% hold on
% plot(PFz_BaseI, 'r')
% plot(PFz_BaseD, 'b')
% title(['TM Baseline -- Fast Z'])
% xlabel('% Stride')
% ylabel('Rotated Position')
% ax28=subplot(3, 4, 8)
% plot(PSz_Base, 'k')
% hold on
% plot(PSz_BaseI, 'r')
% plot(PSz_BaseD, 'b')
% title(['TM Baseline -- Slow Z'])
% xlabel('% Stride')
% ylabel('Rotated Position')
% 
% %%
% ax29=subplot(3, 4, 9)
% plot(PFy_fastBase, 'k')
% hold on
% plot(PFy_fastBaseI, 'r')
% plot(PFy_fastBaseD, 'b')
% title(['fast Baseline -- Fast Y'])
% xlabel('% Stride')
% ylabel('Rotated Position')
% legend({'Flat', 'Incline', 'Decline'})
% ax210=subplot(3, 4, 10)
% plot(PSy_fastBase, 'k')
% hold on
% plot(PSy_fastBaseI, 'r')
% plot(PSy_fastBaseD, 'b')
% title(['fast Baseline -- Slow Y'])
% xlabel('% Stride')
% ylabel('Rotated Position')
% ax211=subplot(3, 4, 11)
% plot(PFz_fastBase, 'k')
% hold on
% plot(PFz_fastBaseI, 'r')
% plot(PFz_fastBaseD, 'b')
% title(['fast Baseline -- Fast Z'])
% xlabel('% Stride')
% ylabel('Rotated Position')
% ax212=subplot(3, 4,12)
% plot(PSz_fastBase, 'k')
% hold on
% plot(PSz_fastBaseI, 'r')
% plot(PSz_fastBaseD, 'b')
% title(['fast Baseline -- Slow Z'])
% xlabel('% Stride')
% ylabel('Rotated Position')
% 
% %%
% figure
% ax31=subplot(2, 4, 1)
% plot(PFy_slowBaseI, 'b')
% hold on
% plot(PFy_fastBaseI, 'r')
% plot(PFy_BaseI, 'k')
% title([subjectI '-- Position -- Fast Y'])
% xlabel('% Stride')
% ylabel('Rotated Position')
% legend({'Base S', 'Base F', 'Base'})
% ax32=subplot(2, 4, 2)
% plot(PSy_slowBaseI, 'b')
% hold on
% plot(PSy_fastBaseI, 'r')
% plot(PSy_BaseI, 'k')
% title('Position -- Slow Y')
% xlabel('% Stride')
% ylabel('Rotated Position')
% ax33=subplot(2, 4, 3)
% plot(PFz_slowBaseI, 'b')
% hold on
% plot(PFz_fastBaseI, 'r')
% plot(PFz_BaseI, 'k')
% title('Position -- Fast Z')
% xlabel('% Stride')
% ylabel('Rotated Position')
% ax34=subplot(2, 4, 4)
% plot(PSz_slowBaseI, 'b')
% hold on
% plot(PSz_fastBaseI, 'r')
% plot(PSz_BaseI, 'k')
% title('Position -- Slow Z')
% xlabel('% Stride')
% ylabel('Rotated Position')
% 
% ax35=subplot(2, 4, 5)
% plot(PFy_fastBaseI, ':r')
% hold on
% plot(PFy_EAI, 'r')
% plot(PFy_LAI, '--r')
% plot(PFy_BaseI, 'k')
% title('Position -- Fast Y')
% xlabel('% Stride')
% ylabel('Rotated Position')
% legend({'Base F', 'EA','LA', 'Base'})
% ax36=subplot(2, 4, 6)
% plot(PSy_slowBaseI, ':b')
% hold on
% plot(PSy_EAI, 'b')
% plot(PSy_LAI, '--b')
% plot(PSy_BaseI, 'k')
% title('Position -- Slow Y')
% xlabel('% Stride')
% ylabel('Rotated Position')
% legend({'Base S', 'EA','LA', 'Base'})
% ax37=subplot(2, 4, 7)
% plot(PFz_fastBaseI, ':r')
% hold on
% plot(PFz_EAI, 'r')
% plot(PFz_LAI, '--r')
% plot(PFz_BaseI, 'k')
% title('Position -- Fast Z')
% xlabel('% Stride')
% ylabel('Rotated Position')
% ax38=subplot(2, 4, 8)
% plot(PSz_slowBaseI, ':b')
% hold on
% plot(PSz_EAI, 'b')
% plot(PSz_LAI, '--b')
% plot(PSz_BaseI, 'k')
% title('Position -- Slow Z')
% xlabel('% Stride')
% ylabel('Rotated Position')
% 
% linkaxes([ax31 ax32 ax35 ax36], 'xy')
% linkaxes([ax33 ax34 ax37 ax38], 'xy')
% %%
% figure
% ax41=subplot(2, 4, 1)
% plot(PFy_slowBaseD, 'b')
% hold on
% plot(PFy_fastBaseD, 'r')
% plot(PFy_BaseD, 'k')
% title([subjectD '-- Position -- Fast Y'])
% xlabel('% Stride')
% ylabel('Rotated Position')
% legend({'Base S', 'Base F', 'Base'})
% ax42=subplot(2, 4, 2)
% plot(PSy_slowBaseD, 'b')
% hold on
% plot(PSy_fastBaseD, 'r')
% plot(PSy_BaseD, 'k')
% title('Position -- Slow Y')
% xlabel('% Stride')
% ylabel('Rotated Position')
% ax43=subplot(2, 4, 3)
% plot(PFz_slowBaseD, 'b')
% hold on
% plot(PFz_fastBaseD, 'r')
% plot(PFz_BaseD, 'k')
% title('Position -- Fast Z')
% xlabel('% Stride')
% ylabel('Rotated Position')
% ax44=subplot(2, 4, 4)
% plot(PSz_slowBaseD, 'b')
% hold on
% plot(PSz_fastBaseD, 'r')
% plot(PSz_BaseD, 'k')
% title('Position -- Slow Z')
% xlabel('% Stride')
% ylabel('Rotated Position')
% 
% ax45=subplot(2, 4, 5)
% plot(PFy_fastBaseD, ':r')
% hold on
% plot(PFy_EAD, 'r')
% plot(PFy_LAD, '--r')
% plot(PFy_BaseD, 'k')
% title('Position -- Fast Y')
% xlabel('% Stride')
% ylabel('Rotated Position')
% legend({'Base F', 'EA','LA', 'Base'})
% ax46=subplot(2, 4, 6)
% plot(PSy_slowBaseD, ':b')
% hold on
% plot(PSy_EAD, 'b')
% plot(PSy_LAD, '--b')
% plot(PSy_BaseD, 'k')
% title('Position -- Slow Y')
% xlabel('% Stride')
% ylabel('Rotated Position')
% legend({'Base S', 'EA','LA', 'Base'})
% ax47=subplot(2, 4, 7)
% plot(PFz_fastBaseD, ':r')
% hold on
% plot(PFz_EAD, 'r')
% plot(PFz_LAD, '--r')
% plot(PFz_BaseD, 'k')
% title('Position -- Fast Z')
% xlabel('% Stride')
% ylabel('Rotated Position')
% ax48=subplot(2, 4, 8)
% plot(PSz_slowBaseD, ':b')
% hold on
% plot(PSz_EAD, 'b')
% plot(PSz_LAD, '--b')
% plot(PSz_BaseD, 'k')
% title('Position -- Slow Z')
% xlabel('% Stride')
% ylabel('Rotated Position')
% 
% linkaxes([ax41 ax42 ax45 ax46], 'xy')
% linkaxes([ax43 ax44 ax47 ax48], 'xy')