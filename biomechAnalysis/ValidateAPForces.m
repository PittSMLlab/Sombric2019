%Validate the forces
% CJS 8/2016
close all
clear all
%subject='LD0030';
%subject='LD0021';
subject='LI0024';
%subject='LN0003';
load([subject '.mat']);%load('LD0030.mat')
%cond='TM base';
cond='adaptation';
%% 1.) Shift the raw forces base on 1/2 BW
trial=expData.metaData.conditionDescription(expData.getConditionIdxsFromName(cond));
BW=expData.subData.weight;
TNUM=expData.metaData.trialsInCondition{expData.getConditionIdxsFromName(cond)}(1);
 trialData=expData.data{1, TNUM};
 
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
%If I want all the forces to be unitless then set this to 9.81*BW, else set it
%to 1*BW
Normalizer=9.81*BW;
FlipB=1; %7/21/2016

if iscell(trial)
    trial=trial{1};
end

[ ang ] = DetermineTMAngle( trial );%The actual angle of the incline
flipIT= 2.*(ang >= 0)-1; %This will be -1 when it was a decline study, 1 otherwise
LevelofInterest=0.5.*flipIT.*cosd(90-abs(ang)); %Multiply by 1/2
%LevelofInterest=flipIT.*cosd(90-abs(ang)); %Multiply by 1/2
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

 %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%IF I want to time normalize
%keyboard
%  SlowFy=((flipIT.*expData.data{1, TNUM}.GRFData.lowPassFilter(20).getDataAsTS([s 'Fy']).Data)./Normalizer)-LevelofInterest;
%  FastFy=((flipIT.*expData.data{1, TNUM}.GRFData.lowPassFilter(20).getDataAsTS([f 'Fy']).Data)./Normalizer)-LevelofInterest;
%   SlowFy=((flipIT.*expData.data{1, TNUM}.GRFData.split(strideEvents.tSHS(6), strideEvents.tSTO(end-5)).lowPassFilter(20).getDataAsTS([s 'Fy']).Data)./Normalizer)-LevelofInterest;
%  FastFy=((flipIT.*expData.data{1, TNUM}.GRFData.split(strideEvents.tSHS(6), strideEvents.tSTO(end-5)).lowPassFilter(20).getDataAsTS([f 'Fy']).Data)./Normalizer)-LevelofInterest;
%  time=expData.data{1, TNUM}.GRFData.split(strideEvents.tSHS(6), strideEvents.tSTO(end-5)).Time;

% Just need to remove the bias prior to all this...
 SlowFy=((flipIT.*expData.data{1, TNUM}.GRFData.split(strideEvents.tSHS(6), strideEvents.tSHS(end-5)).lowPassFilter(20).getDataAsTS([s 'Fy']).Data)./Normalizer)-LevelofInterest;
 FastFy=((flipIT.*expData.data{1, TNUM}.GRFData.split(strideEvents.tSHS(6), strideEvents.tSHS(end-5)).lowPassFilter(20).getDataAsTS([f 'Fy']).Data)./Normalizer)-LevelofInterest;
 time=expData.data{1, TNUM}.GRFData.split(strideEvents.tSHS(6), strideEvents.tSHS(end-5)).Time;

 % SlowFy(find(round(SlowFy, 4)==-1.*round(LevelofInterest, 4)))=NaN;
% FastFy(find(round(FastFy, 4)==-1.*round(LevelofInterest, 4)))=NaN;
 %TESTING

%% 2.) Sum the shifted Fy forces
SummedFy=nansum([SlowFy'; FastFy']);

%% 3.) Integrate along the trial/condition (Trapz?)
Q=trapz(time, SummedFy);
display(['The integration of the summed forces is ' num2str(Q) ' %BW*seconds.'])
QinPBW=Q/(time(end)-time(1));%Units %BW
QinNewtons=Normalizer.*QinPBW;%Units Newtons
display(['Which is  ' num2str(QinPBW) ' %BW, which corresponds to ' num2str(QinNewtons) ' Newtons.'])
figure; plot(SlowFy, 'b'); hold on; plot(FastFy, 'r'); plot(SummedFy, 'k'); refline([0 0]); legend('SlowAPForces', 'FastAPForces', 'SummedAPForces')
title([{[subject ': ' cond]; ['The inegration of the summed forces is ' num2str(Q) ' %BW*seconds.']; ['Which is  ' num2str(QinPBW) ' %BW,']; ['which corresponds to ' num2str(QinNewtons) ' Newtons fot this subject.']}])
xlabel('Time (sec)')
ylabel('Force (%BW)')