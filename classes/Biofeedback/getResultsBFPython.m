function resusts = getResustsBFPython(SMatrix,groups, params,plotFlag,indivFlag)

%params=[{'SlowLeg', 'FastLeg'} params];

% define number of points to use for calculating values
catchNumPts = 3; %catch
steadyNumPts = 40; %end of adaptation
transientNumPts = 5; %OG and Washout

if nargin<3 || isempty(groups)
    groups=fields(SMatrix);  %default
end
ngroups=length(groups);


% Initialize values to calculate
resusts.BFafter1.avg=[];
resusts.BFafter1.se=[];

resusts.BFafter2.avg=[];
resusts.BFafter2.se=[];

resusts.MapShort.avg=[];
resusts.MapShort.se=[];

resusts.MapMid.avg=[];
resusts.MapMid.se=[];

resusts.MapLong.avg=[];
resusts.MapLong.se=[];

UltimateSubjects=[];
for g=1:ngroups
    
    %get subjects in group
    subjects=SMatrix.(groups{g}).ID;
    UltimateSubjects=[UltimateSubjects; subjects'];
    BFafter1=[];
    BFafter2=[];
    MapShort=[];
    MapMid=[];
    MapLong=[];

    for s=1:length(subjects)
        % load subject
        load([subjects{s} '_PerceptionBF_day.mat']);
        
        eval(['fastleg=' subjects{s} '.fastleg;']);
        if fastleg=='r'
            eval(['[fhits, shits, fts, sts, ~]=' subjects{s} '.getHits();']);
        elseif fastleg=='l'
            eval(['[shits, fhits, sts, fts, ~]=' subjects{s} '.getHits();']);
        end
        %Currently not removing the transitions... ANYWHERE
        %[rhits, lhits, rts, lts, rv, lv]=this.removeTransitions(rhits, lhits, rts, lts, rv,lv);
        
        FDATA=[];
        SDATA=[];
        
        %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        % load subject
        adaptData=SMatrix.(groups{g}).adaptData{s};
        %                 % remove baseline bias
        %         adaptData=adaptData.removeBadStrides;
        %         if  ~exist('removeBias') || removeBias==1
        %              adaptData=adaptData.removeBias;
        %         end
        %
        KinData{1}=adaptData.getParamInCond(params,'Familiarization');
        KinData{2}=adaptData.getParamInCond(params,'Map');
        KinData{3}=adaptData.getParamInCond(params,'Error Clamp');
        KinData{5}=adaptData.getParamInCond(params,'Washout Map');
        KinData{4}=adaptData.getParamInCond(params,'Washout Error Clamp');
        
        NexusTarget{1}=adaptData.getParamInCond({'target'},'Familiarization');
        NexusTarget{2}=adaptData.getParamInCond({'target'},'Map');
        NexusTarget{3}=adaptData.getParamInCond({'target'},'Error Clamp');
        NexusTarget{5}=adaptData.getParamInCond({'target'},'Washout Map');
        NexusTarget{4}=adaptData.getParamInCond({'target'},'Washout Error Clamp');
        %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        
        %organize the data
        PossibleTarget=unique(fts{1});
        LLL=max(PossibleTarget);
        SS=min(PossibleTarget);
        MM=median(PossibleTarget);
        DATA=[];
        
        for z = 1:length(fts)
            clear FDATA SDATA NDATA
            for t=1:length(fts{z})
                if fts{z}(t)==LLL
                    FDATA(t)=3;
                elseif fts{z}(t)==SS
                    FDATA(t)=1;
                elseif fts{z}(t)==MM
                    FDATA(t)=2;
                else
                    break
                end
            end
            
            for t=1:length(sts{z})
                if sts{z}(t)==LLL
                    SDATA(t)=3;
                elseif sts{z}(t)==SS
                    SDATA(t)=1;
                elseif sts{z}(t)==MM
                    SDATA(t)=2;
                else
                    break
                end
            end
            
            for t=1:length(NexusTarget{z})
                if NexusTarget{z}(t)==LLL
                    NDATA(t)=3;
                elseif NexusTarget{z}(t)==SS
                    NDATA(t)=1;
                elseif NexusTarget{z}(t)==MM
                    NDATA(t)=2;
                else
                    break
                end
            end
            
            
            %~~~~~~~~~~~~
            for p =1:length(params)+2
                clear data target
                if p==2
                    data=fhits{z};
                    target=FDATA;% same as fts?
                elseif p==1
                    data=shits{z};
                    target=SDATA;% same as fts?
                else
                    data=KinData{z}(:, p-2);
                    target=NDATA;
%                     if ~isempty(findstr('Fast', params{p-2}))
%                         target=FDATA;
%                     elseif ~isempty(findstr('Slow', params{p-2}))
%                         target=SDATA;
%                     end
                end
                t=1;
                r=1;
                DATA{p, z}=[0 0 0];
                
                while t<length(data)
                    if (find(target(t:end)~=target(t),1, 'first')+t-2)>=length(data)
                        DATA{p, z}(r, target(t))=nanmean(data(t:end));
                        break
                    else
                        DATA{p, z}(r, target(t))=nanmean(data(t:(find(target(t:end)~=target(t),1, 'first')+t-2))); %BLAH
                    end
                    t=find(target(t:end)~=target(t),1, 'first')+t-1;
                    if isempty(t)
                        t=length(data);
                    end
                    if  t<length(data) && DATA{p, z}(r, target(t))~=0
                        r=r+1;
                    end
                end
                
            end
        end
        
        %keyboard
        
        eval(['tlist = ' subjects{s} '.triallist;']);
        train = find(strcmp(tlist(:,4),'Familiarization'));%logicals of where training trials are
        base = find(strcmp(tlist(:,4),'Base Map'));
        adapt = find(strcmp(tlist(:,4),'Base Clamp'));
        wash = find(strcmp(tlist(:,4),'Post Clamp'));
        wash2 = find(strcmp(tlist(:,4),'Post Map'));
        for p =1:length(params)+2
            DDATA{p, 1}=DATA{p, wash}-repmat([mean(DATA{p, adapt}(:, 1)) DATA{p, adapt}(end, 2) mean(DATA{p, adapt}(:, 3))], size(DATA{p, wash}, 1), 1);DDATA{p, 1}(1:end-1, 2)=0;% Use the whole Baseline, mean
            DDATA{p, 2}=nanmean(DATA{p, wash2}-DATA{p, base});
        end
        MapShortT=[]; MapMidT=[]; MapLongT=[]; BFafter1T=[]; BFafter2T=[];
        for p =1:length(params)+2
            %Order independent
            MapShortT=[MapShortT, DDATA{p, 2}(1, 1)];
            MapMidT=[MapMidT, DDATA{p, 2}(1, 2)];
            MapLongT=[MapLongT, DDATA{p, 2}(1, 3)];
            
            %Order Dependent
            if fts{3}(1)==SS
                BFafter1T=[BFafter1T, DDATA{p, 1}(1, 1)];
                BFafter2T=[BFafter2T, DDATA{p, 1}(1, 3)];
            else
                BFafter1T=[BFafter1T, DDATA{p, 1}(1, 3)];
                BFafter2T=[BFafter2T, DDATA{p, 1}(1, 1)];
            end
            
        end
        MapShort=[MapShort; MapShortT];
        MapMid=[MapMid; MapMidT];
        MapLong=[MapLong; MapLongT];
        
        %Order Dependent
        BFafter1=[BFafter1; BFafter1T];
        BFafter2=[BFafter2; BFafter2T];
        
    end
    
    nSubs=length(subjects);
    
    resusts.BFafter1.avg(end+1,:)=nanmean(BFafter1,1);
    resusts.BFafter1.se(end+1,:)=nanstd(BFafter1,1, 1)./sqrt(nSubs);
    
    resusts.BFafter2.avg(end+1,:)=nanmean(BFafter2,1);
    resusts.BFafter2.se(end+1,:)=nanstd(BFafter2,1, 1)./sqrt(nSubs);
    
    resusts.MapShort.avg(end+1,:)=nanmean(MapShort,1);
    resusts.MapShort.se(end+1,:)=nanstd(MapShort,1, 1)./sqrt(nSubs);
    
    resusts.MapMid.avg(end+1,:)=nanmean(MapMid,1);
    resusts.MapMid.se(end+1,:)=nanstd(MapMid,1, 1)./sqrt(nSubs);
    
    resusts.MapLong.avg(end+1,:)=nanmean(MapLong,1);
    resusts.MapLong.se(end+1,:)=nanstd(MapLong,1, 1)./sqrt(nSubs);
    
    params=[{'SlowLeg', 'FastLeg'} params];
    if g==1 %This seems ridiculous, but I don't know of another way to do it without making MATLAB mad. The resusts.(whatever).indiv structure needs to be in this format to make life easier for using SPSS
        for p=1:length(params)
            resusts.BFafter1.indiv.(params{p})=[g*ones(nSubs,1) BFafter1(:,p)];
            resusts.BFafter2.indiv.(params{p})=[g*ones(nSubs,1) BFafter2(:,p)];
            resusts.MapShort.indiv.(params{p})=[g*ones(nSubs,1) MapShort(:,p)];
            resusts.MapMid.indiv.(params{p})=[g*ones(nSubs,1) MapMid(:,p)];
            resusts.MapLong.indiv.(params{p})=[g*ones(nSubs,1) MapLong(:,p)];
        end
    else
        for p=1:length(params)
            resusts.BFafter1.indiv.(params{p})(end+1:end+nSubs,1:2)=[g*ones(nSubs,1) BFafter1(:,p)];
            resusts.BFafter2.indiv.(params{p})(end+1:end+nSubs,1:2)=[g*ones(nSubs,1) BFafter2(:,p)];
            resusts.MapShort.indiv.(params{p})(end+1:end+nSubs,1:2)=[g*ones(nSubs,1) MapShort(:,p)];
            resusts.MapMid.indiv.(params{p})(end+1:end+nSubs,1:2)=[g*ones(nSubs,1) MapMid(:,p)];
            resusts.MapLong.indiv.(params{p})(end+1:end+nSubs,1:2)=[g*ones(nSubs,1) MapLong(:,p)];
        end
    end
    params= params(3:end);
end
params=[{'SlowLeg', 'FastLeg'} params];

% %stats
% resultNames=fieldnames(resusts);
% %if StatFlag==1
% namest=[];
% for h=1:length(resultNames)
%     group1=find(resusts.(resultNames{h}).indiv.(params{1})(:, 1)==1);
%     group2=find(resusts.(resultNames{h}).indiv.(params{1})(:, 1)==2);
% for gg=1:length(resusts.(resultNames{h}).indiv.(params{1})(:, 2))
%     namest{gg}=[groups{resusts.(resultNames{h}).indiv.(params{1})(gg, 1)}];
% end
%     for i=1:size(resusts.BFafter1.avg, 2)%size(StatReady, 2)
%         [~, resusts.(resultNames{h}).p(i)]=ttest(resusts.(resultNames{h}).indiv.(params{i})(:, 2));
%
% %         stataData = [resusts.(resultNames{h}).indiv.(params{i})(group1, 2)', resusts.(resultNames{h}).indiv.(params{i})(group2, 2)'];
% %         [ resusts.(resultNames{h}).p(i)] = anova1(stataData, namest);
%     end
% end
% close all
% %SHOULDN'T BE BOTH GROUPS TOGETHER!!!!
% StataReady=[[UltimateSubjects; UltimateSubjects;UltimateSubjects; UltimateSubjects]...
%     num2cell([ones(2.*length(UltimateSubjects), 1); 0.*ones(2.*length(UltimateSubjects), 1)])...
%     num2cell([ones(length(UltimateSubjects), 1); 0.*ones(length(UltimateSubjects), 1); ones(length(UltimateSubjects), 1); 0.*ones(length(UltimateSubjects), 1)])...
%     [num2cell(abs(resusts.BFafter1.indiv.SlowLeg(:,2)));...
%     num2cell(abs(resusts.BFafter1.indiv.FastLeg(:,2)));...
%     num2cell(abs(resusts.BFafter2.indiv.SlowLeg(:,2)));...
%     num2cell(abs(resusts.BFafter2.indiv.FastLeg(:,2)))]...
%     num2cell([ones(length(UltimateSubjects), 1); 2.*ones(length(UltimateSubjects), 1); 3.*ones(length(UltimateSubjects), 1); 4.*ones(length(UltimateSubjects), 1)])...
%     num2cell([ones(length(UltimateSubjects(group1)), 1); 0.*ones(length(UltimateSubjects(group2)), 1);...
%     ones(length(UltimateSubjects(group1)), 1); 0.*ones(length(UltimateSubjects(group2)), 1);...
%     ones(length(UltimateSubjects(group1)), 1); 0.*ones(length(UltimateSubjects(group2)), 1);...
%     ones(length(UltimateSubjects(group1)), 1); 0.*ones(length(UltimateSubjects(group2)), 1)])];
%
%
% StataReady1=[[UltimateSubjects(group1); UltimateSubjects(group1);UltimateSubjects(group1); UltimateSubjects(group1)]...
%     num2cell([ones(2.*length(UltimateSubjects(group1)), 1); 0.*ones(2.*length(UltimateSubjects(group1)), 1)])...
%     num2cell([ones(length(UltimateSubjects(group1)), 1); 0.*ones(length(UltimateSubjects(group1)), 1); ones(length(UltimateSubjects(group1)), 1); 0.*ones(length(UltimateSubjects(group1)), 1)])...
%     [num2cell(resusts.BFafter1.indiv.SlowLeg(group1,2));...
%     num2cell(resusts.BFafter1.indiv.FastLeg(group1,2));...
%     num2cell(resusts.BFafter2.indiv.SlowLeg(group1,2));...
%     num2cell(resusts.BFafter2.indiv.FastLeg(group1,2))]...
%     num2cell([ones(length(UltimateSubjects(group1)), 1); 2.*ones(length(UltimateSubjects(group1)), 1); 3.*ones(length(UltimateSubjects(group1)), 1); 4.*ones(length(UltimateSubjects(group1)), 1)])];
% StataReady2=[[UltimateSubjects(group2); UltimateSubjects(group2);UltimateSubjects(group2); UltimateSubjects(group2)]...
%     num2cell([ones(2.*length(UltimateSubjects(group2)), 1); 0.*ones(2.*length(UltimateSubjects(group2)), 1)])...
%     num2cell([ones(length(UltimateSubjects(group2)), 1); 0.*ones(length(UltimateSubjects(group2)), 1); ones(length(UltimateSubjects(group2)), 1); 0.*ones(length(UltimateSubjects(group2)), 1)])...
%     [num2cell(resusts.BFafter1.indiv.SlowLeg(group2,2));...
%     num2cell(resusts.BFafter1.indiv.FastLeg(group2,2));...
%     num2cell(resusts.BFafter2.indiv.SlowLeg(group2,2));...
%     num2cell(resusts.BFafter2.indiv.FastLeg(group2,2))]...
%     num2cell([ones(length(UltimateSubjects(group2)), 1); 2.*ones(length(UltimateSubjects(group2)), 1); 3.*ones(length(UltimateSubjects(group2)), 1); 4.*ones(length(UltimateSubjects(group2)), 1)])];
%
% %Group 1: Short Slow
% %Group 2: Short Fast
% %Group 3: Long Slow
% %Group 4: Long Fast
%
% MapMaintance1=[[UltimateSubjects(group1); UltimateSubjects(group1); UltimateSubjects(group1); UltimateSubjects(group1); UltimateSubjects(group1); UltimateSubjects(group1)]...
%     num2cell([ones(2.*length(UltimateSubjects(group1)), 1); 2.*ones(2.*length(UltimateSubjects(group1)), 1); 3.*ones(2.*length(UltimateSubjects(group1)), 1)])...
%     num2cell([ones(length(UltimateSubjects(group1)), 1); 0.*ones(length(UltimateSubjects(group1)), 1); ones(length(UltimateSubjects(group1)), 1); 0.*ones(length(UltimateSubjects(group1)), 1); ones(length(UltimateSubjects(group1)), 1); 0.*ones(length(UltimateSubjects(group1)), 1)])...
%     [num2cell(resusts.MapShort.indiv.SlowLeg((group1),2));...
%     num2cell(resusts.MapShort.indiv.FastLeg((group1),2));...
%     num2cell(resusts.MapMid.indiv.SlowLeg((group1),2));...
%     num2cell(resusts.MapMid.indiv.FastLeg((group1),2));...
%     num2cell(resusts.MapLong.indiv.SlowLeg((group1),2));...
%     num2cell(resusts.MapLong.indiv.FastLeg((group1),2))]];%...
%     %num2cell([ones(length(UltimateSubjects), 1); 2.*ones(length(UltimateSubjects), 1); 3.*ones(length(UltimateSubjects), 1); 4.*ones(length(UltimateSubjects), 1); 5.*ones(length(UltimateSubjects), 1); 6.*ones(length(UltimateSubjects), 1)])];
%
% MapMaintance=[[UltimateSubjects; UltimateSubjects;UltimateSubjects; UltimateSubjects;UltimateSubjects; UltimateSubjects]...
%     num2cell([ones(2.*length(UltimateSubjects), 1); 2.*ones(2.*length(UltimateSubjects), 1); 3.*ones(2.*length(UltimateSubjects), 1)])...
%     num2cell([ones(length(UltimateSubjects), 1); 0.*ones(length(UltimateSubjects), 1); ones(length(UltimateSubjects), 1); 0.*ones(length(UltimateSubjects), 1); ones(length(UltimateSubjects), 1); 0.*ones(length(UltimateSubjects), 1)])...
%     [num2cell(resusts.MapShort.indiv.SlowLeg(:,2));...
%     num2cell(resusts.MapShort.indiv.FastLeg(:,2));...
%     num2cell(resusts.MapMid.indiv.SlowLeg(:,2));...
%     num2cell(resusts.MapMid.indiv.FastLeg(:,2));...
%     num2cell(resusts.MapLong.indiv.SlowLeg(:,2));...
%     num2cell(resusts.MapLong.indiv.FastLeg(:,2))]...
%     num2cell([ones(length(UltimateSubjects), 1); 2.*ones(length(UltimateSubjects), 1); 3.*ones(length(UltimateSubjects), 1); 4.*ones(length(UltimateSubjects), 1); 5.*ones(length(UltimateSubjects), 1); 6.*ones(length(UltimateSubjects), 1)])];
%plot stuff
if plotFlag
    epochs={'BFafter1','BFafter2', 'MapShort', 'MapMid', 'MapLong'};
    if nargin>3 %I imagine there has to be a better way to do this...
        barGroups(SMatrix,resusts,groups,params,epochs,indivFlag)
    else
        barGroups(SMatrix,resusts,groups,params,epochs)
    end
end


