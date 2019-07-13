function Stats=InclineDeclineFigure5V2(adaptDataList,params,conds,binWidth,trialMarkerFlag,indivSubFlag,IndivSubList,removeBias,groups, results, resultsNoBias)
%% Set up the physical Figure
axesFontSize=10;
labelFontSize=0;
titleFontSize=12;
row=2;
col=3;
[ah,figHandle]=optimizedSubPlot(row*col,row,col,'tb',axesFontSize,labelFontSize,titleFontSize);
%%
poster_colors;
colorOrder=[p_red; p_orange; p_fade_green; p_fade_blue; p_plum; p_green; p_blue; p_fade_red;    [204, 0, 204]./255; [230, 25, 75]./255; [0, 0, 128]./255; [128, 0, 0]./255; [230, 190, 255]./255];
colorOrderGrey=[.9 .9 .9; .3 .3 .3];

%% Timecourse plots
subers=[1:2; 4:5];
for p=1:length(params)
    plotAvgTimeCourseSingle(adaptDataList,params(p),conds,binWidth,trialMarkerFlag,indivSubFlag,IndivSubList,colorOrder,0,removeBias,groups,0,ah, row, col, subers(p, :)); hold on
end

Stats=CrissCrossSingle(adaptDataList,resultsNoBias,groups,params,colorOrder, 2, 3, [3 6], figHandle.Number)
axis square


%% Pretty
fh=gcf;
ah=findobj(fh,'Type','Axes');
set(gcf,'Renderer','painters');
