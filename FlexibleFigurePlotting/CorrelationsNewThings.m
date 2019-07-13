function CorrelationsNewThings(SMatrix, results,epoch1,param1,results2, epoch2, param2, groups,MultReg, colorOrder)
%CorrelationsNewThings(DumbTester7, results,['TMsteady'],params,results, ['TMafter'], params, groups,[])
%2= x-axis
%1= y-axis

%THIS MAY BE WHAT YOU ARE LOOKING FOR IF THIS DOESN'T WORK FOR YOU!
%lm=MetaCorrelations(SMatrix, results,epoch1,param1,meta, groups,colorOrder)

% Set colors order
if nargin<8 || exist('colorOrder')==0 || isempty(colorOrder) || size(colorOrder,2)~=3
    poster_colors;
    colorOrder=[p_red; p_orange; p_fade_green; p_fade_blue; p_plum; p_green; p_blue; p_fade_red; p_lime; p_yellow; [0 0 0]];
end

if length(param1)<=4 && length(param2)<=4
    %figure
    %hold on
    ah=optimizedSubPlot(length(param1)*size(param2, 2), length(param1), size(param2, 2));
    i=1;
end
X=[];
for var=1:length(param1)
    if length(param1)>4 || length(param2)>4
        eval(['figure(' num2str(var) ')']);
        hold on
        ah=optimizedSubPlot(size(param2, 2));
        i=1;
    end
    
    Y=results.(epoch1).indiv.(param1{var})(:,2);
    
    for cog=1:size(param2, 2)
        X=results2.(epoch2).indiv.(param2{cog})(:,2);
        
        groupKey=results.(epoch1).indiv.(param1{var})(:,1);
        if ~ isempty(find(isnan(Y)==1)) || length(X)~=length(Y)
            Y=results.(epoch1).indiv.(param1{var})(:,2);
            X(find(isnan(Y)==1))=[];
            groupKey(find(isnan(Y)==1))=[];
            Y(find(isnan(Y)==1))=[];
        end
        groupNums=unique(groupKey);
        axes(ah(i)); hold on
        for g=groupNums'
            plot(X(groupKey==g),Y(groupKey==g),'.','markerSize',15,'color',colorOrder(g,:))
        end
        lm = fitlm(X,Y,'linear');
        Pslope=double(lm.Coefficients{2,4});
        Pintercept=double(lm.Coefficients{1,4});
        Y_fit=lm.Fitted;
        coef=double(lm.Coefficients{:,1});%Intercept=(1, 1), slop=(2,1)
        Rsquared=lm.Rsquared.Ordinary;
        R=corr(X, Y);
        Resid=lm.Residuals.Studentized;
        
        %Pearson Coefficient
        FullMeta=find(isnan(X)~=1);
        [RHO_Pearson,PVAL_Pearson] = corr(X(FullMeta),Y(FullMeta),'type', 'Pearson');
        
        %Spearman Coefficient
        [RHO_Spearman,PVAL_Spearman] = corr(X(FullMeta),Y(FullMeta),'type', 'Spearman');
        
        %         %Multiple Linear Refression
        %         [b,bint,r,rint,stats] =regress(Y, [X groupKey])
        [b1,b2,st] =glmfit([X groupKey], Y, 'normal');
        stpData=st.p(2);
        stpGroup=st.p(3);
        
        plot(X,Y_fit,'k');
        hold on
        %% ULTRA LABEL
                    lm2=fitlm([X groupKey], Y, 'linear');
                    T=anova(lm2,'summary');
                    F=table2array(T(2,4));
                    Fp=table2array(T(2,5));
            %lm2stats=anova(lm2, 'summary');
            %F2=double(lm2stats.F);F2=F2(2);
            CX2=double(lm2.Coefficients{1,1});
            CX1=double(lm2.Coefficients{2,1});
            CX2=double(lm2.Coefficients{3,1});
            PX1=double(lm2.Coefficients{2,4});
            PX2=double(lm2.Coefficients{3,4});
            Rsquared=lm2.Rsquared.Ordinary;
        label1 = sprintf('p_{F}= %0.3f; R^2 = %0.2f (p_{rho} = %0.3f);   XData = %0.2f,   Groups = %0.2f',Fp, Rsquared, PVAL_Pearson, stpData,stpGroup);
        title(label1,'fontsize',10)
