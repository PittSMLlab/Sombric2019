close all
load('C:\Users\cjs180\Desktop\paramFiles\DumbTester7.mat')
groups = {'DeclineYoungAbrupt','FlatYoungAbrupt','InclineYoungAbrupt'};
%params={'alphaAngSlow', 'alphaAngFast','betaAngSlow','betaAngFast'};
%params={'alphaAngSlow', 'alphaAngFast','XAngSlow','XAngFast'};
params={'alphaAngSlowGravity', 'alphaAngFastGravity','XAngSlowGravity','XAngFastGravity'};
%results = getResults(DumbTester7,params,groups,0, 0 , 0, 0);
results = getForceResults(DumbTester7,params,groups,0, 1 , 0, 0);
params={'stepLengthSlow', 'StepLengthFast'};
R = getForceResults(DumbTester7,params,groups,0, 0 , 0, 0);

poster_colors;
colorOrder=[p_red; p_orange; p_fade_green; p_fade_blue; p_plum; p_green; p_blue; p_fade_red; p_lime; p_yellow; p_gray; p_black;[1 1 1]];         

cond='TMSteady';
%cond='EarlyA';
%cond='TMafter';

condB='MidBase';
condBS='SlowBase';
condBF='FastBase';

 G=results.(cond).indiv.('alphaAngSlowGravity')(:,1);
% AlphaS=results.(cond).indiv.('alphaAngSlow')(:,2);
% AlphaF=results.(cond).indiv.('alphaAngFast')(:,2);
% % BetaS=results.(cond).indiv.('betaAngSlow')(:,2);
% % BetaF=results.(cond).indiv.('betaAngFast')(:,2);
% BetaS=results.(cond).indiv.('XAngFast')(:,2);
% BetaF=results.(cond).indiv.('XAngSlow')(:,2);
% 
 SLs=R.(cond).indiv.('stepLengthSlow')(:,2);
 SLf=R.(cond).indiv.('StepLengthFast')(:,2);
% 
% DATA=[ G abs(AlphaS-BetaS) abs(AlphaF-BetaF)];

figure
subplot(2, 3, 1)
%tempAng1=degtorad(results.TMsteady.avg(1, :)-90);
tempAng1=eval(['degtorad(results.' cond '.avg(1, :)-90)']);
%tempAng1=eval(['degtorad((results.' cond '.avg(1, :)-90)+([-8.5 -8.5 8.5 8.5 ]))'])
hs1=polar([0 tempAng1(1) tempAng1(3) ], [0 1 1], 'b');
hold on
hf1=polar([0 tempAng1(2) tempAng1(4)], [0 1 1 ], 'r');
hs11=patch( get(hs1,'XData'), get(hs1,'YData'), 'b', 'FaceAlpha', .3);
hs12=patch( get(hf1,'XData'), get(hf1,'YData'), 'r', 'FaceAlpha', .3);

tempAng1BS=eval(['degtorad(results.' condBS '.avg(1, :)-90)']);
hsbaseA1=polar([0 mean([tempAng1BS(1) tempAng1BS(2)]) ], [0 1 ], 'b--o');
hsbaseA2=polar([0 mean([tempAng1BS(3) tempAng1BS(4)])], [0 1 ],'b--o');

tempAng1BF=eval(['degtorad(results.' condBF '.avg(1, :)-90)']);
hfbaseA1=polar([0 mean([tempAng1BF(1) tempAng1BF(2)]) ], [0 1 ], 'r--o');
hfbaseA2=polar([0 mean([tempAng1BF(3) tempAng1BF(4)])], [0 1 ],'r--o');
legend([hs11 hs12 hsbaseA1 hfbaseA1], 'Slow leg range', 'Fast leg swing range',condBS,condBF, 'Location', 'North')
title([groups{1} ': ' cond ' Leg Range'])


