function StepLengthVis(StudyData, groups)

resultsSL = getForceResults(StudyData,{'stepLengthSlow', 'stepLengthFast'},groups,0, 0 , 0, 1);
params = {'FyBSmax','FyBFmax','FyPSmax','FyPFmax',  'XSlow', 'XFast', 'alphaSlow', 'alphaFast','stepLengthSlow', 'stepLengthFast'};
RF=getForceResults(StudyData,params,groups,0, 0, 0, 1);
 cond='TMSteady';condE='EarlyA';condB='MidBase';condBS='SlowBase';condBF='FastBase'; condAE='TMafter'; % TO look at adaptation
RccX=getForceResults(StudyData,{'XSlow', 'XFast'},groups,0, 0, 0, 1);
RccA=getForceResults(StudyData,{'alphaSlow', 'alphaFast'},groups,0, 0, 0, 1);
%% Param Pattern for correct Plotting -- PERPENDICULAR TO THE SURGACE OF THE TREADMILL
% %params={'(A) Slow leg at SHS', '(B) Fast leg at FHS', '(A) Fast leg SHS', '(B)Slow leg at FHS'};
%Position of the leg relative to the average hip at events used to calc step lengths
params={'alphaSlow', 'alphaFast','XFast','XSlow'};
%'alphaSlow',                'ankle placement of slow leg at SHS2 (realtive to avg hip marker) (in mm)';...
%'alphaTemp',                'ankle placement of slow leg at SHS (realtive to avg hip marker) (in mm)';...
%'alphaFast',                'ankle placement of fast leg at FHS (in mm)';...
%'XSlow',                    'ankle postion of the slow leg @FHS (in mm)';...
%'XFast',                    'ankle position of Fast leg @SHS (in mm)';...
% ylabelTEXT={' Trailing Leg | Step Lendth (mm) | Forward Leg'};
%legendTEXT={[cond ' SL'], [condE ' SL'], 'Speed Specific Baseline SL', 'Slow SL', 'Fast SL'};
legendTEXT={'AnkleRange', 'Slow SL', 'Fast SL'};
ylabelTEXT={'Ankle Range (mm)'};

%%
close all
results = getForceResults(StudyData,params,groups,0, 0 , 0, 0);

COMProjParams={'COM_Grav_ProjSHS', 'COM_Grav_ProjFHS'};
COMresults = getForceResults(StudyData,COMProjParams,groups,0, 0 , 0, 0);

w1 = 0.5;
w2 = 0.5;
ww = 0.5; % ww=.7;
x = [2 1];
xb = [.5 2.5];

len1=eval(['results.' cond '.avg(1, :)']);
len1AE=eval(['results.' condAE '.avg(1, :)']);
len1E=eval(['results.' condE '.avg(1, :)']);
len1S=eval(['results.' condBS '.avg(1, :)']);
len1F=eval(['results.' condBF '.avg(1, :)']);
len1M=eval(['results.' condB '.avg(1, :)']);
len1_SE=eval(['results.' cond '.se(1, :)']);
len1AE_SE=eval(['results.' condAE '.se(1, :)']);
len1E_SE=eval(['results.' condE '.se(1, :)']);
len1S_SE=eval(['results.' condBS '.se(1, :)']);
len1F_SE=eval(['results.' condBF '.se(1, :)']);
len1M_SE=eval(['results.' condB '.se(1, :)']);
Alpha1 =[ len1(1); len1(3)];Alpha1_SE=[ len1_SE(1); len1_SE(3)];
X1=[ len1(4); len1(2)];X1_SE=[ len1_SE(4); len1_SE(2)];
Alpha1AE =[ len1AE(1); len1AE(3)];Alpha1AE_SE=[ len1AE_SE(1); len1AE_SE(3)];
X1AE=[ len1AE(4); len1AE(2)];X1AE_SE=[ len1AE_SE(4); len1AE_SE(2)];
AlphaSpdSPec=[ len1S(1); len1F(3)];AlphaSpdSPec_SE=[ len1S_SE(1); len1F_SE(3)];
X1SpdSPec=[len1S(4); len1F(2) ];X1SpdSPec_SE=[len1S_SE(4); len1F_SE(2) ];
Alpha1E =[ len1E(1); len1E(2)];Alpha1E_SE =[ len1E_SE(1); len1E_SE(2)];
X1E=[len1E(4); len1E(3) ];X1E_SE=[len1E_SE(4); len1E_SE(3) ];
Alpha1SlowBase=[ len1S(1); len1S(3)];Alpha1SlowBase_SE=[ len1S_SE(1); len1S_SE(3)];
X1SlowBase=[len1S(4); len1S(2) ];X1SlowBase_SE=[len1S_SE(4); len1S_SE(2) ];
Alpha1FastBase=[ len1F(1); len1F(3)];Alpha1FastBase_SE=[ len1F_SE(1); len1F_SE(3)];
X1FastBase=[len1F(4); len1F(2) ];X1FastBase_SE=[len1F_SE(4); len1F_SE(2) ];
Alpha1MBase=[ len1M(1); len1M(3)];Alpha1MBase_SE=[ len1M_SE(1); len1M_SE(3)];
X1MBase=[len1M(4); len1M(2) ];X1MBase_SE=[len1M_SE(4); len1M_SE(2) ];

len2=eval(['results.' cond '.avg(2, :)']);
len2AE=eval(['results.' condAE '.avg(2, :)']);
len2S=eval(['results.' condBS '.avg(2, :)']);
len2F=eval(['results.' condBF '.avg(2, :)']);
len2M=eval(['results.' condB '.avg(2, :)']);
len2E=eval(['results.' condE '.avg(2, :)']);
len2_SE=eval(['results.' cond '.se(2, :)']);
len2AE_SE=eval(['results.' condAE '.se(2, :)']);
len2S_SE=eval(['results.' condBS '.se(2, :)']);
len2F_SE=eval(['results.' condBF '.se(2, :)']);
len2M_SE=eval(['results.' condB '.se(2, :)']);
len2E_SE=eval(['results.' condE '.se(2, :)']);
Alpha2 =[ len2(1); len2(3)];Alpha2_SE =[ len2_SE(1); len2_SE(3)];
X2=[ len2(4); len2(2)];X2_SE=[ len2_SE(4); len2_SE(2)];
Alpha2AE =[ len2AE(1); len2AE(3)];Alpha2AE_SE =[ len2AE_SE(1); len2AE_SE(3)];
X2AE=[ len2AE(4); len2AE(2)];X2AE_SE=[ len2AE_SE(4); len2AE_SE(2)];
Alpha2S =[ len2S(1); len2S(2)];Alpha2S_SE =[ len2S_SE(1); len2S_SE(2)];
X2S=[len2S(4); len2S(3) ];X2S_SE=[len2S_SE(4); len2S_SE(3) ];
Alpha2F =[ len2F(1); len2F(2)];Alpha2F_SE =[ len2F_SE(1); len2F_SE(2)];
X2F=[len2F(4); len2F(3) ];X2F_SE=[len2F_SE(4); len2F_SE(3) ];
AlphaSpdSPec2=[ len2S(1); len2F(3)];AlphaSpdSPec2_SE=[ len2S_SE(1); len2F_SE(3)];
X2SpdSPec=[len2S(4); len2F(2) ];X2SpdSPec_SE=[len2S_SE(4); len2F_SE(2) ];
Alpha2E =[ len2E(1); len2E(2)];Alpha2E_SE =[ len2E_SE(1); len2E_SE(2)];
X2E=[len2E(4); len2E(3) ];X2E_SE=[len2E_SE(4); len2E_SE(3) ];
Alpha2SlowBase=[ len2S(1); len2S(3)];Alpha2SlowBase_SE=[ len2S_SE(1); len2S_SE(3)];
X2SlowBase=[len2S(4); len2S(2) ];X2SlowBase_SE=[len2S_SE(4); len2S_SE(2) ];
Alpha2FastBase=[ len2F(1); len2F(3)];Alpha2FastBase_SE=[ len2F_SE(1); len2F_SE(3)];
X2FastBase=[len2F(4); len2F(2) ];X2FastBase_SE=[len2F_SE(4); len2F_SE(2) ];
Alpha2MBase=[ len2M(1); len2M(3)];Alpha2MBase_SE=[ len2M_SE(1); len2M_SE(3)];
X2MBase=[len2M(4); len2M(2) ];X2MBase_SE=[len2M_SE(4); len2M_SE(2) ];

len3=eval(['results.' cond '.avg(3, :)']);
len3AE=eval(['results.' condAE '.avg(3, :)']);
len3S=eval(['results.' condBS '.avg(3, :)']);
len3F=eval(['results.' condBF '.avg(3, :)']);
len3E=eval(['results.' condE '.avg(3, :)']);
len3M=eval(['results.' condB '.avg(3, :)']);
len3_SE=eval(['results.' cond '.se(3, :)']);
len3AE_SE=eval(['results.' condAE '.se(3, :)']);
len3S_SE=eval(['results.' condBS '.se(3, :)']);
len3F_SE=eval(['results.' condBF '.se(3, :)']);
len3E_SE=eval(['results.' condE '.se(3, :)']);
len3M_SE=eval(['results.' condB '.se(3, :)']);
Alpha3 =[ len3(1); len3(3)];Alpha3_SE =[ len3_SE(1); len3_SE(3)];
X3=[ len3(4); len3(2)];X3_SE=[ len3_SE(4); len3_SE(2)];
Alpha3AE =[ len3AE(1); len3AE(3)];Alpha3AE_SE =[ len3AE_SE(1); len3AE_SE(3)];
X3AE=[ len3AE(4); len3AE(2)];X3AE_SE=[ len3AE_SE(4); len3AE_SE(2)];
Alpha3S =[ len3S(1); len3S(2)];Alpha3S_SE =[ len3S_SE(1); len3S_SE(2)];
X3S=[len3S(4); len3S(3) ];X3S_SE=[len3S_SE(4); len3S_SE(3) ];
Alpha3F =[ len3F(1); len3F(2)];Alpha3F_SE =[ len3F_SE(1); len3F_SE(2)];
X3F=[len3F(4); len3F(3) ];X3F_SE=[len3F_SE(4); len3F_SE(3) ];
AlphaSpdSPec3=[ len3S(1); len3F(3)];AlphaSpdSPec3_SE=[ len3S_SE(1); len3F_SE(3)];
X3SpdSPec=[len3S(4); len3F(2) ];X3SpdSPec_SE=[len3S_SE(4); len3F_SE(2) ];
Alpha3E =[ len3E(1); len3E(2)];Alpha3E_SE =[ len3E_SE(1); len3E_SE(2)];
X3E=[len3E(4); len3E(3) ];X3E_SE=[len3E_SE(4); len3E_SE(3) ];
Alpha3SlowBase=[ len3S(1); len3S(3)];Alpha3SlowBase_SE=[ len3S_SE(1); len3S_SE(3)];
X3SlowBase=[len3S(4); len3S(2) ];X3SlowBase_SE=[len3S_SE(4); len3S_SE(2) ];
Alpha3FastBase=[ len3F(1); len3F(3)];Alpha3FastBase_SE=[ len3F_SE(1); len3F_SE(3)];
X3FastBase=[len3F(4); len3F(2) ];X3FastBase_SE=[len3F_SE(4); len3F_SE(2) ];
Alpha3MBase=[ len3M(1); len3M(3)];Alpha3MBase_SE=[ len3M_SE(1); len3M_SE(3)];
X3MBase=[len3M(4); len3M(2) ];X3MBase_SE=[len3M_SE(4); len3M_SE(2) ];
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%% Most recent version 4, row, r columns
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure
ax4=subplot(4, 4, 1);
a4=barh(x,X1SlowBase,w2,'FaceColor','r', 'FaceAlpha', .2,  'EdgeColor', 'r', 'LineWidth', 2); hold on; herrorbar(X1SlowBase,x, -1.*X1SlowBase_SE, X1SlowBase_SE, '.k')
barh(x,Alpha1SlowBase,w2,'FaceColor','b', 'FaceAlpha', .2,  'EdgeColor', 'b', 'LineWidth', 2);herrorbar( Alpha1SlowBase,x, -1.*Alpha1SlowBase_SE, Alpha1SlowBase_SE, '.k')
a4(1).BaseLine.LineStyle = ':';a4(1).BaseLine.Color = 'k';a4(1).BaseLine.LineWidth = 2;
line([len1S(3),len1S(1)],[1.55,1.55], 'Color','blue', 'LineWidth', 2) 
line([len1S(4),len1S(2)],[1.45,1.45],'Color','red', 'LineWidth', 2) 
title([groups{1} ': ' condBS])
set(gca,'yticklabel',{ 'Fast Leg', 'Slow Leg'})
xlabel(ylabelTEXT)
axis square
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ax5=subplot(4, 4, 2);
a5=barh(x,X2SlowBase,w2,'FaceColor','r', 'FaceAlpha', .2,  'EdgeColor', 'r', 'LineWidth', 2); hold on; herrorbar( X2SlowBase,x, -1.*X2SlowBase_SE,X2SlowBase_SE, '.k')
barh(x,Alpha2SlowBase,w2,'FaceColor','b', 'FaceAlpha', .2,  'EdgeColor', 'b', 'LineWidth', 2);herrorbar( Alpha2SlowBase,x, -1.*Alpha2SlowBase_SE, Alpha2SlowBase_SE, '.k')
a5(1).BaseLine.LineStyle = ':';a5(1).BaseLine.Color = 'k';a5(1).BaseLine.LineWidth = 2;
line([len2S(3),len2S(1)],[1.55,1.55], 'Color','blue', 'LineWidth', 2) 
line([len2S(4),len2S(2)],[1.45,1.45],'Color','red', 'LineWidth', 2) 
title([groups{2} ': ' condBS])
set(gca,'yticklabel',{ 'Fast Leg', 'Slow Leg'})
xlabel(ylabelTEXT)
a5(1).BaseLine.LineStyle = ':';
a5(1).BaseLine.Color = 'k';
a5(1).BaseLine.LineWidth = 2;
axis square
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ax6=subplot(4, 4, 3);
a6=barh(x,X3SlowBase,w2,'FaceColor','r', 'FaceAlpha', .2,  'EdgeColor', 'r', 'LineWidth', 2); hold on; herrorbar(X3SlowBase,x, -1.*X3SlowBase_SE, X3SlowBase_SE, '.k')
barh(x,Alpha3SlowBase,w2,'FaceColor','b', 'FaceAlpha', .2,  'EdgeColor', 'b', 'LineWidth', 2);herrorbar(Alpha3SlowBase,x,  -1.*Alpha3SlowBase_SE,Alpha3SlowBase_SE, '.k')
a6(1).BaseLine.LineStyle = ':';a6(1).BaseLine.Color = 'k';a6(1).BaseLine.LineWidth = 2;
line([len3S(3),len3S(1)],[1.55,1.55], 'Color','blue', 'LineWidth', 2) 
line([len3S(4),len3S(2)],[1.45,1.45],'Color','red', 'LineWidth', 2) 
title([groups{3} ': ' condBS])
set(gca,'yticklabel',{ 'Fast Leg', 'Slow Leg'})
 xlabel(ylabelTEXT)
 a6(1).BaseLine.LineStyle = ':';
