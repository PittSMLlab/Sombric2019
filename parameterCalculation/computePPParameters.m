function [ out] = computePPParameters( strideEvents,PPData, slowleg, fastleg, BW, trialData, markerData,eventData )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
PPDataAS=PPData.align(eventData, {[slowleg 'HS'],[fastleg 'TO'],[fastleg 'HS'],[slowleg 'TO']},[15,35,15,35]);
PPDataAF=PPData.align(eventData, {[fastleg 'HS'],[slowleg 'TO'],[slowleg 'HS'],[fastleg 'TO']},[15,35,15,35]);
for i=1:length(strideEvents.tSHS)-1
    if strcmp(slowleg, 'L')
        striderS=PPDataAS.Data(1:65,  1:1260, i);
        striderF=PPDataAF.Data(1:65, 1261:2520, i);
%         striderS=PPData.split(strideEvents.tSHS(i), strideEvents.tSTO(i)).Data(:, 1:1260);
%         striderF=PPData.split(strideEvents.tFHS(i), strideEvents.tFTO2(i)).Data(:, 1281: 2520);
%         footS=PPData.split(strideEvents.tSHS(i), strideEvents.tSTO(i)).dataL;
%         footF=PPData.split(strideEvents.tFHS(i), strideEvents.tFTO2(i)).dataR;
        
    else
                striderF=PPDataAF.Data(1:65,  1:1260, i);
        striderS=PPDataAS.Data(1:65, 1261: 2520, i);
%         striderS=PPDataA.split(strideEvents.tSHS(i), (strideEvents.tSTO(i))).Data(:, 1281: 2560);
%         striderF=PPDataA.split(strideEvents.tFHS(i), (strideEvents.tFTO2(i))).Data(:, 1:1280);
%         footF=PPData.split(strideEvents.tFHS(i), strideEvents.tFTO2(i)).dataL;
%         footS=PPData.split(strideEvents.tSHS(i), strideEvents.tSTO(i)).dataR;
    end
    %% Peak magnitude, and location 
%     peakS(i)=nanmax(nanmax(striderS));
%     peakF(i)=nanmax(nanmax(striderF));
    peakS(i)=nanmax(nansum(striderS, 2));
    peakF(i)=nanmax(nansum(striderF, 2));
    
    %resample 
%     [N, D]=rat(size(striderS, 1)/size(striderF, 1));
%    striderS=resample(striderS, D,N);
   

    
%    HeelLab=PPData.labels
%    MFLab=
%    FFLab=
       %if strcmp(slowleg, 'L')
            %ll= PPData.getLabelsThatMatch('^L');
            footS=reshape(striderS,size(striderS, 1),60,21);                    
            %rl= PPData.getLabelsThatMatch('^R');
footF=reshape(striderF,size(striderF, 1),60,21);   
%     else
%             ll= PPData.getLabelsThatMatch('^L');                      
%             rl= PPData.getLabelsThatMatch('^R');
% 
%     end
        %% Try segmenting the foot
    [r]=find(isnan(squeeze(footS(1, :,10)))==1);
    [r2]=find(isnan(squeeze(footF(1, :,10)))==1);
    if r~=r2
        break
    end
    if isempty(r)
        len=60;
    else
        len=60-length(r);
    end
    
    third=round(len/3); 
%     heelS(i)=nanmax(nanmax(nanmax(footS(:, (third*2)+1:end , :))));
%     MFootS(i)=nanmax(nanmax(nanmax(footS(:,third+1:third*2 , :))));
%     FFootS(i)=nanmax(nanmax(nanmax(footS(:, 1:third , :))));
%     
%       heelF(i)=nanmax(nanmax(nanmax(footF(:, (third*2)+1:end , :))));
%     MFootF(i)=nanmax(nanmax(nanmax(footF(:,third+1:third*2 , :))));
%     FFootF(i)=nanmax(nanmax(nanmax(footF(:, 1:third , :))));
    
    heelS(i)=nanmax(nansum(nansum(footS(:, (third*2)+1:end , :), 2), 3));
MFootS(i)=nanmax(nansum(nansum(footS(:, third+1:third*2 , :), 2), 3));
FFootS(i)=nanmax(nansum(nansum(footS(:, 1:third , :), 2), 3));

    heelF(i)=nanmax(nansum(nansum(footF(:, (third*2)+1:end , :), 2), 3));
