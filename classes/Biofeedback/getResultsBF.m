function [resusts, DATA] = getResustsBF(SMatrix,groups, params,plotFlag,indivFlag, removeBias)

% define number of points to use for calculating values
catchNumPts = 3; %catch
steadyNumPts = 40; %end of adaptation
transientNumPts = 5; %OG and Washout

if nargin<3 || isempty(groups)
    groups=fields(SMatrix);  %default
end

ngroups=length(groups);

% Initialize values to calculate
% resusts.BFafter1.avg=[];
% resusts.BFafter1.se=[];
%
% resusts.BFafter2.avg=[];
% resusts.BFafter2.se=[];


resusts.BFafter1S1.avg=[]; resusts.BFafter1S1.se=[];
resusts.BFafter3S2.avg=[]; resusts.BFafter3S2.se=[];
resusts.BFafter5S3.avg=[]; resusts.BFafter5S3.se=[];
resusts.BFafter7S4.avg=[]; resusts.BFafter7S4.se=[];
resusts.BFafter9S5.avg=[]; resusts.BFafter9S5.se=[];
resusts.BFafter11S6.avg=[]; resusts.BFafter11S6.se=[];
resusts.BFafter2L1.avg=[]; resusts.BFafter2L1.se=[];
resusts.BFafter4L2.avg=[]; resusts.BFafter4L2.se=[];
resusts.BFafter6L3.avg=[]; resusts.BFafter6L3.se=[];
resusts.BFafter8L4.avg=[]; resusts.BFafter8L4.se=[];
resusts.BFafter10L5.avg=[]; resusts.BFafter10L5.se=[];
resusts.BFafter12L6.avg=[]; resusts.BFafter12L6.se=[];
resusts.BFafter13M1.avg=[]; resusts.BFafter13M1.se=[];

resusts.BF_ShortLongbase.avg=[];
resusts.BF_ShortLongbase.se=[];

resusts.BF_ShortLongAE.avg=[];
resusts.BF_ShortLongAE.se=[];

resusts.MapShortDiff.avg=[];
resusts.MapShortDiff.se=[];

resusts.MapMidDiff.avg=[];
resusts.MapMidDiff.se=[];

resusts.MapLongDiff.avg=[];
resusts.MapLongDiff.se=[];

resusts.MapShortBase.avg=[];
resusts.MapShortBase.se=[];

resusts.MapMidBase.avg=[];
resusts.MapMidBase.se=[];

resusts.MapLongBase.avg=[];
resusts.MapLongBase.se=[];

resusts.ShortBaseAvg.avg=[];
resusts.ShortBaseAvg.se=[];

resusts.MidBaseAvg.avg=[];
resusts.MidBaseAvg.se=[];

resusts.LongBaseAvg.avg=[];
resusts.LongBaseAvg.se=[];

resusts.ShortBaseVar.avg=[];
resusts.ShortBaseVar.se=[];

resusts.MidBaseVar.avg=[];
resusts.MidBaseVar.se=[];

resusts.LongBaseVar.avg=[];
resusts.LongBaseVar.se=[];

resusts.DeltaAdapt.avg=[];
resusts.DeltaAdapt.se=[];

resusts.TMSteady.avg=[];
resusts.TMSteady.se=[];

resusts.catch.avg=[];
resusts.catch.se=[];

resusts.washout.avg=[];
resusts.washout.se=[];

resusts.DecayRateShort.avg=[];
resusts.DecayRateShort.se=[];

resusts.DecayRateLong.avg=[];
resusts.DecayRateLong.se=[];

resusts.DeltaTarget.avg=[];
resusts.DeltaTarget.se=[];

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
    MapShortBase=[];
    MapMidBase=[];
    MapLongBase=[];
    ShortBaseAvg=[];
    MidBaseAvg=[];
    LongBaseAvg=[];
    ShortBaseVar=[];
    MidBaseVar=[];
    LongBaseVar=[];
    BF_ShortLongbase=[];
    BF_ShortLongAE=[];
    DeltaAdapt=[];
    avgAdaptAll=[];
    TMSteady=[];
    tmCatch=[];
    washout=[];
    BFafter1S1=[];
    BFafter3S2=[];
    BFafter5S3=[];
    BFafter7S4=[];
    BFafter9S5=[];
    BFafter11S6=[];
    BFafter2L1=[];
    BFafter4L2=[];
    BFafter6L3=[];
    BFafter8L4=[];
    BFafter10L5=[];
    BFafter12L6=[];
    BFafter13M1=[];
    %DeltaTarget=[];
                DecayRateShort=[];
            DecayRateLong=[];
    for s=1:length(subjects)
        %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        % load subject
        adaptData=SMatrix.(groups{g}).adaptData{s};
        %                 % remove baseline bias
               %  adaptData=adaptData.removeBadStrides;
