clc;
clear;
close all;

magnification_video_path = '.\results\magnification\';
frequency = {[0.1, 20], [20, 40]};
set = {'Train', 'Dev', 'Test'};
face_style = {'real', 'replay'};

fea_save_path = fullfile(magnification_video_path, 'features');
mkdir(fea_save_path);

shape = 'valid';

for fy = 1 : length(frequency)
    frequency_temp = frequency{fy};
    frequency_temp_down = frequency_temp(1);
    frequency_temp_up = frequency_temp(2);
    freStr = ['Frequency-', num2str(frequency_temp_down), '-', num2str(frequency_temp_up)];
    fea_save_path = fullfile(magnification_video_path, 'features', freStr);
    mkdir(fea_save_path);
    for s = 1 : length(set)
        fea = {};
        label = [];
        video_index = [];
        video_index_temp = 0;
        for f = 1 : length(face_style)
            if f == 1
                video_path_all = [magnification_video_path, freStr, '\', set{s}, '\', face_style{f}];
                files = dir(fullfile(video_path_all, '*.avi'));
                
                for v = 1 : length(files)
                    fprintf('Frequency %s-%s Video Feature Extraction: %s set %s style do %d|%d   \n', num2str(frequency_temp_down), num2str(frequency_temp_up), set{s}, face_style{f}, length(files), v);
                    video_name = files(v).name;
                    video_path = fullfile(video_path_all, video_name);
                    % Read video
                    vid = VideoReader(video_path);
                    nFrames=vid.NumberOfFrames;
                    fs=vid.FrameRate;
                    video_hist = [];
                    for j = 1 : nFrames
                        cframe = read(vid,j);
                        cframe_r = cframe(:, :, 1);
                        [code_r_hist, codedMap_r] = LCBPextraction(cframe_r, shape);
                        cframe_g = cframe(:, :, 2);
                        [code_g_hist, codedMap_g] = LCBPextraction(cframe_g, shape);
                        cframe_b = cframe(:, :, 3);
                        [code_b_hist, codedMap_b] = LCBPextraction(cframe_b, shape);
                        cframe_hist = [code_r_hist code_g_hist code_b_hist];
                        video_hist = [video_hist; cframe_hist];                   
                    end
                    if isempty(fea)
                        fea{1} = video_hist;
                    else
                        fea{end + 1} = video_hist;
                    end
                    label = [label 1];
                end
            end
            if f == 2
                    
                video_path_all = [magnification_video_path, freStr, '\', set{s}, '\', face_style{f}];
                files = dir(fullfile(video_path_all, '*.avi'));
                
                for v = 1 : length(files)
                    fprintf('Frequency %s-%s Video Feature Extraction: %s set %s style do %d|%d   \n', num2str(frequency_temp_down), num2str(frequency_temp_up), set{s}, face_style{f}, length(files), v);
                    video_name = files(v).name;
                    video_path = fullfile(video_path_all, video_name);
                    % Read video
                    vid = VideoReader(video_path);
                    nFrames=vid.NumberOfFrames;
                    video_hist = [];
                    for j = 1 : nFrames
                        cframe = read(vid,j);
                        cframe_r = cframe(:, :, 1);
                        [code_r_hist, codedMap_r] = LCBPextraction(cframe_r, shape);
                        cframe_g = cframe(:, :, 2);
                        [code_g_hist, codedMap_g] = LCBPextraction(cframe_g, shape);
                        cframe_b = cframe(:, :, 3);
                        [code_b_hist, codedMap_b] = LCBPextraction(cframe_b, shape);
                        cframe_hist = [code_r_hist code_g_hist code_b_hist];
                        video_hist = [video_hist; cframe_hist];
                    end
                    if isempty(fea)
                        fea{1} = video_hist;
                    else
                        fea{end + 1} = video_hist;
                    end
                    label = [label 2];
                end
                
            end
        end
        save([fea_save_path, '\', set{s}, '_LCBP.mat'], 'fea', 'label',  '-v7.3');
    end
end