a6(1).BaseLine.Color = 'k';
a6(1).BaseLine.LineWidth = 2;
axis square
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ax7=subplot(4, 4, 9);
a7=barh(x,X1FastBase,w2,'FaceColor','r', 'FaceAlpha', .2,  'EdgeColor', 'r', 'LineWidth', 2); hold on; herrorbar(X1FastBase,x,  -1.*X1FastBase_SE,X1FastBase_SE, '.k')
barh(x,Alpha1FastBase,w2,'FaceColor','b', 'FaceAlpha', .2,  'EdgeColor', 'b', 'LineWidth', 2);herrorbar(Alpha1FastBase,x, -1.*Alpha1FastBase_SE, Alpha1FastBase_SE, '.k')
a7(1).BaseLine.LineStyle = ':';a7(1).BaseLine.Color = 'k';a7(1).BaseLine.LineWidth = 2;
line([len1F(3),len1F(1)],[1.55,1.55], 'Color','blue', 'LineWidth', 2) 
line([len1F(4),len1F(2)],[1.45,1.45],'Color','red', 'LineWidth', 2) 
title([groups{1} ': ' condBF])
set(gca,'yticklabel',{ 'Fast Leg', 'Slow Leg'})
xlabel(ylabelTEXT)
a7(1).BaseLine.LineStyle = ':';
a7(1).BaseLine.Color = 'k';
a7(1).BaseLine.LineWidth = 2;
axis square
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ax8=subplot(4, 4, 10);
a8=barh(x,X2FastBase,w2,'FaceColor','r', 'FaceAlpha', .2,  'EdgeColor', 'r', 'LineWidth', 2); hold on; herrorbar( X2FastBase,x, -1.*X2FastBase_SE, X2FastBase_SE, '.k')
barh(x,Alpha2FastBase,w2,'FaceColor','b', 'FaceAlpha', .2,  'EdgeColor', 'b', 'LineWidth', 2);herrorbar(Alpha2FastBase,x,  -1.*Alpha2FastBase_SE, Alpha2FastBase_SE, '.k')
a8(1).BaseLine.LineStyle = ':';a8(1).BaseLine.Color = 'k';a8(1).BaseLine.LineWidth = 2;
line([len2F(3),len2F(1)],[1.55,1.55], 'Color','blue', 'LineWidth', 2) 
line([len2F(4),len2F(2)],[1.45,1.45],'Color','red', 'LineWidth', 2) 
title([groups{2} ': ' condBF])
set(gca,'yticklabel',{ 'Fast Leg', 'Slow Leg'})
xlabel(ylabelTEXT)
a8(1).BaseLine.LineStyle = ':';
a8(1).BaseLine.Color = 'k';
a8(1).BaseLine.LineWidth = 2;
axis square
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ax9=subplot(4, 4, 11);
a9=barh(x,X3FastBase,w2,'FaceColor','r', 'FaceAlpha', .2,  'EdgeColor', 'r', 'LineWidth', 2); hold on; herrorbar( X3FastBase,x, -1.*X3FastBase_SE,X3FastBase_SE, '.k')
barh(x,Alpha3FastBase,w2,'FaceColor', 'b', 'FaceAlpha', .2,  'EdgeColor', 'b', 'LineWidth', 2);herrorbar( Alpha3FastBase,x, -1.*Alpha3FastBase_SE, Alpha3FastBase_SE, '.k')
a9(1).BaseLine.LineStyle = ':';a9(1).BaseLine.Color = 'k';a9(1).BaseLine.LineWidth = 2;
line([len3F(3),len3F(1)],[1.55,1.55], 'Color','blue', 'LineWidth', 2) 
line([len3F(4),len3F(2)],[1.45,1.45],'Color','red', 'LineWidth', 2) 
title([groups{3} ': ' condBF])
set(gca,'yticklabel',{ 'Fast Leg', 'Slow Leg'})
 xlabel(ylabelTEXT)
 a9(1).BaseLine.LineStyle = ':';
a9(1).BaseLine.Color = 'k';
a9(1).BaseLine.LineWidth = 2;
axis square
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Adaptation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ax1=subplot(4, 4, 5);
a1=barh(x,Alpha1,w1,'FaceColor','b', 'LineWidth', 2);
hold on
herrorbar( Alpha1,x,  -1.*Alpha1_SE, Alpha1_SE, '.k');
barh(x,X1,w1,'FaceColor','r', 'LineWidth', 2);herrorbar( X1,x, -1.*X1_SE,X1_SE, '.k')
%Show speed specific baseline
line([X1SlowBase(1) X1SlowBase(1)], [1.75 2.5],'Color','black','LineStyle','--'); plot(X1SlowBase(1), 2.5, 's', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'b', 'MarkerSize', 5) 
line([Alpha1SlowBase(1) Alpha1SlowBase(1)], [1.75 2.5],'Color','black','LineStyle','--'); plot(Alpha1SlowBase(1), 2.5, 's', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'b', 'MarkerSize', 5)
line([X1FastBase(2) X1FastBase(2)], [0.5 1.25],'Color','black','LineStyle','--'); plot(X1FastBase(2), .5, 's', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'r', 'MarkerSize', 5)
line([Alpha1FastBase(2) Alpha1FastBase(2)], [0.5 1.25],'Color','black','LineStyle','--'); plot(Alpha1FastBase(2), .5, 's', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'r', 'MarkerSize', 5)
a1(1).BaseLine.LineStyle = ':';
a1(1).BaseLine.Color = 'k';
a1(1).BaseLine.LineWidth = 2;
line([len1(3),len1(1)],[1.55,1.55], 'Color','blue', 'LineWidth', 2) 
line([len1(4),len1(2)],[1.45,1.45],'Color','red', 'LineWidth', 2) 
title([groups{1} ': ' cond])
set(gca,'yticklabel',{ 'Fast Leg', 'Slow Leg'})
xlabel(ylabelTEXT)
axis square
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ax2=subplot(4, 4, 6);
a1=barh(x,Alpha2,w1,'FaceColor','b', 'LineWidth', 2);
hold on
herrorbar( Alpha2,x, -1.*Alpha2_SE, Alpha2_SE, '.k');
barh(x,X2,w1,'FaceColor','r', 'LineWidth', 2);herrorbar( X2,x, -1.*X2_SE, X2_SE, '.k');
%Show speed specific baseline
line([X2SlowBase(1) X2SlowBase(1)], [1.75 2.5],'Color','black','LineStyle','--');plot(X2SlowBase(1), 2.5, 's', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'b', 'MarkerSize', 5);
line([Alpha2SlowBase(1) Alpha2SlowBase(1)], [1.75 2.5],'Color','black','LineStyle','--');plot(Alpha2SlowBase(1), 2.5, 's', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'b', 'MarkerSize', 5);
line([X2FastBase(2) X2FastBase(2)], [0.5 1.25],'Color','black','LineStyle','--');plot(X2FastBase(2), .5, 's', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'r', 'MarkerSize', 5);
line([Alpha2FastBase(2) Alpha2FastBase(2)], [0.5 1.25],'Color','black','LineStyle','--');plot(Alpha2FastBase(2), .5, 's', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'r', 'MarkerSize', 5);
%
a1(1).BaseLine.LineStyle = ':';
a1(1).BaseLine.Color = 'k';
a1(1).BaseLine.LineWidth = 2;
line([len2(3),len2(1)],[1.55,1.55], 'Color','blue', 'LineWidth', 2) 
line([len2(4),len2(2)],[1.45,1.45],'Color','red', 'LineWidth', 2) 
title([groups{2} ': ' cond])
set(gca,'yticklabel',{ 'Fast Leg', 'Slow Leg'})
xlabel(ylabelTEXT)
axis square
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ax3=subplot(4, 4, 7);
a1=barh(x,Alpha3,w1,'FaceColor','b', 'LineWidth', 2);
hold on
herrorbar( Alpha3,x, -1.*Alpha3_SE, Alpha3_SE, '.k');
a3f=barh(x,X3,w1,'FaceColor','r', 'LineWidth', 2);herrorbar( X3,x, -1.*X3_SE,X3_SE, '.k');
%Show speed specific baseline
bbb=line([X3SlowBase(1) X3SlowBase(1)], [1.75 2.5],'Color','black','LineStyle','--'); plot(X3SlowBase(1), 2.5, 's', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'b', 'MarkerSize', 5);
line([Alpha3SlowBase(1) Alpha3SlowBase(1)], [1.75 2.5],'Color','black','LineStyle','--');plot(Alpha3SlowBase(1), 2.5, 's', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'b', 'MarkerSize', 5);
line([X3FastBase(2) X3FastBase(2)], [0.5 1.25],'Color','black','LineStyle','--');plot(X3FastBase, .5, 's', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'r', 'MarkerSize', 5);
line([Alpha3FastBase(2) Alpha3FastBase(2)], [0.5 1.25],'Color','black','LineStyle','--');plot(Alpha3FastBase(2), .5, 's', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'r', 'MarkerSize', 5);
%
a1(1).BaseLine.LineStyle = ':';
a1(1).BaseLine.Color = 'k';
a1(1).BaseLine.LineWidth = 2;
line([len3(3),len3(1)],[1.55,1.55], 'Color','blue', 'LineWidth', 2) 
line([len3(4),len3(2)],[1.45,1.45],'Color','red', 'LineWidth', 2) 
title([groups{3} ': ' cond])
set(gca,'yticklabel',{ 'Fast Leg', 'Slow Leg'})
xlabel(ylabelTEXT)
axis square

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ax10=subplot(4, 4, 13);
a10=barh(x,X1AE,ww,'FaceColor','r', 'FaceAlpha', .2,  'EdgeColor', 'r', 'LineWidth', 2);hold on; herrorbar(X1AE,x, -1.*X1AE_SE, X1AE_SE, '.k')
barh(x,Alpha1AE,ww,'FaceColor','b', 'FaceAlpha', .2,  'EdgeColor', 'b', 'LineWidth', 2);herrorbar( Alpha1AE,x, -1.*Alpha1AE_SE, Alpha1AE_SE, '.k')
%Show speed specific baseline
line([X1MBase(1) X1MBase(1)], [1.75 2.5],'Color','black','LineStyle','--'); plot(X1MBase(1), 2.5, 's', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'k', 'MarkerSize', 5);
line([Alpha1MBase(1) Alpha1MBase(1)], [1.75 2.5],'Color','black','LineStyle','--'); plot(Alpha1MBase(1), 2.5, 's', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'k', 'MarkerSize', 5);
line([X1MBase(2) X1MBase(2)], [0.5 1.25],'Color','black','LineStyle','--'); plot(X1MBase(2), .5, 's', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'k', 'MarkerSize', 5);
line([Alpha1MBase(2) Alpha1MBase(2)], [0.5 1.25],'Color','black','LineStyle','--'); plot(Alpha1MBase(2), .5, 's', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'k', 'MarkerSize', 5);
% SS
line([X1(1) X1(1)], [0.5 1.25],'Color','blue','LineStyle',':', 'LineWidth', 3);
line([Alpha1(1) Alpha1(1)], [1.75 2.5],'Color','blue','LineStyle',':', 'LineWidth', 3);
line([X1(2) X1(2)], [0.5 1.25],'Color','red','LineStyle',':', 'LineWidth', 3);
line([Alpha1(2) Alpha1(2)], [1.75 2.5],'Color','red','LineStyle',':', 'LineWidth', 3);