%         if  ~exist('removeBias') || removeBias==1
%             adaptData=adaptData.removeBias;
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
        removeTarget=0;
        if removeTarget
            KinData=cellfun(@(x) x/1000,KinData,'un',0);%Change units of kin Data
            if length(params)>1
                NexusTargetTEMP=cellfun(@(x) repmat(x,1,2),NexusTarget,'UniformOutput',false);
                KinData=cellfun(@minus,KinData,NexusTargetTEMP,'UniformOutput',false);%Change so that it is the error from the
            else
                KinData=cellfun(@minus,KinData,NexusTarget,'UniformOutput',false);%Change so that it is the error from the
            end
        end
        %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        
        %organize the data
        PossibleTarget=unique(NexusTarget{1});
        LLL=nanmax(PossibleTarget);
        SS=nanmin(PossibleTarget);
        MM=nanmedian(PossibleTarget);
        DATA=[];
        
        for z = 1:length(NexusTarget)% Number of Conditions
            clear NDATA
            for t=1:length(NexusTarget{z})
                if NexusTarget{z}(t)==LLL
                    NDATA(t)=3;
                elseif NexusTarget{z}(t)==SS
                    NDATA(t)=1;
                elseif NexusTarget{z}(t)==MM
                    NDATA(t)=2;
                elseif isnan(NexusTarget{z}(t))
                    NDATA(t)=NaN;
                else
                    break
                end
            end
            
            %~~~~~~~~~~~~
            for p =1:length(params)
                if exist('NDATA')==0
                    for p =1:length(params)
                        DATA{p, z}=NaN.*ones(2, 3);
                    end
                    break
                end
                clear data target
                data=KinData{z}(:, p);
                target=NDATA;
                t=1;
                r=1;
                [~, occ]=mode(target([find(diff(target)), end])); %occ tells you the number of sets that were in a trial
                DATA{p, z}=NaN.*ones(occ, 3);
                if z==4
                    Stream{p}=[data data data];
                    for ttt=1:3
                        Stream{p}(find(target~=ttt), ttt)=NaN;
                    end
                end
                target(isnan(target))=[];
                
                while t<length(data)
                    if isempty(find(target(t:end)~=target(t),1, 'first')+t-2) || (find(target(t:end)~=target(t),1, 'first')+t-2)>=length(data)% end of the trial has been reached
                        if length(unique(NDATA))==1
                            DATA{p, z}=NaN.*ones(2, 3);
                            DATA{p, z}(r, target(t))=nanmean(data(t:10));
                            DATA{p, z}(r+1, target(t))=nanmean(data(t:end));
                        else
                            DATA{p, z}(r, target(t))=nanmean(data(t:end));
                        end
                        break
                    else
                        DATA{p, z}(r, target(t))=nanmean(data(t:(find(target(t:end)~=target(t),1, 'first')+t-2))); %Still in the middle of the trial
                        
                    end                  
                    if isnan(DATA{p, z}(r, target(t)))
                        %keyboard%CJS
                    end
                    t=find(target(t:end)~=target(t),1, 'first')+t-1+5;% I AM ADDING 5 TO IGNOR THE TRANSITIONS!!! WHICH I WASN'T DOING PRIOR TO 5/13 in the lab tools BF analysis
                    if isempty(t)
                        t=length(data);
                    end
                    if  t<length(data) && isnan(DATA{p, z}(r, target(t)))~=1
                        r=r+1;
                    end
                end
                
            end
        end
        
        train=1; base=2; adapt=3; wash=4; wash2=5;
        
        MapShortT=[]; MapMidT=[]; MapLongT=[];
        for p =1:length(params)
            %Order independent
            MapShortT=[MapShortT, nanmean(DATA{p, base}(:, 1))-(SS*1000)];
            MapMidT=[MapMidT, nanmean(DATA{p, base}(:, 2))-(MM*1000)];
            MapLongT=[MapLongT, nanmean(DATA{p, base}(:, 3))-(LLL*1000)];
            
        end
        MapShortBase=[MapShortBase; MapShortT];
        MapMidBase=[MapMidBase; MapMidT];
        MapLongBase=[MapLongBase; MapLongT];
        
        
        % %         %keyboard
        % %         eval(['tlist = ' subjects{s} '.triallist;']);
        % %         train = find(strcmp(tlist(:,4),'Familiarization'));%logicals of where training trials are
        % %         base = find(strcmp(tlist(:,4),'Base Map'));
        % %         adapt = find(strcmp(tlist(:,4),'Base Clamp'));
        % %         wash = find(strcmp(tlist(:,4),'Post Clamp'));
        % %         wash2 = find(strcmp(tlist(:,4),'Post Map'));
        
        
        
        ShortBaseAvgT=[];MidBaseAvgT=[];LongBaseAvgT=[];
        ShortBaseVarT=[];MidBaseVarT=[];LongBaseVarT=[];
        BF_ShortLongbaseT=[];BF_ShortLongAET=[];
        for p =1:length(params)
            DDATA{p, 1}=DATA{p, wash}-repmat([nanmean(DATA{p, adapt})], size(DATA{p, wash}, 1), 1);
            Stream{p}=Stream{p}(:, :)-repmat([nanmean(DATA{p, adapt})], size(Stream{p}, 1), 1);
            if ~isnan(DDATA{p, 1}(1, 3))
                DDATA{p, 1}(1:end-1, 2)=0;% Use the whole Baseline, mean
            end
            DDATA{p, 2}=nanmean(DATA{p, wash2}-DATA{p, base});
            
            ShortBaseAvgT=[ShortBaseAvgT, nanmean(DATA{p, adapt}(:, 1))];
            MidBaseAvgT=[MidBaseAvgT, nanmean(DATA{p, adapt}(:, 2))];
            LongBaseAvgT=[LongBaseAvgT, nanmean(DATA{p, adapt}(:, 3))];
            
            ShortBaseVarT=[ShortBaseVarT, nanstd(DATA{p, adapt}(:, 1))];
            MidBaseVarT=[MidBaseVarT, nanstd(DATA{p, adapt}(:, 2))];
            LongBaseVarT=[LongBaseVarT, nanstd(DATA{p, adapt}(:, 3))];
            
            %             BF_ShortLongbaseT=[BF_ShortLongbaseT, nanmean(abs([DATA{p, adapt}(:, 1); DATA{p, adapt}(:, 3)]))];
            %             BF_ShortLongAET=[BF_ShortLongAET, nanmean(abs(DATA{p, wash}(1, [1,3])))];
            BF_ShortLongbaseT=[BF_ShortLongbaseT, abs(nanmean([DATA{p, adapt}(:, 1); DATA{p, adapt}(:, 3)]))];
            BF_ShortLongAET=[BF_ShortLongAET, abs(nanmean(DATA{p, wash}(1, [1,3])))];
        end
        ShortBaseAvg=[ShortBaseAvg; ShortBaseAvgT];
        MidBaseAvg=[MidBaseAvg; MidBaseAvgT];
        LongBaseAvg=[LongBaseAvg; LongBaseAvgT];
        
        ShortBaseVar=[ShortBaseVar; ShortBaseVarT];
        MidBaseVar=[MidBaseVar; MidBaseVarT];
        LongBaseVar=[LongBaseVar; LongBaseVarT];
        
        BF_ShortLongbase=[BF_ShortLongbase; BF_ShortLongbaseT];
        BF_ShortLongAE=[BF_ShortLongAE; BF_ShortLongAET];
        %DDATA{p, 1}=reduced error trials
        %DDATA{p, 2}=washout trials
        
        MapShortT=[]; MapMidT=[]; MapLongT=[]; BFafter1T=[]; BFafter2T=[];
        BFafter1TS1=[];BFafter3TS2=[];BFafter5TS3=[];BFafter7TS4=[];BFafter9TS5=[]; BFafter11TS6=[];
        BFafter2TL1=[];BFafter4TL2=[];BFafter6TL3=[];BFafter8TL4=[];BFafter10TL5=[];BFafter12TL6=[];BFafter13TM1=[];
        
        for p =1:length(params)
            %Order independent
            MapShortT=[MapShortT, DDATA{p, 2}(1, 1)];
            MapMidT=[MapMidT, DDATA{p, 2}(1, 2)];
            MapLongT=[MapLongT, DDATA{p, 2}(1, 3)];
            
            oneTar=unique(NexusTarget{3});
            oneTar(find(isnan(oneTar)==1))=[];
            
            %Order Dependent
            if NexusTarget{3}(1)==SS
                BFafter1TS1=[BFafter1TS1, DDATA{p, 1}(1, 1)];
                BFafter3TS2=[BFafter3TS2, DDATA{p, 1}(2, 1)];
                BFafter5TS3=[BFafter5TS3, DDATA{p, 1}(3, 1)];
                BFafter7TS4=[BFafter7TS4, DDATA{p, 1}(4, 1)];
                BFafter9TS5=[BFafter9TS5, DDATA{p, 1}(5, 1)];
                BFafter11TS6=[BFafter11TS6, DDATA{p, 1}(6, 1)];
                if ~isnan(DDATA{p, 1}(1, 3))
                    BFafter2TL1=[BFafter2TL1, DDATA{p, 1}(1, 3)];
                    BFafter4TL2=[BFafter4TL2, DDATA{p, 1}(2, 3)];
                    BFafter6TL3=[BFafter6TL3, DDATA{p, 1}(3, 3)];
                    BFafter8TL4=[BFafter8TL4, DDATA{p, 1}(4, 3)];
                    BFafter10TL5=[BFafter10TL5, DDATA{p, 1}(5, 3)];
                    BFafter12TL6=[BFafter12TL6, DDATA{p, 1}(6, 3)];
                    BFafter13TM1=[BFafter13TM1, DDATA{p, 1}(6, 2)];
                elseif ~isnan(DDATA{p, 1}(1, 2))
                    BFafter2T=[BFafter2T, DDATA{p, 1}(1, 2)];
                end
            elseif length(oneTar)==1
                BFafter1T=[BFafter1T, DDATA{p, 1}(1, find(~isnan(DDATA{p, 1}(1,:))))];
                BFafter2T=[BFafter2T, NaN];
            else
                
                disp('THIS PROBABLY DOESN"T WORK!')
                keyboard
                BFafter1T=[BFafter1T, DDATA{p, 1}(1, 3)];
                BFafter2T=[BFafter2T, DDATA{p, 1}(1, 1)];
                
            end
            
            
        end 
        MapShort=[MapShort; MapShortT];
        MapMid=[MapMid; MapMidT];
        MapLong=[MapLong; MapLongT];
        
        %Order Dependent
        %         BFafter1=[BFafter1; BFafter1T];
        %         BFafter2=[BFafter2; BFafter2T];
        BFafter1S1=[BFafter1S1; BFafter1TS1];
        BFafter3S2=[BFafter3S2;BFafter3TS2];
        BFafter5S3=[BFafter5S3;BFafter5TS3];
        BFafter7S4=[BFafter7S4;BFafter7TS4];
        BFafter9S5=[BFafter9S5;BFafter9TS5];
        BFafter11S6=[BFafter11S6;BFafter11TS6];
        BFafter2L1=[BFafter2L1;BFafter2TL1];
        BFafter4L2=[BFafter4L2;BFafter4TL2];
        BFafter6L3=[BFafter6L3;BFafter6TL3];
        BFafter8L4=[BFafter8L4;BFafter8TL4];
        BFafter10L5=[BFafter10L5;BFafter10TL5];
        BFafter12L6=[BFafter12L6;BFafter12TL6];
        BFafter13M1=[BFafter13M1;BFafter13TM1];
        
        % Calcualting the rate of decay for individuals~~~~~~~~~~~~~~~~
        % do I want to consider zero as the decay or the SS reached?  I
        % don't know the starting decay for the long target so I think that
        % I have to do it this way...
        % will have to use 36.8
        
