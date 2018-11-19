clc;
clear;
close all;

toolbox_path = '..\..\toolbox\EVM_Matlab';
addpath(toolbox_path);
addpath([toolbox_path, '\matlabPyrTools']);
addpath([toolbox_path, '\matlabPyrTools\MEX']);

source_video_path = 'results\magnification\Original';
set = {'Train', 'Dev', 'Test'};
face_style = {'real', 'replay'};
attack_mode = {'fixed', 'hand'};
save_video_path = 'results\magnification';
frequency = {[0.1, 20], [20, 40]};%, [40, 60], [60, 80], [80, 100], [100, 120]};
for fy = 1 : length(frequency)
    frequency_temp = frequency{fy};
    frequency_temp_down = frequency_temp(1);
    frequency_temp_up = frequency_temp(2);
    freStr = ['Frequency-', num2str(frequency_temp_down), '-', num2str(frequency_temp_up)];
    for s = 1 : length(set)
        for f = 1 : length(face_style)           
            resultsDir = fullfile(save_video_path, freStr, set{s}, face_style{f});
            mkdir(resultsDir);
            video_path_all = [source_video_path, '\', set{s}, '\', face_style{f}];
            files = dir(fullfile(video_path_all, '*.avi'));
            for v = 1 : length(files)
                fprintf('Frequency %s-%s Video Magnification: %s set %s style do %d|%d   \n', num2str(frequency_temp_down), num2str(frequency_temp_up), set{s}, face_style{f}, length(files), v);
                video_name = files(v).name;
                video_path = fullfile(video_path_all, video_name);
                amplify_spatial_lpyr_temporal_butter(video_path, resultsDir, 500, 200, frequency_temp_down, frequency_temp_up, 600, 0);
                fprintf('\n');
            end       
        end
    end
end

