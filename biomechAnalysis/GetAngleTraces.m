function [ striderSL striderFL] = GetAngleTraces( expData, cond, params,  StrideRange, FromEnd)
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
    Filtered=expData.data{1, TNUM}.angleData.lowPassFilter(20);%angleData;
    trialData=expData.data{1, TNUM};
    BAD=expData.data{1, TNUM}.adaptParams.bad;
elseif FromEnd==1
    TNUM=expData.metaData.trialsInCondition{expData.getConditionIdxsFromName(cond)}(end);
    Filtered=expData.data{1, TNUM}.angleData.lowPassFilter(20);%angleData;
    trialData=expData.data{1, TNUM};
    BAD=expData.data{1, TNUM}.adaptParams.bad;
end



%IF I want to time normalize
%keyboard
[SlowAF,~,bad_slow,~]=expData.data{1, TNUM}.angleData.lowPassFilter(20).align(expData.data{1, TNUM}.gaitEvents,{[s 'HS'],[s 'TO']},[100 1]);
[FastAF,~,bad_fast,~]=expData.data{1, TNUM}.angleData.lowPassFilter(20).align(expData.data{1, TNUM}.gaitEvents,{[f 'HS'],[f 'TO']},[100 1]);


%keyboard
[ ang ] = DetermineTMAngle( trial );
flipIT= 2.*(ang >= 0)-1; %This will be -1 when it was a decline study, 1 otherwise
offsetANG=abs(ang);
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

%~~~~~~~~~~~~~~~~~~~~~~~~REMOVE BAD STRIDES ~~~~~~~~~~~~~~~~~~~~~
if exist('FromEnd') && FromEnd==1
    for i=(length(strideEvents.tSHS)-1-5)-StrideRange(1)+1:(length(strideEvents.tSHS)-1-5)
if BAD(i)==1
    blah=[];
    keyboard
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
%         timeGRF=round(Filtered.Time,6);
%         SHS=strideEvents.tSHS(i);
%         FHS=strideEvents.tFHS(i);
%         STO=strideEvents.tSTO(i);
%         FTO2=strideEvents.tFTO2(i);

        striderSL(i-offset, :)=...
flipIT.*(SlowAF.Data(1:100,find(strcmp(SlowAF.labels, [s 'Limb'])),i)'+offsetANG);%
 striderFL(i-offset, :)=...
flipIT.*(FastAF.Data(1:100,find(strcmp(FastAF.labels, [f 'Limb'])),i)'+offsetANG);%

    end
    
elseif ~exist('FromEnd') || FromEnd==0 
    offset=StrideRange(1)-1;
    for i=StrideRange
        timeGRF=round(Filtered.Time,6);
        SHS=strideEvents.tSHS(i);
        FHS=strideEvents.tFHS(i);
        STO=strideEvents.tSTO(i);
        FTO2=strideEvents.tFTO2(i);
striderSL(i-offset, :)=...
flipIT.*(SlowAF.Data(1:100,find(strcmp(SlowAF.labels, [s 'Limb'])),i)'+offsetANG);%
         striderFL(i-offset, :)=...
flipIT.*(FastAF.Data(1:100,find(strcmp(FastAF.labels, [f 'Limb'])),i)'+offsetANG);%
    end
end
striderSL(striderSL==0)=NaN;
striderFL(striderFL==0)=NaN;
clear SHS FHS STO FTO2 timeGRF Filtered
end


