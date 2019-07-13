function results = getResultsBF(SMatrix,groups, params,plotFlag,indivFlag)

params=[{'SlowLeg', 'FastLeg'} params];

% define number of points to use for calculating values
catchNumPts = 3; %catch
steadyNumPts = 40; %end of adaptation
transientNumPts = 5; %OG and Washout

if nargin<3 || isempty(groups)
    groups=fields(SMatrix);  %default
end
ngroups=length(groups);


% Initialize values to calculate
results.BFafter1.avg=[];
results.BFafter1.se=[];

results.BFafter2.avg=[];
results.BFafter2.se=[];

results.MapShort.avg=[];
results.MapShort.se=[];

results.MapMid.avg=[];
results.MapMid.se=[];

results.MapLong.avg=[];
results.MapLong.se=[];

UltimateSubjects=[];
for g=1:ngroups
    
    % get subjects in group
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
         eval(['[rhits, lhits, rts, lts, ~]=' subjects{s} '.getHits();']);
        elseif fastleg=='l'
            eval(['[lhits, rhits, lts, rts, ~]=' subjects{s} '.getHits();']);
        end
        
        RDATA=[];
        LDATA=[];
        %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        % load subject
        adaptData=SMatrix.(groups{g}).adaptData{s};
%                 % remove baseline bias
%         adaptData=adaptData.removeBadStrides;
%         if  ~exist('removeBias') || removeBias==1
%              adaptData=adaptData.removeBias;
%         end
%        
        kinparam={'alphaFast', 'alphaSlow'};
        KinData{1}=adaptData.getParamInCond(kinparam,'Familiarization');
        KinData{2}=adaptData.getParamInCond(kinparam,'Map');
        KinData{3}=adaptData.getParamInCond(kinparam,'Error Clamp');
        KinData{5}=adaptData.getParamInCond(kinparam,'Washout Map');
        KinData{4}=adaptData.getParamInCond(kinparam,'Washout Error Clamp');
        %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

        %organize the data
        PossibleTarget=unique(rts{1});
        LLL=max(PossibleTarget);
        SS=min(PossibleTarget);
        MM=median(PossibleTarget);
        
        for z = 1:length(rts)
            
            for t=1:length(rts{z})
                if rts{z}(t)==LLL
                    RDATA(t)=3;
                elseif rts{z}(t)==SS
                    RDATA(t)=1;
                elseif rts{z}(t)==MM
                    RDATA(t)=2;
                else
                    break
                end
            end
            
            for t=1:length(lts{z})
                if lts{z}(t)==LLL
                    LDATA(t)=3;
                elseif lts{z}(t)==SS
                    LDATA(t)=1;
                elseif lts{z}(t)==MM
                    LDATA(t)=2;
                else
                    break
                end
            end
            
            t=1;
            r=1;
            RR{z}=[0, 0, 0];
            RRkin{z}=[0 0 0];
                          %new, removing outliers
%                         badR=[find(rhits{z}>=0.255); find(rhits{z}<=-0.255)];
%                         rhits{z}(badR)=NaN;
%                         badL=[find(lhits{z}>=0.255); find(lhits{z}<=-0.255)];
%                         lhits{z}(badR)=NaN;

                        while t<length(rts{z})
                                RR{z}(r, RDATA(t))=nanmean(rhits{z}(t:(find(RDATA(t:end)~=RDATA(t),1, 'first')+t-2))); %BLAH
                                RRkin{z}(r, RDATA(t))=nanmean(KinData{z}(t:(find(RDATA(t:end)~=RDATA(t),1, 'first')+t-2), 1));%Kinematic Data
                            if isnan(RR{z}(r, RDATA(t)))
                                RR{z}(r, RDATA(t))=nanmean(rhits{z}(t:end));
                                RRkin{z}(r, RDATA(t))=nanmean(KinData{z}(t:end, 1));%Kinematic Data
                            end
                            t=find(RDATA(t:end)~=RDATA(t),1, 'first')+t-1;
                            if isempty(t)
                                t=length(rts{z});
                            end
                            if  RR{z}(r, RDATA(t))~=0;
                                r=r+1;
                            end
                        end
                        t=1;
                        r=1;
                        LL{z}=[0, 0, 0];
                        while t<length(lts{z})
%                             if strcmp(this.triallist{z,4},'Post Clamp')
%                                 LL{z}(r, LDATA(t))=mean(lhits{z}(t+1:t+3));%(find(LDATA(t:end)~=LDATA(t),1, 'first')+t-2)));%BLAH
%                             else
                                LL{z}(r, LDATA(t))=nanmean(lhits{z}(t:(find(LDATA(t:end)~=LDATA(t),1, 'first')+t-2)));%BLAH
