%ForceTraces
%CJS
%8/1/2016

close all


%% Edit
load('LD0030.mat')
[AE, BE]=GetGRFTraces(expData, 'TM base', {'LFy', 'RFy'},  [1:5], 0);
[AL, BL]=GetGRFTraces(expData, 'TM base', {'LFy', 'RFy'},  [40], 1);
%load('LN0009.mat')
%cond='adaptation';
cond='TM base';
params={'LFy', 'RFy'};
%%

poster_colors;
colorOrder=[p_red; p_orange; p_fade_green; p_fade_blue; p_plum; p_green; p_blue; p_fade_red; p_lime; p_yellow; p_gray; p_black;[1 1 1]];

%~~~~~~~ Here is where I am putting real stuffs ~~~~~~~~
trial=expData.metaData.conditionDescription(expData.getConditionIdxsFromName(cond));
BW=expData.subData.weight;
refLeg=expData.subData.dominantLeg(1);
eventClass='';
Filtered=expData.data{1, expData.metaData.trialsInCondition{expData.getConditionIdxsFromName(cond)}(1)}.GRFData.lowPassFilter(20);%GRFData;
trialData=expData.data{1, expData.metaData.trialsInCondition{expData.getConditionIdxsFromName(cond)}(1)};
%~~~~~~~~~~~~~~~~
if refLeg == 'R'
    s = 'R';    f = 'L';
elseif refLeg == 'L'
    s = 'L';    f = 'R';
else
    ME=MException('MakeParameters:refLegError','the refLeg/initEventSide property of metaData must be either ''L'' or ''R''.');
    throw(ME);
end
figure; plot(Filtered.getDataAsTS([s 'Fy']).Data, 'b'); hold on; plot(Filtered.getDataAsTS([f 'Fy']).Data, 'r');
for i=1:length(strideEvents.tSHS)-1
        timeGRF=round(Filtered.Time,6);
        SHS=strideEvents.tSHS(i);
        FTO=strideEvents.tFTO(i);
        FHS=strideEvents.tFHS(i);
        STO=strideEvents.tSTO(i);
        FTO2=strideEvents.tFTO2(i);
        SHS2=strideEvents.tSHS2(i);
FastLegOffSetData(i)=nanmedian(Filtered.split(FTO, FHS).getDataAsTS([f 'Fy']).Data);
SlowLegOffSetData(i)=nanmedian(Filtered.split(STO, SHS2).getDataAsTS([s 'Fy']).Data);
end
FastLegOffSet=round(nanmedian(FastLegOffSetData), 3);
SlowLegOffSet=round(nanmedian(SlowLegOffSetData), 3);

Filtered.Data(:, find(strcmp(Filtered.getLabels, [f 'Fy'])))=Filtered.getDataAsVector([f 'Fy'])-FastLegOffSet;
Filtered.Data(:, find(strcmp(Filtered.getLabels, [s 'Fy'])))=Filtered.getDataAsVector([s 'Fy'])-SlowLegOffSet;
figure; plot(Filtered.getDataAsTS([s 'Fy']).Data, 'b'); hold on; plot(Filtered.getDataAsTS([f 'Fy']).Data, 'r');line([0 5*10^5], [0, 0])

%trialData.GRFData
%If I want all the forces to be unitless then set this to 9.81*BW, else set it
%to 1*BW
Normalizer=9.81*BW;
FlipB=1; %7/21/2016

if iscell(trial)
    trial=trial{1};
end