a10(1).BaseLine.LineStyle = ':';
a10(1).BaseLine.Color = 'k';
a10(1).BaseLine.LineWidth = 2;
line([len1AE(3),len1AE(1)],[1.55,1.55], 'Color','blue', 'LineWidth', 2) 
line([len1AE(4),len1AE(2)],[1.45,1.45],'Color','red', 'LineWidth', 2) 
title([groups{1} ': ' condAE])
set(gca,'yticklabel',{ 'Fast Leg', 'Slow Leg'})
xlabel(ylabelTEXT)
axis square
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ax11=subplot(4, 4, 14);
a11=barh(x,X2AE,ww,'FaceColor','r', 'FaceAlpha', .2, 'EdgeColor', 'r', 'LineWidth', 2);hold on; herrorbar(X2AE,x, -1.*X2AE_SE, X2AE_SE, '.k')
barh(x,Alpha2AE,ww,'FaceColor','b', 'FaceAlpha', .2, 'EdgeColor', 'b', 'LineWidth', 2);herrorbar( Alpha2AE,x, -1.*Alpha2AE_SE, Alpha2AE_SE, '.k')
%Show speed specific baseline
line([X2MBase(1) X2MBase(1)], [1.75 2.5],'Color','black','LineStyle','--');plot(X2MBase(1), 2.5, 's', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'k', 'MarkerSize', 5);
line([Alpha2MBase(1) Alpha2MBase(1)], [1.75 2.5],'Color','black','LineStyle','--');plot(Alpha2MBase(1), 2.5, 's', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'k', 'MarkerSize', 5);
line([X2MBase(2) X2MBase(2)], [0.5 1.25],'Color','black','LineStyle','--');plot(X2MBase(2), .5, 's', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'k', 'MarkerSize', 5);
line([Alpha2MBase(2) Alpha2MBase(2)], [0.5 1.25],'Color','black','LineStyle','--');plot(Alpha2MBase(2), .5, 's', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'k', 'MarkerSize', 5);
% SS
line([X2(1) X2(1)], [0.5 1.25],'Color','blue','LineStyle',':', 'LineWidth', 3);
line([Alpha2(1) Alpha2(1)], [1.75 2.5],'Color','blue','LineStyle',':', 'LineWidth', 3);
line([X2(2) X2(2)], [0.5 1.25],'Color','red','LineStyle',':', 'LineWidth', 3);
line([Alpha2(2) Alpha2(2)], [1.75 2.5],'Color','red','LineStyle',':', 'LineWidth', 3);

a11(1).BaseLine.LineStyle = ':';
a11(1).BaseLine.Color = 'k';
a11(1).BaseLine.LineWidth = 2;
line([len2AE(3),len2AE(1)],[1.55,1.55], 'Color','blue', 'LineWidth', 2) 
line([len2AE(4),len2AE(2)],[1.45,1.45],'Color','red', 'LineWidth', 2) 
title([groups{2} ': ' condAE])
set(gca,'yticklabel',{ 'Fast Leg', 'Slow Leg'})
xlabel(ylabelTEXT)
axis square
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ax12=subplot(4, 4, 15);
ae3s=barh(x,X3AE,ww,'FaceColor','r', 'FaceAlpha', .2, 'EdgeColor', 'r', 'LineWidth', 2); hold on; herrorbar(X3AE,x, -1.*X3AE_SE, X3AE_SE, '.k')
ae3f=barh(x,Alpha3AE,ww,'FaceColor','b', 'FaceAlpha', .2, 'EdgeColor', 'b', 'LineWidth', 2);herrorbar( Alpha3AE,x, -1.*Alpha3AE_SE, Alpha3AE_SE, '.k')
%Show speed specific baseline
bbb=line([X3MBase(1) X3MBase(1)], [1.75 2.5],'Color','black','LineStyle','--');plot(X3MBase(1), 2.5, 's', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'k', 'MarkerSize', 5);
line([Alpha3MBase(1) Alpha3MBase(1)], [1.75 2.5],'Color','black','LineStyle','--');plot(Alpha3MBase(1), 2.5, 's', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'k', 'MarkerSize', 5);
line([X3MBase(2) X3MBase(2)], [0.5 1.25],'Color','black','LineStyle','--');plot(X3MBase(2), .5, 's', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'k', 'MarkerSize', 5);
line([Alpha3MBase(2) Alpha3MBase(2)], [0.5 1.25],'Color','black','LineStyle','--');plot(Alpha3MBase(2), .5, 's', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'k', 'MarkerSize', 5);

% SS
ssSl=line([X3(1) X3(1)], [0.5 1.25],'Color','blue','LineStyle',':', 'LineWidth', 3);
line([Alpha3(1) Alpha3(1)], [1.75 2.5],'Color','blue','LineStyle',':', 'LineWidth', 3);
line([X3(2) X3(2)], [0.5 1.25],'Color','red','LineStyle',':', 'LineWidth', 3);
line([Alpha3(2) Alpha3(2)], [1.75 2.5],'Color','red','LineStyle',':', 'LineWidth', 3);

ae3s(1).BaseLine.LineStyle = ':';
ae3s(1).BaseLine.Color = 'k';
ae3s(1).BaseLine.LineWidth = 2;
line([len3AE(3),len3AE(1)],[1.55,1.55], 'Color','blue', 'LineWidth', 2) 
line([len3AE(4),len3AE(2)],[1.45,1.45],'Color','red', 'LineWidth', 2) 
title([groups{3} ': ' condAE])
set(gca,'yticklabel',{ 'Fast Leg', 'Slow Leg'})
xlabel(ylabelTEXT)
axis square
%ylim(ax12,ax1.YLim)


% % Just to make the legend pretty
% ax20=subplot(2, 4, 8);
% a1(1).BaseLine.LineStyle = ':';hold on
% a1(1).BaseLine.Color = 'k';
% a1(1).BaseLine.LineWidth = 2;
% a3f=barh(x,X3,w1,'FaceColor','r', 'LineWidth', 2);herrorbar( X3,x, -1.*X3_SE,X3_SE, '.k');hold on
% ae3s=barh(x,X3AE,ww,'FaceColor','r', 'FaceAlpha', .2, 'EdgeColor', 'r', 'LineWidth', 2); hold on; 
% ae3f=barh(x,Alpha3AE,ww,'FaceColor','b', 'FaceAlpha', .2, 'EdgeColor', 'b', 'LineWidth', 2);
% ssSl=line([X3(1) X3(1)], [1.75 2.5],'Color','black','LineStyle',':');
% MBL_4L=plot([100 101], [0 0], 's--', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'k', 'MarkerSize', 5);
% FBL_4L=plot([100 101], [0 0], 's--', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'r', 'MarkerSize', 5);
% SBL_4L=plot([100 101], [0 0], 's--', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'b', 'MarkerSize', 5);
% legend([a1 a3f ae3s ae3f ssSl MBL_4L FBL_4L SBL_4L], {'Split SS Slow SL', 'Split SS Fast SL', 'Tied Slow SL', 'Tied Fast SL', 'SS SL', 'Medium Baseline', 'Fast Baseline', 'Slow Baseline'})

A=min([ax1.XLim ax2.XLim ax3.XLim]);
B=max([ax1.XLim ax2.XLim ax3.XLim]);
xlim(ax1,[A B])
xlim(ax2,[A B])
xlim(ax3,[A B])
xlim(ax4,[A B])
xlim(ax5,[A B])
xlim(ax6,[A B])
xlim(ax7,[A B])
xlim(ax8,[A B])
xlim(ax9,[A B])
xlim(ax10,[A B])
xlim(ax11,[A B])
xlim(ax12,[A B])

set(gcf,'renderer','painters')
return
%% Additional Analysis Not Included in the Paper
% figure
 bob=gcf;
% % % %  CorrelationsSingle_AllTogether(StudyData, RF,{'TMafter'},{'FyPSmax','FyPFmax'}, RF,{'TMafter'},{'XSlow', 'XFast'}, groups, [], 2, 3, 1, bob.Number)
% % % %   CorrelationsSingle_AllTogether(StudyData, RF,{'TMSteady'},{'FyBSmax','FyBFmax'}, RF,{'TMafter'},{'alphaSlow', 'alphaFast'}, groups, [], 2, 3, 2, bob.Number)
% % % %   CorrelationsSingle_AllTogether(StudyData, RF,{'TMSteady'},{'FyBSmax','FyBFmax'}, RF,{'TMafter'},{'alphaFast', 'alphaSlow'}, groups, [], 2, 3, 5, bob.Number)
% % % %   CorrelationsSingle_AllTogether(StudyData, RF,{'TMafter'},{'FyBSmax','FyBFmax'}, RF,{'TMafter'},{'alphaSlow', 'alphaFast'}, groups, [], 2, 3, 3, bob.Number)
% % % %     CorrelationsSingle_AllTogether(StudyData, RF,{'TMafter'},{'FyBSmax','FyBFmax'}, RF,{'TMafter'},{'alphaFast', 'alphaSlow'}, groups, [], 2, 3,6, bob.Number)
% % % %return


% grp=[resultsSL.DelFAdapt.indiv.stepLengthFast(:,1); resultsSL.TMafter.indiv.stepLengthFast(:,1);...
%     resultsSL.DelFAdapt.indiv.stepLengthSlow(:,1); resultsSL.TMafter.indiv.stepLengthSlow(:,1)];
% leg=[2.*ones(24*2, 1); 1.*ones(24*2, 1)];
% epoch=[1.*ones(24, 1); 2.*ones(24, 1);1.*ones(24, 1); 2.*ones(24, 1)];
% data=[resultsSL.DelFAdapt.indiv.stepLengthFast(:,2); resultsSL.TMafter.indiv.stepLengthFast(:,2);...
%     resultsSL.DelFAdapt.indiv.stepLengthSlow(:,2); resultsSL.TMafter.indiv.stepLengthSlow(:,2)];
% p=anovan(data, {grp, leg, epoch}, 'model', 'interaction', 'varnames', {'slope', 'leg', 'epoch'});
% gcf
% 
% poster_colors;
% colorOrder=[p_red; p_orange; p_fade_green; p_fade_blue; p_plum; p_green; p_blue; p_fade_red; p_lime; p_yellow; [0 0 0]];
% 
% ax7=subplot(2, 4, 8);
% de=line([.9, 1.9], [resultsSL.DelFAdapt.avg(1, 1) resultsSL.TMafter.avg(1, 1)], 'Color',colorOrder(1, :), 'LineWidth', 2) ; hold on
% sleg=errorbar(.9, resultsSL.DelFAdapt.avg(1, 1), -1.*resultsSL.DelFAdapt.se(1, 1), resultsSL.DelFAdapt.se(1, 1), 'ok', 'MarkerFaceColor', 'w')
% errorbar(1.9, resultsSL.TMafter.avg(1, 1), -1.*resultsSL.TMafter.se(1, 1), resultsSL.TMafter.se(1, 1), 'ok', 'MarkerFaceColor', 'w')
% 
% fl=line([1, 2],[resultsSL.DelFAdapt.avg(2, 1) resultsSL.TMafter.avg(2, 1)], 'Color',colorOrder(2, :), 'LineWidth', 2) ; hold on
% errorbar(1, resultsSL.DelFAdapt.avg(2, 1), -1.*resultsSL.DelFAdapt.se(2, 1), resultsSL.DelFAdapt.se(2, 1), 'ok', 'MarkerFaceColor', 'w')
% errorbar(2, resultsSL.TMafter.avg(2, 1), -1.*resultsSL.TMafter.se(2, 1), resultsSL.TMafter.se(2, 1), 'ok', 'MarkerFaceColor', 'w')
% 
% in=line([1.1, 2.1],[resultsSL.DelFAdapt.avg(3, 1) resultsSL.TMafter.avg(3, 1)], 'Color',colorOrder(3, :), 'LineWidth', 2) ; hold on
% errorbar(1.1, resultsSL.DelFAdapt.avg(3, 1), -1.*resultsSL.DelFAdapt.se(3, 1), resultsSL.DelFAdapt.se(3, 1), 'ok', 'MarkerFaceColor', 'w')
% errorbar(2.1, resultsSL.TMafter.avg(3, 1), -1.*resultsSL.TMafter.se(3, 1), resultsSL.TMafter.se(3, 1), 'ok', 'MarkerFaceColor', 'w')
% 
% line([.9, 1.9], [resultsSL.DelFAdapt.avg(1, 2) resultsSL.TMafter.avg(1, 2)], 'Color',colorOrder(1, :), 'LineWidth', 2) ; hold on
% fleg=errorbar(.9, resultsSL.DelFAdapt.avg(1, 2), -1.*resultsSL.DelFAdapt.se(1, 2), resultsSL.DelFAdapt.se(1, 2), 'ok', 'MarkerFaceColor', 'k');
% errorbar(1.9, resultsSL.TMafter.avg(1, 2), -1.*resultsSL.TMafter.se(1, 2), resultsSL.TMafter.se(1, 2), 'ok', 'MarkerFaceColor', 'k')
% 
% line([1, 2],[resultsSL.DelFAdapt.avg(2, 2) resultsSL.TMafter.avg(2, 2)], 'Color',colorOrder(2, :), 'LineWidth', 2) ; hold on
% errorbar(1, resultsSL.DelFAdapt.avg(2, 2), -1.*resultsSL.DelFAdapt.se(2, 2), resultsSL.DelFAdapt.se(2, 2), 'ok', 'MarkerFaceColor', 'k')
% errorbar(2, resultsSL.TMafter.avg(2, 2), -1.*resultsSL.TMafter.se(2, 2), resultsSL.TMafter.se(2, 2), 'ok', 'MarkerFaceColor', 'k')
% 
% line([1.1, 2.1],[resultsSL.DelFAdapt.avg(3, 2) resultsSL.TMafter.avg(3, 2)], 'Color',colorOrder(3, :), 'LineWidth', 2) ; hold on
% errorbar(1.1, resultsSL.DelFAdapt.avg(3, 2), -1.*resultsSL.DelFAdapt.se(3, 2), resultsSL.DelFAdapt.se(3, 2), 'ok', 'MarkerFaceColor', 'k')
% errorbar(2.1, resultsSL.TMafter.avg(3, 2), -1.*resultsSL.TMafter.se(3, 2), resultsSL.TMafter.se(3, 2), 'ok', 'MarkerFaceColor', 'k')
%  line([.8 2.2], [0 0], 'Color', 'k', 'LineStyle',':')
%  line([1.5 1.5],[-100 400],  'Color', 'k', 'LineStyle',':')
% ax7.XTick=[1, 2]; ax7.XTickLabel={'Del A', 'TMafter'};
% ylabel('SL Change')
% legend([fleg sleg de fl in], {'Fast Leg', 'Slow Leg', 'Decline', 'Flat', 'Incline'})
% axis square
set(gcf,'renderer','painters')
%return

