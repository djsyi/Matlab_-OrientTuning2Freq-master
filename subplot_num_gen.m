function [a,b] = subplot_num_gen(num_graphs)
% this function finds the 2 numbers you need for the inputs of the subplot 
% function, which defines the size of the graph in x and y directions
% various shapes. So instead of you defining these numbers manually, this
% function does it for you automatically. 

a = 1;
b = 1;
count = 1;
if num_graphs == 1
    a = 1;
    b = 1;
else
    
    while true

        if mod(count,2) ~= 0 
            if a*b < num_graphs
                a= a+1;
            else
                break
            end
        elseif mod(count,2) == 0
            if a*b < num_graphs
                b= b+1;
            else
                break
            end 
        end
        count = count+1;
    end
end
    