% % %         subplot(1, 2, 1)
% % %         plot(Stream{1, 1},'DisplayName','Stream{1, 1}')
% % %                 subplot(1, 2, 2)
% % %         plot(Stream{1, 2},'DisplayName','Stream{1, 1}')
% % %         display('ugh')
        %will have to smooth
        for p =1:length(params)
            if strcmp(params(p), 'stepLengthSlow')
                NegPos=-1;
            elseif strcmp(params(p), 'stepLengthFast')
                NegPos=1;
            else
                NegPos = 1;%input('Will this decay from negative up (-1) or from positive down(1)?  ');
            end
            if strcmp(groups(g), 'PerceptionControl')
                 [DecayRateShort(s, p)]=NaN;
            [DecayRateLong(s, p)]=NaN;
            
            else
            [DecayRateShort(s, p)]=DecayRate(Stream{1, p}(:,1), NegPos, [subjects{s} ':  ShortTarget, ' params{p} ]);
            [DecayRateLong(s, p)]=DecayRate(Stream{1, p}(:,3), NegPos, [subjects{s} ':  LongTarget, ' params{p} ]);
            end
            end
        %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        adaptData=adaptData.removeBias;
        % compute TM steady state before OG walking (mean of first steadyNumPts of last steadyNumPts+5 strides)
        if sum(strcmp(adaptData.metaData.conditionName, 're-adaptation'))~=0
            adapt2Data=adaptData.getParamInCond(params,'re-adaptation');
            adaptAllData=adaptData.getParamInCond(params,{'adaptation','re-adaptation'});
            avgAdaptAll=[avgAdaptAll; nanmean(adaptAllData)];
            TMSteady=[TMSteady; nanmean(adapt2Data((end-5)-steadyNumPts+1:(end-5),:))];
        elseif sum(strcmp(adaptData.metaData.conditionName, 'adaptation'))~=0%For controls
            adapt2Data=adaptData.getParamInCond(params,'adaptation');
            adaptAllData=adaptData.getParamInCond(params,{'adaptation'});
            avgAdaptAll=[avgAdaptAll; nanmean(adaptAllData)];
            TMSteady=[TMSteady; nanmean(adapt2Data((end-5)-steadyNumPts+1:(end-5),:))];
        end
        %DeltaAdapt=[DeltaAdapt; nanmean(adapt2Data((end-5)-steadyNumPts+1:(end-5),:))-nanmean(adaptAllData(15,:))];
        DeltaAdapt=[DeltaAdapt; nanmean(adapt2Data((end-5)-steadyNumPts+1:(end-5),:))-nanmedian(adaptAllData(1:20,:))];
        %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        % compute catch
        adaptData=adaptData.removeBias;
        if isempty(find(cellfun(@(x) ~isempty(x),(regexp(lower(adaptData.metaData.conditionName), 'catch')))))
            %newtmcatchData=NaN.*ones(1, length(params));
            newtmcatchData=nanmean(adapt2Data(651:651+catchNumPts,:))
        else
            tmcatchData=adaptData.getParamInCond(params,'catch');
            if isempty(tmcatchData)
                newtmcatchData=NaN(1,length(params));
            elseif size(tmcatchData,1)<3
                newtmcatchData=nanmean(tmcatchData);
            else
                newtmcatchData=nanmean(tmcatchData(1:catchNumPts,:));
                %newtmcatchData=nanmean(tmcatchData);
            end
        end
        tmCatch=[tmCatch; newtmcatchData];
        %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        %Compute Washout
        WashoutData=adaptData.getParamInCond(params,'washout');
        washout=[washout; nanmean(WashoutData(1:transientNumPts,:))];
    end
    
    nSubs=length(subjects);
    
    
    %
    %     resusts.BFafter2.avg(end+1,:)=nanmean(BFafter2,1);
    %     resusts.BFafter2.se(end+1,:)=nanstd(BFafter2,1, 1)./sqrt(nSubs);
    
    resusts.MapShortDiff.avg(end+1,:)=nanmean(MapShort,1);
    resusts.MapShortDiff.se(end+1,:)=nanstd(MapShort,1, 1)./sqrt(nSubs);
    
    resusts.MapMidDiff.avg(end+1,:)=nanmean(MapMid,1);
    resusts.MapMidDiff.se(end+1,:)=nanstd(MapMid,1, 1)./sqrt(nSubs);
    
    resusts.MapLongDiff.avg(end+1,:)=nanmean(MapLong,1);
    resusts.MapLongDiff.se(end+1,:)=nanstd(MapLong,1, 1)./sqrt(nSubs);
    
    resusts.MapShortBase.avg(end+1,:)=nanmean(MapShortBase,1);
    resusts.MapShortBase.se(end+1,:)=nanstd(MapShortBase,1, 1)./sqrt(nSubs);
    
    resusts.MapMidBase.avg(end+1,:)=nanmean(MapMidBase,1);
    resusts.MapMidBase.se(end+1,:)=nanstd(MapMidBase,1, 1)./sqrt(nSubs);
    
    resusts.MapLongBase.avg(end+1,:)=nanmean(MapLongBase,1);
    resusts.MapLongBase.se(end+1,:)=nanstd(MapLongBase,1, 1)./sqrt(nSubs);
    
    resusts.ShortBaseAvg.avg(end+1,:)=nanmean(ShortBaseAvg,1);
    resusts.ShortBaseAvg.se(end+1,:)=nanstd(ShortBaseAvg,1, 1)./sqrt(nSubs);
    
    resusts.MidBaseAvg.avg(end+1,:)=nanmean(MidBaseAvg,1);
    resusts.MidBaseAvg.se(end+1,:)=nanstd(MidBaseAvg,1, 1)./sqrt(nSubs);
    
    resusts.LongBaseAvg.avg(end+1,:)=nanmean(LongBaseAvg,1);
    resusts.LongBaseAvg.se(end+1,:)=nanstd(LongBaseAvg,1, 1)./sqrt(nSubs);
    
    resusts.ShortBaseVar.avg(end+1,:)=nanmean(ShortBaseVar,1);
    resusts.ShortBaseVar.se(end+1,:)=nanstd(ShortBaseVar,1, 1)./sqrt(nSubs);
    
    resusts.MidBaseVar.avg(end+1,:)=nanmean(MidBaseVar,1);
    resusts.MidBaseVar.se(end+1,:)=nanstd(MidBaseVar,1, 1)./sqrt(nSubs);
    
    resusts.LongBaseVar.avg(end+1,:)=nanmean(LongBaseVar,1);
    resusts.LongBaseVar.se(end+1,:)=nanstd(LongBaseVar,1, 1)./sqrt(nSubs);
    
    resusts.catch.avg(end+1,:)=nanmean(    tmCatch,1);
    resusts.catch.se(end+1,:)=nanstd(    tmCatch)./sqrt(nSubs);
    
    resusts.washout.avg(end+1,:)=nanmean(    washout,1);
    resusts.washout.se(end+1,:)=nanstd(    washout)./sqrt(nSubs);
    %
    %     if nanmean(strcmp({'stepLengthSlow', 'stepLengthFast'}, params))==1 || nanmean(strcmp({'alphaSlow','alphaFast'}, params))==1
    %         resusts.BF_ShortLongbase.avg(end+1,:)=[nanmean(BF_ShortLongbase,1) nanmean(nanmean(BF_ShortLongbase))];
    %         resusts.BF_ShortLongbase.se(end+1,:)=[nanstd(BF_ShortLongbase,1, 1)./sqrt(nSubs) nanstd([BF_ShortLongbase(:, 1); BF_ShortLongbase(:, 2)],1, 1)./sqrt(nSubs)];
    %
    %         resusts.BF_ShortLongAE.avg(end+1,:)=[nanmean(BF_ShortLongAE,1) nanmean(nanmean(BF_ShortLongAE,1))];
    %         resusts.BF_ShortLongAE.se(end+1,:)=[nanstd(BF_ShortLongAE,1, 1)./sqrt(nSubs) nanstd([BF_ShortLongAE(:, 1); BF_ShortLongAE(:, 2)],1, 1)./sqrt(nSubs)];
    %
    %     resusts.DeltaAdapt.avg(end+1,:)=[nanmean(DeltaAdapt,1) diff(nanmean(DeltaAdapt,1))];
    %     resusts.DeltaAdapt.se(end+1,:)=[nanstd(DeltaAdapt,1, 1)./sqrt(nSubs) nanstd([diff([DeltaAdapt(:, 1), DeltaAdapt(:, 2)], 2)],1, 1)./sqrt(nSubs)];
    %
    %     resusts.TMSteady.avg(end+1,:)=[nanmean(TMSteady,1) diff(nanmean(TMSteady))];
    %     resusts.TMSteady.se(end+1,:)=[nanstd( TMSteady,1, 1)./sqrt(nSubs) nanstd([diff( [TMSteady(:, 1),  TMSteady(:, 2)],2)],1, 1)./sqrt(nSubs)];
    %
    %     resusts.BFafter1.avg(end+1,:)=[nanmean(BFafter1,1) diff(nanmean(BFafter1))];
    %     resusts.BFafter1.se(end+1,:)=[nanstd( BFafter1,1, 1)./sqrt(nSubs) nanstd([diff( [BFafter1(:, 1),  BFafter1(:, 2)],2)],1, 1)./sqrt(nSubs)];
    %     else
    resusts.BF_ShortLongbase.avg(end+1,:)=nanmean(BF_ShortLongbase,1);
    resusts.BF_ShortLongbase.se(end+1,:)=nanstd(BF_ShortLongbase,1, 1)./sqrt(nSubs);
    
    resusts.BF_ShortLongAE.avg(end+1,:)=nanmean(BF_ShortLongAE,1);
    resusts.BF_ShortLongAE.se(end+1,:)=nanstd(BF_ShortLongAE,1, 1)./sqrt(nSubs);
    
    resusts.DeltaAdapt.avg(end+1,:)=nanmean(    DeltaAdapt,1);
    resusts.DeltaAdapt.se(end+1,:)=nanstd(    DeltaAdapt)./sqrt(nSubs);
    
    resusts.TMSteady.avg(end+1,:)=nanmean(    TMSteady,1);
    resusts.TMSteady.se(end+1,:)=nanstd(    TMSteady)./sqrt(nSubs);
    
        resusts.DecayRateShort.avg(end+1,:)=nanmean(    DecayRateShort,1);
    resusts.DecayRateShort.se(end+1,:)=nanstd(   DecayRateShort)./sqrt(nSubs);
            resusts.DecayRateLong.avg(end+1,:)=nanmean(    DecayRateLong,1);
    resusts.DecayRateLong.se(end+1,:)=nanstd(   DecayRateLong)./sqrt(nSubs);
    %         resusts.BFafter1.avg(end+1,:)=nanmean(BFafter1,1);
    %     resusts.BFafter1.se(end+1,:)=nanstd(BFafter1,1, 1)./sqrt(nSubs);
    
    resusts.BFafter1S1.avg(end+1,:)=nanmean(BFafter1S1,1);
    resusts.BFafter1S1.se(end+1,:)=nanstd(BFafter1S1,1, 1)./sqrt(nSubs);
    resusts.BFafter3S2.avg(end+1,:)=nanmean(BFafter3S2,1);
    resusts.BFafter3S2.se(end+1,:)=nanstd(BFafter3S2,1, 1)./sqrt(nSubs);
    resusts.BFafter5S3.avg(end+1,:)=nanmean(BFafter5S3,1);
    resusts.BFafter5S3.se(end+1,:)=nanstd(BFafter5S3,1, 1)./sqrt(nSubs);
    resusts.BFafter7S4.avg(end+1,:)=nanmean(BFafter7S4,1);
    resusts.BFafter7S4.se(end+1,:)=nanstd(BFafter7S4,1, 1)./sqrt(nSubs);
    resusts.BFafter9S5.avg(end+1,:)=nanmean(BFafter9S5,1);
    resusts.BFafter9S5.se(end+1,:)=nanstd(BFafter9S5,1, 1)./sqrt(nSubs);
    resusts.BFafter11S6.avg(end+1,:)=nanmean(BFafter11S6,1);
    resusts.BFafter11S6.se(end+1,:)=nanstd(BFafter11S6,1, 1)./sqrt(nSubs);
    resusts.BFafter2L1.avg(end+1,:)=nanmean(BFafter2L1,1);
    resusts.BFafter2L1.se(end+1,:)=nanstd(BFafter2L1,1, 1)./sqrt(nSubs);
    resusts.BFafter4L2.avg(end+1,:)=nanmean(BFafter4L2,1);
    resusts.BFafter4L2.se(end+1,:)=nanstd(BFafter4L2,1, 1)./sqrt(nSubs);
    resusts.BFafter6L3.avg(end+1,:)=nanmean(BFafter6L3,1);
    resusts.BFafter6L3.se(end+1,:)=nanstd(BFafter6L3,1, 1)./sqrt(nSubs);
    resusts.BFafter8L4.avg(end+1,:)=nanmean(BFafter8L4,1);
    resusts.BFafter8L4.se(end+1,:)=nanstd(BFafter8L4,1, 1)./sqrt(nSubs);
    resusts.BFafter10L5.avg(end+1,:)=nanmean(BFafter10L5,1);
    resusts.BFafter10L5.se(end+1,:)=nanstd(BFafter10L5,1, 1)./sqrt(nSubs);
    resusts.BFafter12L6.avg(end+1,:)=nanmean(BFafter12L6,1);
    resusts.BFafter12L6.se(end+1,:)=nanstd(BFafter12L6,1, 1)./sqrt(nSubs);
    resusts.BFafter13M1.avg(end+1,:)=nanmean(BFafter13M1,1);
    resusts.BFafter13M1.se(end+1,:)=nanstd(BFafter13M1,1, 1)./sqrt(nSubs);

    DeltaTarget=BFafter1S1-BFafter2L1;
    resusts.DeltaTarget.avg(end+1,:)=nanmean(DeltaTarget,1);
    resusts.DeltaTarget.se(end+1,:)=nanstd(DeltaTarget,1, 1)./sqrt(nSubs);
    
    if g==1 %This seems ridiculous, but I don't know of another way to do it without making MATLAB mad. The resusts.(whatever).indiv structure needs to be in this format to make life easier for using SPSS
        for p=1:length(params)
            %             resusts.BFafter1.indiv.(params{p})=[g*ones(nSubs,1) BFafter1(:,p)];
            %             resusts.BFafter2.indiv.(params{p})=[g*ones(nSubs,1) BFafter2(:,p)];
            resusts.MapShortDiff.indiv.(params{p})=[g*ones(nSubs,1) MapShort(:,p)];
            resusts.MapMidDiff.indiv.(params{p})=[g*ones(nSubs,1) MapMid(:,p)];
            resusts.MapLongDiff.indiv.(params{p})=[g*ones(nSubs,1) MapLong(:,p)];
            
            resusts.MapShortBase.indiv.(params{p})=[g*ones(nSubs,1) MapShortBase(:,p)];
            resusts.MapMidBase.indiv.(params{p})=[g*ones(nSubs,1) MapMidBase(:,p)];
            resusts.MapLongBase.indiv.(params{p})=[g*ones(nSubs,1) MapLongBase(:,p)];
            
            resusts.ShortBaseAvg.indiv.(params{p})=[g*ones(nSubs,1) ShortBaseAvg(:,p)];
            resusts.MidBaseAvg.indiv.(params{p})=[g*ones(nSubs,1) MidBaseAvg(:,p)];
            resusts.LongBaseAvg.indiv.(params{p})=[g*ones(nSubs,1) LongBaseAvg(:,p)];
            
            resusts.ShortBaseVar.indiv.(params{p})=[g*ones(nSubs,1) ShortBaseVar(:,p)];
            resusts.MidBaseVar.indiv.(params{p})=[g*ones(nSubs,1) MidBaseVar(:,p)];
            resusts.LongBaseVar.indiv.(params{p})=[g*ones(nSubs,1) LongBaseVar(:,p)];
            %
            resusts.BF_ShortLongbase.indiv.(params{p})=[g*ones(nSubs,1) BF_ShortLongbase(:,p)];
            resusts.BF_ShortLongAE.indiv.(params{p})=[g*ones(nSubs,1) BF_ShortLongAE(:,p)];
            
            resusts.DeltaAdapt.indiv.(params{p})=[g*ones(nSubs,1)     DeltaAdapt(:,p)];
            resusts.TMSteady.indiv.(params{p})=[g*ones(nSubs,1)     TMSteady(:,p)];
            resusts.catch.indiv.(params{p})=[g*ones(nSubs,1)     tmCatch(:,p)];
            resusts.washout.indiv.(params{p})=[g*ones(nSubs,1)     washout(:,p)];
            
                        resusts.DecayRateShort.indiv.(params{p})=[g*ones(nSubs,1)     DecayRateShort(:,p)];
            resusts.DecayRateLong.indiv.(params{p})=[g*ones(nSubs,1)     DecayRateLong(:,p)];
            
            resusts.BFafter1S1.indiv.(params{p})=[g*ones(nSubs,1) BFafter1S1(:,p)];
            resusts.BFafter3S2.indiv.(params{p})=[g*ones(nSubs,1) BFafter3S2(:,p)];
            resusts.BFafter5S3.indiv.(params{p})=[g*ones(nSubs,1) BFafter5S3(:,p)];
            resusts.BFafter7S4.indiv.(params{p})=[g*ones(nSubs,1) BFafter7S4(:,p)];
            resusts.BFafter9S5.indiv.(params{p})=[g*ones(nSubs,1) BFafter9S5(:,p)];
            resusts.BFafter11S6.indiv.(params{p})=[g*ones(nSubs,1) BFafter11S6(:,p)];
            resusts.BFafter2L1.indiv.(params{p})=[g*ones(nSubs,1) BFafter2L1(:,p)];
            resusts.BFafter4L2.indiv.(params{p})=[g*ones(nSubs,1) BFafter4L2(:,p)];
            resusts.BFafter6L3.indiv.(params{p})=[g*ones(nSubs,1) BFafter6L3(:,p)];
            resusts.BFafter8L4.indiv.(params{p})=[g*ones(nSubs,1) BFafter8L4(:,p)];
            resusts.BFafter10L5.indiv.(params{p})=[g*ones(nSubs,1) BFafter10L5(:,p)];
            resusts.BFafter12L6.indiv.(params{p})=[g*ones(nSubs,1) BFafter12L6(:,p)];
            resusts.BFafter13M1.indiv.(params{p})=[g*ones(nSubs,1) BFafter13M1(:,p)];
            
            resusts.DeltaTarget.indiv.(params{p})=[g*ones(nSubs,1) DeltaTarget(:,p)];
        end
    else
        for p=1:length(params)
            %             resusts.BFafter1.indiv.(params{p})(end+1:end+nSubs,1:2)=[g*ones(nSubs,1) BFafter1(:,p)];
            %             resusts.BFafter2.indiv.(params{p})(end+1:end+nSubs,1:2)=[g*ones(nSubs,1) BFafter2(:,p)];
            resusts.MapShortDiff.indiv.(params{p})(end+1:end+nSubs,1:2)=[g*ones(nSubs,1) MapShort(:,p)];
            resusts.MapMidDiff.indiv.(params{p})(end+1:end+nSubs,1:2)=[g*ones(nSubs,1) MapMid(:,p)];
            resusts.MapLongDiff.indiv.(params{p})(end+1:end+nSubs,1:2)=[g*ones(nSubs,1) MapLong(:,p)];
            
            resusts.MapShortBase.indiv.(params{p})(end+1:end+nSubs,1:2)=[g*ones(nSubs,1) MapShortBase(:,p)];
            resusts.MapMidBase.indiv.(params{p})(end+1:end+nSubs,1:2)=[g*ones(nSubs,1) MapMidBase(:,p)];
            resusts.MapLongBase.indiv.(params{p})(end+1:end+nSubs,1:2)=[g*ones(nSubs,1) MapLongBase(:,p)];
            
            resusts.ShortBaseAvg.indiv.(params{p})(end+1:end+nSubs,1:2)=[g*ones(nSubs,1) ShortBaseAvg(:,p)];
            resusts.MidBaseAvg.indiv.(params{p})(end+1:end+nSubs,1:2)=[g*ones(nSubs,1) MidBaseAvg(:,p)];
            resusts.LongBaseAvg.indiv.(params{p})(end+1:end+nSubs,1:2)=[g*ones(nSubs,1) LongBaseAvg(:,p)];
            
            resusts.ShortBaseVar.indiv.(params{p})(end+1:end+nSubs,1:2)=[g*ones(nSubs,1) ShortBaseVar(:,p)];
            resusts.MidBaseVar.indiv.(params{p})(end+1:end+nSubs,1:2)=[g*ones(nSubs,1) MidBaseVar(:,p)];
            resusts.LongBaseVar.indiv.(params{p})(end+1:end+nSubs,1:2)=[g*ones(nSubs,1) LongBaseVar(:,p)];
            %
            resusts.BF_ShortLongbase.indiv.(params{p})(end+1:end+nSubs,1:2)=[g*ones(nSubs,1) BF_ShortLongbase(:,p)];
            resusts.BF_ShortLongAE.indiv.(params{p})(end+1:end+nSubs,1:2)=[g*ones(nSubs,1) BF_ShortLongAE(:,p)];
            
            resusts.DeltaAdapt.indiv.(params{p})(end+1:end+nSubs,1:2)=[g*ones(nSubs,1)     DeltaAdapt(:,p)];
            resusts.TMSteady.indiv.(params{p})(end+1:end+nSubs,1:2)=[g*ones(nSubs,1)     TMSteady(:,p)];
            resusts.catch.indiv.(params{p})(end+1:end+nSubs,1:2)=[g*ones(nSubs,1)     tmCatch(:,p)];
            resusts.washout.indiv.(params{p})(end+1:end+nSubs,1:2)=[g*ones(nSubs,1)     washout(:,p)];
            
            resusts.DecayRateShort.indiv.(params{p})(end+1:end+nSubs,1:2)=[g*ones(nSubs,1)     DecayRateShort(:,p)];
            resusts.DecayRateLong.indiv.(params{p})(end+1:end+nSubs,1:2)=[g*ones(nSubs,1)     DecayRateLong(:,p)];
            
            resusts.BFafter1S1.indiv.(params{p})(end+1:end+nSubs,1:2)=[g*ones(nSubs,1) BFafter1S1(:,p)];
            resusts.BFafter3S2.indiv.(params{p})(end+1:end+nSubs,1:2)=[g*ones(nSubs,1) BFafter3S2(:,p)];
            resusts.BFafter5S3.indiv.(params{p})(end+1:end+nSubs,1:2)=[g*ones(nSubs,1) BFafter5S3(:,p)];
            resusts.BFafter7S4.indiv.(params{p})(end+1:end+nSubs,1:2)=[g*ones(nSubs,1) BFafter7S4(:,p)];
            resusts.BFafter9S5.indiv.(params{p})(end+1:end+nSubs,1:2)=[g*ones(nSubs,1) BFafter9S5(:,p)];
            resusts.BFafter11S6.indiv.(params{p})(end+1:end+nSubs,1:2)=[g*ones(nSubs,1) BFafter11S6(:,p)];
            resusts.BFafter2L1.indiv.(params{p})(end+1:end+nSubs,1:2)=[g*ones(nSubs,1) BFafter2L1(:,p)];
            resusts.BFafter4L2.indiv.(params{p})(end+1:end+nSubs,1:2)=[g*ones(nSubs,1) BFafter4L2(:,p)];
            resusts.BFafter6L3.indiv.(params{p})(end+1:end+nSubs,1:2)=[g*ones(nSubs,1) BFafter6L3(:,p)];
            resusts.BFafter8L4.indiv.(params{p})(end+1:end+nSubs,1:2)=[g*ones(nSubs,1) BFafter8L4(:,p)];
            resusts.BFafter10L5.indiv.(params{p})(end+1:end+nSubs,1:2)=[g*ones(nSubs,1) BFafter10L5(:,p)];
            resusts.BFafter12L6.indiv.(params{p})(end+1:end+nSubs,1:2)=[g*ones(nSubs,1) BFafter12L6(:,p)];
            resusts.BFafter13M1.indiv.(params{p})(end+1:end+nSubs,1:2)=[g*ones(nSubs,1) BFafter13M1(:,p)];
            
            resusts.DeltaTarget.indiv.(params{p})(end+1:end+nSubs,1:2)=[g*ones(nSubs,1) DeltaTarget(:,p)];
        end
    end
    
