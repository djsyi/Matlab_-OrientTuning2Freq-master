function z = frequencyPlot(cond, conditions_to_visualize, channel_to_visualize)

% Wrtitten by Reza Moein Taghavi April of 2018
% if you have any questions, contact me at rezamoeint@gmail.com

% this function plots the frequency amplitudes of EEG data obtained from
% PowerDiva up to 50 Hz of frequency. 

% ***********
% Variables
% ***********

% cond relates to the sort of data you would like to analyze. Your options are: 
%  1) Axx_trial 
%  2) Axx 
%  3) Raw EEG


% conditions to visualize is the conditions within the directory you would
% like to visualize. This is variable, depending on your data. 

% channel to visualize refers to the channel (out of the 128) that you
% would like to analyze. If you don't pass any argument for this, the
% program goes for the default channel, which is 75. 

%***********************
% running this function
% **********************

% a sample command would be:
% frequencyPlot (3, '1-9', 75) .then select the directory where the Power
% Diva files are located.

% the above command visualizes the Raw EEG data for conditions 1 to 9 from
% channel 75. 

% you have the option of plotting the conditions of choice by using the a
% format such as: frequencyPlot (3, '1,5,7,20') which will plot the
% frequncy plot of conditions 1,5,7, and 20. 

% --------------------------------------------------------------------

% this block checks the conditions_to_visualize entry and splits it into a
% matrix of condition numbers
if exist('conditions_to_visualize', 'var') == 0 
    disp('please enter a valid condition 1-9 ');
    return
elseif ~isempty(strfind(conditions_to_visualize, ','))
    
    conditions_to_visualize = str2double(strsplit(conditions_to_visualize,','));
    
elseif ~isempty(strfind(conditions_to_visualize, '-'))
    
    conditions_to_visualize = str2double(strsplit(conditions_to_visualize,'-'));
    conditions_to_visualize = conditions_to_visualize(1):conditions_to_visualize(2);
else 
    conditions_to_visualize = str2double(conditions_to_visualize);
end



if lower(cond) == 'raw'
    cond = 3;
elseif cond == 'trial'
    cond = 1;
elseif lower(cond) == 'axx'
    cond = 2;
end


if cond == 3
    data = readPowerDiva(cond);
else
    [~, ampl] = readPowerDiva(cond);
end

if exist('channel_to_visualize', 'var') == 0
    channel_to_visualize = 75; %the default channel to analyze in case no argument is passed for it
end


if exist('data','var') == 1
    o = size(data);
    if o(end) < max(conditions_to_visualize) % checks to make sure the number of conditions the user enters matchthe data in the directory
        disp('At least one of your selected conditions exceeds the number of conditions in this directory.')
        disp('Please revise the number of conditions.');
        disp('Quitting the program!');
        return
    end
else
    o = size(ampl);
    if o(end) < max(conditions_to_visualize) % checks to make sure the number of conditions the user enters matchthe data in the directory
    disp('At least one of your selected conditions exceeds the number of conditions in this directory.')
    disp('Please revise the number of conditions.');
    disp('Quitting the program!');
    return
    end
end


% this if block determines the size of the subplot plot
if length(conditions_to_visualize) == 1
    [subplot_x, subplot_y] = subplot_num_gen(1);
    conditions_to_visualize = [conditions_to_visualize;conditions_to_visualize]; %this ensures that the loop below will work
else
    [subplot_x, subplot_y] = subplot_num_gen(length(conditions_to_visualize)); % this finds the
    % optimal dimensions for the subplot
end


%*************************************************************
%*************************************************************

% this section is for reading the raw EEG data

%*************************************************************
%*************************************************************


if cond == 3
    a = squeeze(data(:,2:size(data,2) - 1, channel_to_visualize, :,:)); % excluding the first and the last epochs from the analysis
    % a = squeeze(data(:,:, channel_to_visualize, :,:));
    new_dimensions = [size(data,1)*2, (size(data,2)-2)/2, size(data,4), size(data,5)]; % reshaping it because we want to
    % use 2 second epochs for plotting frequency ampl. This increases the
    % resolution to 0.5 hz as opposed to 1 hz.
    a = reshape(a, new_dimensions);
    a = squeeze(mean(mean(a,2),3)); % averaging epochs
    jj = 1; % loop counter
    
    if exist('ampls', 'var') ==1
        clear ampls
    end
    
%     ampls = zeros(str2double(conditions_to_visualize(2))...
%         - str2double(conditions_to_visualize(1))+1,2);
    for i = 1: length(conditions_to_visualize)
        ampls(i,:) = freq_ampl(a(:,i), 420, 100);
    end
    
    ampls = max(max(ampls)); % this variable is used to normalize the scale of
    % y-axis across all graphs
    
    
    for c = conditions_to_visualize % looping over conditions
        
        
        x = 0:1000/size(data,1):1000;
        x = x(1:size(data,1)); %timestamp for graphing
        % disp(jj) for debugging purposes 
        subplot(subplot_x, subplot_y, jj)
        freq_plot(a(:, conditions_to_visualize(jj)), 420, 100)
        ylim([0, ampls]);
        title(strcat({'Condition'}, {' '}, {num2str(conditions_to_visualize(jj))}))
        jj = jj+1;
    end
    
    
    
    %*************************************************************
    %*************************************************************
    
    % this section is for plotting freq ampl of processed Axx files w.o trial data
    
    %*************************************************************
    %*************************************************************
    
elseif cond == 2
    jj = 1;
    a = squeeze(ampl (:, channel_to_visualize, :));
    ampl_scale = a(:, conditions_to_visualize);
    ampl_scale = max(max(ampl_scale));
    
    for c = conditions_to_visualize
        
        subplot(subplot_x, subplot_y, jj)
        hold on;
        axx_freq_plot(a(:,conditions_to_visualize(jj)));
        ylim([0, ampl_scale]);
        
        title(strcat({'Condition'}, {' '}, {num2str(conditions_to_visualize(jj))}))
        jj = jj +1;
    end
    
    
%*************************************************************
%*************************************************************

% this section is for reading the processed Axx files WITH trial data

%*************************************************************
%*************************************************************

    
elseif cond == 1
    jj = 1;
    a = squeeze(mean(ampl,3));
    a = squeeze(a (:, channel_to_visualize, :));
    
    ampl_scale = a(:, conditions_to_visualize);
    ampl_scale = max(max(ampl_scale));
    
    for c = conditions_to_visualize % looping over conditions
        
        subplot(subplot_x, subplot_y, jj)
        
        hold on;
        axx_freq_plot(a(:,conditions_to_visualize(jj)));
        ylim([0, ampl_scale]);
        
        title(strcat({'Condition'}, {' '}, {num2str(conditions_to_visualize(jj))}))
        jj = jj +1;
    end
    
end


end

