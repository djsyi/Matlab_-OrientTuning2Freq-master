% clear; clc;

% this script graphs the frequency amplitudes of the conditions of the
% experiment. Then it 
freq_ampl_final = [];
trials = squeeze(cat(3,[1:9], [10:18], [19:27]));

cd('/Users/reza/Dropbox/Research_Stuff/Neuro/Justin Gardner/Matlab Files/20180313/Exp_MATL_HCN_128_Avg')
% cd('/Users/reza/Dropbox/Research_Stuff/Neuro/Justin Gardner/Matlab Files/20180309/Exp_MATL_HCN_128_Avg')
for k = 1:3 %number of experiments. in this case we're analyzing the data from 3 experiments 
    % so we're simply looping over the whole thing

    ch75 = [];
    % this loop extracts all the data from channel 75 for a single condition in the variable ch75. 

    j = '1'; % this is the number of conditions while i is the number of trial 
    
    % these nested loops read the raw EEG files 
    for j = 1:9 % nine conditions for each experiment 
        jj = trials(j,k);
%         disp (strcat('jj = ', num2str(jj)))
%         disp (strcat('k = ', num2str(k)))
        temp = [];
        for i = 1:10 % 10 trials for each condition 
            if i <10
                i = strcat('0',num2str(i));
            else 
                i = num2str(i);
            end
            
            if jj <10
                jj = strcat('0',num2str(jj));
            else 
                jj = num2str(jj);
            end
            temp = load(strcat('Raw_c0', num2str(jj),'_t0', num2str(i),'.mat'));
            if i ==1
                ch75 = temp.RawTrial(:,75);
            else
                ch75 = horzcat(ch75,temp.RawTrial(:,75));
            end
        end
    end

    ch75 = reshape(ch75, [5040, 10, 9]); % reshaping this variable so that each trial is in the 2nd dimension of the variable
    % and each condition is in the third dimension 

    ampl_coefficient = temp.Ampl(75,:); %amplitude scaling coefficients
    shift = temp.Shift(75,:);  % DC offset coefficient

    % preallocating the variable to speed up the program
    ch75_2 = zeros(5040/12, size(ch75,2), size(ch75,3));
    temp = [];
    % the outer loop is for repeating the same operation for different conditions
    for j = 1: size(ch75,3)
        % averaging each 420 points (or each epoch)
        for i = 1:size(ch75,2)
            temp = ch75(:,i, j);
            temp2= reshape(temp,[420,12]);
            temp2 = mean(temp2,2); % averaging the 12 epochs
            ch75_2(:,i, j) = temp2;
        end
    end

    ch75_main = ch75_2;
    ch75_2 = squeeze(mean(ch75_2,2)); % averaging of the 10 trials, which is the average data for one condition
    % so each column of this variable represents the average data for each condition (in this case, we have 9 conditions)

    % clear i, j, temp;

%     ch75_2 = ch75_2 * ampl_coefficient + shift;
%     ch75_main = ch75_main * ampl_coefficient + shift; % this contains each trial data too
% 
%    
%     x = reshape(ch75_main, [840, 5, 9]);
%     % [1:7, 10:16, 19:25]
%     trial_angles = [0,7, 15, 30, 45, 70, 90, 0.3, 0.5];
%     freq_ampl = [];
%     figure(k)
%     for i = 1:9
%         ylim([0,6 *10^-4])
%         x2 = mean(squeeze(x(:,:, i)),2);
%         subplot(3,3,i)
%         freq_ampl(:,i) = freq_plot(x2,420,100);
%         title (strcat('this is plot', num2str(i), 'trial angle: ', num2str(trial_angles(i))))
%     end
%     freq_ampl_final = cat(3, freq_ampl_final, freq_ampl);
%     disp (strcat('Done with the analysis of experiment number', num2str(k)));
end


%%
trial_angles = [-90 ,-70, -45, -30, -15 ,-7,0, 7, 15, 30, 45, 70, 90];
dataz = [];
for k = 1:3
    plot(trial_angles, horzcat(flip(freq_ampl_final(1,2:7, k),2), freq_ampl_final(1,1:7, k)))
    dataz = cat(3, dataz,horzcat(flip(freq_ampl_final(1,2:7, k),2), freq_ampl_final(1,1:7, k)));
%     plot (trial_angles, freq_ampl_final(1,1:7, k))
    hold on;
end

xlabel 'Frequency (Hz)'
ylabel '|y|'

title('Averaged Tuning bandwidth based on 1f1 - 1f2 (2 Hz)');
legend('high contrast', 'med contrast', 'low contrast');


dataz = squeeze(dataz);
%%

%%
dataz = [];
trial_angles = [-90 ,-70, -45, -30, -15 ,-7,0, 7, 15, 30, 45, 70, 90];
for k = 1:3
    plot(trial_angles, horzcat(flip(freq_ampl_final(2,2:7, k),2), freq_ampl_final(2,1:7, k)))
    dataz = cat(3, dataz,horzcat(flip(freq_ampl_final(2,2:7, k),2), freq_ampl_final(2,1:7, k)));
    hold on;
end

xlabel 'Frequency (Hz)'
ylabel '|y|'

title('Averaged Tuning bandwidth based on 1f1 + 1f2 (8 Hz)');
legend('high contrast', 'med contrast', 'low contrast');

dataz = squeeze(dataz);

%%

d2 = dataz;

%% run the script with the other set of data and then this finds the averages


k = cat(3,dataz,d2);

plot(trial_angles,mean(k,3));

xlabel 'Frequency (Hz)'
ylabel '|y|'
