function z = get_frequency(x, target_freq)

freq_granularity = 100;
x1 = 0.5:0.5:50;
y1 = x(2:101);

z = y1(find(x1 == target_freq))
end