grp=[resultsSL.DelFAdapt.indiv.stepLengthFast(:,1); resultsSL.DelFDeAdapt.indiv.stepLengthFast(:,1);...
    resultsSL.DelFAdapt.indiv.stepLengthSlow(:,1); resultsSL.DelFDeAdapt.indiv.stepLengthSlow(:,1)];
leg=[2.*ones(24*2, 1); 1.*ones(24*2, 1)];
epoch=[1.*ones(24, 1); 2.*ones(24, 1);1.*ones(24, 1); 2.*ones(24, 1)];
data=[resultsSL.DelFAdapt.indiv.stepLengthFast(:,2); resultsSL.DelFDeAdapt.indiv.stepLengthFast(:,2);...
    resultsSL.DelFAdapt.indiv.stepLengthSlow(:,2); resultsSL.DelFDeAdapt.indiv.stepLengthSlow(:,2)];
p=anovan(data, {grp, leg, epoch}, 'model', 'interaction', 'varnames', {'slope', 'leg', 'epoch'});
gcf

ax7=subplot(2, 4, 8);
poster_colors;
colorOrder=[p_red; p_orange; p_fade_green; p_fade_blue; p_plum; p_green; p_blue; p_fade_red; p_lime; p_yellow; [0 0 0]];
de=line([.9, 1.9], [resultsSL.DelFAdapt.avg(1, 1) resultsSL.DelFDeAdapt.avg(1, 1)], 'Color',colorOrder(1, :), 'LineWidth', 2) ; hold on
sleg=errorbar(.9, resultsSL.DelFAdapt.avg(1, 1), -1.*resultsSL.DelFAdapt.se(1, 1), resultsSL.DelFAdapt.se(1, 1), 'ok', 'MarkerFaceColor', 'w')
errorbar(1.9, resultsSL.DelFDeAdapt.avg(1, 1), -1.*resultsSL.DelFDeAdapt.se(1, 1), resultsSL.DelFDeAdapt.se(1, 1), 'ok', 'MarkerFaceColor', 'w')

fl=line([1, 2],[resultsSL.DelFAdapt.avg(2, 1) resultsSL.DelFDeAdapt.avg(2, 1)], 'Color',colorOrder(2, :), 'LineWidth', 2) ; hold on
errorbar(1, resultsSL.DelFAdapt.avg(2, 1), -1.*resultsSL.DelFAdapt.se(2, 1), resultsSL.DelFAdapt.se(2, 1), 'ok', 'MarkerFaceColor', 'w')
errorbar(2, resultsSL.DelFDeAdapt.avg(2, 1), -1.*resultsSL.DelFDeAdapt.se(2, 1), resultsSL.DelFDeAdapt.se(2, 1), 'ok', 'MarkerFaceColor', 'w')

in=line([1.1, 2.1],[resultsSL.DelFAdapt.avg(3, 1) resultsSL.DelFDeAdapt.avg(3, 1)], 'Color',colorOrder(3, :), 'LineWidth', 2) ; hold on
errorbar(1.1, resultsSL.DelFAdapt.avg(3, 1), -1.*resultsSL.DelFAdapt.se(3, 1), resultsSL.DelFAdapt.se(3, 1), 'ok', 'MarkerFaceColor', 'w')
errorbar(2.1, resultsSL.DelFDeAdapt.avg(3, 1), -1.*resultsSL.DelFDeAdapt.se(3, 1), resultsSL.DelFDeAdapt.se(3, 1), 'ok', 'MarkerFaceColor', 'w')

line([.9, 1.9], [resultsSL.DelFAdapt.avg(1, 2) resultsSL.DelFDeAdapt.avg(1, 2)], 'Color',colorOrder(1, :), 'LineWidth', 2) ; hold on
fleg=errorbar(.9, resultsSL.DelFAdapt.avg(1, 2), -1.*resultsSL.DelFAdapt.se(1, 2), resultsSL.DelFAdapt.se(1, 2), 'ok', 'MarkerFaceColor', 'k');
errorbar(1.9, resultsSL.DelFDeAdapt.avg(1, 2), -1.*resultsSL.DelFDeAdapt.se(1, 2), resultsSL.DelFDeAdapt.se(1, 2), 'ok', 'MarkerFaceColor', 'k')

line([1, 2],[resultsSL.DelFAdapt.avg(2, 2) resultsSL.DelFDeAdapt.avg(2, 2)], 'Color',colorOrder(2, :), 'LineWidth', 2) ; hold on
errorbar(1, resultsSL.DelFAdapt.avg(2, 2), -1.*resultsSL.DelFAdapt.se(2, 2), resultsSL.DelFAdapt.se(2, 2), 'ok', 'MarkerFaceColor', 'k')
errorbar(2, resultsSL.DelFDeAdapt.avg(2, 2), -1.*resultsSL.DelFDeAdapt.se(2, 2), resultsSL.DelFDeAdapt.se(2, 2), 'ok', 'MarkerFaceColor', 'k')

line([1.1, 2.1],[resultsSL.DelFAdapt.avg(3, 2) resultsSL.DelFDeAdapt.avg(3, 2)], 'Color',colorOrder(3, :), 'LineWidth', 2) ; hold on
errorbar(1.1, resultsSL.DelFAdapt.avg(3, 2), -1.*resultsSL.DelFAdapt.se(3, 2), resultsSL.DelFAdapt.se(3, 2), 'ok', 'MarkerFaceColor', 'k')
errorbar(2.1, resultsSL.DelFDeAdapt.avg(3, 2), -1.*resultsSL.DelFDeAdapt.se(3, 2), resultsSL.DelFDeAdapt.se(3, 2), 'ok', 'MarkerFaceColor', 'k')
 line([.8 2.2], [0 0], 'Color', 'k', 'LineStyle',':')
 line([1.5 1.5],[-100 400],  'Color', 'k', 'LineStyle',':')
ax7.XTick=[1, 2]; ax7.XTickLabel={'Del A', 'Del PA'};
ylabel('SL Change')
legend([fleg sleg de fl in], {'Fast Leg', 'Slow Leg', 'Decline', 'Flat', 'Incline'})
axis square

set(gcf,'renderer','painters')
%return
% return
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure
 bob=gcf;
 CorrelationsSingle_AllTogether(StudyData, RF,{'TMafter'},{'FyPSmax','FyPFmax'}, RF,{'TMafter'},{'XSlow', 'XFast'}, groups, [], 2, 3, 1, bob.Number)
 CrissCrossSingle(StudyData,RccX,groups,{'XSlow', 'XFast'},colorOrder(:, :), 2, 3, 4, bob.Number)
 
CorrelationsSingle_AllTogether(StudyData, RF,{'TMafter'},{'FyBSmax','FyBFmax'}, RF,{'TMafter'},{ 'alphaFast', 'alphaSlow'}, groups, [], 2, 3, 2, bob.Number)
CrissCrossSingle(StudyData,resultsSL,groups,{'stepLengthSlow', 'stepLengthFast'},colorOrder(:, :), 2, 3, 5, bob.Number)

CorrelationsSingle_AllTogether(StudyData, RF,{'TMafter'},{'FyBSmax','FyBFmax'}, RF,{'TMafter'},{'alphaSlow', 'alphaFast'}, groups, [], 2, 3, 3, bob.Number)
CrissCrossSingle(StudyData,RccA,groups,{'alphaSlow', 'alphaFast'},colorOrder(:, :), 2, 3, 6, bob.Number)

% %  CrissCrossSingle(StudyData,RccX,groups,{'XSlow', 'XFast'},{'TMafter'}, 2, 3, 4, bob.Number)
% % 
% % CorrelationsSingle_AllTogether(StudyData, RF,{'TMafter'},{'FyPSmax','FyPFmax'}, RF,{'TMafter'},{'stepLengthSlow', 'stepLengthFast'}, groups, [], 2, 3, 2, bob.Number)
% % CrissCrossSingle(StudyData,RccSL,groups,{'stepLengthSlow', 'stepLengthFast'},{'TMafter'}, 2, 3, 5, bob.Number)
% % 
% % CorrelationsSingle_AllTogether(StudyData, RF,{'TMafter'},{'FyBSmax','FyBFmax'}, RF,{'TMafter'},{'alphaSlow', 'alphaFast'}, groups, [], 2, 3, 3, bob.Number)
% % CrissCrossSingle(StudyData,RccA,groups,{'alphaSlow', 'alphaFast'},{'TMafter'}, 2, 3, 6, bob.Number)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
return



%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%% Adaptation Figure
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure
ax4=subplot(3, 4, 1);
a4=barh(x,X1SlowBase,w2,'FaceColor','r', 'FaceAlpha', .2,  'EdgeColor', 'r', 'LineWidth', 2); hold on; herrorbar(X1SlowBase,x, -1.*X1SlowBase_SE, X1SlowBase_SE, '.k')
barh(x,Alpha1SlowBase,w2,'FaceColor','b', 'FaceAlpha', .2,  'EdgeColor', 'b', 'LineWidth', 2);herrorbar( Alpha1SlowBase,x, -1.*Alpha1SlowBase_SE, Alpha1SlowBase_SE, '.k')
a4(1).BaseLine.LineStyle = ':';a4(1).BaseLine.Color = 'k';a4(1).BaseLine.LineWidth = 2;
% hs1=herrorbar(0,1.4,len1S(3),len1S(1), 'b') ;
% hf1=herrorbar(0,1.6, len1S(4),len1S(2), 'r') ;
line([len1S(3),len1S(1)],[1.55,1.55], 'Color','blue', 'LineWidth', 2) 
line([len1S(4),len1S(2)],[1.45,1.45],'Color','red', 'LineWidth', 2) 
title([groups{1} ': ' condBS])
set(gca,'yticklabel',{ 'Fast Leg', 'Slow Leg'})
xlabel(ylabelTEXT)
axis square
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ax5=subplot(3, 4, 2);
a5=barh(x,X2SlowBase,w2,'FaceColor','r', 'FaceAlpha', .2,  'EdgeColor', 'r', 'LineWidth', 2); hold on; herrorbar( X2SlowBase,x, -1.*X2SlowBase_SE,X2SlowBase_SE, '.k')
barh(x,Alpha2SlowBase,w2,'FaceColor','b', 'FaceAlpha', .2,  'EdgeColor', 'b', 'LineWidth', 2);herrorbar( Alpha2SlowBase,x, -1.*Alpha2SlowBase_SE, Alpha2SlowBase_SE, '.k')
a5(1).BaseLine.LineStyle = ':';a5(1).BaseLine.Color = 'k';a5(1).BaseLine.LineWidth = 2;
% hs2=herrorbar(0,1.4,len2S(3),len2S(1), 'b') ;
% hf2=herrorbar(0,1.6,len2S(4),len2S(2), 'r') ;
line([len2S(3),len2S(1)],[1.55,1.55], 'Color','blue', 'LineWidth', 2) 
line([len2S(4),len2S(2)],[1.45,1.45],'Color','red', 'LineWidth', 2) 
title([groups{2} ': ' condBS])
set(gca,'yticklabel',{ 'Fast Leg', 'Slow Leg'})
xlabel(ylabelTEXT)
a5(1).BaseLine.LineStyle = ':';
a5(1).BaseLine.Color = 'k';
a5(1).BaseLine.LineWidth = 2;
axis square
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ax6=subplot(3, 4, 3);
a6=barh(x,X3SlowBase,w2,'FaceColor','r', 'FaceAlpha', .2,  'EdgeColor', 'r', 'LineWidth', 2); hold on; herrorbar(X3SlowBase,x, -1.*X3SlowBase_SE, X3SlowBase_SE, '.k')
barh(x,Alpha3SlowBase,w2,'FaceColor','b', 'FaceAlpha', .2,  'EdgeColor', 'b', 'LineWidth', 2);herrorbar(Alpha3SlowBase,x,  -1.*Alpha3SlowBase_SE,Alpha3SlowBase_SE, '.k')
a6(1).BaseLine.LineStyle = ':';a6(1).BaseLine.Color = 'k';a6(1).BaseLine.LineWidth = 2;
% hs3=herrorbar(0,1.4,len3S(3),len3S(1), 'b') ;
% hf3=herrorbar(0,1.6,len3S(4),len3S(2), 'r') ;
line([len3S(3),len3S(1)],[1.55,1.55], 'Color','blue', 'LineWidth', 2) 
line([len3S(4),len3S(2)],[1.45,1.45],'Color','red', 'LineWidth', 2) 
title([groups{3} ': ' condBS])
set(gca,'yticklabel',{ 'Fast Leg', 'Slow Leg'})
 xlabel(ylabelTEXT)
 a6(1).BaseLine.LineStyle = ':';