%                             end
                            if isnan(LL{z}(r, LDATA(t)))
                                LL{z}(r, LDATA(t))=nanmean(lhits{z}(t:end));
                            end
                            t=find(LDATA(t:end)~=LDATA(t),1, 'first')+t-1;
                            if isempty(t)
                                t=length(lts{z});
                            end
                            if  LL{z}(r,LDATA(t))~=0;
                                r=r+1;
                            end
                        end
                        clear RDATA LDATA
                    end

                    eval(['tlist = ' subjects{s} '.triallist;']);
                    train = find(strcmp(tlist(:,4),'Familiarization'));%logicals of where training trials are
                    base = find(strcmp(tlist(:,4),'Base Map'));
                    adapt = find(strcmp(tlist(:,4),'Base Clamp'));
                    wash = find(strcmp(tlist(:,4),'Post Clamp'));
                    wash2 = find(strcmp(tlist(:,4),'Post Map'));

                             %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%                     if  length(wash)==2
%                         DDR{1}=[RR{wash(1)}(1:2, :)]-[RR{adapt(1)}(1:2, :)];
%                         DDR{2}=nanmean(RR{wash2}-RR{base});
%                         keyboard
%                         DDL{1}=[LL{wash(1)}(1:2, :)]-[LL{adapt(1)}(1:2, :)];
%                         DDL{2}=nanmean(LL{wash2}-LL{base});
%                     else
                        %DDR{1}=RR{wash}-RR{adapt};%Tit4tat:base subtraction
                        %DDR{1}=RR{wash}-repmat(RR{adapt}(end, :), size(RR{wash}, 1), 1);% Use the Baseline SS
                        DDR{1}=RR{wash}-repmat([mean(RR{adapt}(:, 1)) RR{adapt}(end, 2) mean(RR{adapt}(:, 3))], size(RR{wash}, 1), 1);DDR{1}(1:end-1, 2)=0;% Use the whole Baseline, mean
                        DDR_Kin{1}=RRkin{wash}-repmat([mean(RRkin{adapt}(:, 1)) RRkin{adapt}(end, 2) mean(RRkin{adapt}(:, 3))], size(RRkin{wash}, 1), 1);DDR_Kin{1}(1:end-1, 2)=0;% Use the whole Baseline, mean
                        
                        %DDR{1}=RR{wash}-repmat([median(RR{adapt}(:, 1)) RR{adapt}(end, 2) median(RR{adapt}(:, 3))], size(RR{wash}, 1), 1);DDR{1}(1:end-1, 2)=0;% Use the whole Baseline, median
                        DDR{2}=nanmean(RR{wash2}-RR{base});
                        DDR_Kin{2}=nanmean(RRkin{wash2}-RRkin{base});
                        
                        %DDL{1}=LL{wash}-LL{adapt};%Tit4tat:base subtraction
                        %DDL{1}=LL{wash}-repmat(LL{adapt}(end, :), size(LL{wash}, 1), 1);% Use the Baseline SS
                        DDL{1}=LL{wash}-repmat([mean(LL{adapt}(:, 1)) LL{adapt}(end, 2) mean(LL{adapt}(:, 3))], size(LL{wash}, 1), 1);DDL{1}(1:end-1, 2)=0;% Use the whole Baseline, mean
                       % DDL{1}=LL{wash}-repmat([median(LL{adapt}(:, 1)) LL{adapt}(end, 2) median(LL{adapt}(:, 3))], size(LL{wash}, 1), 1);DDL{1}(1:end-1, 2)=0;% Use the whole Baseline, median
                        DDL{2}=nanmean(LL{wash2}-LL{base});
