function Y = smoothedMin(X,N,vector)
%SMOOTHEDmin finds the minimum value of an N-pt running average 
%   For vectors, smoothedmin(X,N) returns the largest value of the N-pt 
%   running  average of X. For matrixes, smoothedmin(X,N) takes an N-pt running
%   average of each column and returens the largest value within each column.
%
%   xmin=smoothedmin(X,N,dataVector) returns the values of the N-pt
%   running average of X in the same location as the largest value of the
%   N-pt running average of dataVector if dataVector is a column vector that has
%   the same length as the columns of X.

if nargin>2
    if isempty(X)
        newX=NaN(1,size(X,2));
        newVector=NaN;
    elseif size(X,1)<N
        newX=nanmean(X);
        newVector=nanmean(vector);
    else
        [newX,~]=binData(X,N);
        [newVector,~]=binData(vector,N);
    end
    [~,minLoc]=min(abs(newVector),[],1);
    Y=newX(minLoc,:);
else
    if isempty(X)
        newX=NaN(1,size(X,2));        
    elseif size(X,1)<N
        newX=nanmean(X,1);        
    else
        [newX,~]=binData(X,N);        
    end
    [~,minLoc]=min(abs(newX),[],1);
    ind=sub2ind(size(newX),minLoc*ones(1,size(X,2)),1:size(X,2));
    Y=newX(ind,:);
end


end