a6(1).BaseLine.Color = 'k';
a6(1).BaseLine.LineWidth = 2;
axis square
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ax7=subplot(3, 4, 9);
a7=barh(x,X1FastBase,w2,'FaceColor','r', 'FaceAlpha', .2,  'EdgeColor', 'r', 'LineWidth', 2); hold on; herrorbar(X1FastBase,x,  -1.*X1FastBase_SE,X1FastBase_SE, '.k')
barh(x,Alpha1FastBase,w2,'FaceColor','b', 'FaceAlpha', .2,  'EdgeColor', 'b', 'LineWidth', 2);herrorbar(Alpha1FastBase,x, -1.*Alpha1FastBase_SE, Alpha1FastBase_SE, '.k')
a7(1).BaseLine.LineStyle = ':';a7(1).BaseLine.Color = 'k';a7(1).BaseLine.LineWidth = 2;
% hs1=herrorbar(0,1.4,len1F(3),len1F(1), 'b') ;
% hf1=herrorbar(0,1.6,len1F(4),len1F(2), 'r') ;
line([len1F(3),len1F(1)],[1.55,1.55], 'Color','blue', 'LineWidth', 2) 
line([len1F(4),len1F(2)],[1.45,1.45],'Color','red', 'LineWidth', 2) 
title([groups{1} ': ' condBF])
set(gca,'yticklabel',{ 'Fast Leg', 'Slow Leg'})
xlabel(ylabelTEXT)
a7(1).BaseLine.LineStyle = ':';
a7(1).BaseLine.Color = 'k';
a7(1).BaseLine.LineWidth = 2;
axis square
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ax8=subplot(3, 4, 10);
a8=barh(x,X2FastBase,w2,'FaceColor','r', 'FaceAlpha', .2,  'EdgeColor', 'r', 'LineWidth', 2); hold on; herrorbar( X2FastBase,x, -1.*X2FastBase_SE, X2FastBase_SE, '.k')
barh(x,Alpha2FastBase,w2,'FaceColor','b', 'FaceAlpha', .2,  'EdgeColor', 'b', 'LineWidth', 2);herrorbar(Alpha2FastBase,x,  -1.*Alpha2FastBase_SE, Alpha2FastBase_SE, '.k')
a8(1).BaseLine.LineStyle = ':';a8(1).BaseLine.Color = 'k';a8(1).BaseLine.LineWidth = 2;
% hs2=herrorbar(0,1.4,len2F(3),len2F(1), 'b') ;
% hf2=herrorbar(0,1.6,len2F(4),len2F(2), 'r') ;
line([len2F(3),len2F(1)],[1.55,1.55], 'Color','blue', 'LineWidth', 2) 
line([len2F(4),len2F(2)],[1.45,1.45],'Color','red', 'LineWidth', 2) 
title([groups{2} ': ' condBF])
set(gca,'yticklabel',{ 'Fast Leg', 'Slow Leg'})
xlabel(ylabelTEXT)
a8(1).BaseLine.LineStyle = ':';
a8(1).BaseLine.Color = 'k';
a8(1).BaseLine.LineWidth = 2;
axis square
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ax9=subplot(3, 4, 11);
a9=barh(x,X3FastBase,w2,'FaceColor','r', 'FaceAlpha', .2,  'EdgeColor', 'r', 'LineWidth', 2); hold on; herrorbar( X3FastBase,x, -1.*X3FastBase_SE,X3FastBase_SE, '.k')
barh(x,Alpha3FastBase,w2,'FaceColor', 'b', 'FaceAlpha', .2,  'EdgeColor', 'b', 'LineWidth', 2);herrorbar( Alpha3FastBase,x, -1.*Alpha3FastBase_SE, Alpha3FastBase_SE, '.k')
a9(1).BaseLine.LineStyle = ':';a9(1).BaseLine.Color = 'k';a9(1).BaseLine.LineWidth = 2;
% hs3=herrorbar(0,1.4,len3F(3),len3F(1), 'b') ;
% hf3=herrorbar(0,1.6,len3F(4),len3F(2), 'r') ;
line([len3F(3),len3F(1)],[1.55,1.55], 'Color','blue', 'LineWidth', 2) 
line([len3F(4),len3F(2)],[1.45,1.45],'Color','red', 'LineWidth', 2) 
title([groups{3} ': ' condBF])
set(gca,'yticklabel',{ 'Fast Leg', 'Slow Leg'})
 xlabel(ylabelTEXT)
 a9(1).BaseLine.LineStyle = ':';
a9(1).BaseLine.Color = 'k';
a9(1).BaseLine.LineWidth = 2;
axis square
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Adaptation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ax1=subplot(3, 4, 5);
%fill([nanmean([X1MBase(1) Alpha1MBase(2)]) nanmean([X1MBase(1) Alpha1MBase(2)]) nanmean([X1MBase(2) Alpha1MBase(1)]) nanmean([X1MBase(2) Alpha1MBase(1)])], [.5 2.5  2.5 .5], 'k', 'FaceAlpha', 0.4); hold on
barh(x,X1AE,ww,'FaceColor','r', 'FaceAlpha', .2,  'EdgeColor', 'r', 'LineWidth', 2);hold on; herrorbar(X1AE,x+.3, -1.*X1AE_SE, X1AE_SE, '.k')
barh(x,Alpha1AE,ww,'FaceColor','b', 'FaceAlpha', .2,  'EdgeColor', 'b', 'LineWidth', 2);herrorbar( Alpha1AE,x+.3, -1.*Alpha1AE_SE, Alpha1AE_SE, '.k')
% line([len1AE(3),len1AE(1)],[1.55,1.55], 'Color','blue') ;line([len1AE(3),len1AE(1)],[1.55,1.55],'Color','white','LineStyle','--') ;
% line([len1AE(4),len1AE(2)],[1.45,1.45],'Color','red') ;line([len1AE(4),len1AE(2)],[1.45,1.45],'Color','white','LineStyle','--') ;
%
a1=barh(x,Alpha1,w1,'FaceColor','b', 'LineWidth', 2);
hold on
herrorbar( Alpha1,x,  -1.*Alpha1_SE, Alpha1_SE, '.k');
barh(x,X1,w1,'FaceColor','r', 'LineWidth', 2);herrorbar( X1,x, -1.*X1_SE,X1_SE, '.k')
%Show speed specific baseline
line([X1SlowBase(1) X1SlowBase(1)], [1.75 2.5],'Color','black','LineStyle','--');
line([Alpha1SlowBase(1) Alpha1SlowBase(1)], [1.75 2.5],'Color','black','LineStyle','--');
line([X1FastBase(2) X1FastBase(2)], [0.5 1.25],'Color','black','LineStyle','--');
line([Alpha1FastBase(2) Alpha1FastBase(2)], [0.5 1.25],'Color','black','LineStyle','--');
a1(1).BaseLine.LineStyle = ':';
a1(1).BaseLine.Color = 'k';
a1(1).BaseLine.LineWidth = 2;
% hs1=herrorbar(0,1.4,len1(3),len1(1), 'b') ;
% hf1=herrorbar(0,1.6,len1(4),len1(2), 'r') ;
line([len1(3),len1(1)],[1.55,1.55], 'Color','blue', 'LineWidth', 2) 
line([len1(4),len1(2)],[1.45,1.45],'Color','red', 'LineWidth', 2) 
title([groups{1} ': ' cond])
set(gca,'yticklabel',{ 'Fast Leg', 'Slow Leg'})
xlabel(ylabelTEXT)
axis square
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ax2=subplot(3, 4, 6);
% fill([nanmean([X2MBase(1) Alpha2MBase(2)]) nanmean([X2MBase(1) Alpha2MBase(2)]) nanmean([X2MBase(2) Alpha2MBase(1)]) nanmean([X2MBase(2) Alpha2MBase(1)])], [.5 2.5  2.5 .5], 'k', 'FaceAlpha', 0.4); hold on
barh(x,X2AE,ww,'FaceColor','r', 'FaceAlpha', .2, 'EdgeColor', 'r', 'LineWidth', 2);hold on; herrorbar(X2AE,x+.3, -1.*X2AE_SE, X2AE_SE, '.k')
barh(x,Alpha2AE,ww,'FaceColor','b', 'FaceAlpha', .2, 'EdgeColor', 'b', 'LineWidth', 2);herrorbar( Alpha2AE,x+.3, -1.*Alpha2AE_SE, Alpha2AE_SE, '.k')
% line([len2AE(3),len2AE(1)],[1.55,1.55], 'Color','blue') ;line([len2AE(3),len2AE(1)],[1.55,1.55],'Color','white','LineStyle','--') ;
% line([len2AE(4),len2AE(2)],[1.45,1.45],'Color','red') ;line([len2AE(4),len2AE(2)],[1.45,1.45],'Color','white','LineStyle','--') ;
%
a1=barh(x,Alpha2,w1,'FaceColor','b', 'LineWidth', 2);
hold on
herrorbar( Alpha2,x, -1.*Alpha2_SE, Alpha2_SE, '.k');
barh(x,X2,w1,'FaceColor','r', 'LineWidth', 2);herrorbar( X2,x, -1.*X2_SE, X2_SE, '.k');
%Show speed specific baseline
line([X2SlowBase(1) X2SlowBase(1)], [1.75 2.5],'Color','black','LineStyle','--');
line([Alpha2SlowBase(1) Alpha2SlowBase(1)], [1.75 2.5],'Color','black','LineStyle','--');
line([X2FastBase(2) X2FastBase(2)], [0.5 1.25],'Color','black','LineStyle','--');
line([Alpha2FastBase(2) Alpha2FastBase(2)], [0.5 1.25],'Color','black','LineStyle','--');
%
a1(1).BaseLine.LineStyle = ':';
a1(1).BaseLine.Color = 'k';
a1(1).BaseLine.LineWidth = 2;
% hs1=herrorbar(0,1.4,len2(3),len2(1), 'b') ;
% hf1=herrorbar(0,1.6,len2(4),len2(2), 'r') ;
line([len2(3),len2(1)],[1.55,1.55], 'Color','blue', 'LineWidth', 2) 
line([len2(4),len2(2)],[1.45,1.45],'Color','red', 'LineWidth', 2) 
title([groups{2} ': ' cond])
set(gca,'yticklabel',{ 'Fast Leg', 'Slow Leg'})
xlabel(ylabelTEXT)
axis square
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ax3=subplot(3, 4, 7);
% mb3=fill([nanmean([X3MBase(1) Alpha3MBase(2)]) nanmean([X3MBase(1) Alpha3MBase(2)]) nanmean([X3MBase(2) Alpha3MBase(1)]) nanmean([X3MBase(2) Alpha3MBase(1)])], [.5 2.5  2.5 .5], 'k', 'FaceAlpha', 0.4); hold on
% % % ae3s=barh(x,X3AE,ww,'FaceColor','w', 'EdgeColor', 'r', 'LineWidth', 1); hold on; herrorbar(X3AE,x+.3, -1.*X3AE_SE, X3AE_SE, '.k')
% % % ae3f=barh(x,Alpha3AE,ww,'FaceColor','w', 'EdgeColor', 'b', 'LineWidth', 1);herrorbar( Alpha3AE,x+.3, -1.*Alpha3AE_SE, Alpha3AE_SE, '.k')
ae3s=barh(x,X3AE,ww,'FaceColor','r', 'FaceAlpha', .2, 'EdgeColor', 'r', 'LineWidth', 2); hold on; herrorbar(X3AE,x+.3, -1.*X3AE_SE, X3AE_SE, '.k')
ae3f=barh(x,Alpha3AE,ww,'FaceColor','b', 'FaceAlpha', .2, 'EdgeColor', 'b', 'LineWidth', 2);herrorbar( Alpha3AE,x+.3, -1.*Alpha3AE_SE, Alpha3AE_SE, '.k')
% line([len3AE(3),len3AE(1)],[1.55,1.55], 'Color','blue') ;line([len3AE(3),len3AE(1)],[1.55,1.55],'Color','white','LineStyle','--') ;
% line([len3AE(4),len3AE(2)],[1.45,1.45],'Color','red') ;line([len3AE(4),len3AE(2)],[1.45,1.45],'Color','white','LineStyle','--') ;
%
a1=barh(x,Alpha3,w1,'FaceColor','b', 'LineWidth', 2);
hold on
herrorbar( Alpha3,x, -1.*Alpha3_SE, Alpha3_SE, '.k');
a3f=barh(x,X3,w1,'FaceColor','r', 'LineWidth', 2);herrorbar( X3,x, -1.*X3_SE,X3_SE, '.k');
%Show speed specific baseline
bbb=line([X3SlowBase(1) X3SlowBase(1)], [1.75 2.5],'Color','black','LineStyle','--');
line([Alpha3SlowBase(1) Alpha3SlowBase(1)], [1.75 2.5],'Color','black','LineStyle','--');
line([X3FastBase(2) X3FastBase(2)], [0.5 1.25],'Color','black','LineStyle','--');
line([Alpha3FastBase(2) Alpha3FastBase(2)], [0.5 1.25],'Color','black','LineStyle','--');
%
a1(1).BaseLine.LineStyle = ':';
a1(1).BaseLine.Color = 'k';
a1(1).BaseLine.LineWidth = 2;
% hs1=herrorbar(0,1.4,len3(3),len3(1), 'b') ;
% hf1=herrorbar(0,1.6,len3(4),len3(2), 'r') ;
line([len3(3),len3(1)],[1.55,1.55], 'Color','blue', 'LineWidth', 2) 
line([len3(4),len3(2)],[1.45,1.45],'Color','red', 'LineWidth', 2) 
title([groups{3} ': ' cond])
set(gca,'yticklabel',{ 'Fast Leg', 'Slow Leg'})
xlabel(ylabelTEXT)
axis square
%legend([mb3  a1 a3f ae3 bbb], {'MidBaseSL', 'SS Slow SL', 'SS Fast SL', 'EP SL', 'SpdSpecificBaseSL' })
legend([a1 a3f ae3s ae3f bbb], {'Split SS Slow SL', 'Split SS Fast SL', 'Tied Slow SL', 'Tied Fast SL', 'SpdSpecificBaseSL' })

