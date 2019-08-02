function z = freq_ampl(x, Fs, freq_granularity)
    % x is the vector of signal data
    % Fs is the sampling frequency of the data 
    % freq_granularity is the upper limit of the number of frequency points
    % for instance, if you have 2 seconds worth of data, then your
    % frequency amplitude resolution is 0.5 Hz. In our case, that would be
    % 840 data points. So in that case, we pick 100 for granularity (since
    % we care about the first 50 hz)

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

    
    z = vertcat(y1(second_grating_frequency_idx(1)- first_grating_frequency_idx(1))...
        ,y1(second_grating_frequency_idx(1)+ first_grating_frequency_idx(1))); % I'm using this to extract the freq amplitude info for 2f1 and 2f2 (2nd harmonic)

    % first exported number from this function is 1f2 - 1f1 and the second number is 1f2+ 1f1
end