MFootF(i)=nanmax(nansum(nansum(footF(:, third+1:third*2 , :), 2), 3));
FFootF(i)=nanmax(nansum(nansum(footF(:, 1:third , :), 2), 3));

    %% Try stat analysis to characterize the distribution of the force on the foot
    SlowCS=nansum(footS, 3)';%CS=Cross Section
    SlowCS(all(SlowCS==0, 2), :)=[];
    Sk = kurtosis(SlowCS);
    Ss = skewness(SlowCS);
    
    FastCS=nansum(footF, 3)';%CS=Cross Section
    FastCS(all(FastCS==0, 2), :)=[];
    Fk = kurtosis(FastCS);
    Fs = skewness(FastCS);
    
    kurt(i)=nanmean(Fk)-nanmean(Sk);
    skew(i)=nanmean(Fs)-nanmean(Ss);
    
    kurtSym(i)=nanmean(Fk-Sk);
    skewSym(i)=nanmean(Fs-Ss);
    if i==5 || i==length(strideEvents.tSHS)-1-5
    c=colormap(jet(size(FastCS, 1)));
    figure
    for ii=1:min([size(FastCS, 1) size(SlowCS, 1)])
        subplot(2, 2, 1)
        plot(SlowCS(ii, :), 'Color', c(ii, :)'); hold on
        subplot(2, 2, 3)
        plot(FastCS(ii, :), 'Color', c(ii, :)'); hold on
    end
    subplot(2, 2, 3)
    colorbar('Ticks',[0,1], 'TickLabels',{'Trial Start','Trial End'})
    title('Fast Leg Cross Section')
    ylim([0 4000])
    subplot(2, 2, 1)
    colorbar('Ticks',[0,1], 'TickLabels',{'Trial Start','Trial End'})
    title('Slow Leg Cross Section')
      ylim([0 4000])
    
    subplot(2, 2, 2)
    plot(Sk, 'b')
    hold on
    plot(Fk, 'r')
    plot(Fk-Sk, 'g')
    title ('Kurtosis')
    xlabel('%Stride')
      ylim([-6 13])
      
    subplot(2, 2, 4)
    plot(Ss, 'b')
    hold on
    plot(Fs, 'r')
    plot(Fs-Ss, 'g')
    title ('Skewness')
    xlabel('%Stride')
      ylim([-1.5 3])
    end
      
%     figure
%     subplot(4, 1, 1)
%     plot(SlowCS)
%     subplot(4, 1, 2)
%     plot(FastCS)
%     subplot(4, 1, 3)
%     plot(Fk-Sk)
%     hold on 
%     ylabel('Delta Kurtosis')
%     subplot(4, 1, 4)
%     plot(Fs-Ss)
%     hold on 
%     ylabel('Delta Skewness')
%     
%     figure
%     subplot(4, 1, 1)
%     plot(SlowCS)
%     subplot(4, 1, 2)
%     plot(Sk)
%     hold on 
%     ylabel('Slow Kurtosis')
%     subplot(4, 1, 3)
%     plot(Ss)
%     hold on 
%     ylabel('Slow Skewness')
    
    clear striderS striderF footS footF SlowCS FastCS
end

peakSym=peakF-peakS;

heelSym=heelF-heelS;
MFootSym=MFootF-MFootS;
FFootSym=FFootF-FFootS;

%% Actually output and store stuff
data=[[peakS NaN]' [peakF NaN]' [peakSym NaN]' [heelS NaN]' [MFootS NaN]' [FFootS NaN]'  [heelF NaN]' [MFootF NaN]' [FFootF NaN]'  [heelSym NaN]' [MFootSym NaN]' [FFootSym NaN]' [kurt NaN]' [skew NaN]'];
labels={'PeakPressureS', 'PeakPressureF', 'PeakPressureSym', 'SHeelPeak', 'SMFootPeak', 'SFFootPeak', 'FHeelPeak', 'FSMFootPeak', 'FFFootPeak', 'SymHeelPeak', 'SymMFootPeak', 'SymFFootPeak', 'Kurt', 'Skew'};
description={'Max force during slow stance', 'Max force during fast stance', 'Max force symmetry during stance', '', '', '','', '', '','', '', '', '', ''};
out=parameterSeries(data,labels,[],description);
end

