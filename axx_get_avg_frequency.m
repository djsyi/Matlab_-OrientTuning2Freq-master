% This function returns the average frequency amplitudes 
% from the axx data that matches 
% target_freq - 0.5 and target_freq + 0.5

function z = axx_get_avg_frequency(x, target_freq)

% x is the vector of axx data
% target_freq is the frequency of interest

freq_granularity = 100;
x1 = 0.5:0.5:50;
y1 = x(2:101);

left = y1(find(x1 == target_freq - 0.5))
right = y1(find(x1 == target_freq + 0.5))
z = (left + right) / 2
end
