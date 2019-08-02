function z = timeSeriesPlot(cond, conditions_to_visualize, channel_to_visualize)

% Wrtitten by Reza Moein Taghavi April of 2018
% if you have any questions, contact me at rezamoeint@gmail.com

% This function plots the time series EEG data obtained from Power Diva. 

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
% timeSeriesPlot (3, '1-9', 75) .then select the directory where the Power
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
    disp('please enter a valid condition (i.e. 1-9)');
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
     

data = readPowerDiva(cond);

if exist('channel_to_visualize', 'var') == 0
    channel_to_visualize = 75; %the default channel to analyze in case no argument is passed for it
end

o = size(data);
if o(end) < max(conditions_to_visualize) % checks to make sure the number of conditions the user enters matchthe data in the directory
    disp('At least one of your selected conditions exceed the number of conditions in this directory.')
    disp('Please revise the number of conditions.');
    disp('Quitting the program!');
    return
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
    
    
    a = data(:,2:11, :, :,:); % excluding the first and the last epochs from the analysis
    a = squeeze(mean(a,2)); % averaging epochs
    a = squeeze(a(:, channel_to_visualize, :, :)); % squeezing the variable to eliminate extra dimension
    jj = 1; % loop counter
    for c = conditions_to_visualize % looping over conditions
        
        temp = a(:,:,conditions_to_visualize(jj));
        
        x = 0:1000/size(temp,1):1000;
        x = x(1:size(temp,1)); %timestamp for graphing
        
        subplot(subplot_x, subplot_y, jj)
        
        for t = 1:size(data,4) % looping over trials
            
            if t < size(data,4)
                hold on;
                plot (x, temp(:,t), 'color',[.5,.5,.5])
                xlabel('Time (ms)')
                ylabel('Signal Amplitude (uV)')
                
            else
                
                hold on;
                plot (x, temp(:,t), 'color',[.5,.5,.5])
                xlabel('Time (ms)')
                ylabel('Signal Amplitude (uV)')
                
                plot(x, mean(temp,2), 'r', 'LineWidth',2) % this plots the average of trials in red
                hold off;
            end
        end
        title(strcat({'Condition'}, {' '}, {num2str(conditions_to_visualize(jj))}))
        jj = jj+1;
    end
    

%*************************************************************
%*************************************************************

% this section is for plotting the processed Axx files w.o trial data

%*************************************************************
%*************************************************************
    
    
elseif cond == 2
    jj = 1;
    a = squeeze(data (:, channel_to_visualize, :));
    
    for c = conditions_to_visualize % looping over conditions
        
        x = 0:1000/size(a,1):1000;
        x = x(1:size(a,1)); %timestamp for graphing
        
        subplot(subplot_x, subplot_y, jj)
        
        hold on;
        plot (x, a(:,conditions_to_visualize(jj)), 'b', 'LineWidth',2)
        xlabel('Time (ms)')
        ylabel('Signal Amplitude (uV)')
        title(strcat({'Condition'}, {' '}, {num2str(conditions_to_visualize(jj))}))
        jj = jj +1;
    end

    
%*************************************************************
%*************************************************************

% this section is for reading the processed Axx files WITH trial data

%*************************************************************
%*************************************************************

elseif cond == 1
    a = data(:, :, :,:);
    a = squeeze(a(:, channel_to_visualize, :, :));
    jj = 1;
    for c = conditions_to_visualize % looping over conditions

        temp = a(:,:,conditions_to_visualize(jj));

        x = 0:1000/size(temp,1):1000;
        x = x(1:size(temp,1)); %timestamp for graphing

        subplot(subplot_x, subplot_y, jj)

        for t = 1:size(data,3) % looping over trials

            if t < size(data,3)
                hold on;
                plot (x, temp(:,t), 'color',[.5,.5,.5])
                xlabel('Time (ms)')
                ylabel('Signal Amplitude (uV)')

            else

                hold on;
                plot (x, temp(:,t), 'color',[.5,.5,.5])
                xlabel('Time (ms)')
                ylabel('Signal Amplitude (uV)')

                plot(x, mean(temp,2), 'r', 'LineWidth',2)
                hold off;
            end
        end
        title(strcat({'Condition'}, {' '}, {num2str(conditions_to_visualize(jj))}))
        jj = jj+1;
    end



end


end
%
%
%