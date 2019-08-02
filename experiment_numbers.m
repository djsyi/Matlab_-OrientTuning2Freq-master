function [a2, b2] = experiment_numbers(files)
% this function finds the number of conditions and trials given the list of
% the files in a directory. So the input of this function is the list of
% files in the directory, which is the output of function conditionChecker.

% file_directory = uigetdir();

% files = dir(fullfile(file_directory, '*.mat'));
% 
% files = conditionChecker(files, 3);
z = {};
for i = 1:length(files)
    z(i, :) = strsplit(char(files(i)), {'_', '.', 'c', 't'});
end



a = z(:,2);

b = z(:,3);

a2 = zeros(size(a));
b2 = zeros(size(b));

for i = 1:length(a)
    a2(i) = str2double(a(i));
    b2(i) = str2double(b(i));
end

    a2 = max(a2); %number of conditions in the directory 
    b2 = max(b2); % number of trials in each condition 
end