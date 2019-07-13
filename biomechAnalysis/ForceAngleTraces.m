%ForceAngleTraces
close all
clear all

%% Edit
subject='LD0030';
%subject='LI0024';
%subject='LN0003';
load([subject '.mat']);%load('LD0030.mat')
%cond='TM base'; params={'LFy', 'RFy'};
cond='adaptation'; params={'LFy', 'RFy'};
%cond='slow base flat';params={'LFz', 'RFz'};
[striderSE, striderFE, LevelofInterest]=GetGRFTraces(expData, cond , params,  [1:20], 0);
[striderSL, striderFL, LevelofInterest]=GetGRFTraces(expData, cond, params,  [40], 1);

[striderSE_A, striderFE_A]=GetAngleTraces(expData, cond , params,  [1:20], 0);
[striderSL_A, striderFL_A]=GetAngleTraces(expData, cond, params,  [40], 1);

close all

x = linspace(1,100);
y1=striderSE';
y2=striderSE_A';
figure(1) % new figure
subplot(2, 2, 1);
[hAx,hLine1,hLine2] = plotyy(x,y1,x,y2);
hline = refline([0 0]);
hline.Color = 'k';
maxval = cellfun(@(x) max(abs(x)), get([hLine1 hLine2], 'YData'));
halfy=length(maxval)/2;
ylim1 = [-1.*max(maxval(1:halfy)), max(maxval(1:halfy))] * 1.1;  % Mult by 1.1 to pad out a bit
ylim2 = [-1.*max(maxval(halfy+1:end)), max(maxval(halfy+1:end))] * 1.1;  % Mult by 1.1 to pad out a bit
set(hAx(1), 'YLim', ylim1);
set(hAx(2), 'YLim', ylim2);
hAx(2).YTick = [-20 -10  0  10 20];
title({[subject ': Early ' cond] ; 'Slow Leg: AP Force & Angle'})
xlabel('% Stance')
ylabel(hAx(1),'Force (%BW)') % left y-axis
ylabel(hAx(2),'Angle (deg)') % right y-axis

y1=striderFE';
y2=striderFE_A';
figure(1) % new figure
subplot(2, 2, 2)
[hAx,hLine1,hLine2] = plotyy(x,y1,x,y2);
hline = refline([0 0]);
hline.Color = 'k';
maxval = cellfun(@(x) max(abs(x)), get([hLine1 hLine2], 'YData'));
halfy=length(maxval)/2;
ylim1 = [-1.*max(maxval(1:halfy)), max(maxval(1:halfy))] * 1.1;  % Mult by 1.1 to pad out a bit
ylim2 = [-1.*max(maxval(halfy+1:end)), max(maxval(halfy+1:end))] * 1.1;  % Mult by 1.1 to pad out a bit
set(hAx(1), 'YLim', ylim1);
set(hAx(2), 'YLim', ylim2);
hAx(2).YTick = [-40 -20  0  20 40];
title({[subject ': Early ' cond] ;  'Fast Leg: AP Force & Angle'})
xlabel('% Stance')
ylabel(hAx(1),'Force (%BW)') % left y-axis
ylabel(hAx(2),'Angle (deg)') % right y-axis

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
y1=striderSL';
y2=striderSL_A';
figure(1) % new figure
subplot(2, 2, 3)
[hAx,hLine1,hLine2] = plotyy(x,y1,x,y2);
hline = refline([0 0]);
hline.Color = 'k';
maxval = cellfun(@(x) max(abs(x)), get([hLine1 hLine2], 'YData'));
halfy=length(maxval)/2;
ylim1 = [-1.*max(maxval(1:halfy)), max(maxval(1:halfy))] * 1.1;  % Mult by 1.1 to pad out a bit
ylim2 = [-1.*max(maxval(halfy+1:end)), max(maxval(halfy+1:end))] * 1.1;  % Mult by 1.1 to pad out a bit
set(hAx(1), 'YLim', ylim1);
set(hAx(2), 'YLim', ylim2);
hAx(2).YTick = [-20 -10  0  10 20];
title({[subject ': Late ' cond] ;  'Slow Leg: AP Force & Angle'})
xlabel('% Stance')
ylabel(hAx(1),'Force (%BW)') % left y-axis
ylabel(hAx(2),'Angle (deg)') % right y-axis

y1=striderFL';
y2=striderFL_A';
figure(1) % new figure
subplot(2, 2, 4)
[hAx,hLine1,hLine2] = plotyy(x,y1,x,y2);
hline = refline([0 0]);
hline.Color = 'k';
maxval = cellfun(@(x) max(abs(x)), get([hLine1 hLine2], 'YData'));
halfy=length(maxval)/2;
ylim1 = [-1.*max(maxval(1:halfy)), max(maxval(1:halfy))] * 1.1;  % Mult by 1.1 to pad out a bit
ylim2 = [-1.*max(maxval(halfy+1:end)), max(maxval(halfy+1:end))] * 1.1;  % Mult by 1.1 to pad out a bit
set(hAx(1), 'YLim', ylim1);
set(hAx(2), 'YLim', ylim2);
hAx(2).YTick = [-40 -20  0  20 40];
title({[subject ': Late ' cond] ; 'Fast Leg: AP Force & Angle'})
xlabel('% Stance')
ylabel(hAx(1),'Force (%BW)') % left y-axis
ylabel(hAx(2),'Angle (deg)') % right y-axis