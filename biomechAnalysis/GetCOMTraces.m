function [COM_pos_Fy, COM_pos_Sy, COM_pos_Fz, COM_pos_Sz, COM_velo_Fy, COM_velo_Sy, COM_velo_Fz, COM_velo_Sz] = GetCOMTraces( expData, cond, params,  StrideRange, FromEnd)
%UNTITLED3 This funciton grabs the Marker traces from the experinmental
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
% trial=expData.getConditionIdxsFromName(cond);
trial= expData.metaData.getTrialsInCondition(cond);

domLeg=expData.subData.dominantLeg(1);%THIS IS THE NON-DOMINANT LEG
if domLeg == 'R'
    s = 'L';    f = 'R';
elseif domLeg == 'L'
    s = 'R';    f = 'L';
else
    ME=MException('MakeParameters:domLegError','the domLeg/initEventSide property of metaData must be either ''L'' or ''R''.');
    throw(ME);
end

%%
if FromEnd==1
    markerData=expData.data{trial(end)}.markerData;
    gaitEvents=expData.data{trial(end)}.gaitEvents;
else
    markerData=expData.data{trial(1)}.markerData;
    gaitEvents=expData.data{trial(1)}.gaitEvents;
end

COMTS=markerData.getDataAsTS('BCOM');

[rotatedMarkerData_F]=getKinematicData_respect2Ank(markerData, {[f, 'ANK']});
[rotatedMarkerData_S]=getKinematicData_respect2Ank(markerData, {[s, 'ANK']});

% ROTATED
[COMTS_FANK] = getDataAsTS(rotatedMarkerData_F, {'BCOMx' 'BCOMy' 'BCOMz'});
[COMTS_SANK] =getDataAsTS(rotatedMarkerData_S, {'BCOMx' 'BCOMy' 'BCOMz'});
% Non_rotated
COMTS_unrotated=getDataAsTS(markerData, {'BCOMx' 'BCOMy' 'BCOMz'});

% 4.) Aquire the speed of the COMTS in ankle specific CS for that ankles
% heel strike
veloCOM_F_unfilteredY=COMTS_FANK.derivate.getDataAsTS({'d/dt BCOMy'});
veloCOM_S_unfilteredY=COMTS_SANK.derivate.getDataAsTS({'d/dt BCOMy'});
veloCOM_F_unfilteredZ=COMTS_FANK.derivate.getDataAsTS({'d/dt BCOMz'});
veloCOM_S_unfilteredZ=COMTS_SANK.derivate.getDataAsTS({'d/dt BCOMz'});

veloCOM_unfilteredY=COMTS_unrotated.derivate.getDataAsTS({'d/dt BCOMy'});
veloCOM_unfilteredZ=COMTS_unrotated.derivate.getDataAsTS({'d/dt BCOMz'});

