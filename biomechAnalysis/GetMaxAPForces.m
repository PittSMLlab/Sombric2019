function [ B P Bindex Pindex] = GetMaxAPForces( striderSE, LevelofInterest )
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
    
    ns(find(ns>=90))=[]; % This is to prevent us from identifiying the tail end of the trace as teh braking force 4/11/2017
    
    if isempty(ns)
        B(i)=NaN;
        Bindex(i)=NaN;
    else
        [B(i) Bindex(i)]=(nanmin(striderSE(i, ns)-LevelofInterest));
        % Bindex(i)=Bindex(i)+ns(1)-1;
        Bindex(i)=ns(Bindex(i));
    end
    
    if isempty(ps)
        P(i)=NaN;
        Pindex(i)=NaN;
    else
        [P(i) Pindex(i)]=nanmax(striderSE(i, ps)-LevelofInterest);
        %Pindex(i)=Pindex(i)+ps(1)-1;
        Pindex(i)=ps(Pindex(i));
        if P(i)~=(striderSE(i, Pindex(i))-LevelofInterest)
            display('')
        end
    end
    
end
end

