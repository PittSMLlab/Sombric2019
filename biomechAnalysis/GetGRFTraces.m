function [ striderSL striderFL, LevelofInterest] = GetGRFTraces( expData, cond, params,  StrideRange, FromEnd)
%UNTITLED3 This funciton grabs the force traces from the experinmental
%data, it also exports a "Level of Interest" which will be zero unless the
%GRF data was shifted because of inclination.
%   ExpData is where the experimental data is input
%   Condition, example 'adaptation'
%   Params, example {'LFy', 'RFy'}
%   StideRange, example [1:5]
%   FromEnd, if 1 then it takes the last strides from the last trial for a
%   condition
% Example:
% [striderSE, striderFE, LevelofInterest]=GetGRFTraces(expData,cond , params,  [1:20], 0);
% [striderSL, striderFL, LevelofInterest]=GetGRFTraces(expData, cond, params,  [40], 1);

%eval(['load(' subject '.mat)']);

if length(StrideRange)>=2 && FromEnd==1
    display('Only input one value for stride range and this code will take the StrideRange -5 from the end')
    keyboard
end

%~~~~~~~ Load Relavent Trial/Subject INFO ~~~~~~~~
trial=expData.metaData.conditionDescription(expData.getConditionIdxsFromName(cond));
BW=expData.subData.weight;

domLeg=expData.subData.dominantLeg(1);%THIS IS THE NON-DOMINANT LEG
if domLeg == 'R'
        s = 'L';    f = 'R';
elseif domLeg == 'L'
    s = 'R';    f = 'L';
else
    ME=MException('MakeParameters:domLegError','the domLeg/initEventSide property of metaData must be either ''L'' or ''R''.');
    throw(ME);
end

eventClass='';
if ~exist('FromEnd') || FromEnd==0
    TNUM=expData.metaData.trialsInCondition{expData.getConditionIdxsFromName(cond)}(1);
    Filtered=expData.data{1, TNUM}.GRFData.lowPassFilter(20);%GRFData;
    trialData=expData.data{1, TNUM};
    BAD=expData.data{1, TNUM}.adaptParams.bad;
elseif FromEnd==1
    TNUM=expData.metaData.trialsInCondition{expData.getConditionIdxsFromName(cond)}(end);
    Filtered=expData.data{1, TNUM}.GRFData.lowPassFilter(20);%GRFData;
    trialData=expData.data{1, TNUM};
    BAD=expData.data{1, TNUM}.adaptParams.bad;
end

%IF I want to time normalize
%keyboard
% [SlowAF,~,bad_slow,~]=expData.data{1, TNUM}.GRFData.lowPassFilter(20).align(expData.data{1, TNUM}.gaitEvents,{[s 'HS'],[s 'TO']},[100 1]);
% [FastAF,~,bad_fast,~]=expData.data{1, TNUM}.GRFData.lowPassFilter(20).align(expData.data{1, TNUM}.gaitEvents,{[f 'HS'],[f 'TO']},[100 1]);
[SlowAF]=expData.data{1, TNUM}.GRFData.lowPassFilter(20).align(expData.data{1, TNUM}.gaitEvents,{[s 'HS'],[s 'TO']},[100 1]);
[FastAF]=expData.data{1, TNUM}.GRFData.lowPassFilter(20).align(expData.data{1, TNUM}.gaitEvents,{[f 'HS'],[f 'TO']},[100 1]);

%If I want all the forces to be unitless then set this to 9.81*BW, else set it
%to 1*BW
Normalizer=9.81*BW;
FlipB=1; %7/21/2016

if iscell(trial)
    trial=trial{1};
end

[ ang ] = DetermineTMAngle( trial );
flipIT= 2.*(ang >= 0)-1; %This will be -1 when it was a decline study, 1 otherwise
% LevelofInterest=flipIT.*cosd(90-abs(ang)); %The actual angle of the incline
LevelofInterest=0.5.*flipIT.*cosd(90-abs(ang)); %Multiply by 1/2
%~~~~~~~~~~~~~~~~ DEFINE GAIT/TIME EVENTS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
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
%~~~~~~~~~~~~~~~~ REMOVE ANY OFFSETS IN THE DATA~~~~~~~~~~~~~~~~~~~~~~~~~~~
%figure; plot(Filtered.getDataAsTS([s 'Fy']).Data, 'b'); hold on; plot(Filtered.getDataAsTS([f 'Fy']).Data, 'r');
for i=1:length(strideEvents.tSHS)-1
        timeGRF=round(Filtered.Time,6);
        SHS=strideEvents.tSHS(i);
        FTO=strideEvents.tFTO(i);
        FHS=strideEvents.tFHS(i);
        STO=strideEvents.tSTO(i);
        FTO2=strideEvents.tFTO2(i);
        SHS2=strideEvents.tSHS2(i);
                if isnan(FTO) || isnan(FHS)
            FastLegOffSetData(i)=NaN;
        else
            FastLegOffSetData(i)=nanmedian(Filtered.split(FTO, FHS).getDataAsTS([f 'Fy']).Data);
        end
        if isnan(STO) || isnan(SHS2)
            SlowLegOffSetData(i)=NaN;
        else
            SlowLegOffSetData(i)=nanmedian(Filtered.split(STO, SHS2).getDataAsTS([s 'Fy']).Data);
        end
end

