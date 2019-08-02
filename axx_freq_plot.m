function z = axx_freq_plot(x, Fs, plot)
    % x is the vector of signal data
    % Fs is the sampling frequency of the data 
    % you want to show in your graph. Adjust it according to the resolution
    % of the data and your desired range of frequency to be plotted. 

    if exist('plot', 'var') == 0
        plot = 1;
    end
    
    if exist('Fs', 'var') == 0
        Fs = 420;
    end
    
    freq_granularity = 100;
    x1 = 0.5:0.5:50;

    y1 = x(2:101); % I'm limiting the data to this range: 0.5 hz to 50 hz
    
    first_grating_frequency_idx = [6:6:freq_granularity]; % these indices are used for graphing them in different colors
    second_grating_frequency_idx = [10:10:freq_granularity];

   if plot == 1

        stem(x1(1:freq_granularity),y1(1:freq_granularity), 'color',[.5,.6,0.7]); % plotting all frequencies in gray 
        hold on;

        stem(x1(second_grating_frequency_idx),y1(second_grating_frequency_idx), 'r'); % plotting f2 harmonics in red

        stem(x1(first_grating_frequency_idx),y1(first_grating_frequency_idx), 'g'); %plotting f1 harmonics in green

        % this takes care of indexing the intermodulation indexing for plots
        % with different resolutions
        if freq_granularity == 50
            stem(x1(2),y1(2), 'm');
            stem(x1(8),y1(8), 'b');
        else
            stem(x1(4),y1(4), 'm');
            stem(x1(16),y1(16), 'b');
        end
        legend( {'', 'f2','f1', '1f2-1f1','1f2+1f1' }, 'Location', 'NorthEast' )

        xlabel 'Frequency (Hz)'
        ylabel '|y|'

    hold off;
end