%                     end
                    %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        
        eval(['fastleg=' subjects{s} '.fastleg;']);
        if fastleg=='r'
            %Order independent
            MapShort=[MapShort; DDL{2}(1, 1) DDR{2}(1, 1)];
            MapMid=[MapMid; DDL{2}(1, 2) DDR{2}(1, 2)];
            MapLong=[MapLong; DDL{2}(1, 3) DDR{2}(1, 3)];
            %Order Dependent
            if rts{3}(1)==SS
                BFafter1=[BFafter1; DDL{1}(1, 1) DDR{1}(1, 1) DDR_Kin{1}(1, 1)];
                BFafter2=[BFafter2; DDL{1}(1, 3) DDR{1}(1, 3) DDR_Kin{1}(1, 3)];
            else
                BFafter1=[BFafter1; DDL{1}(1, 3) DDR{1}(1, 3) DDR_Kin{1}(1, 3)];
                BFafter2=[BFafter2; DDL{1}(1, 1) DDR{1}(1, 1) DDR_Kin{1}(1, 1)];
            end
        elseif fastleg=='l'
            %Order independent
            MapShort=[MapShort; DDR{2}(1, 1) DDL{2}(1, 1)];
            MapMid=[MapMid; DDR{2}(1, 2) DDL{2}(1, 2)];
            MapLong=[MapLong; DDR{2}(1, 3) DDL{2}(1, 3)];
            %Order Dependent
            if rts{3}(1)==SS
                BFafter1=[BFafter1; DDR{1}(1, 1) DDL{1}(1, 1)];
                BFafter2=[BFafter2; DDR{1}(1, 3) DDL{1}(1, 3)];
            else
                BFafter1=[BFafter1; DDR{1}(1, 3) DDL{1}(1, 3)];
                BFafter2=[BFafter2; DDR{1}(1, 1) DDL{1}(1, 1)];
            end
        else
            cprintf('err','WARNING: Which leg is fast????');
        end
        
        
        
    end
    
    nSubs=length(subjects);
    
    results.BFafter1.avg(end+1,:)=nanmean(BFafter1,1);
    results.BFafter1.se(end+1,:)=nanstd(BFafter1,1)./sqrt(nSubs);
    
    results.BFafter2.avg(end+1,:)=nanmean(BFafter2,1);
    results.BFafter2.se(end+1,:)=nanstd(BFafter2,1)./sqrt(nSubs);
    
    results.MapShort.avg(end+1,:)=nanmean(MapShort,1);
    results.MapShort.se(end+1,:)=nanstd(MapShort,1)./sqrt(nSubs);
    
    results.MapMid.avg(end+1,:)=nanmean(MapMid,1);
    results.MapMid.se(end+1,:)=nanstd(MapMid,1)./sqrt(nSubs);
    
    results.MapLong.avg(end+1,:)=nanmean(MapLong,1);
    results.MapLong.se(end+1,:)=nanstd(MapLong,1)./sqrt(nSubs);
    
    
    if g==1 %This seems ridiculous, but I don't know of another way to do it without making MATLAB mad. The results.(whatever).indiv structure needs to be in this format to make life easier for using SPSS
        for p=1:length(params)
            results.BFafter1.indiv.(params{p})=[g*ones(nSubs,1) BFafter1(:,p)];
            results.BFafter2.indiv.(params{p})=[g*ones(nSubs,1) BFafter2(:,p)];
            results.MapShort.indiv.(params{p})=[g*ones(nSubs,1) MapShort(:,p)];
            results.MapMid.indiv.(params{p})=[g*ones(nSubs,1) MapMid(:,p)];
            results.MapLong.indiv.(params{p})=[g*ones(nSubs,1) MapLong(:,p)];
        end
    else
        for p=1:length(params)
            results.BFafter1.indiv.(params{p})(end+1:end+nSubs,1:2)=[g*ones(nSubs,1) BFafter1(:,p)];
            results.BFafter2.indiv.(params{p})(end+1:end+nSubs,1:2)=[g*ones(nSubs,1) BFafter2(:,p)];
            results.MapShort.indiv.(params{p})(end+1:end+nSubs,1:2)=[g*ones(nSubs,1) MapShort(:,p)];
            results.MapMid.indiv.(params{p})(end+1:end+nSubs,1:2)=[g*ones(nSubs,1) MapMid(:,p)];
            results.MapLong.indiv.(params{p})(end+1:end+nSubs,1:2)=[g*ones(nSubs,1) MapLong(:,p)];
        end
    end
end