end
% if nanmean(strcmp({'stepLengthSlow', 'stepLengthFast'}, params))==1
%     params={'stepLengthSlow', 'stepLengthFast', 'AVGStepLength'}
% elseif nanmean(strcmp({'alphaSlow','alphaFast'}, params))==1
%     params={'alphaSlow','alphaFast', 'alphaSym'}
% end

%stats
resultNames=fieldnames(resusts);
%if StatFlag==1
namest=[];
for h=1:length(resultNames)
    if length(groups)==1
        for i=1:size(resusts.MapShortDiff.avg, 2)%size(StatReady, 2)
            [~, resusts.(resultNames{h}).p(i)]=ttest(resusts.(resultNames{h}).indiv.(params{i})(:, 2));
        end
    elseif length(groups)==2
        group1=find(resusts.(resultNames{h}).indiv.(params{1})(:, 1)==1);
        group2=find(resusts.(resultNames{h}).indiv.(params{1})(:, 1)==2);
        % % %         for gg=1:length(resusts.(resultNames{h}).indiv.(params{1})(:, 2))
        % % %             namest{gg}=[groups{resusts.(resultNames{h}).indiv.(params{1})(gg, 1)}];
        % % %         end
        for i=1:size(resusts.MapShortDiff.avg, 2)%size(StatReady, 2)
            [~, resusts.(resultNames{h}).p(i)]=ttest2(resusts.(resultNames{h}).indiv.(params{i})(group1, 2), resusts.(resultNames{h}).indiv.(params{i})(group2, 2));
            
            %         stataData = [resusts.(resultNames{h}).indiv.(params{i})(group1, 2)', resusts.(resultNames{h}).indiv.(params{i})(group2, 2)'];
            %         [ resusts.(resultNames{h}).p(i)] = anova1(stataData, namest);
            
            
        end
    elseif length(groups)>=3
        for i=1:size(resusts.BFafter1.avg, 2)%size(StatReady, 2)
            [ resusts.(resultNames{h}).p(i)] = anova1(resusts.(resultNames{h}).indiv.(params{i})(:, 2), resusts.(resultNames{h}).indiv.(params{i})(:, 1));
        end
    end