A=min([ax1.XLim ax2.XLim ax3.XLim]);
B=max([ax1.XLim ax2.XLim ax3.XLim]);
xlim(ax1,[A B])
xlim(ax2,[A B])
xlim(ax3,[A B])
xlim(ax4,[A B])
xlim(ax5,[A B])
xlim(ax6,[A B])
xlim(ax7,[A B])
xlim(ax8,[A B])
xlim(ax9,[A B])
%%
 bob=gcf;
 CorrelationsSingle_AllTogether(StudyData, RF,{'TMafter'},{'FyPSmax','FyPFmax'}, RF,{'TMafter'},{'XSlow', 'XFast'}, groups, [], 2, 4, 4, bob.Number)

grp=[resultsSL.DelFAdapt.indiv.stepLengthFast(:,1); resultsSL.DelFDeAdapt.indiv.stepLengthFast(:,1);...
    resultsSL.DelFAdapt.indiv.stepLengthSlow(:,1); resultsSL.DelFDeAdapt.indiv.stepLengthSlow(:,1)];
leg=[2.*ones(24*2, 1); 1.*ones(24*2, 1)];
epoch=[1.*ones(24, 1); 2.*ones(24, 1);1.*ones(24, 1); 2.*ones(24, 1)];
data=[resultsSL.DelFAdapt.indiv.stepLengthFast(:,2); resultsSL.DelFDeAdapt.indiv.stepLengthFast(:,2);...
    resultsSL.DelFAdapt.indiv.stepLengthSlow(:,2); resultsSL.DelFDeAdapt.indiv.stepLengthSlow(:,2)];
p=anovan(data, {grp, leg, epoch}, 'model', 'interaction', 'varnames', {'slope', 'leg', 'epoch'});
gcf

ax7=subplot(2, 4, 8);
poster_colors;
colorOrder=[p_red; p_orange; p_fade_green; p_fade_blue; p_plum; p_green; p_blue; p_fade_red; p_lime; p_yellow; [0 0 0]];
de=line([.9, 1.9], [resultsSL.DelFAdapt.avg(1, 1) resultsSL.DelFDeAdapt.avg(1, 1)], 'Color',colorOrder(1, :), 'LineWidth', 2) ; hold on
sleg=errorbar(.9, resultsSL.DelFAdapt.avg(1, 1), -1.*resultsSL.DelFAdapt.se(1, 1), resultsSL.DelFAdapt.se(1, 1), 'ok', 'MarkerFaceColor', 'w')
errorbar(1.9, resultsSL.DelFDeAdapt.avg(1, 1), -1.*resultsSL.DelFDeAdapt.se(1, 1), resultsSL.DelFDeAdapt.se(1, 1), 'ok', 'MarkerFaceColor', 'w')

fl=line([1, 2],[resultsSL.DelFAdapt.avg(2, 1) resultsSL.DelFDeAdapt.avg(2, 1)], 'Color',colorOrder(2, :), 'LineWidth', 2) ; hold on
errorbar(1, resultsSL.DelFAdapt.avg(2, 1), -1.*resultsSL.DelFAdapt.se(2, 1), resultsSL.DelFAdapt.se(2, 1), 'ok', 'MarkerFaceColor', 'w')
errorbar(2, resultsSL.DelFDeAdapt.avg(2, 1), -1.*resultsSL.DelFDeAdapt.se(2, 1), resultsSL.DelFDeAdapt.se(2, 1), 'ok', 'MarkerFaceColor', 'w')

in=line([1.1, 2.1],[resultsSL.DelFAdapt.avg(3, 1) resultsSL.DelFDeAdapt.avg(3, 1)], 'Color',colorOrder(3, :), 'LineWidth', 2) ; hold on
errorbar(1.1, resultsSL.DelFAdapt.avg(3, 1), -1.*resultsSL.DelFAdapt.se(3, 1), resultsSL.DelFAdapt.se(3, 1), 'ok', 'MarkerFaceColor', 'w')
errorbar(2.1, resultsSL.DelFDeAdapt.avg(3, 1), -1.*resultsSL.DelFDeAdapt.se(3, 1), resultsSL.DelFDeAdapt.se(3, 1), 'ok', 'MarkerFaceColor', 'w')

line([.9, 1.9], [resultsSL.DelFAdapt.avg(1, 2) resultsSL.DelFDeAdapt.avg(1, 2)], 'Color',colorOrder(1, :), 'LineWidth', 2) ; hold on
fleg=errorbar(.9, resultsSL.DelFAdapt.avg(1, 2), -1.*resultsSL.DelFAdapt.se(1, 2), resultsSL.DelFAdapt.se(1, 2), 'ok', 'MarkerFaceColor', 'k');
errorbar(1.9, resultsSL.DelFDeAdapt.avg(1, 2), -1.*resultsSL.DelFDeAdapt.se(1, 2), resultsSL.DelFDeAdapt.se(1, 2), 'ok', 'MarkerFaceColor', 'k')

line([1, 2],[resultsSL.DelFAdapt.avg(2, 2) resultsSL.DelFDeAdapt.avg(2, 2)], 'Color',colorOrder(2, :), 'LineWidth', 2) ; hold on
errorbar(1, resultsSL.DelFAdapt.avg(2, 2), -1.*resultsSL.DelFAdapt.se(2, 2), resultsSL.DelFAdapt.se(2, 2), 'ok', 'MarkerFaceColor', 'k')
errorbar(2, resultsSL.DelFDeAdapt.avg(2, 2), -1.*resultsSL.DelFDeAdapt.se(2, 2), resultsSL.DelFDeAdapt.se(2, 2), 'ok', 'MarkerFaceColor', 'k')

line([1.1, 2.1],[resultsSL.DelFAdapt.avg(3, 2) resultsSL.DelFDeAdapt.avg(3, 2)], 'Color',colorOrder(3, :), 'LineWidth', 2) ; hold on
errorbar(1.1, resultsSL.DelFAdapt.avg(3, 2), -1.*resultsSL.DelFAdapt.se(3, 2), resultsSL.DelFAdapt.se(3, 2), 'ok', 'MarkerFaceColor', 'k')
errorbar(2.1, resultsSL.DelFDeAdapt.avg(3, 2), -1.*resultsSL.DelFDeAdapt.se(3, 2), resultsSL.DelFDeAdapt.se(3, 2), 'ok', 'MarkerFaceColor', 'k')
 line([.8 2.2], [0 0], 'Color', 'k', 'LineStyle',':')
 line([1.5 1.5],[-100 400],  'Color', 'k', 'LineStyle',':')
ax7.XTick=[1, 2]; ax7.XTickLabel={'Del A', 'Del PA'};
ylabel('SL Change')
legend([fleg sleg de fl in], {'Fast Leg', 'Slow Leg', 'Decline', 'Flat', 'Incline'})
axis square
return
%% Alternative visualizations of the data
poster_colors;
colorOrder=[p_red; p_orange; p_fade_green; p_fade_blue; p_plum; p_green; p_blue; p_fade_red; p_lime; p_yellow; [0 0 0]];

figure
ax4=subplot(3, 3, 1);
g11=barh([1.75], [nanmean([X1SlowBase(2) Alpha1SlowBase(1)])], .25, 'FaceColor',colorOrder(1, :), 'FaceAlpha', .2); hold on; barh([1.75], [nanmean([X1SlowBase(1) Alpha1SlowBase(2)])],.25, 'FaceColor',colorOrder(1, :), 'FaceAlpha', .2)
g22=barh([2], [nanmean([X2SlowBase(2) Alpha2SlowBase(1)])],.25, 'FaceColor',colorOrder(2, :), 'FaceAlpha', .2); hold on; barh([2], [nanmean([X2SlowBase(1) Alpha2SlowBase(2)])],.25, 'FaceColor',colorOrder(2, :), 'FaceAlpha', .2)
g33=barh([2.25], [nanmean([X3SlowBase(2) Alpha3SlowBase(1)])],.25, 'FaceColor',colorOrder(3, :), 'FaceAlpha', .2); hold on; barh([2.25], [nanmean([X3SlowBase(1) Alpha3SlowBase(2)])],.25, 'FaceColor',colorOrder(3, :), 'FaceAlpha', .2)

barh([.75], [nanmean([X1FastBase(2) Alpha1FastBase(1)])], .25, 'FaceColor',colorOrder(1, :), 'FaceAlpha', .2); hold on; barh([.75], [nanmean([X1FastBase(1) Alpha1FastBase(2)])],.25, 'FaceColor',colorOrder(1, :), 'FaceAlpha', .2)
barh([1], [nanmean([X2FastBase(2) Alpha2FastBase(1)])],.25, 'FaceColor',colorOrder(2, :), 'FaceAlpha', .2); hold on; barh([1], [nanmean([X2FastBase(1) Alpha2FastBase(2)])],.25, 'FaceColor',colorOrder(2, :), 'FaceAlpha', .2)
barh([1.25], [nanmean([X3FastBase(2) Alpha3FastBase(1)])],.25, 'FaceColor',colorOrder(3, :), 'FaceAlpha', .2); hold on; barh([1.25], [nanmean([X3FastBase(1) Alpha3FastBase(2)])],.25, 'FaceColor',colorOrder(3, :), 'FaceAlpha', .2)

a4(1).BaseLine.LineStyle = ':';a4(1).BaseLine.Color = 'k';a4(1).BaseLine.LineWidth = 2;
title(['Baselines'])
ax4.YTick=[1, 2]; ax4.YTickLabel={  'FastBase', 'SlowBase'};
xlabel(ylabelTEXT)
axis square
xlim(ax4,[-500 500])
legend([g11 g22 g33], {'Decline', 'Flat', 'Incline'})

%%
ax5=subplot(3, 3, 4);
barh([1.75], X1(1), .25, 'FaceColor',colorOrder(1, :), 'FaceAlpha', .2); hold on; barh([1.75], X1(2),.25, 'FaceColor',colorOrder(1, :), 'FaceAlpha', .2)
barh([2], X2(1),.25, 'FaceColor',colorOrder(2, :), 'FaceAlpha', .2); hold on; barh([2], X2(2),.25, 'FaceColor',colorOrder(2, :), 'FaceAlpha', .2)
barh([2.25], X3(1),.25, 'FaceColor',colorOrder(3, :), 'FaceAlpha', .2); hold on; barh([2.25], X3(2),.25, 'FaceColor',colorOrder(3, :), 'FaceAlpha', .2)

barh([.75], X1AE(1), .25, 'FaceColor',colorOrder(1, :), 'FaceAlpha', .2); hold on; barh([.75], X1AE(2),.25, 'FaceColor',colorOrder(1, :), 'FaceAlpha', .2)
barh([1], X2AE(1),.25, 'FaceColor',colorOrder(2, :), 'FaceAlpha', .2); hold on; barh([1], X2AE(2),.25, 'FaceColor',colorOrder(2, :), 'FaceAlpha', .2)
barh([1.25], X3AE(1),.25, 'FaceColor',colorOrder(3, :), 'FaceAlpha', .2); hold on; barh([1.25], X3AE(2),.25, 'FaceColor',colorOrder(3, :), 'FaceAlpha', .2)