% %stats
% resultNames=fieldnames(results);
% %if StatFlag==1
% namest=[];
% for h=1:length(resultNames)
%     group1=find(results.(resultNames{h}).indiv.(params{1})(:, 1)==1);
%     group2=find(results.(resultNames{h}).indiv.(params{1})(:, 1)==2);
% for gg=1:length(results.(resultNames{h}).indiv.(params{1})(:, 2))
%     namest{gg}=[groups{results.(resultNames{h}).indiv.(params{1})(gg, 1)}];
% end
%     for i=1:size(results.BFafter1.avg, 2)%size(StatReady, 2)
%         [~, results.(resultNames{h}).p(i)]=ttest(results.(resultNames{h}).indiv.(params{i})(:, 2));
%         
% %         stataData = [results.(resultNames{h}).indiv.(params{i})(group1, 2)', results.(resultNames{h}).indiv.(params{i})(group2, 2)'];
% %         [ results.(resultNames{h}).p(i)] = anova1(stataData, namest);
%     end
% end
% close all
% %SHOULDN'T BE BOTH GROUPS TOGETHER!!!!
% StataReady=[[UltimateSubjects; UltimateSubjects;UltimateSubjects; UltimateSubjects]...
%     num2cell([ones(2.*length(UltimateSubjects), 1); 0.*ones(2.*length(UltimateSubjects), 1)])...
%     num2cell([ones(length(UltimateSubjects), 1); 0.*ones(length(UltimateSubjects), 1); ones(length(UltimateSubjects), 1); 0.*ones(length(UltimateSubjects), 1)])...
%     [num2cell(abs(results.BFafter1.indiv.SlowLeg(:,2)));...
%     num2cell(abs(results.BFafter1.indiv.FastLeg(:,2)));...
%     num2cell(abs(results.BFafter2.indiv.SlowLeg(:,2)));...
%     num2cell(abs(results.BFafter2.indiv.FastLeg(:,2)))]...
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
%     [num2cell(results.BFafter1.indiv.SlowLeg(group1,2));...
%     num2cell(results.BFafter1.indiv.FastLeg(group1,2));...
%     num2cell(results.BFafter2.indiv.SlowLeg(group1,2));...
%     num2cell(results.BFafter2.indiv.FastLeg(group1,2))]...
%     num2cell([ones(length(UltimateSubjects(group1)), 1); 2.*ones(length(UltimateSubjects(group1)), 1); 3.*ones(length(UltimateSubjects(group1)), 1); 4.*ones(length(UltimateSubjects(group1)), 1)])];
% StataReady2=[[UltimateSubjects(group2); UltimateSubjects(group2);UltimateSubjects(group2); UltimateSubjects(group2)]...
%     num2cell([ones(2.*length(UltimateSubjects(group2)), 1); 0.*ones(2.*length(UltimateSubjects(group2)), 1)])...
%     num2cell([ones(length(UltimateSubjects(group2)), 1); 0.*ones(length(UltimateSubjects(group2)), 1); ones(length(UltimateSubjects(group2)), 1); 0.*ones(length(UltimateSubjects(group2)), 1)])...
%     [num2cell(results.BFafter1.indiv.SlowLeg(group2,2));...
%     num2cell(results.BFafter1.indiv.FastLeg(group2,2));...
%     num2cell(results.BFafter2.indiv.SlowLeg(group2,2));...
%     num2cell(results.BFafter2.indiv.FastLeg(group2,2))]...
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
%     [num2cell(results.MapShort.indiv.SlowLeg((group1),2));...
%     num2cell(results.MapShort.indiv.FastLeg((group1),2));...
%     num2cell(results.MapMid.indiv.SlowLeg((group1),2));...
%     num2cell(results.MapMid.indiv.FastLeg((group1),2));...
%     num2cell(results.MapLong.indiv.SlowLeg((group1),2));...
%     num2cell(results.MapLong.indiv.FastLeg((group1),2))]];%...
%     %num2cell([ones(length(UltimateSubjects), 1); 2.*ones(length(UltimateSubjects), 1); 3.*ones(length(UltimateSubjects), 1); 4.*ones(length(UltimateSubjects), 1); 5.*ones(length(UltimateSubjects), 1); 6.*ones(length(UltimateSubjects), 1)])];
% 
% MapMaintance=[[UltimateSubjects; UltimateSubjects;UltimateSubjects; UltimateSubjects;UltimateSubjects; UltimateSubjects]...
%     num2cell([ones(2.*length(UltimateSubjects), 1); 2.*ones(2.*length(UltimateSubjects), 1); 3.*ones(2.*length(UltimateSubjects), 1)])...
%     num2cell([ones(length(UltimateSubjects), 1); 0.*ones(length(UltimateSubjects), 1); ones(length(UltimateSubjects), 1); 0.*ones(length(UltimateSubjects), 1); ones(length(UltimateSubjects), 1); 0.*ones(length(UltimateSubjects), 1)])...
%     [num2cell(results.MapShort.indiv.SlowLeg(:,2));...
%     num2cell(results.MapShort.indiv.FastLeg(:,2));...
%     num2cell(results.MapMid.indiv.SlowLeg(:,2));...
%     num2cell(results.MapMid.indiv.FastLeg(:,2));...
%     num2cell(results.MapLong.indiv.SlowLeg(:,2));...
%     num2cell(results.MapLong.indiv.FastLeg(:,2))]...
%     num2cell([ones(length(UltimateSubjects), 1); 2.*ones(length(UltimateSubjects), 1); 3.*ones(length(UltimateSubjects), 1); 4.*ones(length(UltimateSubjects), 1); 5.*ones(length(UltimateSubjects), 1); 6.*ones(length(UltimateSubjects), 1)])];
%plot stuff
if plotFlag
    epochs={'BFafter1','BFafter2', 'MapShort', 'MapMid', 'MapLong'};
    if nargin>3 %I imagine there has to be a better way to do this...
        barGroups(SMatrix,results,groups,params,epochs,indivFlag)
    else
        barGroups(SMatrix,results,groups,params,epochs)
    end
end