end
close all

% StataReadyABS=[[UltimateSubjects; UltimateSubjects;UltimateSubjects; UltimateSubjects]...
%     num2cell([ones(2.*length(UltimateSubjects), 1); 0.*ones(2.*length(UltimateSubjects), 1)])...
%     num2cell([ones(length(UltimateSubjects), 1); 0.*ones(length(UltimateSubjects), 1); ones(length(UltimateSubjects), 1); 0.*ones(length(UltimateSubjects), 1)])...
%     [num2cell(abs(resusts.BFafter1.indiv.alphaSlow(:,2)));...
%     num2cell(abs(resusts.BFafter1.indiv.alphaFast(:,2)));...
%     num2cell(abs(resusts.BFafter2.indiv.alphaSlow(:,2)));...
%     num2cell(abs(resusts.BFafter2.indiv.alphaFast(:,2)))]...
%     num2cell([ones(length(UltimateSubjects), 1); 2.*ones(length(UltimateSubjects), 1); 3.*ones(length(UltimateSubjects), 1); 4.*ones(length(UltimateSubjects), 1)])...
%     num2cell([ones(length(UltimateSubjects(group1)), 1); 0.*ones(length(UltimateSubjects(group2)), 1);...
%     ones(length(UltimateSubjects(group1)), 1); 0.*ones(length(UltimateSubjects(group2)), 1);...
%     ones(length(UltimateSubjects(group1)), 1); 0.*ones(length(UltimateSubjects(group2)), 1);...
%     ones(length(UltimateSubjects(group1)), 1); 0.*ones(length(UltimateSubjects(group2)), 1)])];
% StataReadySigned=[[UltimateSubjects; UltimateSubjects;UltimateSubjects; UltimateSubjects]...
%     num2cell([ones(2.*length(UltimateSubjects), 1); 0.*ones(2.*length(UltimateSubjects), 1)])...
%     num2cell([ones(length(UltimateSubjects), 1); 0.*ones(length(UltimateSubjects), 1); ones(length(UltimateSubjects), 1); 0.*ones(length(UltimateSubjects), 1)])...
%     [num2cell((resusts.BFafter1.indiv.alphaSlow(:,2)));...
%     num2cell((resusts.BFafter1.indiv.alphaFast(:,2)));...
%     num2cell((resusts.BFafter2.indiv.alphaSlow(:,2)));...
%     num2cell((resusts.BFafter2.indiv.alphaFast(:,2)))]...
%     num2cell([ones(length(UltimateSubjects), 1); 2.*ones(length(UltimateSubjects), 1); 3.*ones(length(UltimateSubjects), 1); 4.*ones(length(UltimateSubjects), 1)])...
%     num2cell([ones(length(UltimateSubjects(group1)), 1); 0.*ones(length(UltimateSubjects(group2)), 1);...
%     ones(length(UltimateSubjects(group1)), 1); 0.*ones(length(UltimateSubjects(group2)), 1);...
%     ones(length(UltimateSubjects(group1)), 1); 0.*ones(length(UltimateSubjects(group2)), 1);...
%     ones(length(UltimateSubjects(group1)), 1); 0.*ones(length(UltimateSubjects(group2)), 1)])];