if length(strideEvents.tSHS)<StrideRange
    display('NOT ENOUGH DATA POINTS')
    StrideRange=length(strideEvents.tSHS)-6;
end

FastLegOffSet=round(nanmedian(FastLegOffSetData), 3);
SlowLegOffSet=round(nanmedian(SlowLegOffSetData), 3);
display(['Fast Leg Off Set: ' num2str(FastLegOffSet) ', Slow Leg OffSet: ' num2str(SlowLegOffSet)]);

Filtered.Data(:, find(strcmp(Filtered.getLabels, [f 'Fy'])))=Filtered.getDataAsVector([f 'Fy'])-FastLegOffSet;
Filtered.Data(:, find(strcmp(Filtered.getLabels, [s 'Fy'])))=Filtered.getDataAsVector([s 'Fy'])-SlowLegOffSet;
% figure; plot(Filtered.getDataAsTS([s 'Fy']).Data, 'b'); hold on; plot(Filtered.getDataAsTS([f 'Fy']).Data, 'r');line([0 5*10^5], [0, 0])
% figure; plot(Filtered.getDataAsTS([s 'Fz']).Data, 'b'); hold on; plot(Filtered.getDataAsTS([f 'Fz']).Data, 'r');line([0 5*10^5], [0, 0])
%~~~~~~~~~~~~~~~~~~~~~~~~REMOVE BAD STRIDES ~~~~~~~~~~~~~~~~~~~~~
if exist('FromEnd') && FromEnd==1
    for i=(length(strideEvents.tSHS)-1-5)-StrideRange(1)+1:(length(strideEvents.tSHS)-1-5)
        if BAD(i)==1
%             blah=[];
%             keyboard
%CJS --> I am not sure if this is correct... 2/14 -- Happy Valentines Day
StrideRange(i-((length(strideEvents.tSHS)-1-5)-StrideRange(1)))=NaN;
%StrideRange(end+1)=StrideRange(end)+1;
        end
    end
    
elseif ~exist('FromEnd') || FromEnd==0
    
    for i=StrideRange
        if BAD(i)==1
            StrideRange(i)=[];
            StrideRange(end+1)=StrideRange(end)+1;
        end
    end
end

%~~~~~~~~~~~~~~~~~~~~~~~~Get the GRF stride by stride ~~~~~~~~~~~~~~~~~~~~~
striderSL=NaN.*ones(length(StrideRange), 100);
striderFL=NaN.*ones(length(StrideRange), 100);

if exist('FromEnd') && FromEnd==1
    offset=((length(strideEvents.tSHS)-1-5)-StrideRange(1)+1)-1;
    for i=(length(strideEvents.tSHS)-1-5)-StrideRange(1)+1:(length(strideEvents.tSHS)-1-5)
        timeGRF=round(Filtered.Time,6);
        SHS=strideEvents.tSHS(i);
        FHS=strideEvents.tFHS(i);
        STO=strideEvents.tSTO(i);
        FTO2=strideEvents.tFTO2(i);
        %striderSL(i-offset, 1:size(Filtered.split(SHS, STO).getDataAsTS([s 'Fy']).Data, 1))=flipIT.*Filtered.split(SHS, STO).getDataAsTS([s 'Fy']).Data'/Normalizer;%
        %striderFL(i-offset, 1:size(Filtered.split(FHS, FTO2).getDataAsTS([f 'Fy']).Data, 1))=flipIT.*Filtered.split(FHS, FTO2).getDataAsTS([f 'Fy']).Data'/Normalizer;%
        %keyboard
        striderSL(i-offset, :)=...
            flipIT.*(SlowAF.Data(1:100,find(strcmp(SlowAF.labels, [s 'Fy'])),i)'-SlowLegOffSet)/Normalizer;%
        striderFL(i-offset, :)=...
            flipIT.*(FastAF.Data(1:100,find(strcmp(FastAF.labels, [f 'Fy'])),i)'-FastLegOffSet)/Normalizer;%
        
    end
    
elseif ~exist('FromEnd') || FromEnd==0
    offset=StrideRange(1)-1;
    for i=StrideRange
        timeGRF=round(Filtered.Time,6);
        SHS=strideEvents.tSHS(i);
        FHS=strideEvents.tFHS(i);
        STO=strideEvents.tSTO(i);
        FTO2=strideEvents.tFTO2(i);
        %striderSL(i-offset, 1:size(Filtered.split(SHS, STO).getDataAsTS([s 'Fy']).Data, 1))=flipIT.*Filtered.split(SHS, STO).getDataAsTS([s 'Fy']).Data'/Normalizer;%
        %striderFL(i-offset, 1:size(Filtered.split(FHS, FTO2).getDataAsTS([f 'Fy']).Data, 1))=flipIT.*Filtered.split(FHS, FTO2).getDataAsTS([f 'Fy']).Data'/Normalizer;%
        striderSL(i-offset, :)=...
            flipIT.*(SlowAF.Data(1:100,find(strcmp(SlowAF.labels, [s 'Fy'])),i)'-SlowLegOffSet)/Normalizer;%
        striderFL(i-offset, :)=...
            flipIT.*(FastAF.Data(1:100,find(strcmp(FastAF.labels, [f 'Fy'])),i)'-FastLegOffSet)/Normalizer;%
    end
end
striderSL(striderSL==0)=NaN;
striderFL(striderFL==0)=NaN;
clear SHS FHS STO FTO2 timeGRF Filtered
end

