function [rotatedMarkerData]=getKinematicData_respect2Ank(markerData, REFEREE)
%getKinematicData   loads marker data sampled only at time of gait events
%
%getKinematicData generates:
%
% Three dimensional matrices in the format:
%   number of strides x 6 events (SHS thru FTO2) x 2 dimensions (x,y)
% whith variable names:
%   sAnk2D, fAnk2D 
%
% Two dimensional matrices in the format:
%   number of strides x 6 events (SHS thru FTO2)
% with variable names:
%   sAnkFwd, fAnkFwd: ankle position in fore-aft direction with respect to avg hip
%   sAngle, fAngle: limb angles (angle of hip-ankle vector with respect to verticle)                         
%
% direction: a vector with length equal to the number of strides and
%   values of 1 if walking towards the door in the lab and -1 if walking
%   towards the window.

% Three dimensional matrices in the format:
%   number of strides x 6 events (SHS thru FTO2) x 3 dimensions (x,y,z)
% whith variable names:
%   sHip 
%   fHip
%   sAnk
%   fAnk
%   sToe
%   fToe

% %THE FOLLOWING RELIES ON HAVING A DECENT RECONSTRUCTION OF HIP MARKERS:
% refMarker3D=.5*sum(markerData.getOrientedData({'LHIP','RHIP'}),2); %midHip

%Ref axis option 1 (ideal): Body reference
refAxis=squeeze(markerData.getOrientedData(REFEREE)); %L to R

%THE FOLLOWING RELIES ON HAVING A DECENT RECONSTRUCTION OF ANKLE MARKERS:
%refMarker3D=.5*sum(markerData.getOrientedData({'RANK'}),2); %midHip
refMarker3D=(markerData.getOrientedData(REFEREE)); %L or R ank

%Ref axis option 2 (assuming the subject walks only along the y axis):
refAxis=refAxis*[1,0,0]' *[1,0,0]; %Projecting along x direction, this is equivalent to just determining forward/backward sign
rotatedMarkerData=markerData.translate(-squeeze(refMarker3D)).alignRotate(refAxis,[0,0,1]);



end