subplot(2, 3, 2)
%tempAng2=degtorad(results.TMsteady.avg(2, :)-90);
tempAng2=eval(['degtorad(results.' cond '.avg(2, :)-90)']);
hs2=polar([0 tempAng2(1) tempAng2(3) ], [0 1 1], 'b');
hold on
hf2=polar([0 tempAng2(2) tempAng2(4)], [0 1 1 ], 'r');
hs21=patch( get(hs2,'XData'), get(hs2,'YData'), 'b', 'FaceAlpha', .3);
hs22=patch( get(hf2,'XData'), get(hf2,'YData'), 'r', 'FaceAlpha', .3);

tempAng2B=eval(['degtorad(results.' condB '.avg(2, :)-90)']);
hs2base=polar([0 mean([tempAng2B(1) tempAng2B(2)]) ], [0 1 ], 'b--o');
hf2base=polar([0 mean([tempAng2B(3) tempAng2B(4)])], [0 1 ],'b--o');

tempAng2BF=eval(['degtorad(results.' condBF '.avg(2, :)-90)']);
hfbaseB1=polar([0 mean([tempAng2BF(1) tempAng2BF(2)]) ], [0 1 ], 'r--o');
hfbaseB2=polar([0 mean([tempAng2BF(3) tempAng2BF(4)])], [0 1 ],'r--o');
%legend([hs21 hs22], 'Slow leg range', 'Fast leg swing range','Location', 'SouthOutside')
title([groups{2} ': ' cond ' Leg Range'])
%DATA=[DATA; tempAng2(1)-tempAng2(3) tempAng2(2)-tempAng2(4)]

subplot(2, 3, 3)
%tempAng3=degtorad(results.TMsteady.avg(3, :)-90);
tempAng3=eval(['degtorad(results.' cond '.avg(3, :)-90)']);
%tempAng3=eval(['degtorad((results.' cond '.avg(3, :)-90)+([8.5 8.5 -8.5 -8.5 ]))'])
hs3=polar([0 tempAng3(1) tempAng3(3) ], [0 1 1], 'b');
hold on
hf3=polar([0 tempAng3(2) tempAng3(4)], [0 1 1 ], 'r');
hs31=patch( get(hs3,'XData'), get(hs3,'YData'), 'b', 'FaceAlpha', .3);
hs32=patch( get(hf3,'XData'), get(hf3,'YData'), 'r', 'FaceAlpha', .3);

tempAng3B=eval(['degtorad(results.' condB '.avg(3, :)-90)']);
  hs3base=polar([0 mean([tempAng3B(1) tempAng3B(2)]) ], [0 1 ], 'b--o');
 hf3base=polar([0 mean([tempAng3B(3) tempAng3B(4)])], [0 1 ],'b--o');
 
 tempAng3BF=eval(['degtorad(results.' condBF '.avg(3, :)-90)']);
hfbaseC1=polar([0 mean([tempAng3BF(1) tempAng3BF(2)]) ], [0 1 ], 'r--o');
hfbaseC2=polar([0 mean([tempAng3BF(3) tempAng3BF(4)])], [0 1 ],'r--o');
%legend([hs31 hs32], 'Slow leg range', 'Fast leg swing range','Location', 'SouthOutside')
title([groups{3}  ': ' cond ' Leg Range'])
%DATA=[DATA; tempAng3(1)-tempAng3(3) tempAng3(2)-tempAng3(4)]
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ax1=subplot(2, 3, 4);
barh([mean(SLs(find(G==1)));mean(SLf(find(G==1))) ; mean(SLf(find(G==1)))-mean(SLs(find(G==1)))])
set(gca,'yticklabel',{'SlowStepLength',  'FastStepLength', 'StepLengthDiff'})
xlabel('Distance (mm)')
title([groups{1} ': ' cond ' Step Lengths'])

ax2=subplot(2, 3, 5);
barh([mean(SLs(find(G==2)));mean(SLf(find(G==2))) ; mean(SLf(find(G==2)))-mean(SLs(find(G==2)))])
set(gca,'yticklabel',{'SlowStepLength',  'FastStepLength', 'StepLengthDiff'})
xlabel('Distance (mm)')
title([groups{2} ': ' cond ' Step Lengths'])

