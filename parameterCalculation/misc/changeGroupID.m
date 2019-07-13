function changeGroupID(subID,oldID,newID)
%Changes the condition names of a param file. 
%   INPTUS:
%   subID: a string (or cell array of strings) with the subject's ID (i.e. the
%   characters preceeding 'params' in the file name)
%   oldID: a string (or cell array of strings) with the condition name(s) to be replaced
%   newID: a string (or cell array of strings) with the condition name(s) that should replace the old ones
%Check inputs.

if isa(subID,'char')
    subID={subID};
elseif ~(isa(subID,'cell') && isa(subID{1},'char'))       
    ME=MException('changeCondName:inputMismatch','subID needs to be a string or cell array of strings.');
    throw(ME);
end

if isa(oldID,'char')
    oldID={oldID};
elseif ~(isa(oldID,'cell') && isa(oldID{1},'char'))       
   ME=MException('changeCondName:inputMismatch','oldID needs to be a string or cell array of strings.');
   throw(ME);
end

if isa(newID,'char')
    newID={newID};
elseif ~(isa(newID,'cell') && isa(newID{1},'char'))       
   ME=MException('changeCondName:inputMismatch','oldID needs to be a string or cell array of strings.');
   throw(ME);
end

if length(oldID) ~= length(newID)
   ME=MException('changeCondName:badInput','oldID and newID inputs must be the same length.');
   throw(ME);
end

for s=1:length(subID)
    try
        load([subID{s} 'params.mat'])
    catch
        ME=MException('changeCondName:badInput',['The params file for ' subID{s} ' does not appear to be in your curent folder.']);
        throw(ME);
    end
    adaptData.metaData.ID(regexp(adaptData.metaData.ID,'[_ ]'))=[];% CJS, will remov ethe "_" 
    if strcmp(adaptData.metaData.ID, oldID)==1
        adaptData.metaData.ID=newID{1};
    else
        warning([subID{s}  '''s file does not have and ID called ''' oldID{1} ''' and was not replaced with ''' newID{1} ''''])
    end
    
    save([subID{s} 'params.mat'],'adaptData','-v7.3')
end


    
    

end

