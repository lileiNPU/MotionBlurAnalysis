clc;
clear;
close all;

toolbox_path = '.\matconvnet\';
run([toolbox_path 'matlab\vl_setupnn.m']);

% network parameters
active_mode = 'relu'; % select activate function 'relu' 'tanh' 'sigmoid'
bn = 0; % whether use batch normalization layer
epoch = 100;
batch_size = 20;
gpu_mode = 1;

magnification_fea_path = 'results\magnification\features\';
norm = 0;
frequency = {[140, 160], [160, 180], [180, 200], [200, 220], [220, 240]};
% frequency = {[0.1, 20], [20, 40], [40, 60], [60, 80], [80, 100], [100, 120], ...
%              [120, 140], [140, 160], [160, 180], [180, 200], [200, 220], [220, 240]};
num_frame = 75;
hist_size = 3 * 256;
for fy = 1 : length(frequency)
    close all
    % init deep network
    [net, eraser_params] = networkInit(active_mode, bn, hist_size);
%     net = eraser(net, eraser_params);
    % training parameters
    net.conserveMemory = 0;
    state.learningRate = 1e-3;
    state.momentum = num2cell(zeros(1, numel(net.params))) ;
    opts.weightDecay = 0.0005 ;
    opts.momentum = 0.9 ; 
    if gpu_mode == 1
        state.momentum = cellfun(@gpuArray, state.momentum, 'UniformOutput', false);
    end
     
    frequency_temp = frequency{fy};
    frequency_temp_down = frequency_temp(1);
    frequency_temp_up = frequency_temp(2);
    freStr = ['Frequency-', num2str(frequency_temp_down), '-', num2str(frequency_temp_up)];
    save_path = ['.\results\net-hist\', freStr];
    if ~exist(save_path)
        mkdir(save_path);
    end
    
    feaPath = [fullfile(magnification_fea_path, freStr), '\'];
    Hist = load([feaPath, 'train_hist.mat']);
    Hist_fea_train = Hist.Hist_fea;
    max_value = max(Hist_fea_train(:));
    min_value = min(Hist_fea_train(:));
%     Hist_fea_train = Hist_fea_train * 1000;
    Hist_label_train = Hist.Hist_label;
    if size(Hist_fea_train, 4) ~= length(Hist_label_train)
        error('The length of training data should be equal to label!');
    end
    Hist = load([feaPath, 'devel_hist.mat']);
    Hist_fea_devel = Hist.Hist_fea;
%     Hist_fea_devel = Hist_fea_devel * 1000;
    Hist_label_devel = Hist.Hist_label;
    if size(Hist_fea_devel, 4) ~= length(Hist_label_devel)
        error('The length of devel data should be equal to label!');
    end
    
    train_epoch_cost = [];
    dev_epoch_cost = [];
    for e = 1 : epoch
        
        if gpu_mode == 1
            net.move('gpu');
        end
        
        train_num_data = numel(Hist_label_train);
        data_select_index = randperm(train_num_data);
        train_cost_all = 0;
        dev_cost_all = 0;
        for i = 1 : batch_size : train_num_data
            batchTrainStart = min(i, train_num_data);
            batchTrainEnd = min(i + batch_size - 1, train_num_data);
            batchNum = batchTrainEnd - batchTrainStart + 1;
            hist = Hist_fea_train(:, :, :, data_select_index(batchTrainStart : batchTrainEnd));
            label = Hist_label_train(data_select_index(batchTrainStart : batchTrainEnd));
            % Forward to the network
            if ~isa(hist, 'single')
                hist = single(hist);
            end
            if gpu_mode == 1
                hist = gpuArray(hist);
            end
            inputs = {'input', hist, 'label', label};
            net.eval(inputs, {'objective', 1});
            loss_classification = net.vars(net.getVarIndex('objective')).value;
            fprintf('%s: Train histogram network -- epoch: %d|%d minibatch: %d|%d Loss=%s \n', freStr, epoch, e, train_num_data, i, num2str(loss_classification/batchNum));
            train_cost_all = train_cost_all + loss_classification;
            % update the parameters
            state = updateNet(state, net, opts, batchNum);
%             net = eraser(net, eraser_params);
        end
        train_epoch_cost = [train_epoch_cost train_cost_all/train_num_data];
        figure(1);
        semilogy(1 : e, train_epoch_cost, 'ro-');
        
         % dev set
         dev_num_data = numel(Hist_label_devel);
         for d = 1 : batch_size : dev_num_data
             batchDevStart = min(d, dev_num_data);
             batchDevEnd = min(d + batch_size - 1, dev_num_data);
             batchNum = batchDevEnd - batchDevStart + 1;
             hist = Hist_fea_devel(:, :, :, batchDevStart : batchDevEnd);
             label = Hist_label_devel(batchDevStart : batchDevEnd);
             % Forward to the network
             if ~isa(hist, 'single')
                 hist = single(hist);
             end
             if gpu_mode == 1
                 hist = gpuArray(hist);
             end
            inputs = {'input', hist, 'label', label};
            net.eval(inputs);
            loss_classification = net.vars(net.getVarIndex('objective')).value;
            dev_cost_all = dev_cost_all + loss_classification;
            fprintf('%s: Devel histogram network -- epoch: %d|%d minibatch: %d|%d Loss=%s \n', freStr, epoch, e, dev_num_data, d, num2str(loss_classification/batchNum));            
         end
         dev_epoch_cost = [dev_epoch_cost dev_cost_all/dev_num_data];
         figure(1); hold on;
         semilogy(1 : e, dev_epoch_cost, 'b*-');
        
          figure(1);
          legend('Train Classification Cost', 'Dev Classification Cost');
          xlabel('epoch');
          title('The curves of cost.');
          grid on;
          drawnow;
          print(1, fullfile(save_path, 'net-train.pdf'), '-dpdf');
           
          netStruct = net.saveobj() ;
          save(fullfile(save_path, ['net_', num2str(e), '.mat']), '-struct', 'netStruct', '-v7.3');
          
    end
    
end