veloCOM_FY=veloCOM_F_unfilteredY.substituteNaNs.lowPassFilter(5);
veloCOM_SY=veloCOM_S_unfilteredY.substituteNaNs.lowPassFilter(5);
veloCOM_FZ=veloCOM_F_unfilteredZ.substituteNaNs.lowPassFilter(5);
veloCOM_SZ=veloCOM_S_unfilteredZ.substituteNaNs.lowPassFilter(5);
veloCOM_Y=veloCOM_unfilteredY.substituteNaNs.lowPassFilter(5);
veloCOM_Z=veloCOM_unfilteredZ.substituteNaNs.lowPassFilter(5);


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %Rotated Data
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %Time Normalied -- Rotated -- COM position
% AlignedCOMTS_F=COMTS_FANK.align(gaitEvents, {[f, 'HS'], [s, 'TO'], [s, 'HS'], [f, 'TO']},  [15 30 15 40]);
% AlignedCOMTS_S=COMTS_SANK.align(gaitEvents,  {[s, 'HS'], [f, 'TO'], [f, 'HS'], [s, 'TO']},  [15 30 15 40]);
% %Time Normalied -- Rotated -- COM velocity
% AlignedCOMVelo_FY=veloCOM_FY.align(gaitEvents, {[f, 'HS'], [s, 'TO'], [s, 'HS'], [f, 'TO']},  [15 30 15 40]);
% AlignedCOMVelo_SY=veloCOM_SY.align(gaitEvents,  {[s, 'HS'], [f, 'TO'], [f, 'HS'], [s, 'TO']},  [15 30 15 40]);
% AlignedCOMVelo_FZ=veloCOM_FZ.align(gaitEvents, {[f, 'HS'], [s, 'TO'], [s, 'HS'], [f, 'TO']},  [15 30 15 40]);
% AlignedCOMVelo_SZ=veloCOM_SZ.align(gaitEvents,  {[s, 'HS'], [f, 'TO'], [f, 'HS'], [s, 'TO']},  [15 30 15 40]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Un-Rotated Data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
warning('THIS IS THE UNROTATED POSITION OF THE COM!!!!!!!!')
%Time Normalied -- Rotated -- COM position
AlignedCOMTS_F=COMTS_unrotated.align(gaitEvents, {[f, 'HS'], [s, 'TO'], [s, 'HS'], [f, 'TO']},  [15 30 15 40]);
AlignedCOMTS_S=COMTS_unrotated.align(gaitEvents,  {[s, 'HS'], [f, 'TO'], [f, 'HS'], [s, 'TO']},  [15 30 15 40]);
%Time Normalied -- Rotated -- COM velocity
AlignedCOMVelo_FY=veloCOM_Y.align(gaitEvents, {[f, 'HS'], [s, 'TO'], [s, 'HS'], [f, 'TO']},  [15 30 15 40]);
AlignedCOMVelo_SY=veloCOM_Y.align(gaitEvents,  {[s, 'HS'], [f, 'TO'], [f, 'HS'], [s, 'TO']},  [15 30 15 40]);
AlignedCOMVelo_FZ=veloCOM_Z.align(gaitEvents, {[f, 'HS'], [s, 'TO'], [s, 'HS'], [f, 'TO']},  [15 30 15 40]);
AlignedCOMVelo_SZ=veloCOM_Z.align(gaitEvents,  {[s, 'HS'], [f, 'TO'], [f, 'HS'], [s, 'TO']},  [15 30 15 40]);


if exist('FromEnd') && FromEnd==1
    COM_pos_Fy=nanmean(AlignedCOMTS_F.Data(:,2, (end-5)-StrideRange+1:(end-5)),3);
    COM_pos_Sy=nanmean(AlignedCOMTS_S.Data(:,2, (end-5)-StrideRange+1:(end-5)),3);
    COM_pos_Fz=nanmean(AlignedCOMTS_F.Data(:,3, (end-5)-StrideRange+1:(end-5)),3);
    COM_pos_Sz=nanmean(AlignedCOMTS_S.Data(:,3, (end-5)-StrideRange+1:(end-5)),3);
    
    COM_velo_Fy=nanmean(AlignedCOMVelo_FY.Data(:, (end-5)-StrideRange+1:(end-5)),2);
    COM_velo_Sy=nanmean(AlignedCOMVelo_SY.Data(:, (end-5)-StrideRange+1:(end-5)),2);
    COM_velo_Fz=nanmean(AlignedCOMVelo_FZ.Data(:, (end-5)-StrideRange+1:(end-5)),2);
    COM_velo_Sz=nanmean(AlignedCOMVelo_SZ.Data(:, (end-5)-StrideRange+1:(end-5)),2);
elseif ~exist('FromEnd') || FromEnd==0
    COM_pos_Fy=nanmean(AlignedCOMTS_F.Data(:,2, StrideRange),3);
    COM_pos_Sy=nanmean(AlignedCOMTS_S.Data(:,2, StrideRange),3);
    COM_pos_Fz=nanmean(AlignedCOMTS_F.Data(:,3, StrideRange),3);
    COM_pos_Sz=nanmean(AlignedCOMTS_S.Data(:,3, StrideRange),3);
    
    COM_velo_Fy=nanmean(AlignedCOMVelo_FY.Data(:, StrideRange),2);
    COM_velo_Sy=nanmean(AlignedCOMVelo_SY.Data(:, StrideRange),2);
    COM_velo_Fz=nanmean(AlignedCOMVelo_FZ.Data(:, StrideRange),2);
    COM_velo_Sz=nanmean(AlignedCOMVelo_SZ.Data(:, StrideRange),2);
end

%%
COM_pos_Fy(61:end)=[];
COM_pos_Sy(61:end)=[];
COM_pos_Fz(61:end)=[];
COM_pos_Sz(61:end)=[];
COM_velo_Fy(61:end)=[];
COM_velo_Sy(61:end)=[];
COM_velo_Fz(61:end)=[];
COM_velo_Sz(61:end)=[];

end