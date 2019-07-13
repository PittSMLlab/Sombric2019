function barGroupsSingle_Paired_AcrossgGroup(Study,results,groups,params,epochs,indivFlag,colorOrder,mode, row, col, sub)
%Make a bar plot to compare groups for a given epoch and parameter
%   TO DO: make function be able to accept a group array that is different
%   thand the groups in the results matrix

if nargin<8 || isempty(mode)
    mode=1;
end

if strcmp(groups,'NoDescription')==1
    greyOrder=[1 1 1; 1 1 1];
else
    greyOrder=[.5 .5 .5; .5 .5 .5];
end

legendNAMES=[];
ngroups=length(groups);
numPlots=length(epochs)*length(params);
numE=length(epochs);

i=1;
for p=1:length(params)
    ReallyWhereStats=[find(cellfun(@(x) strcmp(x, params{1}), fieldnames(results.(epochs{1}).indiv),'uniformoutput',1)),...
        find(cellfun(@(x) strcmp(x, params{2}), fieldnames(results.(epochs{1}).indiv),'uniformoutput',1))];
    
    
    limy=[];
    for t=1:numE
        subplot(row, col, sub)
        hold on
        for b=1:length(params)
            nSubs=length(Study.(groups{1}).ID);
            
            ind=b;
            bar(b,results.(epochs{t}).avg(1, ReallyWhereStats(b)),'facecolor',greyOrder(ind,:));
            
            %% Plot individual Subjects 5/8/2019
            for s=1:length(Study.(groups{1}).ID)
                GroupIDPosition=find(results.(epochs{t}).indiv.(params{1})(:, 1)==1);
                DataTogether(s, 1)=results.(epochs{t}).indiv.(params{1})(GroupIDPosition(s),2);
                DataTogether(s, 2)=results.(epochs{t}).indiv.(params{2})(GroupIDPosition(s),2);
            end
            set(gca,'ColorOrder',colorOrder);
            plot([1.2, 1.8], DataTogether, '-o', 'LineWidth', 2)
            
            %%
            errorbar(1, results.(epochs{t}).avg(1,ReallyWhereStats(1)),results.(epochs{t}).se(1, ReallyWhereStats(1)),'LineWidth',2,'Color','k')
            errorbar(2, results.(epochs{t}).avg(1,ReallyWhereStats(2)),results.(epochs{t}).se(1, ReallyWhereStats(2)),'LineWidth',2,'Color','k')
        
        %%
        set(gca,'Xtick',1:2,'XTickLabel',{'Non-Paretic', 'Paretic'},'fontSize',9);%Orignoal

        axis tight
        limy=[limy get(gca,'Ylim')];
        limy(find(abs(limy)==1))=[];
        %ylabel(params{p}())
        ylabel([epochs{t}])
        offsettersP=(limy(end)*.05);
        offsetters=(limy(end-1)*.05);
        
        title([epochs{t}, ': ', groups{1}])
        
        i=i+1;
        
    end
    set(gcf,'Renderer','painters');
    ylim([ 0 .33])
    axis square
end

end

