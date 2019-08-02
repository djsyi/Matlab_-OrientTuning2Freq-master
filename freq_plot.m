function z = freq_plot(x, Fs, freq_granularity)
    % x is the vector of signal data
    % Fs is the sampling frequency of the data 
    % freq_granularity is the upper limit of the number of frequency points
    % you want to show in your graph. Adjust it according to the resolution
    % of the data and your desired range of frequency to be plotted. 
    
    % figure('rend','painters','pos',[10 10 1000 700])

    x = detrend(x,0);
    xdft = fft(x);
    freq = 0:Fs/length(x):Fs/2;

    y = fft(x);
    ly = length(y);
    f = (-ly/2:ly/2-1)/ly*Fs;
    a = abs(fftshift(y));

    x1= f(f>0); % this is used for plotting the frequency values. 
    y1 = a(f>0); % excluding the negative frequency values
    
    if freq_granularity == 50
        first_grating_frequency_idx = [3:3:freq_granularity]; % these indices are used for graphing them in different colors
        second_grating_frequency_idx = [5:5:freq_granularity];
    else
        first_grating_frequency_idx = [6:6:freq_granularity]; % these indices are used for graphing them in different colors
        second_grating_frequency_idx = [10:10:freq_granularity];
    end


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
    
%     z = vertcat(y1(second_grating_frequency_idx(1)- first_grating_frequency_idx(1))...
%         ,y1(second_grating_frequency_idx(1)+ first_grating_frequency_idx(1))); % I'm using this to extract the freq amplitude info for 2f1 and 2f2 (2nd harmonic)

    hold off;
    
    % first exported number from this function is 1f2 - 1f1 and the second number is 1f2+ 1f1
end

