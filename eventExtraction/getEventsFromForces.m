function [LHS,RHS,LTO,RTO]= getEventsFromForces(FzL,FzR,fsample)

%% Get stance phases
th=10; %Detection threshold in Newtons
% CJS MONSTER
if (length(find(FzL>-10))/length(FzL))<0.05
    [stanceL] = getStanceFromForces(FzL, 30, fsample);
    warning('I am doing something weird with the event detection threshold, beware, CJS')
else
    [stanceL] = getStanceFromForces(FzL, th, fsample);
end
[stanceR] = getStanceFromForces(FzR, th, fsample);
%[stanceL] = getStanceFromForcesAlt(FzL, [], fsample); %New method
%[stanceR] = getStanceFromForcesAlt(FzR, [], fsample); %New method

%% Get events from stance
[LHS,RHS,LTO,RTO] = getEventsFromStance(stanceL,stanceR);

%% Eliminate any events that ocurr prior to actual activity in the trial
% This section was commented out by Pablo on 2/20/2015 because it lead to
% the very first step not being properly detected, which can be a big
% problem.

% Rheel=FzR;
% Lheel=FzL;
% aux=Rheel(:,1)-Rheel(1,1); %Zero initial value
% aux2=cumsum(aux.^2); %Cumulative energy 
% begin_index1=find(aux2>.001*aux2(end),1); %First element whose cumulative energy is at least .1% of total energy
% aux=Lheel(:,1)-Lheel(1,1); %Zero initial value
% aux2=cumsum(aux.^2); %Cumulative energy 
% begin_index2=find(aux2>.001*aux2(end),1); %First element whose cumulative energy is at least .1% of total energy
% 
% begin_index=max([begin_index1,begin_index2]);
% 
% LHS(1:begin_index)=false;
% RHS(1:begin_index)=false;
% LTO(1:begin_index)=false;
% RTO(1:begin_index)=false;

%% Check consistency
%[consistent] = checkEventConsistency(LHS,RHS,LTO,RTO);



end

