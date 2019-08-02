function result = conditionChecker(files, name_of_condition) %filters the list of the files and returns the list based on three possible conditions. 

% you have three conditions in this case. 
% 1) is Axx_trials, which returns the list of Axx trial files (these are
% the Axx files that contain trial files)
% 2) is Axx files. These are averaged files of all trials for each
% condition
% 3) Raw files. These files contain the raw EEG files for all trials and
% conditions

result = {};
if name_of_condition == 1 %extracting Axx files containing trial info
    for i = 1:length(files)
        if fileNameChecker(files(i).name, 'Axx') == 1 && fileNameChecker(files(i).name, 'trials') == 1 
            result = cat(1,result, files(i).name);
        end
    end
elseif name_of_condition == 2 % extracting just Axx files w.o trial data
    
    for i = 1:length(files)
        if fileNameChecker(files(i).name, 'Axx') == 1 && fileNameChecker(files(i).name, 'trials') ~= 1 
            result = cat(1,result, files(i).name);
        end
    end
elseif name_of_condition == 3 % extracting raw files 
    
       for i = 1:length(files)
        if fileNameChecker(files(i).name, 'Raw')
            result = cat(1,result, files(i).name);
        end
       end 
else % in case the user makes a mistake 
    disp('Please enter a valid condition (number 1 to 3)')
end