% StataReadyABS=[[UltimateSubjects; UltimateSubjects;UltimateSubjects; UltimateSubjects]...
%     num2cell([ones(2.*length(UltimateSubjects), 1); 0.*ones(2.*length(UltimateSubjects), 1)])...
%     num2cell([ones(length(UltimateSubjects), 1); 0.*ones(length(UltimateSubjects), 1); ones(length(UltimateSubjects), 1); 0.*ones(length(UltimateSubjects), 1)])...
%     [num2cell(abs(resusts.BFafter1.indiv.stepLengthSlow(:,2)));...
%     num2cell(abs(resusts.BFafter1.indiv.stepLengthFast(:,2)));...
%     num2cell(abs(resusts.BFafter2.indiv.stepLengthSlow(:,2)));...
%     num2cell(abs(resusts.BFafter2.indiv.stepLengthFast(:,2)))]...
%     num2cell([ones(length(UltimateSubjects), 1); 2.*ones(length(UltimateSubjects), 1); 3.*ones(length(UltimateSubjects), 1); 4.*ones(length(UltimateSubjects), 1)])...
%     num2cell([ones(length(UltimateSubjects(group1)), 1); 0.*ones(length(UltimateSubjects(group2)), 1);...
%     ones(length(UltimateSubjects(group1)), 1); 0.*ones(length(UltimateSubjects(group2)), 1);...
%     ones(length(UltimateSubjects(group1)), 1); 0.*ones(length(UltimateSubjects(group2)), 1);...
%     ones(length(UltimateSubjects(group1)), 1); 0.*ones(length(UltimateSubjects(group2)), 1)])];
% StataReadySigned=[[UltimateSubjects; UltimateSubjects;UltimateSubjects; UltimateSubjects]...
%     num2cell([ones(2.*length(UltimateSubjects), 1); 0.*ones(2.*length(UltimateSubjects), 1)])...
%     num2cell([ones(length(UltimateSubjects), 1); 0.*ones(length(UltimateSubjects), 1); ones(length(UltimateSubjects), 1); 0.*ones(length(UltimateSubjects), 1)])...
%     [num2cell((resusts.BFafter1.indiv.stepLengthSlow(:,2)));...
%     num2cell((resusts.BFafter1.indiv.stepLengthFast(:,2)));...
%     num2cell((resusts.BFafter2.indiv.stepLengthSlow(:,2)));...
%     num2cell((resusts.BFafter2.indiv.stepLengthFast(:,2)))]...
%     num2cell([ones(length(UltimateSubjects), 1); 2.*ones(length(UltimateSubjects), 1); 3.*ones(length(UltimateSubjects), 1); 4.*ones(length(UltimateSubjects), 1)])...
%     num2cell([ones(length(UltimateSubjects(group1)), 1); 0.*ones(length(UltimateSubjects(group2)), 1);...
%     ones(length(UltimateSubjects(group1)), 1); 0.*ones(length(UltimateSubjects(group2)), 1);...
%     ones(length(UltimateSubjects(group1)), 1); 0.*ones(length(UltimateSubjects(group2)), 1);...
%     ones(length(UltimateSubjects(group1)), 1); 0.*ones(length(UltimateSubjects(group2)), 1)])];

