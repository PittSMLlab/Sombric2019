SS_DSB=resultsForce.TMSteady.indiv.FyBS(find(resultsForce.TMSteady.indiv.FyBS(:,1)==1), 2);
SS_FSB=resultsForce.TMSteady.indiv.FyBS(find(resultsForce.TMSteady.indiv.FyBS(:,1)==2), 2);
SS_ISB=resultsForce.TMSteady.indiv.FyBS(find(resultsForce.TMSteady.indiv.FyBS(:,1)==3), 2);
Base_ISB=resultsForce.DelFBaseS.indiv.FyBS(find(resultsForce.DelFBaseS.indiv.FyBS(:,1)==3), 2);
Base_FSB=resultsForce.DelFBaseS.indiv.FyBS(find(resultsForce.DelFBaseS.indiv.FyBS(:,1)==2), 2);
Base_DSB=resultsForce.DelFBaseS.indiv.FyBS(find(resultsForce.DelFBaseS.indiv.FyBS(:,1)==1), 2);
Base_DMB=resultsForce.DelFBaseM.indiv.FyBS(find(resultsForce.DelFBaseM.indiv.FyBS(:,1)==1), 2);

[h, p]=ttest(SS_DSB, Base_DSB)
[h, p]=ttest(SS_FSB, Base_FSB)
[h, p]=ttest(SS_ISB, Base_ISB)

%
SS_DFB=resultsForce.TMSteady.indiv.FyBF(find(resultsForce.TMSteady.indiv.FyBF(:,1)==1), 2);
SS_FFB=resultsForce.TMSteady.indiv.FyBF(find(resultsForce.TMSteady.indiv.FyBF(:,1)==2), 2);
SS_IFB=resultsForce.TMSteady.indiv.FyBF(find(resultsForce.TMSteady.indiv.FyBF(:,1)==3), 2);
Base_IFB=resultsForce.DelFBaseS.indiv.FyBF(find(resultsForce.DelFBaseF.indiv.FyBF(:,1)==3), 2);
Base_FFB=resultsForce.DelFBaseS.indiv.FyBF(find(resultsForce.DelFBaseF.indiv.FyBF(:,1)==2), 2);
Base_DFB=resultsForce.DelFBaseS.indiv.FyBF(find(resultsForce.DelFBaseF.indiv.FyBF(:,1)==1), 2);

Base_IMB=resultsForce.DelFBaseM.indiv.FyBF(find(resultsForce.DelFBaseM.indiv.FyBF(:,1)==3), 2);
Base_FMB=resultsForce.DelFBaseM.indiv.FyBF(find(resultsForce.DelFBaseM.indiv.FyBF(:,1)==2), 2);
Base_DMB=resultsForce.DelFBaseM.indiv.FyBF(find(resultsForce.DelFBaseM.indiv.FyBF(:,1)==1), 2);

[h, p]=ttest(SS_DFB, Base_DFB)
[h, p]=ttest(SS_FFB, Base_FFB)
[h, p]=ttest(SS_IFB, Base_IFB)

%
SS_DSP=resultsForce.TMSteady.indiv.FyPS(find(resultsForce.TMSteady.indiv.FyPS(:,1)==1), 2);
SS_FSP=resultsForce.TMSteady.indiv.FyPS(find(resultsForce.TMSteady.indiv.FyPS(:,1)==2), 2);
SS_ISP=resultsForce.TMSteady.indiv.FyPS(find(resultsForce.TMSteady.indiv.FyPS(:,1)==3), 2);
Base_ISP=resultsForce.DelFBaseS.indiv.FyPS(find(resultsForce.DelFBaseS.indiv.FyPS(:,1)==3), 2);
Base_FSP=resultsForce.DelFBaseS.indiv.FyPS(find(resultsForce.DelFBaseS.indiv.FyPS(:,1)==2), 2);
Base_DSP=resultsForce.DelFBaseS.indiv.FyPS(find(resultsForce.DelFBaseS.indiv.FyPS(:,1)==1), 2);

Base_IMP=resultsForce.DelFBaseM.indiv.FyPS(find(resultsForce.DelFBaseM.indiv.FyPS(:,1)==3), 2);
Base_FMP=resultsForce.DelFBaseM.indiv.FyPS(find(resultsForce.DelFBaseM.indiv.FyPS(:,1)==2), 2);
Base_DMP=resultsForce.DelFBaseM.indiv.FyPS(find(resultsForce.DelFBaseM.indiv.FyPS(:,1)==1), 2);

[h, p]=ttest(SS_DSP, Base_DSP)
[h, p]=ttest(SS_FSP, Base_FSP)
[h, p]=ttest(SS_ISP, Base_ISP)

%
SS_DFP=resultsForce.TMSteady.indiv.FyPF(find(resultsForce.TMSteady.indiv.FyPF(:,1)==1), 2);
SS_FFP=resultsForce.TMSteady.indiv.FyPF(find(resultsForce.TMSteady.indiv.FyPF(:,1)==2), 2);
SS_IFP=resultsForce.TMSteady.indiv.FyPF(find(resultsForce.TMSteady.indiv.FyPF(:,1)==3), 2);
Base_IFP=resultsForce.DelFBaseS.indiv.FyPF(find(resultsForce.DelFBaseF.indiv.FyPF(:,1)==3), 2);
Base_FFP=resultsForce.DelFBaseS.indiv.FyPF(find(resultsForce.DelFBaseF.indiv.FyPF(:,1)==2), 2);
Base_DFP=resultsForce.DelFBaseS.indiv.FyPF(find(resultsForce.DelFBaseF.indiv.FyPF(:,1)==1), 2);

[h, p]=ttest(SS_DFP, Base_DFP)
[h, p]=ttest(SS_FFP, Base_FFP)
[h, p]=ttest(SS_IFP, Base_IFP)