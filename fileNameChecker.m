function z = fileNameChecker(file_name,target_word)
% the point of this function is to break apart the name of the files and
% return true if the name contains the target_word
% target_word = lower(target_word);

file_name = strsplit(file_name,{'.','_'});

for i = 1: length(file_name)
%     disp(char(file_name(i)))
    if strcmp(char(file_name(i)), target_word) == 1
        z = 1;
        return 
    else
        z = 0;
    end
end


end
