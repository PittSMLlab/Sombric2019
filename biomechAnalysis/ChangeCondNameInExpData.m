function ChangeCondNameInExpData( subjects, oldNames, newNames )
%ChangeCondNameInExpData --> change trial descriptions in expData
%   Condition descriptions are found in two places in expData, bummer.
%   And I need to extract information from the descriptions for the force
%   analysis, bummer^2.
%   Therefore, I have written this idiotic function which will change the
%   trial descriptions in expData.metaData AND expData.data, your welcome.
%
%   eg1
%   oldNames={'50 strides at 0.5 m/s','50 strides at 1.5 m/s','50 strides at 1.0 m/s','50 strides at 0.5 m/s w/ treadmill at 8.5 deg incline','10 strides 3:1','50 strides at 1.5 m/s w/ treadmill at 8.5 deg incline','50 strides at 1.0 m/s w/ treadmill at 8.5 deg incline','200 strides 3:1','200 strides at 1.0 m/s w/ treadmill at 8.5 deg incline','200 strides at 1.0 m/s w/ treadmill flat'};
%   newNames={'50 strides at 0.5 m/s','50 strides at 1.5 m/s','50 strides at 1.0 m/s','50 strides at 0.5 m/s w/ treadmill at 8.5 deg decline','10 strides 3:1 treadmill at 8.5 deg decline','50 strides at 1.5 m/s w/ treadmill at 8.5 deg decline','50 strides at 1.0 m/s w/ treadmill at 8.5 deg decline','200 strides 3:1 treadmill at 8.5 deg decline','200 strides at 1.0 m/s w/ treadmill at 8.5 deg decline','200 strides at 1.0 m/s w/ treadmill flat'};
%   ChangeCondNameInExpData('LD0017', oldNames, newNames)
%
%   eg2
%   oldNames={'50 strides at 0.5 m/s','50 strides at 1.5 m/s','50 strides at 1.0 m/s','50 strides at 0.5 m/s w/ treadmill at 8.5 deg incline','10 strides 3:1','50 strides at 1.5 m/s w/ treadmill at 8.5 deg incline','50 strides at 1.0 m/s w/ treadmill at 8.5 deg incline','200 strides 3:1','200 strides at 1.0 m/s w/ treadmill at 8.5 deg incline','200 strides at 1.0 m/s w/ treadmill flat'};
%   newNames={'50 strides at 0.5 m/s','50 strides at 1.5 m/s','50 strides at 1.0 m/s','50 strides at 0.5 m/s w/ treadmill at 8.5 deg incline','10 strides 3:1 w/ treadmill at 8.5 deg incline','50 strides at 1.5 m/s w/ treadmill at 8.5 deg incline','50 strides at 1.0 m/s w/ treadmill at 8.5 deg incline','200 strides 3:1 w/ treadmill at 8.5 deg incline','200 strides at 1.0 m/s w/ treadmill at 8.5 deg incline','200 strides at 1.0 m/s w/ treadmill flat'};
%   ChangeCondNameInExpData('LI0018', oldNames, newNames)

h=waitbar(0, 'Updating...');
hw=findobj(h,'Type','Patch');
set(hw,'EdgeColor',[0 0 1],'FaceColor',[0 0 1]) % changes the color to green

if isa(subjects,'char')
    subjects={subjects};    
end

for s=1:length(subjects)
    try
        load([subjects{s} '.mat'])
        saveloc = [];
    catch
        try
            load([subjects{s} filesep char(s) '.mat'])
            saveloc=[subjects{s} filesep];
        catch
            ME=MException('makeDataObject:loadSubject',[char(s) ' could not be loaded, try changing your matlab path.']);
            throw(ME)
        end
    end
    
    %~~~~~ Make the meta trial descriptions something else
    
    for c=1:length(oldNames)
        ind=find(ismember(expData.metaData.conditionDescription,oldNames(c)));
        if isempty(ind)
            warning([subjects{s}  '''s file does not contain condition ''' oldNames{c} ''' and was not replaced with ''' newNames{c} ''''])
            break
            continue
        else
            expData.metaData.conditionDescription{ind(1)}=newNames{c};
        end
    end
    
    %~~~~~ Make the meta trial description and the data trial descriptions the
    %same
    trials=cell2mat(expData.metaData.trialsInCondition);
    
    for t=trials
        cond=expData.data{t}.metaData.condition;
        expData.data{t}.metaData.description=expData.metaData.conditionDescription(cond);
    end
    
    save([saveloc subjects{s} '.mat'],'expData', '-v7.3'); %overwrites file
end

close(h)

end