line([X1(1),X1AE(1)],[1.75,.75], 'Color',colorOrder(1, :), 'LineWidth', 2) 
line([X2(1),X2AE(1)],[2,1], 'Color',colorOrder(2, :), 'LineWidth', 2) 
line([X3(1),X3AE(1)],[2.25,1.25], 'Color',colorOrder(3, :), 'LineWidth', 2) 

line([X1(2),X1AE(2)],[1.75,.75], 'Color',colorOrder(1, :), 'LineWidth', 2) 
line([X2(2),X2AE(2)],[2,1], 'Color',colorOrder(2, :), 'LineWidth', 2) 
line([X3(2),X3AE(2)],[2.25,1.25], 'Color',colorOrder(3, :), 'LineWidth', 2) 

a5(1).BaseLine.LineStyle = ':';a5(1).BaseLine.Color = 'k';a5(1).BaseLine.LineWidth = 2;
title(['Fast Leg Adaptation & PA'])
ax5.YTick=[1, 2]; ax5.YTickLabel={'Fast PA', 'Fast SS'};
xlabel(ylabelTEXT)
axis square
xlim(ax5,[-500 500])
%%
ax6=subplot(3, 3, 7);
barh([1.75], Alpha1(1), .25, 'FaceColor',colorOrder(1, :), 'FaceAlpha', .2); hold on; barh([1.75], Alpha1(2),.25, 'FaceColor',colorOrder(1, :), 'FaceAlpha', .2)
barh([2], Alpha2(1),.25, 'FaceColor',colorOrder(2, :), 'FaceAlpha', .2); hold on; barh([2], Alpha2(2),.25, 'FaceColor',colorOrder(2, :), 'FaceAlpha', .2)
barh([2.25], Alpha3(1),.25, 'FaceColor',colorOrder(3, :), 'FaceAlpha', .2); hold on; barh([2.25], Alpha3(2),.25, 'FaceColor',colorOrder(3, :), 'FaceAlpha', .2)

barh([.75], Alpha1AE(1), .25, 'FaceColor',colorOrder(1, :), 'FaceAlpha', .2); hold on; barh([.75], Alpha1AE(2),.25, 'FaceColor',colorOrder(1, :), 'FaceAlpha', .2)
barh([1], Alpha2AE(1),.25, 'FaceColor',colorOrder(2, :), 'FaceAlpha', .2); hold on; barh([1], Alpha2AE(2),.25, 'FaceColor',colorOrder(2, :), 'FaceAlpha', .2)
barh([1.25], Alpha3AE(1),.25, 'FaceColor',colorOrder(3, :), 'FaceAlpha', .2); hold on; barh([1.25], Alpha3AE(2),.25, 'FaceColor',colorOrder(3, :), 'FaceAlpha', .2)

line([Alpha1(1),Alpha1AE(1)],[1.75,.75], 'Color',colorOrder(1, :), 'LineWidth', 2) 
line([Alpha2(1),Alpha2AE(1)],[2,1], 'Color',colorOrder(2, :), 'LineWidth', 2) 
line([Alpha3(1),Alpha3AE(1)],[2.25,1.25], 'Color',colorOrder(3, :), 'LineWidth', 2) 

line([Alpha1(2),Alpha1AE(2)],[1.75,.75], 'Color',colorOrder(1, :), 'LineWidth', 2) 
line([Alpha2(2),Alpha2AE(2)],[2,1], 'Color',colorOrder(2, :), 'LineWidth', 2) 
line([Alpha3(2),Alpha3AE(2)],[2.25,1.25], 'Color',colorOrder(3, :), 'LineWidth', 2) 

a6(1).BaseLine.LineStyle = ':';a6(1).BaseLine.Color = 'k';a6(1).BaseLine.LineWidth = 2;
title(['Slow Leg Adaptation & PA'])
ax6.YTick=[1, 2]; ax6.YTickLabel={'Slow PA', 'Slow SS'};
xlabel(ylabelTEXT)
axis square
xlim(ax6,[-500 500])
%return
%%

ax7=subplot(3, 3, 2);
de=line([.9, 1.9], [resultsSL.DelFAdapt.avg(1, 1) resultsSL.DelFDeAdapt.avg(1, 1)], 'Color',colorOrder(1, :), 'LineWidth', 2) ; hold on
sleg=errorbar(.9, resultsSL.DelFAdapt.avg(1, 1), -1.*resultsSL.DelFAdapt.se(1, 1), resultsSL.DelFAdapt.se(1, 1), 'ok', 'MarkerFaceColor', 'w')
errorbar(1.9, resultsSL.DelFDeAdapt.avg(1, 1), -1.*resultsSL.DelFDeAdapt.se(1, 1), resultsSL.DelFDeAdapt.se(1, 1), 'ok', 'MarkerFaceColor', 'w')

fl=line([1, 2],[resultsSL.DelFAdapt.avg(2, 1) resultsSL.DelFDeAdapt.avg(2, 1)], 'Color',colorOrder(2, :), 'LineWidth', 2) ; hold on
errorbar(1, resultsSL.DelFAdapt.avg(2, 1), -1.*resultsSL.DelFAdapt.se(2, 1), resultsSL.DelFAdapt.se(2, 1), 'ok', 'MarkerFaceColor', 'w')
errorbar(2, resultsSL.DelFDeAdapt.avg(2, 1), -1.*resultsSL.DelFDeAdapt.se(2, 1), resultsSL.DelFDeAdapt.se(2, 1), 'ok', 'MarkerFaceColor', 'w')

in=line([1.1, 2.1],[resultsSL.DelFAdapt.avg(3, 1) resultsSL.DelFDeAdapt.avg(3, 1)], 'Color',colorOrder(3, :), 'LineWidth', 2) ; hold on
errorbar(1.1, resultsSL.DelFAdapt.avg(3, 1), -1.*resultsSL.DelFAdapt.se(3, 1), resultsSL.DelFAdapt.se(3, 1), 'ok', 'MarkerFaceColor', 'w')
errorbar(2.1, resultsSL.DelFDeAdapt.avg(3, 1), -1.*resultsSL.DelFDeAdapt.se(3, 1), resultsSL.DelFDeAdapt.se(3, 1), 'ok', 'MarkerFaceColor', 'w')

line([.9, 1.9], [resultsSL.DelFAdapt.avg(1, 2) resultsSL.DelFDeAdapt.avg(1, 2)], 'Color',colorOrder(1, :), 'LineWidth', 2) ; hold on
fleg=errorbar(.9, resultsSL.DelFAdapt.avg(1, 2), -1.*resultsSL.DelFAdapt.se(1, 2), resultsSL.DelFAdapt.se(1, 2), 'ok', 'MarkerFaceColor', 'k');
errorbar(1.9, resultsSL.DelFDeAdapt.avg(1, 2), -1.*resultsSL.DelFDeAdapt.se(1, 2), resultsSL.DelFDeAdapt.se(1, 2), 'ok', 'MarkerFaceColor', 'k')

line([1, 2],[resultsSL.DelFAdapt.avg(2, 2) resultsSL.DelFDeAdapt.avg(2, 2)], 'Color',colorOrder(2, :), 'LineWidth', 2) ; hold on
errorbar(1, resultsSL.DelFAdapt.avg(2, 2), -1.*resultsSL.DelFAdapt.se(2, 2), resultsSL.DelFAdapt.se(2, 2), 'ok', 'MarkerFaceColor', 'k')
errorbar(2, resultsSL.DelFDeAdapt.avg(2, 2), -1.*resultsSL.DelFDeAdapt.se(2, 2), resultsSL.DelFDeAdapt.se(2, 2), 'ok', 'MarkerFaceColor', 'k')

line([1.1, 2.1],[resultsSL.DelFAdapt.avg(3, 2) resultsSL.DelFDeAdapt.avg(3, 2)], 'Color',colorOrder(3, :), 'LineWidth', 2) ; hold on
errorbar(1.1, resultsSL.DelFAdapt.avg(3, 2), -1.*resultsSL.DelFAdapt.se(3, 2), resultsSL.DelFAdapt.se(3, 2), 'ok', 'MarkerFaceColor', 'k')
errorbar(2.1, resultsSL.DelFDeAdapt.avg(3, 2), -1.*resultsSL.DelFDeAdapt.se(3, 2), resultsSL.DelFDeAdapt.se(3, 2), 'ok', 'MarkerFaceColor', 'k')

ax7.XTick=[1, 2]; ax7.XTickLabel={'Del A', 'Del PA'};
ylabel('SL Change')





return
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%% Post-Adaptation Figure
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% POST-Adaptation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ax4=subplot(3, 3, 4);
a4=barh(x,X1AE,w2,'FaceColor','r'); hold on; herrorbar(X1AE,x, -1.*X1AE_SE, X1AE_SE, '.k')
barh(x,Alpha1AE,w2,'FaceColor','b');herrorbar( Alpha1AE,x, -1.*Alpha1AE_SE, Alpha1AE_SE, '.k')
%Show ss specific baseline alphas and the opposite X
line([X1(1) X1(1)], [0.5 1.25],'Color','black','LineStyle',':');
line([Alpha1(1) Alpha1(1)], [1.75 2.5],'Color','black','LineStyle',':');
line([X1(2) X1(2)], [0.5 1.25],'Color','black','LineStyle',':');
line([Alpha1(2) Alpha1(2)], [1.75 2.5],'Color','black','LineStyle',':');
%
a4(1).BaseLine.LineStyle = ':';a4(1).BaseLine.Color = 'k';a4(1).BaseLine.LineWidth = 2;
hs1=herrorbar(0,1.4,len1AE(3),len1AE(1), 'b') ;
hf1=herrorbar(0,1.6, len1AE(4),len1AE(2), 'r') ;
title([groups{1} ': ' condAE])
set(gca,'yticklabel',{ 'Fast Leg', 'Slow Leg'})
xlabel(ylabelTEXT)
axis square
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ax5=subplot(3, 3, 5);
a5=barh(x,X2AE,w2,'FaceColor','r'); hold on; herrorbar( X2AE,x, -1.*X2AE_SE,X2AE_SE, '.k')
barh(x,Alpha2AE,w2,'FaceColor','b');herrorbar( Alpha2AE,x, -1.*Alpha2AE_SE, Alpha2AE_SE, '.k')
%Show ss specific baseline alphas and the opposite X
line([X2(1) X2(1)], [0.5 1.25],'Color','black','LineStyle',':');
line([Alpha2(1) Alpha2(1)], [1.75 2.5],'Color','black','LineStyle',':');
line([X2(2) X2(2)], [0.5 1.25],'Color','black','LineStyle',':');
line([Alpha2(2) Alpha2(2)], [1.75 2.5],'Color','black','LineStyle',':');
%
a5(1).BaseLine.LineStyle = ':';a5(1).BaseLine.Color = 'k';a5(1).BaseLine.LineWidth = 2;
hs2=herrorbar(0,1.4,len2AE(3),len2AE(1), 'b') ;
hf2=herrorbar(0,1.6,len2AE(4),len2AE(2), 'r') ;
title([groups{2} ': ' condAE])
set(gca,'yticklabel',{ 'Fast Leg', 'Slow Leg'})
xlabel(ylabelTEXT)
a5(1).BaseLine.LineStyle = ':';
a5(1).BaseLine.Color = 'k';
a5(1).BaseLine.LineWidth = 2;
axis square
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ax6=subplot(3, 3, 6);
a6=barh(x,X3AE,w2,'FaceColor','r'); hold on; herrorbar(X3AE,x, -1.*X3AE_SE, X3AE_SE, '.k')
barh(x,Alpha3AE,w2,'FaceColor','b');herrorbar(Alpha3AE,x,  -1.*Alpha3AE_SE,Alpha3AE_SE, '.k')
%Show ss specific baseline alphas and the opposite X
line([X3(1) X3(1)], [0.5 1.25],'Color','black','LineStyle',':');
line([Alpha3(1) Alpha3(1)], [1.75 2.5],'Color','black','LineStyle',':');
line([X3(2) X3(2)], [0.5 1.25],'Color','black','LineStyle',':');
line([Alpha3(2) Alpha3(2)], [1.75 2.5],'Color','black','LineStyle',':');
%
a6(1).BaseLine.LineStyle = ':';a6(1).BaseLine.Color = 'k';a6(1).BaseLine.LineWidth = 2;
hs3=herrorbar(0,1.4,len3AE(3),len3AE(1), 'b') ;
hf3=herrorbar(0,1.6,len3AE(4),len3AE(2), 'r') ;
title([groups{3} ': ' condAE])
set(gca,'yticklabel',{ 'Fast Leg', 'Slow Leg'})
 xlabel(ylabelTEXT)
 a6(1).BaseLine.LineStyle = ':';