%         %% SPecific Labels
%         if exist('MultReg')==1 && MultReg==1
%             lm2=fitlm([X groupKey], Y, 'linear');
%             %lm2stats=anova(lm2, 'summary');
%             %F2=double(lm2stats.F);F2=F2(2);
%             CX2=double(lm2.Coefficients{1,1});
%             CX1=double(lm2.Coefficients{2,1});
%             CX2=double(lm2.Coefficients{3,1});
%             PX1=double(lm2.Coefficients{2,4});
%             PX2=double(lm2.Coefficients{3,4});
%             Rsquared=lm2.Rsquared.Ordinary;
%             Y_fit2=X.*CX1+groupKey.*CX2+CX2;
%             
%             label1 = sprintf('R^2 = %0.2f \n XData = %0.2f,   Groups = %0.2f', Rsquared, stpData,stpGroup);
%             %                      x1 = .5.*nanmax(X);
%             %                 y1 = 1.*nanmean(Y);
%             %         text(x1,y1,label1,'fontsize',12)
%             ylabel({[epoch1]; [param1{var}]},'fontsize',12);%ylabel({[epoch1]; [param1{var}(1:10)]},'fontsize',12)
%             title(label1,'fontsize',12)
%             %title({[epoch2 ', ' param2{cog}]},'fontsize',12)
%         else
%             % label1 = sprintf('r^2 = %0.2f, (p_{slope} = %0.2f) \n Pearson = %0.2f, (p = %0.2f) \n Spearman = %0.2f, (p = %0.2f) ',Rsquared,Pslope, RHO_Pearson, PVAL_Pearson,RHO_Spearman, PVAL_Spearman);
%             %label1 = sprintf('r = %0.2f, \n Pearson = %0.2f, \n  (p = %0.6f) ',R, RHO_Pearson, PVAL_Pearson);
%             label1 = sprintf(['  r = %0.2f \n  p_{rho} = %0.3f \n\n  P_{' param2{cog} '}= %0.3f \n  P_{group} = %0.3f'],R , PVAL_Pearson, stpData, stpGroup);
%             label1SHORT = sprintf(['  r = %0.2f;  p_{rho} = %0.3f'],R , PVAL_Pearson);
%             %label1SHORT = sprintf(['  r = %0.2f \n  p_{rho} = %0.3f'],R , PVAL_Pearson);
%             title(label1SHORT,'fontsize',12)
%             
%         end
        ylabel({[epoch1 ', ' param1{var}]},'fontsize',12)
        xlabel({[epoch2 ', ' param2{cog}]},'fontsize',12)
        
        %xlabel([metalabels{cog}],'fontsize',10)
        %title([param2{cog}],'fontsize',12)
        %title({[epoch1 ' ' param1{var} ' vs. ' meta{cog}] ; ['(n = ' num2str(length(subjects)) ')']},'fontsize',16)
        set(gca,'fontsize',10)
        
        axis equal
        axis tight
        axis square
        if var==1 && cog==1
            legend(groups)
        end
        i=i+1;
        X=[];
    end
    %linkaxes([ah(1) ah(2)], 'y')
    if length(param1)<=4 && length(param2)<=4
        clearvars -except SMatrix results epoch1 param1 meta  groups colorOrder i ah results2 epoch2 param2 MultReg
        set(gcf,'renderer','painters')
        X=[];
    else
        clearvars -except SMatrix results epoch1 param1 meta  groups colorOrder metalabels results2 epoch2 param2 MultReg
        X=[];
    end
end

set(gcf,'renderer','painters')
end