% StataReadyABS=[[UltimateSubjects; UltimateSubjects;UltimateSubjects; UltimateSubjects]...
%     num2cell([ones(2.*length(UltimateSubjects), 1); 0.*ones(2.*length(UltimateSubjects), 1)])...
%     num2cell([ones(length(UltimateSubjects), 1); 0.*ones(length(UltimateSubjects), 1); ones(length(UltimateSubjects), 1); 0.*ones(length(UltimateSubjects), 1)])...
%     [num2cell(abs(resusts.BFafter1.indiv.stepCadenceSlow(:,2)));...
%     num2cell(abs(resusts.BFafter1.indiv.stepCadenceFast(:,2)));...
%     num2cell(abs(resusts.BFafter2.indiv.stepCadenceSlow(:,2)));...
%     num2cell(abs(resusts.BFafter2.indiv.stepCadenceFast(:,2)))]...
%     num2cell([ones(length(UltimateSubjects), 1); 2.*ones(length(UltimateSubjects), 1); 3.*ones(length(UltimateSubjects), 1); 4.*ones(length(UltimateSubjects), 1)])...
%     num2cell([ones(length(UltimateSubjects(group1)), 1); 0.*ones(length(UltimateSubjects(group2)), 1);...
%     ones(length(UltimateSubjects(group1)), 1); 0.*ones(length(UltimateSubjects(group2)), 1);...
%     ones(length(UltimateSubjects(group1)), 1); 0.*ones(length(UltimateSubjects(group2)), 1);...
%     ones(length(UltimateSubjects(group1)), 1); 0.*ones(length(UltimateSubjects(group2)), 1)])];
% StataReadySigned=[[UltimateSubjects; UltimateSubjects;UltimateSubjects; UltimateSubjects]...
%     num2cell([ones(2.*length(UltimateSubjects), 1); 0.*ones(2.*length(UltimateSubjects), 1)])...
%     num2cell([ones(length(UltimateSubjects), 1); 0.*ones(length(UltimateSubjects), 1); ones(length(UltimateSubjects), 1); 0.*ones(length(UltimateSubjects), 1)])...
%     [num2cell((resusts.BFafter1.indiv.stepCadenceSlow(:,2)));...
%     num2cell((resusts.BFafter1.indiv.stepCadenceFast(:,2)));...
%     num2cell((resusts.BFafter2.indiv.stepCadenceSlow(:,2)));...
%     num2cell((resusts.BFafter2.indiv.stepCadenceFast(:,2)))]...
%     num2cell([ones(length(UltimateSubjects), 1); 2.*ones(length(UltimateSubjects), 1); 3.*ones(length(UltimateSubjects), 1); 4.*ones(length(UltimateSubjects), 1)])...
%     num2cell([ones(length(UltimateSubjects(group1)), 1); 0.*ones(length(UltimateSubjects(group2)), 1);...
%     ones(length(UltimateSubjects(group1)), 1); 0.*ones(length(UltimateSubjects(group2)), 1);...
%     ones(length(UltimateSubjects(group1)), 1); 0.*ones(length(UltimateSubjects(group2)), 1);...
%     ones(length(UltimateSubjects(group1)), 1); 0.*ones(length(UltimateSubjects(group2)), 1)])];

% % StataReady1=[[UltimateSubjects(group1); UltimateSubjects(group1);UltimateSubjects(group1); UltimateSubjects(group1)]...
% %     num2cell([ones(2.*length(UltimateSubjects(group1)), 1); 0.*ones(2.*length(UltimateSubjects(group1)), 1)])...
% %     num2cell([ones(length(UltimateSubjects(group1)), 1); 0.*ones(length(UltimateSubjects(group1)), 1); ones(length(UltimateSubjects(group1)), 1); 0.*ones(length(UltimateSubjects(group1)), 1)])...
% %     [num2cell(resusts.BFafter1.indiv.SlowLeg(group1,2));...
% %     num2cell(resusts.BFafter1.indiv.FastLeg(group1,2));...
% %     num2cell(resusts.BFafter2.indiv.SlowLeg(group1,2));...
% %     num2cell(resusts.BFafter2.indiv.FastLeg(group1,2))]...
% %     num2cell([ones(length(UltimateSubjects(group1)), 1); 2.*ones(length(UltimateSubjects(group1)), 1); 3.*ones(length(UltimateSubjects(group1)), 1); 4.*ones(length(UltimateSubjects(group1)), 1)])];
% % StataReady2=[[UltimateSubjects(group2); UltimateSubjects(group2);UltimateSubjects(group2); UltimateSubjects(group2)]...
% %     num2cell([ones(2.*length(UltimateSubjects(group2)), 1); 0.*ones(2.*length(UltimateSubjects(group2)), 1)])...
% %     num2cell([ones(length(UltimateSubjects(group2)), 1); 0.*ones(length(UltimateSubjects(group2)), 1); ones(length(UltimateSubjects(group2)), 1); 0.*ones(length(UltimateSubjects(group2)), 1)])...
% %     [num2cell(resusts.BFafter1.indiv.SlowLeg(group2,2));...
% %     num2cell(resusts.BFafter1.indiv.FastLeg(group2,2));...
% %     num2cell(resusts.BFafter2.indiv.SlowLeg(group2,2));...
% %     num2cell(resusts.BFafter2.indiv.FastLeg(group2,2))]...
% %     num2cell([ones(length(UltimateSubjects(group2)), 1); 2.*ones(length(UltimateSubjects(group2)), 1); 3.*ones(length(UltimateSubjects(group2)), 1); 4.*ones(length(UltimateSubjects(group2)), 1)])];

%Group 1: Short Slow
%Group 2: Short Fast
%Group 3: Long Slow
%Group 4: Long Fast