a6(1).BaseLine.Color = 'k';
a6(1).BaseLine.LineWidth = 2;
axis square
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ax7=subplot(3, 3, 7);
a7=barh(x,X1MBase,w2,'FaceColor','r'); hold on; herrorbar(X1MBase,x,  -1.*X1MBase_SE,X1MBase_SE, '.k')
barh(x,Alpha1MBase,w2,'FaceColor','b');herrorbar(Alpha1MBase,x, -1.*Alpha1MBase_SE, Alpha1MBase_SE, '.k')
a7(1).BaseLine.LineStyle = ':';a7(1).BaseLine.Color = 'k';a7(1).BaseLine.LineWidth = 2;
hs1=herrorbar(0,1.4,len1M(3),len1M(1), 'b') ;
hf1=herrorbar(0,1.6,len1M(4),len1M(2), 'r') ;
title([groups{1} ': ' condB])
set(gca,'yticklabel',{ 'Fast Leg', 'Slow Leg'})
xlabel(ylabelTEXT)
a7(1).BaseLine.LineStyle = ':';
a7(1).BaseLine.Color = 'k';
a7(1).BaseLine.LineWidth = 2;
axis square
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ax8=subplot(3, 3, 8);
a8=barh(x,X2MBase,w2,'FaceColor','r'); hold on; herrorbar( X2MBase,x, -1.*X2MBase_SE, X2MBase_SE, '.k')
barh(x,Alpha2MBase,w2,'FaceColor','b');herrorbar(Alpha2MBase,x,  -1.*Alpha2MBase_SE, Alpha2MBase_SE, '.k')
a8(1).BaseLine.LineStyle = ':';a8(1).BaseLine.Color = 'k';a8(1).BaseLine.LineWidth = 2;
hs2=herrorbar(0,1.4,len2M(3),len2M(1), 'b') ;
hf2=herrorbar(0,1.6,len2M(4),len2M(2), 'r') ;
title([groups{2} ': ' condB])
set(gca,'yticklabel',{ 'Fast Leg', 'Slow Leg'})
xlabel(ylabelTEXT)
a8(1).BaseLine.LineStyle = ':';
a8(1).BaseLine.Color = 'k';
a8(1).BaseLine.LineWidth = 2;
axis square
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ax9=subplot(3, 3, 9);
a9=barh(x,X3MBase,w2,'FaceColor','r'); hold on; herrorbar( X3MBase,x, -1.*X3MBase_SE,X3MBase_SE, '.k')
barh(x,Alpha3MBase,w2,'FaceColor','b');herrorbar( Alpha3MBase,x, -1.*Alpha3MBase_SE, Alpha3MBase_SE, '.k')
a9(1).BaseLine.LineStyle = ':';a9(1).BaseLine.Color = 'k';a9(1).BaseLine.LineWidth = 2;
hs3=herrorbar(0,1.4,len3M(3),len3M(1), 'b') ;
hf3=herrorbar(0,1.6,len3M(4),len3M(2), 'r') ;
title([groups{3} ': ' condB])
set(gca,'yticklabel',{ 'Fast Leg', 'Slow Leg'})
 xlabel(ylabelTEXT)
 a9(1).BaseLine.LineStyle = ':';
a9(1).BaseLine.Color = 'k';
a9(1).BaseLine.LineWidth = 2;
axis square
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Adaptation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ax1=subplot(3, 3, 1);
a1=barh(x,Alpha1,w1,'FaceColor','b');
hold on
herrorbar( Alpha1,x,  -1.*Alpha1_SE, Alpha1_SE, '.k');
barh(x,X1,w1,'FaceColor','r');herrorbar( X1,x, -1.*X1_SE,X1_SE, '.k')
%Show speed specific baseline
line([X1SlowBase(1) X1SlowBase(1)], [1.75 2.5],'Color','black','LineStyle','--');
line([Alpha1SlowBase(1) Alpha1SlowBase(1)], [1.75 2.5],'Color','black','LineStyle','--');
line([X1FastBase(2) X1FastBase(2)], [0.5 1.25],'Color','black','LineStyle','--');
line([Alpha1FastBase(2) Alpha1FastBase(2)], [0.5 1.25],'Color','black','LineStyle','--');
%
a1(1).BaseLine.LineStyle = ':';
a1(1).BaseLine.Color = 'k';
a1(1).BaseLine.LineWidth = 2;
hs1=herrorbar(0,1.4,len1(3),len1(1), 'b') ;
hf1=herrorbar(0,1.6,len1(4),len1(2), 'r') ;
title([groups{1} ': ' cond])
set(gca,'yticklabel',{ 'Fast Leg', 'Slow Leg'})
xlabel(ylabelTEXT)
axis square
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ax2=subplot(3, 3, 2);
a1=barh(x,Alpha2,w1,'FaceColor','b');
hold on
herrorbar( Alpha2,x, -1.*Alpha2_SE, Alpha2_SE, '.k');
barh(x,X2,w1,'FaceColor','r');herrorbar( X2,x, -1.*X2_SE, X2_SE, '.k');
%Show speed specific baseline
line([X2SlowBase(1) X2SlowBase(1)], [1.75 2.5],'Color','black','LineStyle','--');
line([Alpha2SlowBase(1) Alpha2SlowBase(1)], [1.75 2.5],'Color','black','LineStyle','--');
line([X2FastBase(2) X2FastBase(2)], [0.5 1.25],'Color','black','LineStyle','--');
line([Alpha2FastBase(2) Alpha2FastBase(2)], [0.5 1.25],'Color','black','LineStyle','--');
%
a1(1).BaseLine.LineStyle = ':';
a1(1).BaseLine.Color = 'k';
a1(1).BaseLine.LineWidth = 2;
hs1=herrorbar(0,1.4,len2(3),len2(1), 'b') ;
hf1=herrorbar(0,1.6,len2(4),len2(2), 'r') ;
title([groups{2} ': ' cond])
set(gca,'yticklabel',{ 'Fast Leg', 'Slow Leg'})
xlabel(ylabelTEXT)
axis square
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ax3=subplot(3, 3, 3);
a1=barh(x,Alpha3,w1,'FaceColor','b');
hold on
herrorbar( Alpha3,x, -1.*Alpha3_SE, Alpha3_SE, '.k');
barh(x,X3,w1,'FaceColor','r');herrorbar( X3,x, -1.*X3_SE,X3_SE, '.k');
%Show speed specific baseline
line([X3SlowBase(1) X3SlowBase(1)], [1.75 2.5],'Color','black','LineStyle','--');
line([Alpha3SlowBase(1) Alpha3SlowBase(1)], [1.75 2.5],'Color','black','LineStyle','--');
line([X3FastBase(2) X3FastBase(2)], [0.5 1.25],'Color','black','LineStyle','--');
line([Alpha3FastBase(2) Alpha3FastBase(2)], [0.5 1.25],'Color','black','LineStyle','--');
%
a1(1).BaseLine.LineStyle = ':';
a1(1).BaseLine.Color = 'k';
a1(1).BaseLine.LineWidth = 2;
hs1=herrorbar(0,1.4,len3(3),len3(1), 'b') ;
hf1=herrorbar(0,1.6,len3(4),len3(2), 'r') ;
title([groups{3} ': ' cond])
set(gca,'yticklabel',{ 'Fast Leg', 'Slow Leg'})
xlabel(ylabelTEXT)
axis square

A=min([ax1.XLim ax2.XLim ax3.XLim]);
B=max([ax1.XLim ax2.XLim ax3.XLim]);
xlim(ax1,[A B])
xlim(ax2,[A B])
xlim(ax3,[A B])
xlim(ax4,[A B])
xlim(ax5,[A B])
xlim(ax6,[A B])
xlim(ax7,[A B])
xlim(ax8,[A B])
xlim(ax9,[A B])


return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Here I am predicting the SL Symmetry from the incline and speed specific
% baseline ankle ranges
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
resultsSLA = getForceResults(StudyData,{'netContributionNorm2'},groups,0, 0 , 0, 0);
resultsSL = getForceResults(StudyData,{'stepLengthSlow', 'stepLengthFast'},groups,0, 0 , 0, 0);

for g=1:length(groups)
    lenS_indiv=[eval(['results.' condBS '.indiv.' (params{1}) '(:,:)']),...
        eval(['results.' condBS '.indiv.' (params{2}) '(:,2)']),...
        eval(['results.' condBS '.indiv.' (params{3}) '(:,2)']),...
        eval(['results.' condBS '.indiv.' (params{4}) '(:,2)'])];
    lenF_indiv=[eval(['results.' condBF '.indiv.' (params{1}) '(:,:)']),...
        eval(['results.' condBF '.indiv.' (params{2}) '(:,2)']),...
        eval(['results.' condBF '.indiv.' (params{3}) '(:,2)']),...
        eval(['results.' condBF '.indiv.' (params{4}) '(:,2)'])];
        lenSS_indiv=[eval(['results.' cond '.indiv.' (params{1}) '(:,:)']),...
        eval(['results.' cond '.indiv.' (params{2}) '(:,2)']),...
        eval(['results.' cond '.indiv.' (params{3}) '(:,2)']),...
        eval(['results.' cond '.indiv.' (params{4}) '(:,2)'])];
    GF=find(lenS_indiv(:,1)==g);
    % Steady State Predictions
    Predicted_FSL_indiv= lenF_indiv(GF, 2)-lenS_indiv(GF, 5);
    Predicted_SSL_indiv= lenS_indiv(GF, 2)-lenF_indiv(GF, 5);
    SLA_indiv=(Predicted_FSL_indiv-Predicted_SSL_indiv)./(Predicted_FSL_indiv+Predicted_SSL_indiv);
    SLS_SS(g)=nanmean(Predicted_SSL_indiv);
    SLF_SS(g)=nanmean(Predicted_FSL_indiv);
    SLA_predited(g)=nanmean(SLA_indiv);
    SLA_predited_se(g)=nanstd(SLA_indiv)./sqrt(length(GF));
    [~, pss(g)]=ttest(resultsSLA.TMSteady.indiv.netContributionNorm2(GF,2),SLA_indiv)
    % AE Predicitons just from baseline
    Predicted_FSLAE_indiv= lenF_indiv(GF, 2)-lenF_indiv(GF, 5);
    Predicted_SSLAE_indiv= lenS_indiv(GF, 2)-lenS_indiv(GF, 5);
    SLA_AE_indiv=(Predicted_FSLAE_indiv-Predicted_SSLAE_indiv)./(Predicted_FSLAE_indiv+Predicted_SSLAE_indiv);
    SLA_AE_predited(g)=nanmean(SLA_AE_indiv);
    SLA_AE_predited_se(g)=nanstd(SLA_AE_indiv)./sqrt(length(GF));
    [~, pae(g)]=ttest(resultsSLA.TMafter.indiv.netContributionNorm2(GF,2),SLA_AE_indiv)
    %

%     % AE Predicitons just from SS behavior
%     Predicted_FSLAE_indiv= lenSS_indiv(GF, 2)-lenSS_indiv(GF, 4);
%     Predicted_SSLAE_indiv= lenSS_indiv(GF, 3)-lenSS_indiv(GF, 5);
%     SLA_AE_indiv=(Predicted_FSLAE_indiv-Predicted_SSLAE_indiv)./(Predicted_FSLAE_indiv+Predicted_SSLAE_indiv);
%     SLA_AE_predited(g)=nanmean(SLA_AE_indiv);
%     SLA_AE_predited_se(g)=nanstd(SLA_AE_indiv)./sqrt(length(GF));
%     [~, pae(g)]=ttest(resultsSLA.TMafter.indiv.netContributionNorm2(GF,2),SLA_AE_indiv)
%     %
    clear lenS_indiv lenF_indiv GF Predicted_FSL_indiv Predicted_SSL_indiv SLA_indiv
end


figure
subplot(2, 1, 1)
bar([resultsSLA.TMSteady.avg SLA_predited']); hold on
errorbar([.85:1:length(groups)-.15], [resultsSLA.TMSteady.avg ], [resultsSLA.TMSteady.se],'.k');
errorbar([1.15:1:length(groups)+.15], [SLA_predited'], [SLA_predited_se'],'.k');
ylabel('SLA_Norm2')
set(gca,'xticklabel',groups)
legend('GrpSLA', 'Predicted SLA Perpendicular Projection')
text(1,.15,['p=', num2str(pss)])
title(['Can we predict GRP SLA SS?  -- For flat abrupt, but not for sloped'])
subplot(2, 1, 2)
bar([resultsSLA.TMafter.avg SLA_AE_predited']); hold on
errorbar([.85:1:length(groups)-.15], [resultsSLA.TMafter.avg ], [resultsSLA.TMafter.se],'.k');
errorbar([1.15:1:length(groups)+.15], [SLA_AE_predited'], [SLA_AE_predited_se'],'.k');
ylabel('SLA_Norm2')
set(gca,'xticklabel',groups)
legend('GrpSLA', 'Predicted SLA Perpendicular Projection')
text(1,.15,['p=', num2str(pae)])
title(['Can we predict GRP SLA AE?'])



return

figure
bar([resultsSL.TMSteady.avg(:, 1)  SLS_SS' resultsSL.TMSteady.avg(:, 2) SLF_SS']); hold on
ylabel('SS Step Length')
set(gca,'xticklabel',groups)
legend('GrpSLS', 'Predicted SLS', 'GrpSLF', 'Predicted SLF')
