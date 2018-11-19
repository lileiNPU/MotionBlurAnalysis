clc;
clear;
close all;

toolbox_path = '.\matconvnet\';
run([toolbox_path 'matlab\vl_setupnn.m']);
shown = 0;
% network parameters
gpu_mode = 1;


magnification_fea_path = 'results\magnification\features\';
norm = 0;
frequency = {[0.1, 20], [20, 40], [40, 60], [60, 80], [80, 100], [100, 120], ...
             [120, 140], [140, 160], [160, 180], [180, 200], [200, 220], [220, 240]};
net_select = [80, 60, 8, 20, 51, 10, 10, 11, 6, 8, 63, 6];
for fy = 1 : length(frequency)
        
    %% Features extracted from LSP
    frequency_temp = frequency{fy};
    frequency_temp_down = frequency_temp(1);
    frequency_temp_up = frequency_temp(2);
    freStr = ['Frequency-', num2str(frequency_temp_down), '-', num2str(frequency_temp_up)];
    freStrTemp = ['FrequencyTo', num2str(frequency_temp_up)];
    net_path = ['.\results\net-hist\', freStr];
   
    
    feaPath = [fullfile(magnification_fea_path, freStr), '\'];
    Hist = load([feaPath, 'train_LCBP_process.mat']);
    Hist_fea_train = Hist.Hist_fea;
    max_value = max(Hist_fea_train(:));
    min_value = min(Hist_fea_train(:));
    Hist_label_train = Hist.Hist_label;
    Hist = load([feaPath, 'devel_LCBP_process.mat']);
    Hist_fea_devel = Hist.Hist_fea;
    Hist_label_devel = Hist.Hist_label;
    Hist = load([feaPath, 'test_LCBP_process.mat']);
    Hist_fea_test = Hist.Hist_fea;
    Hist_label_test = Hist.Hist_label;
    
    % train set
    fea = [];
    train_num_data = numel(Hist_label_train);
    for i = 1 : train_num_data 
        hist = Hist_fea_train(:, :, :, i);
        fea_from_hist = mean(hist, 1);
        fea = [fea; fea_from_hist];
    end
    Train_fea_from_hist_lsp.fea = fea;
    Train_fea_from_hist_lsp.label = Hist_label_train;
    
    % dev set
    fea = [];
    dev_num_data = numel(Hist_label_devel);
    for d = 1 : dev_num_data       
        hist = Hist_fea_devel(:, :, :, d);
        fea_from_hist = mean(hist, 1);
        fea = [fea; fea_from_hist];
    end
    Dev_fea_from_hist_lsp.fea = fea;
    Dev_fea_from_hist_lsp.label = Hist_label_devel;   
    
    % test set
    fea = [];
    test_num_data = numel(Hist_label_test);
    for t = 1 : test_num_data      
        hist = Hist_fea_test(:, :, :, t);
        fea_from_hist = mean(hist, 1);
        fea = [fea; fea_from_hist];
    end
    Test_fea_from_hist_lsp.fea = fea;
    Test_fea_from_hist_lsp.label = Hist_label_test;   
    
    
    %% Features extracted from CNN
%     frequency_temp = frequency{fy};
%     frequency_temp_down = frequency_temp(1);
%     frequency_temp_up = frequency_temp(2);
    frequency_temp_down = 180;
    frequency_temp_up = 200;
    freStr = ['Frequency-', num2str(frequency_temp_down), '-', num2str(frequency_temp_up)];
    net_path = ['.\results\net-hist\', freStr];
    
    net = load(fullfile(net_path, ['net_', num2str(net_select(10)), '.mat']));
    net = dagnn.DagNN.loadobj(net);
    net.conserveMemory = 0;
    
    feaPath = [fullfile(magnification_fea_path, freStr), '\'];
    Hist = load([feaPath, 'train_hist.mat']);
    Hist_fea_train = Hist.Hist_fea;
    max_value = max(Hist_fea_train(:));
    min_value = min(Hist_fea_train(:));
    Hist_label_train = Hist.Hist_label;
    Hist = load([feaPath, 'devel_hist.mat']);
    Hist_fea_devel = Hist.Hist_fea;
    Hist_label_devel = Hist.Hist_label;
    Hist = load([feaPath, 'test_hist.mat']);
    Hist_fea_test = Hist.Hist_fea;
    Hist_label_test = Hist.Hist_label;
    
    if gpu_mode == 1
        net.move('gpu');
    end   
    
    % train set
    fea = [];
    train_num_data = numel(Hist_label_train);
    for i = 1 : train_num_data %fake start 3541
        hist = Hist_fea_train(:, :, :, i);
        label = Hist_label_train(i);
        if ~isa(hist, 'single')
            hist = single(hist);
        end
        if gpu_mode == 1
            hist = gpuArray(hist);
        end
        inputs = {'input', hist, 'label', label};
        net.eval(inputs);
        fea_from_hist = net.vars(net.getVarIndex('map_19')).value;
        if isa(fea_from_hist, 'gpuArray')
            fea_from_hist = gather(fea_from_hist);
        end  
        fea_from_hist = reshape(fea_from_hist, [1 numel(fea_from_hist)]);
        fea = [fea; fea_from_hist];
%         if label == 2
%             keyboard;
%         end
        if shown == 1
            hist_show = hist;
            figure(1);
            imagesc(hist_show);
            colorbar;
            colormap jet
            figure(2);
            plot(fea_from_hist)
        end
        
    end
    Train_fea_from_hist_cnn.fea = fea;
    Train_fea_from_hist_cnn.label = Hist_label_train;
    
    % dev set
    fea = [];
    dev_num_data = numel(Hist_label_devel);
    for d = 1 : dev_num_data       
        hist = Hist_fea_devel(:, :, :, d);
        label = Hist_label_devel(d);
        if ~isa(hist, 'single')
            hist = single(hist);
        end
        if gpu_mode == 1
            hist = gpuArray(hist);
        end
        inputs = {'input', hist, 'label', label};
        net.eval(inputs);
        fea_from_hist = net.vars(net.getVarIndex('map_19')).value;
        if isa(fea_from_hist, 'gpuArray')
            fea_from_hist = gather(fea_from_hist);
        end
        fea_from_hist = reshape(fea_from_hist, [1 numel(fea_from_hist)]);
        fea = [fea; fea_from_hist];
    end
    Dev_fea_from_hist_cnn.fea = fea;
    Dev_fea_from_hist_cnn.label = Hist_label_devel;   
    
    % test set
    fea = [];
    test_num_data = numel(Hist_label_test);
    for t = 1 : test_num_data      
        hist = Hist_fea_test(:, :, :, t);
        label = Hist_label_test(t);
        if ~isa(hist, 'single')
            hist = single(hist);
        end
        if gpu_mode == 1
            hist = gpuArray(hist);
        end
        inputs = {'input', hist, 'label', label};
        net.eval(inputs);
        fea_from_hist = net.vars(net.getVarIndex('map_19')).value;
        if isa(fea_from_hist, 'gpuArray')
            fea_from_hist = gather(fea_from_hist);
        end
        fea_from_hist = reshape(fea_from_hist, [1 numel(fea_from_hist)]);
        fea = [fea; fea_from_hist];
    end
    Test_fea_from_hist_cnn.fea = fea;
    Test_fea_from_hist_cnn.label = Hist_label_test;   
    
    %% Fusion
    train_fea_lsp = Train_fea_from_hist_lsp.fea;
    train_fea_cnn = Train_fea_from_hist_cnn.fea;
    train_Data = [train_fea_lsp train_fea_cnn];
    train_max_temp = max(train_Data);
    train_max = repmat(train_max_temp, size(train_Data, 1), 1);
    train_min_temp = min(train_Data);
    train_min = repmat(train_min_temp, size(train_Data, 1), 1);
    train_Data = (train_Data - train_min) ./ (train_max - train_min);
    train_labels = Train_fea_from_hist_cnn.label;
    
    dev_fea_lsp = Dev_fea_from_hist_lsp.fea;
    dev_fea_cnn = Dev_fea_from_hist_cnn.fea;
    dev_Data = [dev_fea_lsp dev_fea_cnn];
    train_max = repmat(train_max_temp, size(dev_Data, 1), 1);
    train_min = repmat(train_min_temp, size(dev_Data, 1), 1);
    dev_Data = (dev_Data - train_min) ./ (train_max - train_min);
    dev_labels = Dev_fea_from_hist_cnn.label;
    
    test_fea_lsp = Test_fea_from_hist_lsp.fea;
    test_fea_cnn = Test_fea_from_hist_cnn.fea;
    test_Data = [test_fea_lsp test_fea_cnn];
    train_max = repmat(train_max_temp, size(test_Data, 1), 1);
    train_min = repmat(train_min_temp, size(test_Data, 1), 1);
    test_Data = (test_Data - train_min) ./ (train_max - train_min);
    test_labels = Test_fea_from_hist_cnn.label;
        
    %% SVM Linear   
    n_samples = 1;
    epc_range = [0.5 0.5];
    C = -6 : 1 : 16;
    d = 0;
    Model = [];
    addpath('..\..\toolbox\liblinear-1.96\liblinear-1.96\matlab');
    addpath('..\..\toolbox\epc');
    
    for i=1:numel(C)
        model{i} = train(train_labels', sparse(double(train_Data)), ...
            sprintf('-s %d -c %f', 0,  2^C(i)));
        [lbl, acc, dec] = predict(dev_labels', sparse(double(dev_Data)), model{i});
        %     [TPR, TNR, Info] = vl_roc(dev_labels, dec');
        [com.epc.dev, com.epc.eva, epc_cost] = epc(dec(dev_labels == 2), dec(dev_labels == 1),...
            dec(dev_labels == 2), dec(dev_labels == 1), n_samples, epc_range);
        EER_dev(i) = com.epc.dev.wer_apost(1) * 100;
    end
    [~, ind] = min(EER_dev);
    Model = model{ind};
    [lbl, acc, dec1] = predict(dev_labels', sparse(double(dev_Data)), Model);
    Fusion_LSP_cnn_hist.dec1.(freStrTemp) = dec1; 
    Fusion_LSP_cnn_hist.dev_labels.(freStrTemp) = dev_labels;
    [lbl, acc, dec2] = predict(test_labels', sparse(double(test_Data)), Model);
    Fusion_LSP_cnn_hist.dec2.(freStrTemp) = dec2; 
    Fusion_LSP_cnn_hist.test_labels.(freStrTemp) = test_labels;
    
    [com.epc.dev, com.epc.eva, epc_cost] = epc(dec1(dev_labels == 2), dec1(dev_labels == 1),...
        dec2(test_labels == 2), dec2(test_labels == 1), 1, [0.5 0.5]);
    HTER = com.epc.eva.hter_apri(1) * 100;
    Fusion_LSP_cnn_hist.HTER.(freStrTemp) = HTER; 
    [com.epc.dev, com.epc.eva, epc_cost] = epc(dec2(test_labels == 2, 1), dec2(test_labels == 1, 1), dec2(test_labels == 2, 1),dec2(test_labels == 1,1), 1, [0.5 0.5]);
    EER = com.epc.dev.wer_apost(1) * 100;
    Fusion_LSP_cnn_hist.EER.(freStrTemp) = EER; 
    fprintf('%s: HTER=%s EER=%s \n', freStrTemp, num2str(HTER), num2str(EER));
end
save('.\results\Early_Fusion_LSP_cnn_hist.mat', 'Fusion_LSP_cnn_hist');
