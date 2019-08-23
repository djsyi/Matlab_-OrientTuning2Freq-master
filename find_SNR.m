% This function finds the Signal to Noise Ratio
% by comparing the max of low, medium, high contrasts with the average
function z = findSNR(orientation, low_contrasts, medium_contrasts, high_contrasts, average_contrasts)
    zero_index = find(orientation==0, 1, 'first')
    zero_low = low_contrasts(zero_index)
    zero_med = medium_contrasts(zero_index)
    zero_hi = high_contrasts(zero_index)
    zero_average = average_contrasts(zero_index)
    max_zero_height = max([zero_low, zero_med, zero_hi])
    z =  max_zero_height / zero_average
end