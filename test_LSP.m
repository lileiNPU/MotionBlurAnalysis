clc;
clear;
close all;

magnification_fea_path = 'results\magnification\features\';
norm = 0;
frequency = {[0.1, 20], [20, 40], [40, 60], [60, 80], [80, 100], [100, 120], ...
             [120, 140], [140, 160], [160, 180], [180, 200], [200, 220], [220, 240]};
for fy = 1 : length(frequency)
        
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
        fprintf('Train set: %d|%d \n', train_num_data, i);
        hist = Hist_fea_train(:, :, :, i);
        fea_from_hist = mean(hist, 1);
        fea = [fea; fea_from_hist];
    end
    Train_fea_from_hist.fea = fea;
    Train_fea_from_hist.label = Hist_label_train;
    
    % dev set
    fea = [];
    dev_num_data = numel(Hist_label_devel);
    for d = 1 : dev_num_data  
        fprintf('Dev set: %d|%d \n', dev_num_data, d);
        hist = Hist_fea_devel(:, :, :, d);
        fea_from_hist = mean(hist, 1);
        fea = [fea; fea_from_hist];
    end
    Dev_fea_from_hist.fea = fea;
    Dev_fea_from_hist.label = Hist_label_devel;   
    
    % test set
    fea = [];
    test_num_data = numel(Hist_label_test);
    for t = 1 : test_num_data 
        fprintf('Test set: %d|%d \n', test_num_data, t);
        hist = Hist_fea_test(:, :, :, t);
        fea_from_hist = mean(hist, 1);
        fea = [fea; fea_from_hist];
    end
    Test_fea_from_hist.fea = fea;
    Test_fea_from_hist.label = Hist_label_test;   
    
    %% SVM Linear
    train_Data = Train_fea_from_hist.fea;
    train_labels = Train_fea_from_hist.label;
    
    dev_Data = Dev_fea_from_hist.fea;
    dev_labels = Dev_fea_from_hist.label;
    
    test_Data = Test_fea_from_hist.fea;
    test_labels = Test_fea_from_hist.label;
    
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
    LSP_hist.dec1.(freStrTemp) = dec1; 
    LSP_hist.dev_labels.(freStrTemp) = dev_labels;
    [lbl, acc, dec2] = predict(test_labels', sparse(double(test_Data)), Model);
    LSP_hist.dec2.(freStrTemp) = dec2; 
    LSP_hist.test_labels.(freStrTemp) = test_labels;
    
    [com.epc.dev, com.epc.eva, epc_cost] = epc(dec1(dev_labels == 2), dec1(dev_labels == 1),...
        dec2(test_labels == 2), dec2(test_labels == 1), 1, [0.5 0.5]);
    HTER = com.epc.eva.hter_apri(1) * 100;
    LSP_hist.HTER.(freStrTemp) = HTER; 
    [com.epc.dev, com.epc.eva, epc_cost] = epc(dec2(test_labels == 2, 1), dec2(test_labels == 1, 1), dec2(test_labels == 2, 1),dec2(test_labels == 1,1), 1, [0.5 0.5]);
    EER = com.epc.dev.wer_apost(1) * 100;
    LSP_hist.EER.(freStrTemp) = EER; 
    fprintf('%s: HTER=%s EER=%s \n', freStrTemp, num2str(HTER), num2str(EER));
end
save('.\results\LSP_hist.mat', 'LSP_hist');
