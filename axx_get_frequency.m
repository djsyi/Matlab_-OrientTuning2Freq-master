% This function returns the frequency amplitudes from the axx data
% that matches the target_freq

function z = axx_get_frequency(x, target_freq)

% x is the vector of axx data
% target_freq is the frequency of interest

freq_granularity = 100;
x1 = 0.5:0.5:50;
y1 = x(2:101);

z = y1(find(x1 == target_freq))
end