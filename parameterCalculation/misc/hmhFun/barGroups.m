function barGroups(Study,results,groups,params,epochs,indivFlag,colorOrder,mode)
%Make a bar plot to compare groups for a given epoch and parameter
%   TO DO: make function be able to accept a group array that is different
%   thand the groups in the results matrix

if nargin<8 || isempty(mode)
    mode=1;
end
if nargin<7 || isempty(colorOrder) || size(colorOrder,2)~=3    
    poster_colors;
    colorOrder=[p_red; p_orange; p_fade_green; p_fade_blue; p_plum; p_green; p_blue; p_fade_red; p_lime; p_yellow; p_gray; p_black;[1 1 1]];         
end
% Set grey colors to use when individual subjects are plotted 
greyOrder=[0 0 0 ;1 1 1;0.5 0.5 0.5;0.2 0.2 0.2;0.9 0.9 0.9;0.1 0.1 0.1;0.8 0.8 0.8;0.3 0.3 0.3;0.7 0.7 0.7];

legendNAMES=[];
ngroups=length(groups);         
numPlots=length(epochs)*length(params);
numE=length(epochs);
ah=optimizedSubPlot(numPlots,length(params),numE,'lr',12,10,12);
i=1;
for p=1:length(params)
   limy=[];
   for t=1:numE
       axes(ah(i))
       hold on
       for b=1:ngroups
           legendNAMES=[legendNAMES  groups{b}  Study.(groups{b}).ID];
           nSubs=length(Study.(groups{b}).ID);
           
           %attempt to abbreviate group name
%            adaptData=Study.(groups{b}).adaptData{1};
%            group=adaptData.metaData.ID;
%            spaces=find(group==' ');
%            abrevGroup=group(spaces+1);%
%            abrevGroups{b}=[group(1) abrevGroup];
                      
           ind=find(strcmp(fields(Study),groups{b}));
           switch mode
               case 1
                   if nargin>5 && indivFlag
                       bar(b,results.(epochs{t}).avg(b,p),'facecolor',greyOrder(ind,:));
                       for s=1:nSubs
                           aux=results.(epochs{t}).indiv.(params{p});
                           aux=aux(aux(:,1)==b,2);                   
                           plot(b,aux(s),'*','Color',colorOrder(s,:))                 
                       end
                   else
                       bar(b,results.(epochs{t}).avg(b,p),'facecolor',colorOrder(ind,:));
                   end
               case 2
                   %nop
           end
       end
       switch mode
           case 1
                errorbar(results.(epochs{t}).avg(:,p),results.(epochs{t}).se(:,p),'.','LineWidth',2,'Color','k')
           case 2
               errorbar(results.(epochs{t}).avg(:,p),results.(epochs{t}).se(:,p),'LineWidth',2,'Color','k')
       end
       set(gca,'Xtick',1:ngroups,'XTickLabel',groups,'fontSize',9)
       axis tight
       limy=[limy get(gca,'Ylim')];
       limy(find(abs(limy)==1))=[];
       ylabel(params{p}())
        if ~isfield(results.(epochs{t}), 'p') %~exist('results.(epochs{t}).p') %&& isempty(results.(epochs{t}).p)
       title(epochs{t})
       else
           title([epochs{t} '  (p = ' num2str(results.(epochs{t}).p(p)) ')'])
       end
       i=i+1;
       %% PLOT POST HOC
       if isfield(results.(epochs{t}), 'postHoc')  % Show the pst hoc
           for ph=1:size(results.(epochs{t}).postHoc{p}, 1)
               if isnan(results.(epochs{t}).postHoc{p}(ph, 1)) || isnan(results.(epochs{t}).postHoc{p}(ph, 2)) 
                   break
               elseif abs(limy(end-1))>=abs(limy(end)) 
                    line([results.(epochs{t}).postHoc{p}(ph, 1) results.(epochs{t}).postHoc{p}(ph, 2)], [limy(end-1)+ph.*(limy(end-1)*.05) limy(end-1)+ph.*(limy(end-1)*.05)], 'Color', 'k')
                    limy(end-1)=limy(end-1)+(ph+1).*(limy(end-1)*.05);
               elseif abs(limy(end-1))<abs(limy(end))
                    line([results.(epochs{t}).postHoc{p}(ph, 1) results.(epochs{t}).postHoc{p}(ph, 2)], [limy(end)+ph.*(limy(end)*.05) limy(end)+ph.*(limy(end)*.05)], 'Color', 'k')
                    limy(end)=limy(end)+(ph+1).*(limy(end)*.05);
               end
           end
       end
       %% PLOT DIFF FROM ZERO: CJS new 7/12/2017
       if isfield(results.(epochs{t}), 'DiffZero')  % if we have stats indicating different from zero 'DiffZero'
           for g=1:size(results.(epochs{t}).DiffZero, 1)
               if results.(epochs{t}).DiffZero(g, p)>0.05
                   scatter((g+.2), results.(epochs{t}).avg(g,p), 's', 'FaceColor', 'k')
               end         
           end
       end
   end
   set(ah(p*numE-(numE-1):p*numE),'Ylim',[min(limy) max(limy)])% 6/2016
   set(gcf,'Renderer','painters');
   if nargin>5 && indivFlag
      legend(legendNAMES)
   else
       legend(groups)
   end
end

end