%There is assuredely a better way to do this, but for right now...
%trial
% % % % if ~isempty(regexp(trial, 'deg')) || ~isempty(regexp(trial, '8.5')) 
% % % %     if ~isempty(regexp(trial, '8.5 deg incline')) || ~isempty(regexp(trial, '8.5 deg uphill')) %|| (~isempty(regexp(trial, '8.5 deg'))
% % % %         ang=8.5;
% % % %     elseif ~isempty(regexp(trial, '8.5 deg decline')) || ~isempty(regexp(trial, '8.5 deg downhill'))|| ~isempty(regexp(trial, '8.5 decline'))
% % % %         ang=-8.5;
% % % %     elseif ~isempty(regexp(trial, '5 deg incline'))|| ~isempty(regexp(trial, '5 deg uphill')) || ~isempty(regexp(trial, '5 deg'))
% % % %         ang=5;
% % % %     elseif ~isempty(regexp(trial, '5 deg decline'))|| ~isempty(regexp(trial, '5 deg downhill'))
% % % %         ang=-5;
% % % %     else
% % % %         ang=input(['What angle (in degrees) was the study run at ', trial, ': ',trialData.type ,'?   ']);
% % % %     end
% % % % else
% % % %     ang=0;
% % % % end
[ ang ] = DetermineTMAngle( trial );
flipIT= 2.*(ang >= 0)-1; %This will be -1 when it was a decline study, 1 otherwise
LevelofInterest=flipIT.*cosd(90-abs(ang)); %The actual angle of the incline



%Define the events that will be used for all further computations
eventTypes={[s,'HS'],[f,'TO'],[f,'HS'],[s,'TO']};
eventTypes=strcat(eventClass,eventTypes);
eventLables={'SHS','FTO','FHS','STO'};
triggerEvent=eventTypes{1};

%Initialize:
[numStrides,initTime,endTime]=getStrideInfo(trialData,triggerEvent);
if numStrides==0;    
    disp(['Warning: No strides detected in ',file])
    out=parameterSeries([],{},[],{}); %TODO: Perhaps the reasonable thing is to initializate the parameterSeries with all params and 0 strides instead of empty
    return
end
stridedProcEMG=cell(numStrides,1);
%stridedMarkerData=cell(max(strideIdxs),1);
stridedEventData=cell(numStrides,1);
%Stride:
%steppedDataArray=separateIntoStrides(in,triggerEvent); %This is 
%computationally expensive to do: it calls the split function for every 
%labTS in trialData. If we only care about some fields, we should try 
%calling split independently for those TSs.
eventTimes=nan(numStrides,length(eventTypes));
eventTimes2=nan(numStrides,length(eventTypes));
for i=1:numStrides
    stridedEventData{i}=trialData.('gaitEvents').split(initTime(i),endTime(i));
    for j=1:length(eventTypes)
        aux=stridedEventData{i}.getDataAsVector(eventTypes{j});
        aux=find(aux,2,'first'); %Finding next two events of the type %HH: it is pointless to find the next two events, since find will still return a value even if it only finds one.
        if ~isempty(aux) %HH: maybe instead we should check if aux is has a length of 2
            eventTimes(i,j)=stridedEventData{i}.Time(aux(1));
        end
    end
end
eventTimes2=[eventTimes(2:end,:);nan(1,size(eventTimes,2))]; %This could be improved by trying to find if there exist any other events after the end of the last stride.
for j=1:length(eventTypes)
    strideEvents.(['t' upper(eventLables{j})])=eventTimes(:,j); %generates a structure of tSHS, tFTO, etc
    strideEvents.(['t' upper(eventLables{j}) '2'])=eventTimes2(:,j);
end
%~~~~~~~~~~~~~~~~
striderSE=NaN.*ones(5, 1000);
striderFE=NaN.*ones(5, 1000);
for i=1:5%1:length(strideEvents.tSHS)-1
    timeGRF=round(Filtered.Time,6);
    SHS=strideEvents.tSHS(i);
    FHS=strideEvents.tFHS(i);
    STO=strideEvents.tSTO(i);
    FTO2=strideEvents.tFTO2(i);
    striderSE(i, 1:size(Filtered.split(SHS, STO).getDataAsTS([s 'Fy']).Data, 1))=flipIT.*Filtered.split(SHS, STO).getDataAsTS([s 'Fy']).Data'/Normalizer;  %striderS(i, 1:(STO-SHS).*Filtered.sampFreq)=flipIT.*Filtered.split(SHS, STO).getDataAsTS([s 'Fy']).Data'/Normalizer;  
    %striderF(i, 1:(STO-SHS).*Filtered.sampFreq)=flipIT.*Filtered.split(FHS, FTO2).getDataAsTS([f 'Fy']).Data'/Normalizer;%striderF(i, 1:(FTO2-FHS).*Filtered.sampFreq)=flipIT.*Filtered.split(FHS, FTO2).getDataAsTS([f 'Fy']).Data'/Normalizer;
    ns=find((striderSE(i, :)-LevelofInterest)<0);%1:65
    ps=find((striderSE(i, :)-LevelofInterest)>0);
    
    ImpactMagS=find((striderSE(i, :)-LevelofInterest)==nanmax(striderSE(i, 1:75)-LevelofInterest));%no longer percent of stride
    if isempty(ImpactMagS)~=1
        postImpactS=ns(find(ns>ImpactMagS(end), 1, 'first'));
        if isempty(postImpactS)~=1
            ps(find(ps<postImpactS))=[];
            ns(find(ns<postImpactS))=[];
        end
    end
    
    SBE(i)=FlipB.*(nanmean(striderSE(i, ns)-LevelofInterest));   
    SPE(i)=nanmean(striderSE(i, ps)-LevelofInterest);
end
clear SHS FHS STO FTO2 timeGRF Filtered
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%%
Filtered=expData.data{1, expData.metaData.trialsInCondition{expData.getConditionIdxsFromName(cond)}(end)}.GRFData.lowPassFilter(20);%GRFData;
trialData=expData.data{1, expData.metaData.trialsInCondition{expData.getConditionIdxsFromName(cond)}(end)};

if iscell(trial)
    trial=trial{1};
end
figure; plot(Filtered.getDataAsTS([s 'Fy']).Data, 'b'); hold on; plot(Filtered.getDataAsTS([f 'Fy']).Data, 'r');
for i=1:length(strideEvents.tSHS)-1
        timeGRF=round(Filtered.Time,6);
        SHS=strideEvents.tSHS(i);
        FTO=strideEvents.tFTO(i);
        FHS=strideEvents.tFHS(i);
        STO=strideEvents.tSTO(i);
        FTO2=strideEvents.tFTO2(i);
        SHS2=strideEvents.tSHS2(i);
FastLegOffSetData(i)=nanmedian(Filtered.split(FTO, FHS).getDataAsTS([f 'Fy']).Data);
SlowLegOffSetData(i)=nanmedian(Filtered.split(STO, SHS2).getDataAsTS([s 'Fy']).Data);
end
FastLegOffSet=round(nanmedian(FastLegOffSetData), 3);
SlowLegOffSet=round(nanmedian(SlowLegOffSetData), 3);

Filtered.Data(:, find(strcmp(Filtered.getLabels, [f 'Fy'])))=Filtered.getDataAsVector([f 'Fy'])-FastLegOffSet;
Filtered.Data(:, find(strcmp(Filtered.getLabels, [s 'Fy'])))=Filtered.getDataAsVector([s 'Fy'])-SlowLegOffSet;
figure; plot(Filtered.getDataAsTS([s 'Fy']).Data, 'b'); hold on; plot(Filtered.getDataAsTS([f 'Fy']).Data, 'r');line([0 5*10^5], [0, 0])

%There is assuredely a better way to do this, but for right now...
%trial
% % % % if ~isempty(regexp(trial, 'deg'))
% % % %     if ~isempty(regexp(trial, '8.5 deg incline')) || ~isempty(regexp(trial, '8.5 deg uphill')) %|| (~isempty(regexp(trial, '8.5 deg'))
% % % %         ang=8.5;
% % % %     elseif ~isempty(regexp(trial, '8.5 deg decline')) || ~isempty(regexp(trial, '8.5 deg downhill'))
% % % %         ang=-8.5;
% % % %     elseif ~isempty(regexp(trial, '5 deg incline'))|| ~isempty(regexp(trial, '5 deg uphill')) || ~isempty(regexp(trial, '5 deg'))
% % % %         ang=5;
% % % %     elseif ~isempty(regexp(trial, '5 deg decline'))|| ~isempty(regexp(trial, '5 deg downhill'))
% % % %         ang=-5;
% % % %     else
% % % %         ang=input(['What angle (in degrees) was the study run at ', trial, ': ',trialData.type ,'?   ']);
% % % %     end
% % % % else
% % % %     ang=0;
% % % % end
[ ang ] = DetermineTMAngle( trial );
flipIT= 2.*(ang >= 0)-1; %This will be -1 when it was a decline study, 1 otherwise
LevelofInterest=flipIT.*cosd(90-abs(ang)); %The actual angle of the incline

%Define the events that will be used for all further computations
eventTypes={[s,'HS'],[f,'TO'],[f,'HS'],[s,'TO']};
eventTypes=strcat(eventClass,eventTypes);
eventLables={'SHS','FTO','FHS','STO'};
triggerEvent=eventTypes{1};

%Initialize:
[numStrides,initTime,endTime]=getStrideInfo(trialData,triggerEvent);
if numStrides==0;    
    disp(['Warning: No strides detected in ',file])
    out=parameterSeries([],{},[],{}); %TODO: Perhaps the reasonable thing is to initializate the parameterSeries with all params and 0 strides instead of empty
    return
end
stridedProcEMG=cell(numStrides,1);
%stridedMarkerData=cell(max(strideIdxs),1);
stridedEventData=cell(numStrides,1);
%Stride:
%steppedDataArray=separateIntoStrides(in,triggerEvent); %This is 
%computationally expensive to do: it calls the split function for every 
%labTS in trialData. If we only care about some fields, we should try 
%calling split independently for those TSs.
eventTimes=nan(numStrides,length(eventTypes));
eventTimes2=nan(numStrides,length(eventTypes));
for i=1:numStrides
    stridedEventData{i}=trialData.('gaitEvents').split(initTime(i),endTime(i));
    for j=1:length(eventTypes)
        aux=stridedEventData{i}.getDataAsVector(eventTypes{j});
        aux=find(aux,2,'first'); %Finding next two events of the type %HH: it is pointless to find the next two events, since find will still return a value even if it only finds one.
        if ~isempty(aux) %HH: maybe instead we should check if aux is has a length of 2
            eventTimes(i,j)=stridedEventData{i}.Time(aux(1));
        end
    end
end
eventTimes2=[eventTimes(2:end,:);nan(1,size(eventTimes,2))]; %This could be improved by trying to find if there exist any other events after the end of the last stride.
for j=1:length(eventTypes)
    strideEvents.(['t' upper(eventLables{j})])=eventTimes(:,j); %generates a structure of tSHS, tFTO, etc
    strideEvents.(['t' upper(eventLables{j}) '2'])=eventTimes2(:,j);
end
%~~~~~~~~~~~~~~~~
striderSL=NaN.*ones(40, 1000);
for i=(length(strideEvents.tSHS)-1-5)-40+1:(length(strideEvents.tSHS)-1-5)%1:length(strideEvents.tSHS)-1
    timeGRF=round(Filtered.Time,6);
    SHS=strideEvents.tSHS(i);
    FHS=strideEvents.tFHS(i);
    STO=strideEvents.tSTO(i);
    FTO2=strideEvents.tFTO2(i);
offset=((length(strideEvents.tSHS)-1-5)-40+1)-1;
    striderSL(i-offset, 1:size(Filtered.split(SHS, STO).getDataAsTS([s 'Fy']).Data, 1))=flipIT.*Filtered.split(SHS, STO).getDataAsTS([s 'Fy']).Data'/Normalizer;%striderS(i, 1:(STO-SHS).*Filtered.sampFreq)=flipIT.*Filtered.split(SHS, STO).getDataAsTS([s 'Fy']).Data'/Normalizer;  
    %striderF(i, 1:(STO-SHS).*Filtered.sampFreq)=flipIT.*Filtered.split(FHS, FTO2).getDataAsTS([f 'Fy']).Data'/Normalizer;%striderF(i, 1:(FTO2-FHS).*Filtered.sampFreq)=flipIT.*Filtered.split(FHS, FTO2).getDataAsTS([f 'Fy']).Data'/Normalizer;

  ns=find((striderSL(i-offset, :)-LevelofInterest)<0);%1:65
    ps=find((striderSL(i-offset, :)-LevelofInterest)>0);
    
    ImpactMagS=find((striderSL(i-offset, :)-LevelofInterest)==nanmax(striderSL(i-offset, 1:75)-LevelofInterest));%no longer percent of stride
    if isempty(ImpactMagS)~=1
        postImpactS=ns(find(ns>ImpactMagS(end), 1, 'first'));
        if isempty(postImpactS)~=1
            ps(find(ps<postImpactS))=[];
            ns(find(ns<postImpactS))=[];
        end
    end
    
    SBL(i-offset)=FlipB.*(nanmean(striderSL(i-offset, ns)-LevelofInterest));   
    SPL(i-offset)=nanmean(striderSL(i-offset, ps)-LevelofInterest);
end
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%%
figure
subplot(1, 3, 1)
plot(striderSE', 'b')
hold on
plot(striderSL', 'r')
line([0 600], [LevelofInterest LevelofInterest])
xlabel('Time (ms)')
ylabel('Force (%BW)')
title('LD15: AP-Forces')

subplot(1, 3, 2)
plot(striderSE'-LevelofInterest, 'b')
hold on
plot(striderSL'-LevelofInterest, 'r')
line([0 600], [0 0])
xlabel('Time (ms)')
ylabel('Force (%BW)')
title('LD15: Shifted AP-Forces')


subplot(1, 3, 3)
DataData=[nanmean(SBE)  nanmean(SBL); nanmean(SPE) nanmean(SPL)];
b=bar(DataData);
b(1).FaceColor='b';
b(2).FaceColor='r';
set(gca,'xticklabel',{'Braking', 'Propulsion'})
legend({'Early Adaptation', 'Late Adaptation'})
ylabel('Force (%BW)')
title('Mean Braking and Propulsion')
