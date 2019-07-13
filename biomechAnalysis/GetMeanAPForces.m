function [ SBE SPE] = GetMeanAPForces( striderSE, LevelofInterest )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

for i=1:size(striderSE, 1)
    ns=find((striderSE(i, :)-LevelofInterest)<0);%1:65
    ps=find((striderSE(i, :)-LevelofInterest)>0);
    
    %keyboard
    if length(striderSE(i, :))==100
        ImpactMagS=find((striderSE(i, :)-LevelofInterest)==nanmax(striderSE(i, 1:15)-LevelofInterest));%no longer percent of stride
    else
    ImpactMagS=find((striderSE(i, :)-LevelofInterest)==nanmax(striderSE(i, 1:75)-LevelofInterest));%no longer percent of stride
    end
    if isempty(ImpactMagS)~=1
        postImpactS=ns(find(ns>ImpactMagS(end), 1, 'first'));
        if isempty(postImpactS)~=1
            ps(find(ps<postImpactS))=[];
            ns(find(ns<postImpactS))=[];
        end
    end
    
    SBE(i)=(nanmean(striderSE(i, ns)-LevelofInterest));
    SPE(i)=nanmean(striderSE(i, ps)-LevelofInterest);
end
end