ax3=subplot(2, 3, 6);
barh([mean(SLs(find(G==3)));mean(SLf(find(G==3))) ; mean(SLf(find(G==3)))-mean(SLs(find(G==3)))])
set(gca,'yticklabel',{'SlowStepLength',  'FastStepLength', 'StepLengthDiff'})
xlabel('Distance (mm)')
title([groups{3} ': ' cond ' Step Lengths'])

linkaxes([ax1,ax2,ax3],'x')
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% %figure(2)
% subplot(2, 3, 4)
% hs1=polar([ tempAng1(1) 0 tempAng1(3) ], [1 0 1], 'b')
% hold on
% hs2=polar([ tempAng2(1) 0 tempAng2(3) ], [1 0 1], 'k')
% hs3=polar([ tempAng3(1) 0 tempAng3(3) ], [1 0 1], 'r')
% legend(groups,'Location', 'North')
% title(['Slow Legs: SS Leg Range'])
% % hs1=polar([0 tempAng1(1) tempAng1(3) ], [0 1 1], 'b')
% % hold on
% % hs2=polar([0 tempAng2(1) tempAng2(3) ], [0 1 1], 'k')
% % hs3=polar([0 tempAng3(1) tempAng3(3) ], [0 1 1], 'r')
% % hs11=patch( get(hs1,'XData'), get(hs1,'YData'), colorOrder(1, :), 'FaceAlpha', .1)
% % hs21=patch( get(hs2,'XData'), get(hs2,'YData'), colorOrder(2, :), 'FaceAlpha', .1)
% % hs31=patch( get(hs3,'XData'), get(hs3,'YData'), colorOrder(3, :), 'FaceAlpha', .1)
% 
% %figure(3)
% subplot(2, 3, 5)
% hs1=polar([ tempAng1(2) 0 tempAng1(4) ], [1 0 1], 'b')
% hold on
% hs2=polar([ tempAng2(2) 0 tempAng2(4) ], [1 0 1], 'k')
% hs3=polar([ tempAng3(2) 0 tempAng3(4) ], [1 0 1], 'r')
% %legend(groups,'Location', 'North')
% title(['Fast Legs: SS Leg Range'])
% % hf1=polar([0 tempAng1(2) tempAng1(4)], [0 1 1 ], 'r')
% % hold on
% % hs12=patch( get(hf1,'XData'), get(hf1,'YData'), colorOrder(1, :), 'FaceAlpha', .3)
% % hf2=polar([0 tempAng2(2) tempAng2(4)], [0 1 1 ], 'r')
% % hs22=patch( get(hf2,'XData'), get(hf2,'YData'), colorOrder(2, :), 'FaceAlpha', .3)
% % hf3=polar([0 tempAng3(2) tempAng3(4)], [0 1 1 ], 'r')
% % hs32=patch( get(hf3,'XData'), get(hf3,'YData'), colorOrder(2, :), 'FaceAlpha', .3)
% 
% 
% % %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% % figure(1)
% % subplot(2, 3, 4)
% % tempAng1=degtorad(results.TMsteady.avg(1, :)-90-8.5);
% % hs1=polar([0 tempAng1(1) tempAng1(3) ], [0 1 1], 'b')
% % hold on
% % hf1=polar([0 tempAng1(2) tempAng1(4)], [0 1 1 ], 'r')
% % hs11=patch( get(hs1,'XData'), get(hs1,'YData'), 'b', 'FaceAlpha', .3)
% % hs12=patch( get(hf1,'XData'), get(hf1,'YData'), 'r', 'FaceAlpha', .3)
% % %legend([hs11 hs12], 'Slow leg range', 'Fast leg swing range','Location', 'SouthOutside')
% % title([groups{1} ': SS Leg Range'])
% % 
% % subplot(2, 3, 5)
% % tempAng2=degtorad(results.TMsteady.avg(2, :)-90);
% % hs2=polar([0 tempAng2(1) tempAng2(3) ], [0 1 1], 'b')
% % hold on
% % hf2=polar([0 tempAng2(2) tempAng2(4)], [0 1 1 ], 'r')
% % hs21=patch( get(hs2,'XData'), get(hs2,'YData'), 'b', 'FaceAlpha', .3)
% % hs22=patch( get(hf2,'XData'), get(hf2,'YData'), 'r', 'FaceAlpha', .3)
% % %legend([hs21 hs22], 'Slow leg range', 'Fast leg swing range','Location', 'SouthOutside')
% % title([groups{2} ': SS Leg Range'])
% % 
% % subplot(2, 3, 6)
% % tempAng3=degtorad(results.TMsteady.avg(3, :)-90-8.5);
% % hs3=polar([0 tempAng3(1) tempAng3(3) ], [0 1 1], 'b')
% % hold on
% % hf3=polar([0 tempAng3(2) tempAng3(4)], [0 1 1 ], 'r')
% % hs31=patch( get(hs3,'XData'), get(hs3,'YData'), 'b', 'FaceAlpha', .3)
% % hs32=patch( get(hf3,'XData'), get(hf3,'YData'), 'r', 'FaceAlpha', .3)
% % %legend([hs31 hs32], 'Slow leg range', 'Fast leg swing range','Location', 'SouthOutside')
% % title([groups{3} ': SS Leg Range'])
% % 
% % %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% % % figure(2)
% % % subplot(1, 2, 2)
% % % hs1=polar([ tempAng1(1) 0 tempAng1(3) ], [1 0 1], '--b')
% % % hold on
% % % hs2=polar([ tempAng2(1) 0 tempAng2(3) ], [1 0 1], '--k')
% % % hs3=polar([ tempAng3(1) 0 tempAng3(3) ], [1 0 1], '--r')
% % % title(['270 deg aligns parallel with gravity'])
% % % 
% % % 
% % % figure(3)
% % % subplot(1, 2, 2)
% % % hs1=polar([ tempAng1(2) 0 tempAng1(4) ], [1 0 1], '--b')
% % % hold on
% % % hs2=polar([ tempAng2(2) 0 tempAng2(4) ], [1 0 1], '--k')
% % % hs3=polar([ tempAng3(2) 0 tempAng3(4) ], [1 0 1], '--r')
% % % title(['270 deg aligns parallel with gravity'])
% % 
% % 
% % % hs1=polar([0 tempAng1(1) tempAng1(3) ], [0 1 1], 'b')
% % % hold on
% % % hs2=polar([0 tempAng2(1) tempAng2(3) ], [0 1 1], 'k')
% % % hs3=polar([0 tempAng3(1) tempAng3(3) ], [0 1 1], 'r')
% % % hs21=patch( get(hs2,'XData'), get(hs2,'YData'), colorOrder(2, :), 'FaceAlpha', .4)
% % % hs11=patch( get(hs1,'XData'), get(hs1,'YData'), colorOrder(1, :), 'FaceAlpha', .4)
% % % hs31=patch( get(hs3,'XData'), get(hs3,'YData'), colorOrder(3, :), 'FaceAlpha', .4)
% % 
% % % subplot(2, 3, 5)
% % % hf1=polar([0 tempAng1(2) tempAng1(4)], [0 1 1 ], 'r')
% % % hold on
% % % hs12=patch( get(hf1,'XData'), get(hf1,'YData'), colorOrder(1, :), 'FaceAlpha', .3)
% % % hf2=polar([0 tempAng2(2) tempAng2(4)], [0 1 1 ], 'r')
% % % hs22=patch( get(hf2,'XData'), get(hf2,'YData'), colorOrder(2, :), 'FaceAlpha', .3)
% % % hf3=polar([0 tempAng3(2) tempAng3(4)], [0 1 1 ], 'r')
% % % hs32=patch( get(hf3,'XData'), get(hf3,'YData'), colorOrder(2, :), 'FaceAlpha', .3)