% % MapMaintance1=[[UltimateSubjects(group1); UltimateSubjects(group1); UltimateSubjects(group1); UltimateSubjects(group1); UltimateSubjects(group1); UltimateSubjects(group1)]...
% %     num2cell([ones(2.*length(UltimateSubjects(group1)), 1); 2.*ones(2.*length(UltimateSubjects(group1)), 1); 3.*ones(2.*length(UltimateSubjects(group1)), 1)])...
% %     num2cell([ones(length(UltimateSubjects(group1)), 1); 0.*ones(length(UltimateSubjects(group1)), 1); ones(length(UltimateSubjects(group1)), 1); 0.*ones(length(UltimateSubjects(group1)), 1); ones(length(UltimateSubjects(group1)), 1); 0.*ones(length(UltimateSubjects(group1)), 1)])...
% %     [num2cell(resusts.MapShort.indiv.SlowLeg((group1),2));...
% %     num2cell(resusts.MapShort.indiv.FastLeg((group1),2));...
% %     num2cell(resusts.MapMid.indiv.SlowLeg((group1),2));...
% %     num2cell(resusts.MapMid.indiv.FastLeg((group1),2));...
% %     num2cell(resusts.MapLong.indiv.SlowLeg((group1),2));...
% %     num2cell(resusts.MapLong.indiv.FastLeg((group1),2))]];%...
% %     %num2cell([ones(length(UltimateSubjects), 1); 2.*ones(length(UltimateSubjects), 1); 3.*ones(length(UltimateSubjects), 1); 4.*ones(length(UltimateSubjects), 1); 5.*ones(length(UltimateSubjects), 1); 6.*ones(length(UltimateSubjects), 1)])];
%

% MapMaintance=[[UltimateSubjects; UltimateSubjects;UltimateSubjects; UltimateSubjects;UltimateSubjects; UltimateSubjects]...
%     num2cell([ones(2.*length(UltimateSubjects), 1); 2.*ones(2.*length(UltimateSubjects), 1); 3.*ones(2.*length(UltimateSubjects), 1)])...
%     num2cell([ones(length(UltimateSubjects), 1); 0.*ones(length(UltimateSubjects), 1); ones(length(UltimateSubjects), 1); 0.*ones(length(UltimateSubjects), 1); ones(length(UltimateSubjects), 1); 0.*ones(length(UltimateSubjects), 1)])...
%     [num2cell(resusts.MapShort.indiv.stepLengthSlow(:,2));...
%     num2cell(resusts.MapShort.indiv.stepLengthFast(:,2));...
%     num2cell(resusts.MapMid.indiv.stepLengthSlow(:,2));...
%     num2cell(resusts.MapMid.indiv.stepLengthFast(:,2));...
%     num2cell(resusts.MapLong.indiv.stepLengthSlow(:,2));...
%     num2cell(resusts.MapLong.indiv.stepLengthFast(:,2))]...
%     num2cell([ones(length(UltimateSubjects), 1); 2.*ones(length(UltimateSubjects), 1); 3.*ones(length(UltimateSubjects), 1); 4.*ones(length(UltimateSubjects), 1); 5.*ones(length(UltimateSubjects), 1); 6.*ones(length(UltimateSubjects), 1)])];

% MapMaintance=[[UltimateSubjects; UltimateSubjects;UltimateSubjects; UltimateSubjects;UltimateSubjects; UltimateSubjects]...
%     num2cell([ones(2.*length(UltimateSubjects), 1); 2.*ones(2.*length(UltimateSubjects), 1); 3.*ones(2.*length(UltimateSubjects), 1)])...
%     num2cell([ones(length(UltimateSubjects), 1); 0.*ones(length(UltimateSubjects), 1); ones(length(UltimateSubjects), 1); 0.*ones(length(UltimateSubjects), 1); ones(length(UltimateSubjects), 1); 0.*ones(length(UltimateSubjects), 1)])...
%     [num2cell(resusts.MapShort.indiv.stepCadenceSlow(:,2));...
%     num2cell(resusts.MapShort.indiv.stepCadenceFast(:,2));...
%     num2cell(resusts.MapMid.indiv.stepCadenceSlow(:,2));...
%     num2cell(resusts.MapMid.indiv.stepCadenceFast(:,2));...
%     num2cell(resusts.MapLong.indiv.stepCadenceSlow(:,2));...
%     num2cell(resusts.MapLong.indiv.stepCadenceFast(:,2))]...
%     num2cell([ones(length(UltimateSubjects), 1); 2.*ones(length(UltimateSubjects), 1); 3.*ones(length(UltimateSubjects), 1); 4.*ones(length(UltimateSubjects), 1); 5.*ones(length(UltimateSubjects), 1); 6.*ones(length(UltimateSubjects), 1)])];


% MapMaintance=[[UltimateSubjects; UltimateSubjects;UltimateSubjects; UltimateSubjects;UltimateSubjects; UltimateSubjects]...
%     num2cell([ones(2.*length(UltimateSubjects), 1); 2.*ones(2.*length(UltimateSubjects), 1); 3.*ones(2.*length(UltimateSubjects), 1)])...
%     num2cell([ones(length(UltimateSubjects), 1); 0.*ones(length(UltimateSubjects), 1); ones(length(UltimateSubjects), 1); 0.*ones(length(UltimateSubjects), 1); ones(length(UltimateSubjects), 1); 0.*ones(length(UltimateSubjects), 1)])...
%     [num2cell(resusts.MapShort.indiv.alphaSlow(:,2));...
%     num2cell(resusts.MapShort.indiv.alphaFast(:,2));...
%     num2cell(resusts.MapMid.indiv.alphaSlow(:,2));...
%     num2cell(resusts.MapMid.indiv.alphaFast(:,2));...
%     num2cell(resusts.MapLong.indiv.alphaSlow(:,2));...
%     num2cell(resusts.MapLong.indiv.alphaFast(:,2))]...
%     num2cell([ones(length(UltimateSubjects), 1); 2.*ones(length(UltimateSubjects), 1); 3.*ones(length(UltimateSubjects), 1); 4.*ones(length(UltimateSubjects), 1); 5.*ones(length(UltimateSubjects), 1); 6.*ones(length(UltimateSubjects), 1)])];


%plot stuff
if plotFlag
    %epochs={'TMSteady','DeltaAdapt','BFafter1',};
   % epochs={'DeltaTarget','washout','washout', 'washout', 'washout', 'washout'};
%         epochs={'MapShortDiff', 'MapMidDiff', 'MapLongDiff', 'MapShortDiff', 'MapMidDiff', 'MapLongDiff'};
    %     epochs={'BFafter1S1','BFafter2L1', 'washout', 'BFafter1S1','BFafter2L1', 'washout'};
 
    %epochs={'catch', 'BFafter1S1','BFafter2L1', 'BFafter13M1','washout','washout'};
    %epochs={'catch','BFafter1S1','BFafter2L1','BFafter3S2','BFafter4L2', 'BFafter13M1','washout'};
     epochs={'BFafter1S1', 'BFafter3S2', 'BFafter5S3', 'BFafter7S4', 'BFafter9S5', 'BFafter11S6', 'BFafter13M1'};
    %epochs={'BFafter2L1', 'BFafter4L2', 'BFafter6L3', 'BFafter8L4', 'BFafter10L5', 'BFafter12L6', 'BFafter13M1'};
    %epochs={'BFafter2L1', 'BFafter4L2', 'BFafter6L3', 'BFafter8L4', 'BFafter10L5', 'BFafter12L6', 'BFafter13M1', 'BFafter1S1', 'BFafter3S2', 'BFafter5S3', 'BFafter7S4', 'BFafter9S5', 'BFafter11S6', 'BFafter13M1'};
    %epochs={'MapShortDiff', 'MapMidDiff', 'MapLongDiff', 'MapShortDiff', 'MapMidDiff', 'MapLongDiff'};
    %epochs={'MapShortBase', 'MapMidBase', 'MapLongBase', 'MapShortDiff', 'MapMidDiff', 'MapLongDiff'};
    %epochs={'BF_ShortLongbase','BF_ShortLongAE'};
    %epochs={'ShortBaseAvg','MidBaseAvg', 'LongBaseAvg'};
    %epochs={'ShortBaseVar','MidBaseVar', 'LongBaseVar'};
    if nargin>3 %I imagine there has to be a better way to do this...
        barGroups(SMatrix,resusts,groups,params,epochs,indivFlag)
    else
        barGroups(SMatrix,resusts,groups,params,epochs)
    end
end


