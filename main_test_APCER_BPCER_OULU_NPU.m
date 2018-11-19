clc;
clear;
close all;

addpath('.\epc');

%%  hist network
load('.\results\Hist_network.mat');
dec1_all = Hist_network.dec1;
dev_labels_all = Hist_network.dev_labels;
dec2_all = Hist_network.dec2;
test_labels_all = Hist_network.test_labels;
file_names = fieldnames(dec1_all);
for s = 1 : length(file_names)
    sub_name = file_names{s};
    dec1 = dec1_all.(sub_name);
    dev_labels = dev_labels_all.(sub_name);
    dec2 = dec2_all.(sub_name);
    test_labels = test_labels_all.(sub_name);
    
    [com.epc.dev, com.epc.eva, epc_cost] = epc(dec1(dev_labels == 2), dec1(dev_labels == 1),...
        dec2(test_labels == 2), dec2(test_labels == 1), 1, [0.5 0.5]);
    HTER = com.epc.eva.hter_apri(1) * 100;
    Hist_network_APCER_BPCER.HTER.(sub_name) = HTER;
    [com.epc.dev, com.epc.eva, epc_cost] = epc(dec1(dev_labels == 2, 1), dec1(dev_labels == 1, 1), dec1(dev_labels == 2, 1),dec1(dev_labels == 1,1), 1, [0.5 0.5]);
    EER = com.epc.dev.wer_apost(1) * 100;
    Hist_network_APCER_BPCER.EER.(sub_name) = EER;
    
    threshold = com.epc.dev.thrd_fv;
    % APCER
    dec_attack_test = dec2(test_labels == 2);
    error_attack_classify = dec_attack_test > threshold;
    APCER = sum(error_attack_classify(:)) / length(dec_attack_test);
    Hist_network_APCER_BPCER.APCER.(sub_name) = APCER;
    % BPCER
    dec_real_test = dec2(test_labels == 1);
    error_real_classify = dec_real_test < threshold;
    BPCER = sum(error_real_classify(:)) / length(dec_real_test);
    Hist_network_APCER_BPCER.BPCER.(sub_name) = BPCER;
    % ACER
    ACER = (APCER + BPCER) / 2;
    Hist_network_APCER_BPCER.ACER.(sub_name) = ACER;
    
    % BPCER20
    threshold_start = threshold;
    if APCER < 0.05
        APCER_5 = APCER;
        counter = 0;
        while abs(APCER_5 - 0.05) >= 0.001
            counter = counter + 1;
            disp(counter);
            threshold_start = threshold_start - 0.001;
            % APCER_5
            dec_attack_test = dec2(test_labels == 2);
            error_attack_classify = dec_attack_test > threshold_start;
            APCER_5 = sum(error_attack_classify(:)) / length(dec_attack_test);
        end
        dec_real_test = dec2(test_labels == 1);
        error_real_classify = dec_real_test < threshold_start;
        BPCER_20 = sum(error_real_classify(:)) / length(dec_real_test);
    end
    if APCER > 0.05
        APCER_5 = APCER;
        counter = 0;
        while abs(APCER_5 - 0.05) >= 0.001
            counter = counter + 1;
            disp(counter);
            threshold_start = threshold_start + 0.001;
            % APCER_5
            dec_attack_test = dec2(test_labels == 2);
            error_attack_classify = dec_attack_test > threshold_start;
            APCER_5 = sum(error_attack_classify(:)) / length(dec_attack_test);
        end
        dec_real_test = dec2(test_labels == 1);
        error_real_classify = dec_real_test < threshold_start;
        BPCER_20 = sum(error_real_classify(:)) / length(dec_real_test);
    end 
    Hist_network_APCER_BPCER.BPCER_20.(sub_name) = BPCER_20;
end

%% hist average
load('.\results\Hist_average.mat');
dec1_all = Hist_average.dec1;
dev_labels_all = Hist_average.dev_labels;
dec2_all = Hist_average.dec2;
test_labels_all = Hist_average.test_labels;
file_names = fieldnames(dec1_all);
for s = 1 : length(file_names)
    sub_name = file_names{s};
    dec1 = dec1_all.(sub_name);
    dev_labels = dev_labels_all.(sub_name);
    dec2 = dec2_all.(sub_name);
    test_labels = test_labels_all.(sub_name);
    
    [com.epc.dev, com.epc.eva, epc_cost] = epc(dec1(dev_labels == 2), dec1(dev_labels == 1),...
        dec2(test_labels == 2), dec2(test_labels == 1), 1, [0.5 0.5]);
    HTER = com.epc.eva.hter_apri(1) * 100;
    Hist_average_APCER_BPCER.HTER.(sub_name) = HTER;
    [com.epc.dev, com.epc.eva, epc_cost] = epc(dec1(dev_labels == 2, 1), dec1(dev_labels == 1, 1), dec1(dev_labels == 2, 1),dec1(dev_labels == 1,1), 1, [0.5 0.5]);
    EER = com.epc.dev.wer_apost(1) * 100;
    Hist_average_APCER_BPCER.EER.(sub_name) = EER;
    
    threshold = com.epc.dev.thrd_fv;
    % APCER
    dec_attack_test = dec2(test_labels == 2);
    error_attack_classify = dec_attack_test > threshold;
    APCER = sum(error_attack_classify(:)) / length(dec_attack_test);
    Hist_average_APCER_BPCER.APCER.(sub_name) = APCER;
    % BPCER
    dec_real_test = dec2(test_labels == 1);
    error_real_classify = dec_real_test < threshold;
    BPCER = sum(error_real_classify(:)) / length(dec_real_test);
    Hist_average_APCER_BPCER.BPCER.(sub_name) = BPCER;
    % ACER
    ACER = (APCER + BPCER) / 2;
    Hist_average_APCER_BPCER.ACER.(sub_name) = ACER;
    
    % BPCER20
    threshold_start = threshold;
    if APCER < 0.05
        APCER_5 = APCER;
        counter = 0;
        while abs(APCER_5 - 0.05) >= 0.001
            counter = counter + 1;
            disp(counter);
            threshold_start = threshold_start - 0.001;
            % APCER_5
            dec_attack_test = dec2(test_labels == 2);
            error_attack_classify = dec_attack_test > threshold_start;
            APCER_5 = sum(error_attack_classify(:)) / length(dec_attack_test);
        end
        dec_real_test = dec2(test_labels == 1);
        error_real_classify = dec_real_test < threshold_start;
        BPCER_20 = sum(error_real_classify(:)) / length(dec_real_test);
    end
    if APCER > 0.05
        APCER_5 = APCER;
        counter = 0;
        while abs(APCER_5 - 0.05) >= 0.001
            counter = counter + 1;
            disp(counter);
            threshold_start = threshold_start + 0.001;
            % APCER_5
            dec_attack_test = dec2(test_labels == 2);
            error_attack_classify = dec_attack_test > threshold_start;
            APCER_5 = sum(error_attack_classify(:)) / length(dec_attack_test);
        end
        dec_real_test = dec2(test_labels == 1);
        error_real_classify = dec_real_test < threshold_start;
        BPCER_20 = sum(error_real_classify(:)) / length(dec_real_test);
    end 
    Hist_average_APCER_BPCER.BPCER_20.(sub_name) = BPCER_20;
end

%% LSP
load('.\results\LSP_hist.mat');
dec1_all = LSP_hist.dec1;
dev_labels_all = LSP_hist.dev_labels;
dec2_all = LSP_hist.dec2;
test_labels_all = LSP_hist.test_labels;
file_names = fieldnames(dec1_all);
for s = 1 : length(file_names)
    sub_name = file_names{s};
    dec1 = dec1_all.(sub_name);
    dev_labels = dev_labels_all.(sub_name);
    dec2 = dec2_all.(sub_name);
    test_labels = test_labels_all.(sub_name);
    
    [com.epc.dev, com.epc.eva, epc_cost] = epc(dec1(dev_labels == 2), dec1(dev_labels == 1),...
        dec2(test_labels == 2), dec2(test_labels == 1), 1, [0.5 0.5]);
    HTER = com.epc.eva.hter_apri(1) * 100;
    LSP_hist_APCER_BPCER.HTER.(sub_name) = HTER;
    [com.epc.dev, com.epc.eva, epc_cost] = epc(dec1(dev_labels == 2, 1), dec1(dev_labels == 1, 1), dec1(dev_labels == 2, 1),dec1(dev_labels == 1,1), 1, [0.5 0.5]);
    EER = com.epc.dev.wer_apost(1) * 100;
    LSP_hist_APCER_BPCER.EER.(sub_name) = EER;
    
    threshold = com.epc.dev.thrd_fv;
    % APCER
    dec_attack_test = dec2(test_labels == 2);
    error_attack_classify = dec_attack_test > threshold;
    APCER = sum(error_attack_classify(:)) / length(dec_attack_test);
    LSP_hist_APCER_BPCER.APCER.(sub_name) = APCER;
    % BPCER
    dec_real_test = dec2(test_labels == 1);
    error_real_classify = dec_real_test < threshold;
    BPCER = sum(error_real_classify(:)) / length(dec_real_test);
    LSP_hist_APCER_BPCER.BPCER.(sub_name) = BPCER;
    % ACER
    ACER = (APCER + BPCER) / 2;
    LSP_hist_APCER_BPCER.ACER.(sub_name) = ACER;
    
    % BPCER20
    threshold_start = threshold;
    if APCER < 0.05
        APCER_5 = APCER;
        counter = 0;
        while abs(APCER_5 - 0.05) >= 0.001
            counter = counter + 1;
            disp(counter);
            threshold_start = threshold_start - 0.001;
            % APCER_5
            dec_attack_test = dec2(test_labels == 2);
            error_attack_classify = dec_attack_test > threshold_start;
            APCER_5 = sum(error_attack_classify(:)) / length(dec_attack_test);
        end
        dec_real_test = dec2(test_labels == 1);
        error_real_classify = dec_real_test < threshold_start;
        BPCER_20 = sum(error_real_classify(:)) / length(dec_real_test);
    end
    if APCER > 0.05
        APCER_5 = APCER;
        counter = 0;
        while abs(APCER_5 - 0.05) >= 0.001
            counter = counter + 1;
            disp(counter);
            threshold_start = threshold_start + 0.001;
            % APCER_5
            dec_attack_test = dec2(test_labels == 2);
            error_attack_classify = dec_attack_test > threshold_start;
            APCER_5 = sum(error_attack_classify(:)) / length(dec_attack_test);
        end
        dec_real_test = dec2(test_labels == 1);
        error_real_classify = dec_real_test < threshold_start;
        BPCER_20 = sum(error_real_classify(:)) / length(dec_real_test);
    end 
    LSP_hist_APCER_BPCER.BPCER_20.(sub_name) = BPCER_20;
end

%% early fusion
load('.\results\Early_Fusion_LSP_cnn_hist.mat');
dec1_all = Fusion_LSP_cnn_hist.dec1;
dev_labels_all = Fusion_LSP_cnn_hist.dev_labels;
dec2_all = Fusion_LSP_cnn_hist.dec2;
test_labels_all = Fusion_LSP_cnn_hist.test_labels;
file_names = fieldnames(dec1_all);
for s = 1 : length(file_names)
    sub_name = file_names{s};
    dec1 = dec1_all.(sub_name);
    dev_labels = dev_labels_all.(sub_name);
    dec2 = dec2_all.(sub_name);
    test_labels = test_labels_all.(sub_name);
    
    [com.epc.dev, com.epc.eva, epc_cost] = epc(dec1(dev_labels == 2), dec1(dev_labels == 1),...
        dec2(test_labels == 2), dec2(test_labels == 1), 1, [0.5 0.5]);
    HTER = com.epc.eva.hter_apri(1) * 100;
    Early_Fusion_LSP_cnn_hist_APCER_BPCER.HTER.(sub_name) = HTER;
    [com.epc.dev, com.epc.eva, epc_cost] = epc(dec1(dev_labels == 2, 1), dec1(dev_labels == 1, 1), dec1(dev_labels == 2, 1),dec1(dev_labels == 1,1), 1, [0.5 0.5]);
    EER = com.epc.dev.wer_apost(1) * 100;
    Early_Fusion_LSP_cnn_hist_APCER_BPCER.EER.(sub_name) = EER;
    
    threshold = com.epc.dev.thrd_fv;
    % APCER
    dec_attack_test = dec2(test_labels == 2);
    error_attack_classify = dec_attack_test > threshold;
    APCER = sum(error_attack_classify(:)) / length(dec_attack_test);
    Early_Fusion_LSP_cnn_hist_APCER_BPCER.APCER.(sub_name) = APCER;
    % BPCER
    dec_real_test = dec2(test_labels == 1);
    error_real_classify = dec_real_test < threshold;
    BPCER = sum(error_real_classify(:)) / length(dec_real_test);
    Early_Fusion_LSP_cnn_hist_APCER_BPCER.BPCER.(sub_name) = BPCER;
    % ACER
    ACER = (APCER + BPCER) / 2;
    Early_Fusion_LSP_cnn_hist_APCER_BPCER.ACER.(sub_name) = ACER;
    
    % BPCER20
    threshold_start = threshold;
    if APCER < 0.05
        APCER_5 = APCER;
        counter = 0;
        while abs(APCER_5 - 0.05) >= 0.001
            counter = counter + 1;
            disp(counter);
            threshold_start = threshold_start - 0.001;
            % APCER_5
            dec_attack_test = dec2(test_labels == 2);
            error_attack_classify = dec_attack_test > threshold_start;
            APCER_5 = sum(error_attack_classify(:)) / length(dec_attack_test);
        end
        dec_real_test = dec2(test_labels == 1);
        error_real_classify = dec_real_test < threshold_start;
        BPCER_20 = sum(error_real_classify(:)) / length(dec_real_test);
    end
    if APCER > 0.05
        APCER_5 = APCER;
        counter = 0;
        while abs(APCER_5 - 0.05) >= 0.001
            counter = counter + 1;
            disp(counter);
            threshold_start = threshold_start + 0.001;
            % APCER_5
            dec_attack_test = dec2(test_labels == 2);
            error_attack_classify = dec_attack_test > threshold_start;
            APCER_5 = sum(error_attack_classify(:)) / length(dec_attack_test);
        end
        dec_real_test = dec2(test_labels == 1);
        error_real_classify = dec_real_test < threshold_start;
        BPCER_20 = sum(error_real_classify(:)) / length(dec_real_test);
    end 
    Early_Fusion_LSP_cnn_hist_APCER_BPCER.BPCER_20.(sub_name) = BPCER_20;
end

%% late fusion
load('.\results\Late_Fusion_LSP_cnn_hist.mat');
dec1_all = Late_Fusion_LSP_cnn_hist.dec1;
dev_labels_all = Late_Fusion_LSP_cnn_hist.dev_labels;
dec2_all = Late_Fusion_LSP_cnn_hist.dec2;
test_labels_all = Late_Fusion_LSP_cnn_hist.test_labels;
file_names = fieldnames(dec1_all);
for s = 1 : length(file_names)
    sub_name = file_names{s};
    dec1 = dec1_all.(sub_name);
    dev_labels = dev_labels_all.(sub_name);
    dec2 = dec2_all.(sub_name);
    test_labels = test_labels_all.(sub_name);
    
    [com.epc.dev, com.epc.eva, epc_cost] = epc(dec1(dev_labels == 2), dec1(dev_labels == 1),...
        dec2(test_labels == 2), dec2(test_labels == 1), 1, [0.5 0.5]);
    HTER = com.epc.eva.hter_apri(1) * 100;
    Late_Fusion_LSP_cnn_hist_APCER_BPCER.HTER.(sub_name) = HTER;
    [com.epc.dev, com.epc.eva, epc_cost] = epc(dec1(dev_labels == 2, 1), dec1(dev_labels == 1, 1), dec1(dev_labels == 2, 1),dec1(dev_labels == 1,1), 1, [0.5 0.5]);
    EER = com.epc.dev.wer_apost(1) * 100;
    Late_Fusion_LSP_cnn_hist_APCER_BPCER.EER.(sub_name) = EER;
    
    threshold = com.epc.dev.thrd_fv;
    % APCER
    dec_attack_test = dec2(test_labels == 2);
    error_attack_classify = dec_attack_test > threshold;
    APCER = sum(error_attack_classify(:)) / length(dec_attack_test);
    Late_Fusion_LSP_cnn_hist_APCER_BPCER.APCER.(sub_name) = APCER;
    % BPCER
    dec_real_test = dec2(test_labels == 1);
    error_real_classify = dec_real_test < threshold;
    BPCER = sum(error_real_classify(:)) / length(dec_real_test);
    Late_Fusion_LSP_cnn_hist_APCER_BPCER.BPCER.(sub_name) = BPCER;
    % ACER
    ACER = (APCER + BPCER) / 2;
    Late_Fusion_LSP_cnn_hist_APCER_BPCER.ACER.(sub_name) = ACER;
    % BPCER20
    threshold_start = threshold;
    if APCER < 0.05
        APCER_5 = APCER;
        counter = 0;
        while abs(APCER_5 - 0.05) >= 0.001
            counter = counter + 1;
            disp(counter);
            threshold_start = threshold_start - 0.001;
            % APCER_5
            dec_attack_test = dec2(test_labels == 2);
            error_attack_classify = dec_attack_test > threshold_start;
            APCER_5 = sum(error_attack_classify(:)) / length(dec_attack_test);
        end
        dec_real_test = dec2(test_labels == 1);
        error_real_classify = dec_real_test < threshold_start;
        BPCER_20 = sum(error_real_classify(:)) / length(dec_real_test);
    end
    if APCER > 0.05
        APCER_5 = APCER;
        counter = 0;
        while abs(APCER_5 - 0.05) >= 0.001
            counter = counter + 1;
            disp(counter);
            threshold_start = threshold_start + 0.001;
            % APCER_5
            dec_attack_test = dec2(test_labels == 2);
            error_attack_classify = dec_attack_test > threshold_start;
            APCER_5 = sum(error_attack_classify(:)) / length(dec_attack_test);
        end
        dec_real_test = dec2(test_labels == 1);
        error_real_classify = dec_real_test < threshold_start;
        BPCER_20 = sum(error_real_classify(:)) / length(dec_real_test);
    end 
    Late_Fusion_LSP_cnn_hist_APCER_BPCER.BPCER_20.(sub_name) = BPCER_20;
end

%% base line LBP
load('.\results\LBP_hist.mat');
% RGB space
LBP_hist_RGB = LBP_hist.RGB;
dec1 = LBP_hist_RGB.dec1;
dev_labels = LBP_hist_RGB.dev_labels;
dec2 = LBP_hist_RGB.dec2;
test_labels = LBP_hist_RGB.test_labels;

[com.epc.dev, com.epc.eva, epc_cost] = epc(dec1(dev_labels == 2), dec1(dev_labels == 1),...
    dec2(test_labels == 2), dec2(test_labels == 1), 1, [0.5 0.5]);
HTER = com.epc.eva.hter_apri(1) * 100;
LBP_hist_APCER_BPCER.HTER.RGB = HTER;
[com.epc.dev, com.epc.eva, epc_cost] = epc(dec1(dev_labels == 2, 1), dec1(dev_labels == 1, 1), dec1(dev_labels == 2, 1),dec1(dev_labels == 1,1), 1, [0.5 0.5]);
EER = com.epc.dev.wer_apost(1) * 100;
LBP_hist_APCER_BPCER.EER.RGB = EER;

threshold = com.epc.dev.thrd_fv;
% APCER
dec_attack_test = dec2(test_labels == 2);
error_attack_classify = dec_attack_test > threshold;
APCER = sum(error_attack_classify(:)) / length(dec_attack_test);
LBP_hist_APCER_BPCER.APCER.RGB = APCER;
% BPCER
dec_real_test = dec2(test_labels == 1);
error_real_classify = dec_real_test < threshold;
BPCER = sum(error_real_classify(:)) / length(dec_real_test);
LBP_hist_APCER_BPCER.BPCER.RGB = BPCER;
% ACER
ACER = (APCER + BPCER) / 2;
LBP_hist_APCER_BPCER.ACER.RGB = ACER;
% BPCER20
threshold_start = threshold;
if APCER < 0.05
    APCER_5 = APCER;
    counter = 0;
    while abs(APCER_5 - 0.05) >= 0.001
        counter = counter + 1;
        disp(counter);
        threshold_start = threshold_start - 0.001;
        % APCER_5
        dec_attack_test = dec2(test_labels == 2);
        error_attack_classify = dec_attack_test > threshold_start;
        APCER_5 = sum(error_attack_classify(:)) / length(dec_attack_test);
    end
    dec_real_test = dec2(test_labels == 1);
    error_real_classify = dec_real_test < threshold_start;
    BPCER_20 = sum(error_real_classify(:)) / length(dec_real_test);
end
if APCER > 0.05
    APCER_5 = APCER;
    counter = 0;
    while abs(APCER_5 - 0.05) >= 0.001
        counter = counter + 1;
        disp(counter);
        threshold_start = threshold_start + 0.001;
        % APCER_5
        dec_attack_test = dec2(test_labels == 2);
        error_attack_classify = dec_attack_test > threshold_start;
        APCER_5 = sum(error_attack_classify(:)) / length(dec_attack_test);
    end
    dec_real_test = dec2(test_labels == 1);
    error_real_classify = dec_real_test < threshold_start;
    BPCER_20 = sum(error_real_classify(:)) / length(dec_real_test);
end
LBP_hist_APCER_BPCER.BPCER_20.RGB = BPCER_20;

% HSV space
LBP_hist_HSV = LBP_hist.HSV;
dec1 = LBP_hist_HSV.dec1;
dev_labels = LBP_hist_HSV.dev_labels;
dec2 = LBP_hist_HSV.dec2;
test_labels = LBP_hist_HSV.test_labels;

[com.epc.dev, com.epc.eva, epc_cost] = epc(dec1(dev_labels == 2), dec1(dev_labels == 1),...
    dec2(test_labels == 2), dec2(test_labels == 1), 1, [0.5 0.5]);
HTER = com.epc.eva.hter_apri(1) * 100;
LBP_hist_APCER_BPCER.HTER.HSV = HTER;
[com.epc.dev, com.epc.eva, epc_cost] = epc(dec1(dev_labels == 2, 1), dec1(dev_labels == 1, 1), dec1(dev_labels == 2, 1),dec1(dev_labels == 1,1), 1, [0.5 0.5]);
EER = com.epc.dev.wer_apost(1) * 100;
LBP_hist_APCER_BPCER.EER.HSV = EER;

threshold = com.epc.dev.thrd_fv;
% APCER
dec_attack_test = dec2(test_labels == 2);
error_attack_classify = dec_attack_test > threshold;
APCER = sum(error_attack_classify(:)) / length(dec_attack_test);
LBP_hist_APCER_BPCER.APCER.HSV = APCER;
% BPCER
dec_real_test = dec2(test_labels == 1);
error_real_classify = dec_real_test < threshold;
BPCER = sum(error_real_classify(:)) / length(dec_real_test);
LBP_hist_APCER_BPCER.BPCER.HSV = BPCER;
% ACER
ACER = (APCER + BPCER) / 2;
LBP_hist_APCER_BPCER.ACER.HSV = ACER;
% BPCER20
threshold_start = threshold;
if APCER < 0.05
    APCER_5 = APCER;
    counter = 0;
    while abs(APCER_5 - 0.05) >= 0.001
        counter = counter + 1;
        disp(counter);
        threshold_start = threshold_start - 0.001;
        % APCER_5
        dec_attack_test = dec2(test_labels == 2);
        error_attack_classify = dec_attack_test > threshold_start;
        APCER_5 = sum(error_attack_classify(:)) / length(dec_attack_test);
    end
    dec_real_test = dec2(test_labels == 1);
    error_real_classify = dec_real_test < threshold_start;
    BPCER_20 = sum(error_real_classify(:)) / length(dec_real_test);
end
if APCER > 0.05
    APCER_5 = APCER;
    counter = 0;
    while abs(APCER_5 - 0.05) >= 0.001
        counter = counter + 1;
        disp(counter);
        threshold_start = threshold_start + 0.001;
        % APCER_5
        dec_attack_test = dec2(test_labels == 2);
        error_attack_classify = dec_attack_test > threshold_start;
        APCER_5 = sum(error_attack_classify(:)) / length(dec_attack_test);
    end
    dec_real_test = dec2(test_labels == 1);
    error_real_classify = dec_real_test < threshold_start;
    BPCER_20 = sum(error_real_classify(:)) / length(dec_real_test);
end
LBP_hist_APCER_BPCER.BPCER_20.HSV = BPCER_20;

% YCbCr space
LBP_hist_YCbCr = LBP_hist.YCbCr;
dec1 = LBP_hist_YCbCr.dec1;
dev_labels = LBP_hist_YCbCr.dev_labels;
dec2 = LBP_hist_YCbCr.dec2;
test_labels = LBP_hist_YCbCr.test_labels;

[com.epc.dev, com.epc.eva, epc_cost] = epc(dec1(dev_labels == 2), dec1(dev_labels == 1),...
    dec2(test_labels == 2), dec2(test_labels == 1), 1, [0.5 0.5]);
HTER = com.epc.eva.hter_apri(1) * 100;
LBP_hist_APCER_BPCER.HTER.YCbCr = HTER;
[com.epc.dev, com.epc.eva, epc_cost] = epc(dec1(dev_labels == 2, 1), dec1(dev_labels == 1, 1), dec1(dev_labels == 2, 1),dec1(dev_labels == 1,1), 1, [0.5 0.5]);
EER = com.epc.dev.wer_apost(1) * 100;
LBP_hist_APCER_BPCER.EER.YCbCr = EER;

threshold = com.epc.dev.thrd_fv;
% APCER
dec_attack_test = dec2(test_labels == 2);
error_attack_classify = dec_attack_test > threshold;
APCER = sum(error_attack_classify(:)) / length(dec_attack_test);
LBP_hist_APCER_BPCER.APCER.YCbCr = APCER;
% BPCER
dec_real_test = dec2(test_labels == 1);
error_real_classify = dec_real_test < threshold;
BPCER = sum(error_real_classify(:)) / length(dec_real_test);
LBP_hist_APCER_BPCER.BPCER.YCbCr = BPCER;
% ACER
ACER = (APCER + BPCER) / 2;
LBP_hist_APCER_BPCER.ACER.YCbCr = ACER;
% BPCER20
threshold_start = threshold;
if APCER < 0.05
    APCER_5 = APCER;
    counter = 0;
    while abs(APCER_5 - 0.05) >= 0.001
        counter = counter + 1;
        disp(counter);
        threshold_start = threshold_start - 0.001;
        % APCER_5
        dec_attack_test = dec2(test_labels == 2);
        error_attack_classify = dec_attack_test > threshold_start;
        APCER_5 = sum(error_attack_classify(:)) / length(dec_attack_test);
    end
    dec_real_test = dec2(test_labels == 1);
    error_real_classify = dec_real_test < threshold_start;
    BPCER_20 = sum(error_real_classify(:)) / length(dec_real_test);
end
if APCER > 0.05
    APCER_5 = APCER;
    counter = 0;
    while abs(APCER_5 - 0.05) >= 0.001
        counter = counter + 1;
        disp(counter);
        threshold_start = threshold_start + 0.001;
        % APCER_5
        dec_attack_test = dec2(test_labels == 2);
        error_attack_classify = dec_attack_test > threshold_start;
        APCER_5 = sum(error_attack_classify(:)) / length(dec_attack_test);
    end
    dec_real_test = dec2(test_labels == 1);
    error_real_classify = dec_real_test < threshold_start;
    BPCER_20 = sum(error_real_classify(:)) / length(dec_real_test);
end
LBP_hist_APCER_BPCER.BPCER_20.YCbCr = BPCER_20;


%%  cross early test
load('.\results\Cross_Fusion_LSP_cnn_hist.mat');
dec_all = Cross_Fusion_LSP_cnn_hist.dec;
dev_labels_all = Cross_Fusion_LSP_cnn_hist.dev_labels;
dec1_all = Cross_Fusion_LSP_cnn_hist.dec1;
dec2_all = Cross_Fusion_LSP_cnn_hist.dec2;
dec3_all = Cross_Fusion_LSP_cnn_hist.dec3;
Cross_train_labels_all = Cross_Fusion_LSP_cnn_hist.Cross_train_labels;
Cross_dev_labels_all = Cross_Fusion_LSP_cnn_hist.Cross_dev_labels;
Cross_test_labels_all = Cross_Fusion_LSP_cnn_hist.Cross_test_labels;
file_names = fieldnames(dec_all);
for s = 1 : length(file_names)
    sub_name = file_names{s};
    dec = dec_all.(sub_name);
    dev_labels = dev_labels_all.(sub_name);
    dec1 = dec1_all.(sub_name);
    Cross_train_labels = Cross_train_labels_all.(sub_name);
    dec2 = dec2_all.(sub_name);
    Cross_dev_labels = Cross_dev_labels_all.(sub_name);
    dec3 = dec3_all.(sub_name);
    Cross_test_labels = Cross_test_labels_all.(sub_name);
    
    % train set 
    [com.epc.dev, com.epc.eva, epc_cost] = epc(dec(dev_labels == 2), dec(dev_labels == 1),...
        dec1(Cross_train_labels == 2), dec1(Cross_train_labels == 1), 1, [0.5 0.5]);
    HTER = com.epc.eva.hter_apri(1) * 100;
    Cross_test_APCER_BPCER.train_HTER.(sub_name) = HTER;
    
    threshold = com.epc.dev.thrd_fv;
    % APCER
    dec_attack_test = dec1(Cross_train_labels == 2);
    error_attack_classify = dec_attack_test > threshold;
    APCER = sum(error_attack_classify(:)) / length(dec_attack_test);
    Cross_test_APCER_BPCER.train_APCER.(sub_name) = APCER;
    % BPCER
    dec_real_test = dec1(Cross_train_labels == 1);
    error_real_classify = dec_real_test < threshold;
    BPCER = sum(error_real_classify(:)) / length(dec_real_test);
    Cross_test_APCER_BPCER.train_BPCER.(sub_name) = BPCER;
    % ACER
    ACER = (APCER + BPCER) / 2;
    Cross_test_APCER_BPCER.train_ACER.(sub_name) = ACER;
    % BPCER20
    threshold_start = threshold;
    if APCER < 0.05
        APCER_5 = APCER;
        counter = 0;
        while abs(APCER_5 - 0.05) >= 0.001
            counter = counter + 1;
            disp(counter);
            threshold_start = threshold_start - 0.001;
            % APCER_5
            dec_attack_test = dec1(Cross_train_labels == 2);
            error_attack_classify = dec_attack_test > threshold_start;
            APCER_5 = sum(error_attack_classify(:)) / length(dec_attack_test);
        end
        dec_real_test = dec1(Cross_train_labels == 1);
        error_real_classify = dec_real_test < threshold_start;
        BPCER_20 = sum(error_real_classify(:)) / length(dec_real_test);
    end
    if APCER > 0.05
        APCER_5 = APCER;
        counter = 0;
        while abs(APCER_5 - 0.05) >= 0.001
            counter = counter + 1;
            disp(counter);
            threshold_start = threshold_start + 0.001;
            % APCER_5
            dec_attack_test = dec1(Cross_train_labels == 2);
            error_attack_classify = dec_attack_test > threshold_start;
            APCER_5 = sum(error_attack_classify(:)) / length(dec_attack_test);
        end
        dec_real_test = dec1(Cross_train_labels == 1);
        error_real_classify = dec_real_test < threshold_start;
        BPCER_20 = sum(error_real_classify(:)) / length(dec_real_test);
    end 
    Cross_test_APCER_BPCER.train_BPCER_20.(sub_name) = BPCER_20;
    
     % dev set 
    [com.epc.dev, com.epc.eva, epc_cost] = epc(dec(dev_labels == 2), dec(dev_labels == 1),...
        dec2(Cross_dev_labels == 2), dec2(Cross_dev_labels == 1), 1, [0.5 0.5]);
    HTER = com.epc.eva.hter_apri(1) * 100;
    Cross_test_APCER_BPCER.dev_HTER.(sub_name) = HTER;
    
    threshold = com.epc.dev.thrd_fv;
    % APCER
    dec_attack_test = dec2(Cross_dev_labels == 2);
    error_attack_classify = dec_attack_test > threshold;
    APCER = sum(error_attack_classify(:)) / length(dec_attack_test);
    Cross_test_APCER_BPCER.dev_APCER.(sub_name) = APCER;
    % BPCER
    dec_real_test = dec2(Cross_dev_labels == 1);
    error_real_classify = dec_real_test < threshold;
    BPCER = sum(error_real_classify(:)) / length(dec_real_test);
    Cross_test_APCER_BPCER.dev_BPCER.(sub_name) = BPCER;
    % ACER
    ACER = (APCER + BPCER) / 2;
    Cross_test_APCER_BPCER.dev_ACER.(sub_name) = ACER;
    % BPCER20
    threshold_start = threshold;
    if APCER < 0.05
        APCER_5 = APCER;
        counter = 0;
        while abs(APCER_5 - 0.05) >= 0.001
            counter = counter + 1;
            disp(counter);
            threshold_start = threshold_start - 0.001;
            % APCER_5
            dec_attack_test = dec2(Cross_dev_labels == 2);
            error_attack_classify = dec_attack_test > threshold_start;
            APCER_5 = sum(error_attack_classify(:)) / length(dec_attack_test);
        end
        dec_real_test = dec2(Cross_dev_labels == 1);
        error_real_classify = dec_real_test < threshold_start;
        BPCER_20 = sum(error_real_classify(:)) / length(dec_real_test);
    end
    if APCER > 0.05
        APCER_5 = APCER;
        counter = 0;
        while abs(APCER_5 - 0.05) >= 0.001
            counter = counter + 1;
            disp(counter);
            threshold_start = threshold_start + 0.001;
            % APCER_5
            dec_attack_test = dec2(Cross_dev_labels == 2);
            error_attack_classify = dec_attack_test > threshold_start;
            APCER_5 = sum(error_attack_classify(:)) / length(dec_attack_test);
        end
        dec_real_test = dec2(Cross_dev_labels == 1);
        error_real_classify = dec_real_test < threshold_start;
        BPCER_20 = sum(error_real_classify(:)) / length(dec_real_test);
    end 
    Cross_test_APCER_BPCER.dev_BPCER_20.(sub_name) = BPCER_20;
    
     % test set 
    [com.epc.dev, com.epc.eva, epc_cost] = epc(dec(dev_labels == 2), dec(dev_labels == 1),...
        dec3(Cross_test_labels == 2), dec3(Cross_test_labels == 1), 1, [0.5 0.5]);
    HTER = com.epc.eva.hter_apri(1) * 100;
    Cross_test_APCER_BPCER.test_HTER.(sub_name) = HTER;
    
    threshold = com.epc.dev.thrd_fv;
    % APCER
    dec_attack_test = dec3(Cross_test_labels == 2);
    error_attack_classify = dec_attack_test > threshold;
    APCER = sum(error_attack_classify(:)) / length(dec_attack_test);
    Cross_test_APCER_BPCER.test_APCER.(sub_name) = APCER;
    % BPCER
    dec_real_test = dec3(Cross_test_labels == 1);
    error_real_classify = dec_real_test < threshold;
    BPCER = sum(error_real_classify(:)) / length(dec_real_test);
    Cross_test_APCER_BPCER.test_BPCER.(sub_name) = BPCER;
    % ACER
    ACER = (APCER + BPCER) / 2;
    Cross_test_APCER_BPCER.test_ACER.(sub_name) = ACER;
    % BPCER20
    threshold_start = threshold;
    if APCER < 0.05
        APCER_5 = APCER;
        counter = 0;
        while abs(APCER_5 - 0.05) >= 0.001
            counter = counter + 1;
            disp(counter);
            threshold_start = threshold_start - 0.001;
            % APCER_5
            dec_attack_test = dec3(Cross_test_labels == 2);
            error_attack_classify = dec_attack_test > threshold_start;
            APCER_5 = sum(error_attack_classify(:)) / length(dec_attack_test);
        end
        dec_real_test = dec3(Cross_test_labels == 1);
        error_real_classify = dec_real_test < threshold_start;
        BPCER_20 = sum(error_real_classify(:)) / length(dec_real_test);
    end
    if APCER > 0.05
        APCER_5 = APCER;
        counter = 0;
        while abs(APCER_5 - 0.05) >= 0.001
            counter = counter + 1;
            disp(counter);
            threshold_start = threshold_start + 0.001;
            % APCER_5
            dec_attack_test = dec3(Cross_test_labels == 2);
            error_attack_classify = dec_attack_test > threshold_start;
            APCER_5 = sum(error_attack_classify(:)) / length(dec_attack_test);
        end
        dec_real_test = dec3(Cross_test_labels == 1);
        error_real_classify = dec_real_test < threshold_start;
        BPCER_20 = sum(error_real_classify(:)) / length(dec_real_test);
    end 
    Cross_test_APCER_BPCER.test_BPCER_20.(sub_name) = BPCER_20;
end

%%  cross late test
load('.\results\Cross_Late_Fusion_LSP_cnn_hist.mat');
dec_all = Cross_Late_Fusion_LSP_cnn_hist.dec;
dev_labels_all = Cross_Late_Fusion_LSP_cnn_hist.dev_labels;
dec1_all = Cross_Late_Fusion_LSP_cnn_hist.dec1;
dec2_all = Cross_Late_Fusion_LSP_cnn_hist.dec2;
dec3_all = Cross_Late_Fusion_LSP_cnn_hist.dec3;
Cross_train_labels_all = Cross_Late_Fusion_LSP_cnn_hist.Cross_train_labels;
Cross_dev_labels_all = Cross_Late_Fusion_LSP_cnn_hist.Cross_dev_labels;
Cross_test_labels_all = Cross_Late_Fusion_LSP_cnn_hist.Cross_test_labels;
file_names = fieldnames(dec_all);
for s = 1 : length(file_names)
    sub_name = file_names{s};
    dec = dec_all.(sub_name);
    dev_labels = dev_labels_all.(sub_name);
    dec1 = dec1_all.(sub_name);
    Cross_train_labels = Cross_train_labels_all.(sub_name);
    dec2 = dec2_all.(sub_name);
    Cross_dev_labels = Cross_dev_labels_all.(sub_name);
    dec3 = dec3_all.(sub_name);
    Cross_test_labels = Cross_test_labels_all.(sub_name);
    
    % train set 
    [com.epc.dev, com.epc.eva, epc_cost] = epc(dec(dev_labels == 2), dec(dev_labels == 1),...
        dec1(Cross_train_labels == 2), dec1(Cross_train_labels == 1), 1, [0.5 0.5]);
    HTER = com.epc.eva.hter_apri(1) * 100;
    Cross_late_test_APCER_BPCER.train_HTER.(sub_name) = HTER;
    
    threshold = com.epc.dev.thrd_fv;
    % APCER
    dec_attack_test = dec1(Cross_train_labels == 2);
    error_attack_classify = dec_attack_test > threshold;
    APCER = sum(error_attack_classify(:)) / length(dec_attack_test);
    Cross_late_test_APCER_BPCER.train_APCER.(sub_name) = APCER;
    % BPCER
    dec_real_test = dec1(Cross_train_labels == 1);
    error_real_classify = dec_real_test < threshold;
    BPCER = sum(error_real_classify(:)) / length(dec_real_test);
    Cross_late_test_APCER_BPCER.train_BPCER.(sub_name) = BPCER;
    % ACER
    ACER = (APCER + BPCER) / 2;
    Cross_late_test_APCER_BPCER.train_ACER.(sub_name) = ACER;
    % BPCER20
    threshold_start = threshold;
    if APCER < 0.05
        APCER_5 = APCER;
        counter = 0;
        while abs(APCER_5 - 0.05) >= 0.001
            counter = counter + 1;
            disp(counter);
            threshold_start = threshold_start - 0.001;
            % APCER_5
            dec_attack_test = dec1(Cross_train_labels == 2);
            error_attack_classify = dec_attack_test > threshold_start;
            APCER_5 = sum(error_attack_classify(:)) / length(dec_attack_test);
        end
        dec_real_test = dec1(Cross_train_labels == 1);
        error_real_classify = dec_real_test < threshold_start;
        BPCER_20 = sum(error_real_classify(:)) / length(dec_real_test);
    end
    if APCER > 0.05
        APCER_5 = APCER;
        counter = 0;
        while abs(APCER_5 - 0.05) >= 0.001
            counter = counter + 1;
            disp(counter);
            threshold_start = threshold_start + 0.001;
            % APCER_5
            dec_attack_test = dec1(Cross_train_labels == 2);
            error_attack_classify = dec_attack_test > threshold_start;
            APCER_5 = sum(error_attack_classify(:)) / length(dec_attack_test);
        end
        dec_real_test = dec1(Cross_train_labels == 1);
        error_real_classify = dec_real_test < threshold_start;
        BPCER_20 = sum(error_real_classify(:)) / length(dec_real_test);
    end 
    Cross_late_test_APCER_BPCER.train_BPCER_20.(sub_name) = BPCER_20;
    
     % dev set 
    [com.epc.dev, com.epc.eva, epc_cost] = epc(dec(dev_labels == 2), dec(dev_labels == 1),...
        dec2(Cross_dev_labels == 2), dec2(Cross_dev_labels == 1), 1, [0.5 0.5]);
    HTER = com.epc.eva.hter_apri(1) * 100;
    Cross_late_test_APCER_BPCER.dev_HTER.(sub_name) = HTER;
    
    threshold = com.epc.dev.thrd_fv;
    % APCER
    dec_attack_test = dec2(Cross_dev_labels == 2);
    error_attack_classify = dec_attack_test > threshold;
    APCER = sum(error_attack_classify(:)) / length(dec_attack_test);
    Cross_late_test_APCER_BPCER.dev_APCER.(sub_name) = APCER;
    % BPCER
    dec_real_test = dec2(Cross_dev_labels == 1);
    error_real_classify = dec_real_test < threshold;
    BPCER = sum(error_real_classify(:)) / length(dec_real_test);
    Cross_late_test_APCER_BPCER.dev_BPCER.(sub_name) = BPCER;
    % ACER
    ACER = (APCER + BPCER) / 2;
    Cross_late_test_APCER_BPCER.dev_ACER.(sub_name) = ACER;
    % BPCER20
    threshold_start = threshold;
    if APCER < 0.05
        APCER_5 = APCER;
        counter = 0;
        while abs(APCER_5 - 0.05) >= 0.001
            counter = counter + 1;
            disp(counter);
            threshold_start = threshold_start - 0.001;
            % APCER_5
            dec_attack_test = dec2(Cross_dev_labels == 2);
            error_attack_classify = dec_attack_test > threshold_start;
            APCER_5 = sum(error_attack_classify(:)) / length(dec_attack_test);
        end
        dec_real_test = dec2(Cross_dev_labels == 1);
        error_real_classify = dec_real_test < threshold_start;
        BPCER_20 = sum(error_real_classify(:)) / length(dec_real_test);
    end
    if APCER > 0.05
        APCER_5 = APCER;
        counter = 0;
        while abs(APCER_5 - 0.05) >= 0.001
            counter = counter + 1;
            disp(counter);
            threshold_start = threshold_start + 0.001;
            % APCER_5
            dec_attack_test = dec2(Cross_dev_labels == 2);
            error_attack_classify = dec_attack_test > threshold_start;
            APCER_5 = sum(error_attack_classify(:)) / length(dec_attack_test);
        end
        dec_real_test = dec2(Cross_dev_labels == 1);
        error_real_classify = dec_real_test < threshold_start;
        BPCER_20 = sum(error_real_classify(:)) / length(dec_real_test);
    end 
    Cross_late_test_APCER_BPCER.dev_BPCER_20.(sub_name) = BPCER_20;
    
     % test set 
    [com.epc.dev, com.epc.eva, epc_cost] = epc(dec(dev_labels == 2), dec(dev_labels == 1),...
        dec3(Cross_test_labels == 2), dec3(Cross_test_labels == 1), 1, [0.5 0.5]);
    HTER = com.epc.eva.hter_apri(1) * 100;
    Cross_late_test_APCER_BPCER.test_HTER.(sub_name) = HTER;
    
    threshold = com.epc.dev.thrd_fv;
    % APCER
    dec_attack_test = dec3(Cross_test_labels == 2);
    error_attack_classify = dec_attack_test > threshold;
    APCER = sum(error_attack_classify(:)) / length(dec_attack_test);
    Cross_late_test_APCER_BPCER.test_APCER.(sub_name) = APCER;
    % BPCER
    dec_real_test = dec3(Cross_test_labels == 1);
    error_real_classify = dec_real_test < threshold;
    BPCER = sum(error_real_classify(:)) / length(dec_real_test);
    Cross_late_test_APCER_BPCER.test_BPCER.(sub_name) = BPCER;
    % ACER
    ACER = (APCER + BPCER) / 2;
    Cross_late_test_APCER_BPCER.test_ACER.(sub_name) = ACER;
    % BPCER20
    threshold_start = threshold;
    if APCER < 0.05
        APCER_5 = APCER;
        counter = 0;
        while abs(APCER_5 - 0.05) >= 0.001
            counter = counter + 1;
            disp(counter);
            threshold_start = threshold_start - 0.001;
            % APCER_5
            dec_attack_test = dec3(Cross_test_labels == 2);
            error_attack_classify = dec_attack_test > threshold_start;
            APCER_5 = sum(error_attack_classify(:)) / length(dec_attack_test);
        end
        dec_real_test = dec3(Cross_test_labels == 1);
        error_real_classify = dec_real_test < threshold_start;
        BPCER_20 = sum(error_real_classify(:)) / length(dec_real_test);
    end
    if APCER > 0.05
        APCER_5 = APCER;
        counter = 0;
        while abs(APCER_5 - 0.05) >= 0.001
            counter = counter + 1;
            disp(counter);
            threshold_start = threshold_start + 0.001;
            % APCER_5
            dec_attack_test = dec3(Cross_test_labels == 2);
            error_attack_classify = dec_attack_test > threshold_start;
            APCER_5 = sum(error_attack_classify(:)) / length(dec_attack_test);
        end
        dec_real_test = dec3(Cross_test_labels == 1);
        error_real_classify = dec_real_test < threshold_start;
        BPCER_20 = sum(error_real_classify(:)) / length(dec_real_test);
    end 
    Cross_late_test_APCER_BPCER.test_BPCER_20.(sub_name) = BPCER_20;
end

%% Cross baseline LBP
load('.\results\Cross_ColorLBP.mat');
% RGB space
LBP_hist_RGB = Cross_ColorLBP.RGB;
dec = LBP_hist_RGB.dec;
dec1 = LBP_hist_RGB.dec1;
dec2 = LBP_hist_RGB.dec2;
dec3 = LBP_hist_RGB.dec3;
dev_labels = LBP_hist_RGB.dev_labels;
cross_train_labels = LBP_hist_RGB.cross_train_labels;
cross_dev_labels = LBP_hist_RGB.cross_dev_labels;
cross_test_labels = LBP_hist_RGB.cross_test_labels;

%% RGB train set
[com.epc.dev, com.epc.eva, epc_cost] = epc(dec(dev_labels == -1), dec(dev_labels == 1),...
    dec1(cross_train_labels == -1), dec1(cross_train_labels == 1), 1, [0.5 0.5]);
HTER = com.epc.eva.hter_apri(1) * 100;
Cross_LBP_hist_APCER_BPCER.HTER.RGB_train = HTER;
[com.epc.dev, com.epc.eva, epc_cost] = epc(dec(dev_labels == -1, 1), dec(dev_labels == 1, 1), dec(dev_labels == -1, 1),dec(dev_labels == 1,1), 1, [0.5 0.5]);
EER = com.epc.dev.wer_apost(1) * 100;
Cross_LBP_hist_APCER_BPCER.EER.RGB_train = EER;

threshold = com.epc.dev.thrd_fv;
% APCER
dec_attack_test = dec1(cross_train_labels == -1);
error_attack_classify = dec_attack_test > threshold;
APCER = sum(error_attack_classify(:)) / length(dec_attack_test);
Cross_LBP_hist_APCER_BPCER.APCER.RGB_train = APCER;
% BPCER
dec_real_test = dec1(cross_train_labels == 1);
error_real_classify = dec_real_test < threshold;
BPCER = sum(error_real_classify(:)) / length(dec_real_test);
Cross_LBP_hist_APCER_BPCER.BPCER.RGB_train = BPCER;
% ACER
ACER = (APCER + BPCER) / 2;
Cross_LBP_hist_APCER_BPCER.ACER.RGB_train = ACER;
% BPCER20
threshold_start = threshold;
if APCER < 0.05
    APCER_5 = APCER;
    counter = 0;
    while abs(APCER_5 - 0.05) >= 0.001
        counter = counter + 1;
        disp(counter);
        threshold_start = threshold_start - 0.001;
        % APCER_5
        dec_attack_test = dec1(cross_train_labels == -1);
        error_attack_classify = dec_attack_test > threshold_start;
        APCER_5 = sum(error_attack_classify(:)) / length(dec_attack_test);
    end
    dec_real_test = dec1(cross_train_labels == 1);
    error_real_classify = dec_real_test < threshold_start;
    BPCER_20 = sum(error_real_classify(:)) / length(dec_real_test);
end
if APCER > 0.05
    APCER_5 = APCER;
    counter = 0;
    while abs(APCER_5 - 0.05) >= 0.001
        counter = counter + 1;
        disp(counter);
        threshold_start = threshold_start + 0.001;
        % APCER_5
        dec_attack_test = dec1(cross_train_labels == -1);
        error_attack_classify = dec_attack_test > threshold_start;
        APCER_5 = sum(error_attack_classify(:)) / length(dec_attack_test);
    end
    dec_real_test = dec1(cross_train_labels == 1);
    error_real_classify = dec_real_test < threshold_start;
    BPCER_20 = sum(error_real_classify(:)) / length(dec_real_test);
end
Cross_LBP_hist_APCER_BPCER.BPCER_20.RGB_train = BPCER_20;

%% RGB dev set
[com.epc.dev, com.epc.eva, epc_cost] = epc(dec(dev_labels == -1), dec(dev_labels == 1),...
    dec2(cross_dev_labels == -1), dec2(cross_dev_labels == 1), 1, [0.5 0.5]);
HTER = com.epc.eva.hter_apri(1) * 100;
Cross_LBP_hist_APCER_BPCER.HTER.RGB_dev = HTER;
[com.epc.dev, com.epc.eva, epc_cost] = epc(dec(dev_labels == -1, 1), dec(dev_labels == 1, 1), dec(dev_labels == -1, 1),dec(dev_labels == 1,1), 1, [0.5 0.5]);
EER = com.epc.dev.wer_apost(1) * 100;
Cross_LBP_hist_APCER_BPCER.EER.RGB_dev = EER;

threshold = com.epc.dev.thrd_fv;
% APCER
dec_attack_test = dec2(cross_dev_labels == -1);
error_attack_classify = dec_attack_test > threshold;
APCER = sum(error_attack_classify(:)) / length(dec_attack_test);
Cross_LBP_hist_APCER_BPCER.APCER.RGB_dev = APCER;
% BPCER
dec_real_test = dec2(cross_dev_labels == 1);
error_real_classify = dec_real_test < threshold;
BPCER = sum(error_real_classify(:)) / length(dec_real_test);
Cross_LBP_hist_APCER_BPCER.BPCER.RGB_dev = BPCER;
% ACER
ACER = (APCER + BPCER) / 2;
Cross_LBP_hist_APCER_BPCER.ACER.RGB_dev = ACER;
% BPCER20
threshold_start = threshold;
if APCER < 0.05
    APCER_5 = APCER;
    counter = 0;
    while abs(APCER_5 - 0.05) >= 0.001
        counter = counter + 1;
        disp(counter);
        threshold_start = threshold_start - 0.001;
        % APCER_5
        dec_attack_test = dec2(cross_dev_labels == -1);
        error_attack_classify = dec_attack_test > threshold_start;
        APCER_5 = sum(error_attack_classify(:)) / length(dec_attack_test);
    end
    dec_real_test = dec2(cross_dev_labels == 1);
    error_real_classify = dec_real_test < threshold_start;
    BPCER_20 = sum(error_real_classify(:)) / length(dec_real_test);
end
if APCER > 0.05
    APCER_5 = APCER;
    counter = 0;
    while abs(APCER_5 - 0.05) >= 0.001
        counter = counter + 1;
        disp(counter);
        threshold_start = threshold_start + 0.001;
        % APCER_5
        dec_attack_test = dec2(cross_dev_labels == -1);
        error_attack_classify = dec_attack_test > threshold_start;
        APCER_5 = sum(error_attack_classify(:)) / length(dec_attack_test);
    end
    dec_real_test = dec2(cross_dev_labels == 1);
    error_real_classify = dec_real_test < threshold_start;
    BPCER_20 = sum(error_real_classify(:)) / length(dec_real_test);
end
Cross_LBP_hist_APCER_BPCER.BPCER_20.RGB_dev = BPCER_20;

%% RGB test set
[com.epc.dev, com.epc.eva, epc_cost] = epc(dec(dev_labels == -1), dec(dev_labels == 1),...
    dec3(cross_test_labels == -1), dec3(cross_test_labels == 1), 1, [0.5 0.5]);
HTER = com.epc.eva.hter_apri(1) * 100;
Cross_LBP_hist_APCER_BPCER.HTER.RGB_test = HTER;
[com.epc.dev, com.epc.eva, epc_cost] = epc(dec(dev_labels == -1, 1), dec(dev_labels == 1, 1), dec(dev_labels == -1, 1),dec(dev_labels == 1,1), 1, [0.5 0.5]);
EER = com.epc.dev.wer_apost(1) * 100;
Cross_LBP_hist_APCER_BPCER.EER.RGB_test = EER;

threshold = com.epc.dev.thrd_fv;
% APCER
dec_attack_test = dec3(cross_test_labels == -1);
error_attack_classify = dec_attack_test > threshold;
APCER = sum(error_attack_classify(:)) / length(dec_attack_test);
Cross_LBP_hist_APCER_BPCER.APCER.RGB_test = APCER;
% BPCER
dec_real_test = dec3(cross_test_labels == 1);
error_real_classify = dec_real_test < threshold;
BPCER = sum(error_real_classify(:)) / length(dec_real_test);
Cross_LBP_hist_APCER_BPCER.BPCER.RGB_test = BPCER;
% ACER
ACER = (APCER + BPCER) / 2;
Cross_LBP_hist_APCER_BPCER.ACER.RGB_test = ACER;
% BPCER20
threshold_start = threshold;
if APCER < 0.05
    APCER_5 = APCER;
    counter = 0;
    while abs(APCER_5 - 0.05) >= 0.001
        counter = counter + 1;
        disp(counter);
        threshold_start = threshold_start - 0.001;
        % APCER_5
        dec_attack_test = dec3(cross_test_labels == -1);
        error_attack_classify = dec_attack_test > threshold_start;
        APCER_5 = sum(error_attack_classify(:)) / length(dec_attack_test);
    end
    dec_real_test = dec3(cross_test_labels == 1);
    error_real_classify = dec_real_test < threshold_start;
    BPCER_20 = sum(error_real_classify(:)) / length(dec_real_test);
end
if APCER > 0.05
    APCER_5 = APCER;
    counter = 0;
    while abs(APCER_5 - 0.05) >= 0.001
        counter = counter + 1;
        disp(counter);
        threshold_start = threshold_start + 0.001;
        % APCER_5
        dec_attack_test = dec3(cross_dev_labels == -1);
        error_attack_classify = dec_attack_test > threshold_start;
        APCER_5 = sum(error_attack_classify(:)) / length(dec_attack_test);
    end
    dec_real_test = dec3(cross_dev_labels == 1);
    error_real_classify = dec_real_test < threshold_start;
    BPCER_20 = sum(error_real_classify(:)) / length(dec_real_test);
end
Cross_LBP_hist_APCER_BPCER.BPCER_20.RGB_test = BPCER_20;

%% HSV space
LBP_hist_HSV = Cross_ColorLBP.HSV;
dec = LBP_hist_HSV.dec;
dec1 = LBP_hist_HSV.dec1;
dec2 = LBP_hist_HSV.dec2;
dec3 = LBP_hist_HSV.dec3;
dev_labels = LBP_hist_HSV.dev_labels;
cross_train_labels = LBP_hist_HSV.cross_train_labels;
cross_dev_labels = LBP_hist_HSV.cross_dev_labels;
cross_test_labels = LBP_hist_HSV.cross_test_labels;

%% HSV train set
[com.epc.dev, com.epc.eva, epc_cost] = epc(dec(dev_labels == -1), dec(dev_labels == 1),...
    dec1(cross_train_labels == -1), dec1(cross_train_labels == 1), 1, [0.5 0.5]);
HTER = com.epc.eva.hter_apri(1) * 100;
Cross_LBP_hist_APCER_BPCER.HTER.HSV_train = HTER;
[com.epc.dev, com.epc.eva, epc_cost] = epc(dec(dev_labels == -1, 1), dec(dev_labels == 1, 1), dec(dev_labels == -1, 1),dec(dev_labels == 1,1), 1, [0.5 0.5]);
EER = com.epc.dev.wer_apost(1) * 100;
Cross_LBP_hist_APCER_BPCER.EER.HSV_train = EER;

threshold = com.epc.dev.thrd_fv;
% APCER
dec_attack_test = dec1(cross_train_labels == -1);
error_attack_classify = dec_attack_test > threshold;
APCER = sum(error_attack_classify(:)) / length(dec_attack_test);
Cross_LBP_hist_APCER_BPCER.APCER.HSV_train = APCER;
% BPCER
dec_real_test = dec1(cross_train_labels == 1);
error_real_classify = dec_real_test < threshold;
BPCER = sum(error_real_classify(:)) / length(dec_real_test);
Cross_LBP_hist_APCER_BPCER.BPCER.HSV_train = BPCER;
% ACER
ACER = (APCER + BPCER) / 2;
Cross_LBP_hist_APCER_BPCER.ACER.HSV_train = ACER;
% BPCER20
threshold_start = threshold;
if APCER < 0.05
    APCER_5 = APCER;
    counter = 0;
    while abs(APCER_5 - 0.05) >= 0.001
        counter = counter + 1;
        disp(counter);
        threshold_start = threshold_start - 0.001;
        % APCER_5
        dec_attack_test = dec1(cross_train_labels == -1);
        error_attack_classify = dec_attack_test > threshold_start;
        APCER_5 = sum(error_attack_classify(:)) / length(dec_attack_test);
    end
    dec_real_test = dec1(cross_train_labels == 1);
    error_real_classify = dec_real_test < threshold_start;
    BPCER_20 = sum(error_real_classify(:)) / length(dec_real_test);
end
if APCER > 0.05
    APCER_5 = APCER;
    counter = 0;
    while abs(APCER_5 - 0.05) >= 0.001
        counter = counter + 1;
        disp(counter);
        threshold_start = threshold_start + 0.001;
        % APCER_5
        dec_attack_test = dec1(cross_train_labels == -1);
        error_attack_classify = dec_attack_test > threshold_start;
        APCER_5 = sum(error_attack_classify(:)) / length(dec_attack_test);
    end
    dec_real_test = dec1(cross_train_labels == 1);
    error_real_classify = dec_real_test < threshold_start;
    BPCER_20 = sum(error_real_classify(:)) / length(dec_real_test);
end
Cross_LBP_hist_APCER_BPCER.BPCER_20.HSV_train = BPCER_20;

%% HSV dev set
[com.epc.dev, com.epc.eva, epc_cost] = epc(dec(dev_labels == -1), dec(dev_labels == 1),...
    dec2(cross_dev_labels == -1), dec2(cross_dev_labels == 1), 1, [0.5 0.5]);
HTER = com.epc.eva.hter_apri(1) * 100;
Cross_LBP_hist_APCER_BPCER.HTER.HSV_dev = HTER;
[com.epc.dev, com.epc.eva, epc_cost] = epc(dec(dev_labels == -1, 1), dec(dev_labels == 1, 1), dec(dev_labels == -1, 1),dec(dev_labels == 1,1), 1, [0.5 0.5]);
EER = com.epc.dev.wer_apost(1) * 100;
Cross_LBP_hist_APCER_BPCER.EER.HSV_dev = EER;

threshold = com.epc.dev.thrd_fv;
% APCER
dec_attack_test = dec2(cross_dev_labels == -1);
error_attack_classify = dec_attack_test > threshold;
APCER = sum(error_attack_classify(:)) / length(dec_attack_test);
Cross_LBP_hist_APCER_BPCER.APCER.HSV_dev = APCER;
% BPCER
dec_real_test = dec2(cross_dev_labels == 1);
error_real_classify = dec_real_test < threshold;
BPCER = sum(error_real_classify(:)) / length(dec_real_test);
Cross_LBP_hist_APCER_BPCER.BPCER.HSV_dev = BPCER;
% ACER
ACER = (APCER + BPCER) / 2;
Cross_LBP_hist_APCER_BPCER.ACER.HSV_dev = ACER;
% BPCER20
threshold_start = threshold;
if APCER < 0.05
    APCER_5 = APCER;
    counter = 0;
    while abs(APCER_5 - 0.05) >= 0.001
        counter = counter + 1;
        disp(counter);
        threshold_start = threshold_start - 0.001;
        % APCER_5
        dec_attack_test = dec2(cross_dev_labels == -1);
        error_attack_classify = dec_attack_test > threshold_start;
        APCER_5 = sum(error_attack_classify(:)) / length(dec_attack_test);
    end
    dec_real_test = dec2(cross_dev_labels == 1);
    error_real_classify = dec_real_test < threshold_start;
    BPCER_20 = sum(error_real_classify(:)) / length(dec_real_test);
end
if APCER > 0.05
    APCER_5 = APCER;
    counter = 0;
    while abs(APCER_5 - 0.05) >= 0.001
        counter = counter + 1;
        disp(counter);
        threshold_start = threshold_start + 0.001;
        % APCER_5
        dec_attack_test = dec2(cross_dev_labels == -1);
        error_attack_classify = dec_attack_test > threshold_start;
        APCER_5 = sum(error_attack_classify(:)) / length(dec_attack_test);
    end
    dec_real_test = dec2(cross_dev_labels == 1);
    error_real_classify = dec_real_test < threshold_start;
    BPCER_20 = sum(error_real_classify(:)) / length(dec_real_test);
end
Cross_LBP_hist_APCER_BPCER.BPCER_20.HSV_dev = BPCER_20;

%% HSV test set
[com.epc.dev, com.epc.eva, epc_cost] = epc(dec(dev_labels == -1), dec(dev_labels == 1),...
    dec3(cross_test_labels == -1), dec3(cross_test_labels == 1), 1, [0.5 0.5]);
HTER = com.epc.eva.hter_apri(1) * 100;
Cross_LBP_hist_APCER_BPCER.HTER.HSV_test = HTER;
[com.epc.dev, com.epc.eva, epc_cost] = epc(dec(dev_labels == -1, 1), dec(dev_labels == 1, 1), dec(dev_labels == -1, 1),dec(dev_labels == 1,1), 1, [0.5 0.5]);
EER = com.epc.dev.wer_apost(1) * 100;
Cross_LBP_hist_APCER_BPCER.EER.HSV_test = EER;

threshold = com.epc.dev.thrd_fv;
% APCER
dec_attack_test = dec3(cross_test_labels == -1);
error_attack_classify = dec_attack_test > threshold;
APCER = sum(error_attack_classify(:)) / length(dec_attack_test);
Cross_LBP_hist_APCER_BPCER.APCER.HSV_test = APCER;
% BPCER
dec_real_test = dec3(cross_test_labels == 1);
error_real_classify = dec_real_test < threshold;
BPCER = sum(error_real_classify(:)) / length(dec_real_test);
Cross_LBP_hist_APCER_BPCER.BPCER.HSV_test = BPCER;
% ACER
ACER = (APCER + BPCER) / 2;
Cross_LBP_hist_APCER_BPCER.ACER.HSV_test = ACER;
% BPCER20
threshold_start = threshold;
if APCER < 0.05
    APCER_5 = APCER;
    counter = 0;
    while abs(APCER_5 - 0.05) >= 0.001
        counter = counter + 1;
        disp(counter);
        threshold_start = threshold_start - 0.001;
        % APCER_5
        dec_attack_test = dec3(cross_test_labels == -1);
        error_attack_classify = dec_attack_test > threshold_start;
        APCER_5 = sum(error_attack_classify(:)) / length(dec_attack_test);
    end
    dec_real_test = dec3(cross_test_labels == 1);
    error_real_classify = dec_real_test < threshold_start;
    BPCER_20 = sum(error_real_classify(:)) / length(dec_real_test);
end
if APCER > 0.05
    APCER_5 = APCER;
    counter = 0;
    while abs(APCER_5 - 0.05) >= 0.001
        counter = counter + 1;
        disp(counter);
        threshold_start = threshold_start + 0.001;
        % APCER_5
        dec_attack_test = dec3(cross_test_labels == -1);
        error_attack_classify = dec_attack_test > threshold_start;
        APCER_5 = sum(error_attack_classify(:)) / length(dec_attack_test);
    end
    dec_real_test = dec3(cross_test_labels == 1);
    error_real_classify = dec_real_test < threshold_start;
    BPCER_20 = sum(error_real_classify(:)) / length(dec_real_test);
end
Cross_LBP_hist_APCER_BPCER.BPCER_20.HSV_test = BPCER_20;

%% YCbCr space
LBP_hist_YCbCr = Cross_ColorLBP.YCbCr;
dec = LBP_hist_YCbCr.dec;
dec1 = LBP_hist_YCbCr.dec1;
dec2 = LBP_hist_YCbCr.dec2;
dec3 = LBP_hist_YCbCr.dec3;
dev_labels = LBP_hist_YCbCr.dev_labels;
cross_train_labels = LBP_hist_YCbCr.cross_train_labels;
cross_dev_labels = LBP_hist_YCbCr.cross_dev_labels;
cross_test_labels = LBP_hist_YCbCr.cross_test_labels;

%% YCbCr train set
[com.epc.dev, com.epc.eva, epc_cost] = epc(dec(dev_labels == -1), dec(dev_labels == 1),...
    dec1(cross_train_labels == -1), dec1(cross_train_labels == 1), 1, [0.5 0.5]);
HTER = com.epc.eva.hter_apri(1) * 100;
Cross_LBP_hist_APCER_BPCER.HTER.YCbCr_train = HTER;
[com.epc.dev, com.epc.eva, epc_cost] = epc(dec(dev_labels == -1, 1), dec(dev_labels == 1, 1), dec(dev_labels == -1, 1),dec(dev_labels == 1,1), 1, [0.5 0.5]);
EER = com.epc.dev.wer_apost(1) * 100;
Cross_LBP_hist_APCER_BPCER.EER.YCbCr_train = EER;

threshold = com.epc.dev.thrd_fv;
% APCER
dec_attack_test = dec1(cross_train_labels == -1);
error_attack_classify = dec_attack_test > threshold;
APCER = sum(error_attack_classify(:)) / length(dec_attack_test);
Cross_LBP_hist_APCER_BPCER.APCER.YCbCr_train = APCER;
% BPCER
dec_real_test = dec1(cross_train_labels == 1);
error_real_classify = dec_real_test < threshold;
BPCER = sum(error_real_classify(:)) / length(dec_real_test);
Cross_LBP_hist_APCER_BPCER.BPCER.YCbCr_train = BPCER;
% ACER
ACER = (APCER + BPCER) / 2;
Cross_LBP_hist_APCER_BPCER.ACER.YCbCr_train = ACER;
% BPCER20
threshold_start = threshold;
if APCER < 0.05
    APCER_5 = APCER;
    counter = 0;
    while abs(APCER_5 - 0.05) >= 0.001
        counter = counter + 1;
        disp(counter);
        threshold_start = threshold_start - 0.001;
        % APCER_5
        dec_attack_test = dec1(cross_train_labels == -1);
        error_attack_classify = dec_attack_test > threshold_start;
        APCER_5 = sum(error_attack_classify(:)) / length(dec_attack_test);
    end
    dec_real_test = dec1(cross_train_labels == 1);
    error_real_classify = dec_real_test < threshold_start;
    BPCER_20 = sum(error_real_classify(:)) / length(dec_real_test);
end
if APCER > 0.05
    APCER_5 = APCER;
    counter = 0;
    while abs(APCER_5 - 0.05) >= 0.001
        counter = counter + 1;
        disp(counter);
        threshold_start = threshold_start + 0.001;
        % APCER_5
        dec_attack_test = dec1(cross_train_labels == -1);
        error_attack_classify = dec_attack_test > threshold_start;
        APCER_5 = sum(error_attack_classify(:)) / length(dec_attack_test);
    end
    dec_real_test = dec1(cross_train_labels == 1);
    error_real_classify = dec_real_test < threshold_start;
    BPCER_20 = sum(error_real_classify(:)) / length(dec_real_test);
end
Cross_LBP_hist_APCER_BPCER.BPCER_20.YCbCr_train = BPCER_20;


%% YCbCr dev set
[com.epc.dev, com.epc.eva, epc_cost] = epc(dec(dev_labels == -1), dec(dev_labels == 1),...
    dec2(cross_dev_labels == -1), dec2(cross_dev_labels == 1), 1, [0.5 0.5]);
HTER = com.epc.eva.hter_apri(1) * 100;
Cross_LBP_hist_APCER_BPCER.HTER.YCbCr_dev = HTER;
[com.epc.dev, com.epc.eva, epc_cost] = epc(dec(dev_labels == -1, 1), dec(dev_labels == 1, 1), dec(dev_labels == -1, 1),dec(dev_labels == 1,1), 1, [0.5 0.5]);
EER = com.epc.dev.wer_apost(1) * 100;
Cross_LBP_hist_APCER_BPCER.EER.YCbCr_dev = EER;

threshold = com.epc.dev.thrd_fv;
% APCER
dec_attack_test = dec2(cross_dev_labels == -1);
error_attack_classify = dec_attack_test > threshold;
APCER = sum(error_attack_classify(:)) / length(dec_attack_test);
Cross_LBP_hist_APCER_BPCER.APCER.YCbCr_dev = APCER;
% BPCER
dec_real_test = dec2(cross_dev_labels == 1);
error_real_classify = dec_real_test < threshold;
BPCER = sum(error_real_classify(:)) / length(dec_real_test);
Cross_LBP_hist_APCER_BPCER.BPCER.YCbCr_dev = BPCER;
% ACER
ACER = (APCER + BPCER) / 2;
Cross_LBP_hist_APCER_BPCER.ACER.YCbCr_dev = ACER;
% BPCER20
threshold_start = threshold;
if APCER < 0.05
    APCER_5 = APCER;
    counter = 0;
    while abs(APCER_5 - 0.05) >= 0.001
        counter = counter + 1;
        disp(counter);
        threshold_start = threshold_start - 0.001;
        % APCER_5
        dec_attack_test = dec2(cross_dev_labels == -1);
        error_attack_classify = dec_attack_test > threshold_start;
        APCER_5 = sum(error_attack_classify(:)) / length(dec_attack_test);
    end
    dec_real_test = dec2(cross_dev_labels == 1);
    error_real_classify = dec_real_test < threshold_start;
    BPCER_20 = sum(error_real_classify(:)) / length(dec_real_test);
end
if APCER > 0.05
    APCER_5 = APCER;
    counter = 0;
    while abs(APCER_5 - 0.05) >= 0.001
        counter = counter + 1;
        disp(counter);
        threshold_start = threshold_start + 0.001;
        % APCER_5
        dec_attack_test = dec2(cross_dev_labels == -1);
        error_attack_classify = dec_attack_test > threshold_start;
        APCER_5 = sum(error_attack_classify(:)) / length(dec_attack_test);
    end
    dec_real_test = dec2(cross_dev_labels == 1);
    error_real_classify = dec_real_test < threshold_start;
    BPCER_20 = sum(error_real_classify(:)) / length(dec_real_test);
end
Cross_LBP_hist_APCER_BPCER.BPCER_20.YCbCr_dev = BPCER_20;


%% YCbCr test set
[com.epc.dev, com.epc.eva, epc_cost] = epc(dec(dev_labels == -1), dec(dev_labels == 1),...
    dec3(cross_test_labels == -1), dec3(cross_test_labels == 1), 1, [0.5 0.5]);
HTER = com.epc.eva.hter_apri(1) * 100;
Cross_LBP_hist_APCER_BPCER.HTER.YCbCr_test = HTER;
[com.epc.dev, com.epc.eva, epc_cost] = epc(dec(dev_labels == -1, 1), dec(dev_labels == 1, 1), dec(dev_labels == -1, 1),dec(dev_labels == 1,1), 1, [0.5 0.5]);
EER = com.epc.dev.wer_apost(1) * 100;
Cross_LBP_hist_APCER_BPCER.EER.YCbCr_test = EER;

threshold = com.epc.dev.thrd_fv;
% APCER
dec_attack_test = dec3(cross_test_labels == -1);
error_attack_classify = dec_attack_test > threshold;
APCER = sum(error_attack_classify(:)) / length(dec_attack_test);
Cross_LBP_hist_APCER_BPCER.APCER.YCbCr_test = APCER;
% BPCER
dec_real_test = dec3(cross_test_labels == 1);
error_real_classify = dec_real_test < threshold;
BPCER = sum(error_real_classify(:)) / length(dec_real_test);
Cross_LBP_hist_APCER_BPCER.BPCER.YCbCr_test = BPCER;
% ACER
ACER = (APCER + BPCER) / 2;
Cross_LBP_hist_APCER_BPCER.ACER.YCbCr_test = ACER;
% BPCER20
threshold_start = threshold;
if APCER < 0.05
    APCER_5 = APCER;
    counter = 0;
    while abs(APCER_5 - 0.05) >= 0.001
        counter = counter + 1;
        disp(counter);
        threshold_start = threshold_start - 0.001;
        % APCER_5
        dec_attack_test = dec3(cross_test_labels == -1);
        error_attack_classify = dec_attack_test > threshold_start;
        APCER_5 = sum(error_attack_classify(:)) / length(dec_attack_test);
    end
    dec_real_test = dec3(cross_test_labels == 1);
    error_real_classify = dec_real_test < threshold_start;
    BPCER_20 = sum(error_real_classify(:)) / length(dec_real_test);
end
if APCER > 0.05
    APCER_5 = APCER;
    counter = 0;
    while abs(APCER_5 - 0.05) >= 0.001
        counter = counter + 1;
        disp(counter);
        threshold_start = threshold_start + 0.001;
        % APCER_5
        dec_attack_test = dec3(cross_test_labels == -1);
        error_attack_classify = dec_attack_test > threshold_start;
        APCER_5 = sum(error_attack_classify(:)) / length(dec_attack_test);
    end
    dec_real_test = dec3(cross_test_labels == 1);
    error_real_classify = dec_real_test < threshold_start;
    BPCER_20 = sum(error_real_classify(:)) / length(dec_real_test);
end
Cross_LBP_hist_APCER_BPCER.BPCER_20.YCbCr_test = BPCER_20;


%% Original Video LSP
load('.\results\LSP_hist_OriginalVideo.mat');
dec1 = LSP_hist_OriginalVideo.dec1;
dev_labels = LSP_hist_OriginalVideo.dev_labels;
dec2 = LSP_hist_OriginalVideo.dec2;
test_labels = LSP_hist_OriginalVideo.test_labels;

[com.epc.dev, com.epc.eva, epc_cost] = epc(dec1(dev_labels == 2), dec1(dev_labels == 1),...
    dec2(test_labels == 2), dec2(test_labels == 1), 1, [0.5 0.5]);
HTER = com.epc.eva.hter_apri(1) * 100;
Original_Video_LSP_APCER_BPCER.HTER = HTER;
[com.epc.dev, com.epc.eva, epc_cost] = epc(dec1(dev_labels == 2, 1), dec1(dev_labels == 1, 1), dec1(dev_labels == 2, 1),dec1(dev_labels == 1,1), 1, [0.5 0.5]);
EER = com.epc.dev.wer_apost(1) * 100;
Original_Video_LSP_APCER_BPCER.EER = EER;

threshold = com.epc.dev.thrd_fv;
% APCER
dec_attack_test = dec2(test_labels == 2);
error_attack_classify = dec_attack_test > threshold;
APCER = sum(error_attack_classify(:)) / length(dec_attack_test);
Original_Video_LSP_APCER_BPCER.APCER = APCER;
% BPCER
dec_real_test = dec2(test_labels == 1);
error_real_classify = dec_real_test < threshold;
BPCER = sum(error_real_classify(:)) / length(dec_real_test);
Original_Video_LSP_APCER_BPCER.BPCER = BPCER;
% ACER
ACER = (APCER + BPCER) / 2;
Original_Video_LSP_APCER_BPCER.ACER = ACER;
% BPCER20
threshold_start = threshold;
if APCER < 0.05
    APCER_5 = APCER;
    counter = 0;
    while abs(APCER_5 - 0.05) >= 0.001
        counter = counter + 1;
        disp(counter);
        threshold_start = threshold_start - 0.001;
        % APCER_5
        dec_attack_test = dec2(test_labels == 2);
        error_attack_classify = dec_attack_test > threshold_start;
        APCER_5 = sum(error_attack_classify(:)) / length(dec_attack_test);
    end
    dec_real_test = dec2(test_labels == 1);
    error_real_classify = dec_real_test < threshold_start;
    BPCER_20 = sum(error_real_classify(:)) / length(dec_real_test);
end
if APCER > 0.05
    APCER_5 = APCER;
    counter = 0;
    while abs(APCER_5 - 0.05) >= 0.001
        counter = counter + 1;
        disp(counter);
        threshold_start = threshold_start + 0.001;
        % APCER_5
        dec_attack_test = dec2(test_labels == 2);
        error_attack_classify = dec_attack_test > threshold_start;
        APCER_5 = sum(error_attack_classify(:)) / length(dec_attack_test);
    end
    dec_real_test = dec2(test_labels == 1);
    error_real_classify = dec_real_test < threshold_start;
    BPCER_20 = sum(error_real_classify(:)) / length(dec_real_test);
end
Original_Video_LSP_APCER_BPCER.BPCER_20 = BPCER_20;

%% Original Video Hist Network
load('.\results\Hist_network_OriginalVideo.mat');
dec1 = Hist_network_OriginalVideo.dec1;
dev_labels = Hist_network_OriginalVideo.dev_labels;
dec2 = Hist_network_OriginalVideo.dec2;
test_labels = Hist_network_OriginalVideo.test_labels;

[com.epc.dev, com.epc.eva, epc_cost] = epc(dec1(dev_labels == 2), dec1(dev_labels == 1),...
    dec2(test_labels == 2), dec2(test_labels == 1), 1, [0.5 0.5]);
HTER = com.epc.eva.hter_apri(1) * 100;
Original_Video_Hist_network_APCER_BPCER.HTER = HTER;
[com.epc.dev, com.epc.eva, epc_cost] = epc(dec1(dev_labels == 2, 1), dec1(dev_labels == 1, 1), dec1(dev_labels == 2, 1),dec1(dev_labels == 1,1), 1, [0.5 0.5]);
EER = com.epc.dev.wer_apost(1) * 100;
Original_Video_Hist_network_APCER_BPCER.EER = EER;

threshold = com.epc.dev.thrd_fv;
% APCER
dec_attack_test = dec2(test_labels == 2);
error_attack_classify = dec_attack_test > threshold;
APCER = sum(error_attack_classify(:)) / length(dec_attack_test);
Original_Video_Hist_network_APCER_BPCER.APCER = APCER;
% BPCER
dec_real_test = dec2(test_labels == 1);
error_real_classify = dec_real_test < threshold;
BPCER = sum(error_real_classify(:)) / length(dec_real_test);
Original_Video_Hist_network_APCER_BPCER.BPCER = BPCER;
% ACER
ACER = (APCER + BPCER) / 2;
Original_Video_Hist_network_APCER_BPCER.ACER = ACER;
% BPCER20
threshold_start = threshold;
if APCER < 0.05
    APCER_5 = APCER;
    counter = 0;
    while abs(APCER_5 - 0.05) >= 0.001
        counter = counter + 1;
        disp(counter);
        threshold_start = threshold_start - 0.001;
        % APCER_5
        dec_attack_test = dec2(test_labels == 2);
        error_attack_classify = dec_attack_test > threshold_start;
        APCER_5 = sum(error_attack_classify(:)) / length(dec_attack_test);
    end
    dec_real_test = dec2(test_labels == 1);
    error_real_classify = dec_real_test < threshold_start;
    BPCER_20 = sum(error_real_classify(:)) / length(dec_real_test);
end
if APCER > 0.05
    APCER_5 = APCER;
    counter = 0;
    while abs(APCER_5 - 0.05) >= 0.001
        counter = counter + 1;
        disp(counter);
        threshold_start = threshold_start + 0.001;
        % APCER_5
        dec_attack_test = dec2(test_labels == 2);
        error_attack_classify = dec_attack_test > threshold_start;
        APCER_5 = sum(error_attack_classify(:)) / length(dec_attack_test);
    end
    dec_real_test = dec2(test_labels == 1);
    error_real_classify = dec_real_test < threshold_start;
    BPCER_20 = sum(error_real_classify(:)) / length(dec_real_test);
end
Original_Video_Hist_network_APCER_BPCER.BPCER_20 = BPCER_20;

%% Original Video average hist 
load('.\results\Hist_average_OriginalVideo.mat');
dec1 = Hist_average_OriginalVideo.dec1;
dev_labels = Hist_average_OriginalVideo.dev_labels;
dec2 = Hist_average_OriginalVideo.dec2;
test_labels = Hist_average_OriginalVideo.test_labels;

[com.epc.dev, com.epc.eva, epc_cost] = epc(dec1(dev_labels == 2), dec1(dev_labels == 1),...
    dec2(test_labels == 2), dec2(test_labels == 1), 1, [0.5 0.5]);
HTER = com.epc.eva.hter_apri(1) * 100;
Original_Video_Hist_average_APCER_BPCER.HTER = HTER;
[com.epc.dev, com.epc.eva, epc_cost] = epc(dec1(dev_labels == 2, 1), dec1(dev_labels == 1, 1), dec1(dev_labels == 2, 1),dec1(dev_labels == 1,1), 1, [0.5 0.5]);
EER = com.epc.dev.wer_apost(1) * 100;
Original_Video_Hist_average_APCER_BPCER.EER = EER;

threshold = com.epc.dev.thrd_fv;
% APCER
dec_attack_test = dec2(test_labels == 2);
error_attack_classify = dec_attack_test > threshold;
APCER = sum(error_attack_classify(:)) / length(dec_attack_test);
Original_Video_Hist_average_APCER_BPCER.APCER = APCER;
% BPCER
dec_real_test = dec2(test_labels == 1);
error_real_classify = dec_real_test < threshold;
BPCER = sum(error_real_classify(:)) / length(dec_real_test);
Original_Video_Hist_average_APCER_BPCER.BPCER = BPCER;
% ACER
ACER = (APCER + BPCER) / 2;
Original_Video_Hist_average_APCER_BPCER.ACER = ACER;
% BPCER20
threshold_start = threshold;
if APCER < 0.05
    APCER_5 = APCER;
    counter = 0;
    while abs(APCER_5 - 0.05) >= 0.001
        counter = counter + 1;
        disp(counter);
        threshold_start = threshold_start - 0.001;
        % APCER_5
        dec_attack_test = dec2(test_labels == 2);
        error_attack_classify = dec_attack_test > threshold_start;
        APCER_5 = sum(error_attack_classify(:)) / length(dec_attack_test);
    end
    dec_real_test = dec2(test_labels == 1);
    error_real_classify = dec_real_test < threshold_start;
    BPCER_20 = sum(error_real_classify(:)) / length(dec_real_test);
end
if APCER > 0.05
    APCER_5 = APCER;
    counter = 0;
    while abs(APCER_5 - 0.05) >= 0.001
        counter = counter + 1;
        disp(counter);
        threshold_start = threshold_start + 0.001;
        % APCER_5
        dec_attack_test = dec2(test_labels == 2);
        error_attack_classify = dec_attack_test > threshold_start;
        APCER_5 = sum(error_attack_classify(:)) / length(dec_attack_test);
    end
    dec_real_test = dec2(test_labels == 1);
    error_real_classify = dec_real_test < threshold_start;
    BPCER_20 = sum(error_real_classify(:)) / length(dec_real_test);
end
Original_Video_Hist_average_APCER_BPCER.BPCER_20 = BPCER_20;


%% Original Video early fusion CNN lsp 
load('.\results\Early_Fusion_LSP_cnn_hist_OriginalVideo.mat');
dec1 = Fusion_LSP_cnn_hist_OriginalVideo.dec1;
dev_labels = Fusion_LSP_cnn_hist_OriginalVideo.dev_labels;
dec2 = Fusion_LSP_cnn_hist_OriginalVideo.dec2;
test_labels = Fusion_LSP_cnn_hist_OriginalVideo.test_labels;

[com.epc.dev, com.epc.eva, epc_cost] = epc(dec1(dev_labels == 2), dec1(dev_labels == 1),...
    dec2(test_labels == 2), dec2(test_labels == 1), 1, [0.5 0.5]);
HTER = com.epc.eva.hter_apri(1) * 100;
Original_Video_Early_Fusion_APCER_BPCER.HTER = HTER;
[com.epc.dev, com.epc.eva, epc_cost] = epc(dec1(dev_labels == 2, 1), dec1(dev_labels == 1, 1), dec1(dev_labels == 2, 1),dec1(dev_labels == 1,1), 1, [0.5 0.5]);
EER = com.epc.dev.wer_apost(1) * 100;
Original_Video_Early_Fusion_APCER_BPCER.EER = EER;

threshold = com.epc.dev.thrd_fv;
% APCER
dec_attack_test = dec2(test_labels == 2);
error_attack_classify = dec_attack_test > threshold;
APCER = sum(error_attack_classify(:)) / length(dec_attack_test);
Original_Video_Early_Fusion_APCER_BPCER.APCER = APCER;
% BPCER
dec_real_test = dec2(test_labels == 1);
error_real_classify = dec_real_test < threshold;
BPCER = sum(error_real_classify(:)) / length(dec_real_test);
Original_Video_Early_Fusion_APCER_BPCER.BPCER = BPCER;
% ACER
ACER = (APCER + BPCER) / 2;
Original_Video_Early_Fusion_APCER_BPCER.ACER = ACER;
% BPCER20
threshold_start = threshold;
if APCER < 0.05
    APCER_5 = APCER;
    counter = 0;
    while abs(APCER_5 - 0.05) >= 0.001
        counter = counter + 1;
        disp(counter);
        threshold_start = threshold_start - 0.001;
        % APCER_5
        dec_attack_test = dec2(test_labels == 2);
        error_attack_classify = dec_attack_test > threshold_start;
        APCER_5 = sum(error_attack_classify(:)) / length(dec_attack_test);
    end
    dec_real_test = dec2(test_labels == 1);
    error_real_classify = dec_real_test < threshold_start;
    BPCER_20 = sum(error_real_classify(:)) / length(dec_real_test);
end
if APCER > 0.05
    APCER_5 = APCER;
    counter = 0;
    while abs(APCER_5 - 0.05) >= 0.001
        counter = counter + 1;
        disp(counter);
        threshold_start = threshold_start + 0.001;
        % APCER_5
        dec_attack_test = dec2(test_labels == 2);
        error_attack_classify = dec_attack_test > threshold_start;
        APCER_5 = sum(error_attack_classify(:)) / length(dec_attack_test);
    end
    dec_real_test = dec2(test_labels == 1);
    error_real_classify = dec_real_test < threshold_start;
    BPCER_20 = sum(error_real_classify(:)) / length(dec_real_test);
end
Original_Video_Early_Fusion_APCER_BPCER.BPCER_20 = BPCER_20;


%% Original Video late fusion CNN lsp 
load('.\results\Late_Fusion_LSP_cnn_hist_OriginalVideo.mat');
dec1 = Late_Fusion_LSP_cnn_hist_OriginalVideo.dec1;
dev_labels = Late_Fusion_LSP_cnn_hist_OriginalVideo.dev_labels;
dec2 = Late_Fusion_LSP_cnn_hist_OriginalVideo.dec2;
test_labels = Late_Fusion_LSP_cnn_hist_OriginalVideo.test_labels;

[com.epc.dev, com.epc.eva, epc_cost] = epc(dec1(dev_labels == 2), dec1(dev_labels == 1),...
    dec2(test_labels == 2), dec2(test_labels == 1), 1, [0.5 0.5]);
HTER = com.epc.eva.hter_apri(1) * 100;
Original_Video_Late_Fusion_APCER_BPCER.HTER = HTER;
[com.epc.dev, com.epc.eva, epc_cost] = epc(dec2(test_labels == 2, 1), dec2(test_labels == 1, 1), dec2(test_labels == 2, 1),dec2(test_labels == 1,1), 1, [0.5 0.5]);
EER = com.epc.dev.wer_apost(1) * 100;
Original_Video_Late_Fusion_APCER_BPCER.EER = EER;

threshold = com.epc.dev.thrd_fv;
% APCER
dec_attack_test = dec2(test_labels == 2);
error_attack_classify = dec_attack_test > threshold;
APCER = sum(error_attack_classify(:)) / length(dec_attack_test);
Original_Video_Late_Fusion_APCER_BPCER.APCER = APCER;
% BPCER
dec_real_test = dec2(test_labels == 1);
error_real_classify = dec_real_test < threshold;
BPCER = sum(error_real_classify(:)) / length(dec_real_test);
Original_Video_Late_Fusion_APCER_BPCER.BPCER = BPCER;
% ACER
ACER = (APCER + BPCER) / 2;
Original_Video_Late_Fusion_APCER_BPCER.ACER = ACER;
% BPCER20
threshold_start = threshold;
if APCER < 0.05
    APCER_5 = APCER;
    counter = 0;
    while abs(APCER_5 - 0.05) >= 0.001
        counter = counter + 1;
        disp(counter);
        threshold_start = threshold_start - 0.001;
        % APCER_5
        dec_attack_test = dec2(test_labels == 2);
        error_attack_classify = dec_attack_test > threshold_start;
        APCER_5 = sum(error_attack_classify(:)) / length(dec_attack_test);
    end
    dec_real_test = dec2(test_labels == 1);
    error_real_classify = dec_real_test < threshold_start;
    BPCER_20 = sum(error_real_classify(:)) / length(dec_real_test);
end
if APCER > 0.05
    APCER_5 = APCER;
    counter = 0;
    while abs(APCER_5 - 0.05) >= 0.001
        counter = counter + 1;
        disp(counter);
        threshold_start = threshold_start + 0.001;
        % APCER_5
        dec_attack_test = dec2(test_labels == 2);
        error_attack_classify = dec_attack_test > threshold_start;
        APCER_5 = sum(error_attack_classify(:)) / length(dec_attack_test);
    end
    dec_real_test = dec2(test_labels == 1);
    error_real_classify = dec_real_test < threshold_start;
    BPCER_20 = sum(error_real_classify(:)) / length(dec_real_test);
end
Original_Video_Late_Fusion_APCER_BPCER.BPCER_20 = BPCER_20;


%% Cross Early Fusion LSP and CNN
load('.\results\Cross_Fusion_LSP_cnn_hist_OriginalVideo.mat');
dec = Cross_Fusion_LSP_cnn_hist_OriginalVideo.dec;
dec1 = Cross_Fusion_LSP_cnn_hist_OriginalVideo.dec1;
dec2 = Cross_Fusion_LSP_cnn_hist_OriginalVideo.dec2;
dec3 = Cross_Fusion_LSP_cnn_hist_OriginalVideo.dec3;
dev_labels = Cross_Fusion_LSP_cnn_hist_OriginalVideo.dev_labels;
cross_train_labels = Cross_Fusion_LSP_cnn_hist_OriginalVideo.Cross_train_labels;
cross_dev_labels = Cross_Fusion_LSP_cnn_hist_OriginalVideo.Cross_dev_labels;
cross_test_labels = Cross_Fusion_LSP_cnn_hist_OriginalVideo.Cross_test_labels;

%% train set
[com.epc.dev, com.epc.eva, epc_cost] = epc(dec(dev_labels == 2), dec(dev_labels == 1),...
    dec1(cross_train_labels == 2), dec1(cross_train_labels == 1), 1, [0.5 0.5]);
HTER = com.epc.eva.hter_apri(1) * 100;
Cross_Early_Fusion_lsp_cnn_APCER_BPCER.HTER.RGB_train = HTER;
[com.epc.dev, com.epc.eva, epc_cost] = epc(dec(dev_labels == 2, 1), dec(dev_labels == 1, 1), dec(dev_labels == 2, 1),dec(dev_labels == 1,1), 1, [0.5 0.5]);
EER = com.epc.dev.wer_apost(1) * 100;
Cross_Early_Fusion_lsp_cnn_APCER_BPCER.EER.RGB_train = EER;

threshold = com.epc.dev.thrd_fv;
% APCER
dec_attack_test = dec1(cross_train_labels == 2);
error_attack_classify = dec_attack_test > threshold;
APCER = sum(error_attack_classify(:)) / length(dec_attack_test);
Cross_Early_Fusion_lsp_cnn_APCER_BPCER.APCER.RGB_train = APCER;
% BPCER
dec_real_test = dec1(cross_train_labels == 1);
error_real_classify = dec_real_test < threshold;
BPCER = sum(error_real_classify(:)) / length(dec_real_test);
Cross_Early_Fusion_lsp_cnn_APCER_BPCER.BPCER.RGB_train = BPCER;
% ACER
ACER = (APCER + BPCER) / 2;
Cross_Early_Fusion_lsp_cnn_APCER_BPCER.ACER.RGB_train = ACER;
% BPCER20
threshold_start = threshold;
if APCER < 0.05
    APCER_5 = APCER;
    counter = 0;
    while abs(APCER_5 - 0.05) >= 0.001
        counter = counter + 1;
        disp(counter);
        threshold_start = threshold_start - 0.001;
        % APCER_5
        dec_attack_test = dec1(cross_train_labels == 2);
        error_attack_classify = dec_attack_test > threshold_start;
        APCER_5 = sum(error_attack_classify(:)) / length(dec_attack_test);
    end
    dec_real_test = dec1(cross_train_labels == 1);
    error_real_classify = dec_real_test < threshold_start;
    BPCER_20 = sum(error_real_classify(:)) / length(dec_real_test);
end
if APCER > 0.05
    APCER_5 = APCER;
    counter = 0;
    while abs(APCER_5 - 0.05) >= 0.001
        counter = counter + 1;
        disp(counter);
        threshold_start = threshold_start + 0.001;
        % APCER_5
        dec_attack_test = dec1(cross_train_labels == 2);
        error_attack_classify = dec_attack_test > threshold_start;
        APCER_5 = sum(error_attack_classify(:)) / length(dec_attack_test);
    end
    dec_real_test = dec1(cross_train_labels == 1);
    error_real_classify = dec_real_test < threshold_start;
    BPCER_20 = sum(error_real_classify(:)) / length(dec_real_test);
end
Cross_Early_Fusion_lsp_cnn_APCER_BPCER.BPCER_20.RGB_train = BPCER_20;

%% dev set
[com.epc.dev, com.epc.eva, epc_cost] = epc(dec(dev_labels == 2), dec(dev_labels == 1),...
    dec2(cross_dev_labels == 2), dec2(cross_dev_labels == 1), 1, [0.5 0.5]);
HTER = com.epc.eva.hter_apri(1) * 100;
Cross_Early_Fusion_lsp_cnn_APCER_BPCER.HTER.RGB_dev = HTER;
[com.epc.dev, com.epc.eva, epc_cost] = epc(dec(dev_labels == 2, 1), dec(dev_labels == 1, 1), dec(dev_labels == 2, 1),dec(dev_labels == 1,1), 1, [0.5 0.5]);
EER = com.epc.dev.wer_apost(1) * 100;
Cross_Early_Fusion_lsp_cnn_APCER_BPCER.EER.RGB_dev = EER;

threshold = com.epc.dev.thrd_fv;
% APCER
dec_attack_test = dec2(cross_dev_labels == 2);
error_attack_classify = dec_attack_test > threshold;
APCER = sum(error_attack_classify(:)) / length(dec_attack_test);
Cross_Early_Fusion_lsp_cnn_APCER_BPCER.APCER.RGB_dev = APCER;
% BPCER
dec_real_test = dec2(cross_dev_labels == 1);
error_real_classify = dec_real_test < threshold;
BPCER = sum(error_real_classify(:)) / length(dec_real_test);
Cross_Early_Fusion_lsp_cnn_APCER_BPCER.BPCER.RGB_dev = BPCER;
% ACER
ACER = (APCER + BPCER) / 2;
Cross_Early_Fusion_lsp_cnn_APCER_BPCER.ACER.RGB_dev = ACER;
% BPCER20
threshold_start = threshold;
if APCER < 0.05
    APCER_5 = APCER;
    counter = 0;
    while abs(APCER_5 - 0.05) >= 0.001
        counter = counter + 1;
        disp(counter);
        threshold_start = threshold_start - 0.001;
        % APCER_5
        dec_attack_test = dec2(cross_dev_labels == 2);
        error_attack_classify = dec_attack_test > threshold_start;
        APCER_5 = sum(error_attack_classify(:)) / length(dec_attack_test);
    end
    dec_real_test = dec2(cross_dev_labels == 1);
    error_real_classify = dec_real_test < threshold_start;
    BPCER_20 = sum(error_real_classify(:)) / length(dec_real_test);
end
if APCER > 0.05
    APCER_5 = APCER;
    counter = 0;
    while abs(APCER_5 - 0.05) >= 0.001
        counter = counter + 1;
        disp(counter);
        threshold_start = threshold_start + 0.001;
        % APCER_5
        dec_attack_test = dec2(cross_dev_labels == 2);
        error_attack_classify = dec_attack_test > threshold_start;
        APCER_5 = sum(error_attack_classify(:)) / length(dec_attack_test);
    end
    dec_real_test = dec2(cross_dev_labels == 1);
    error_real_classify = dec_real_test < threshold_start;
    BPCER_20 = sum(error_real_classify(:)) / length(dec_real_test);
end
Cross_Early_Fusion_lsp_cnn_APCER_BPCER.BPCER_20.RGB_dev = BPCER_20;


%% test set
[com.epc.dev, com.epc.eva, epc_cost] = epc(dec(dev_labels == 2), dec(dev_labels == 1),...
    dec3(cross_test_labels == 2), dec3(cross_test_labels == 1), 1, [0.5 0.5]);
HTER = com.epc.eva.hter_apri(1) * 100;
Cross_Early_Fusion_lsp_cnn_APCER_BPCER.HTER.RGB_test = HTER;
[com.epc.dev, com.epc.eva, epc_cost] = epc(dec(dev_labels == 2, 1), dec(dev_labels == 1, 1), dec(dev_labels == 2, 1),dec(dev_labels == 1,1), 1, [0.5 0.5]);
EER = com.epc.dev.wer_apost(1) * 100;
Cross_Early_Fusion_lsp_cnn_APCER_BPCER.EER.RGB_test = EER;

threshold = com.epc.dev.thrd_fv;
% APCER
dec_attack_test = dec3(cross_test_labels == 2);
error_attack_classify = dec_attack_test > threshold;
APCER = sum(error_attack_classify(:)) / length(dec_attack_test);
Cross_Early_Fusion_lsp_cnn_APCER_BPCER.APCER.RGB_test = APCER;
% BPCER
dec_real_test = dec3(cross_test_labels == 1);
error_real_classify = dec_real_test < threshold;
BPCER = sum(error_real_classify(:)) / length(dec_real_test);
Cross_Early_Fusion_lsp_cnn_APCER_BPCER.BPCER.RGB_test = BPCER;
% ACER
ACER = (APCER + BPCER) / 2;
Cross_Early_Fusion_lsp_cnn_APCER_BPCER.ACER.RGB_test = ACER;
% BPCER20
threshold_start = threshold;
if APCER < 0.05
    APCER_5 = APCER;
    counter = 0;
    while abs(APCER_5 - 0.05) >= 0.001
        counter = counter + 1;
        disp(counter);
        threshold_start = threshold_start - 0.001;
        % APCER_5
        dec_attack_test = dec3(cross_test_labels == 2);
        error_attack_classify = dec_attack_test > threshold_start;
        APCER_5 = sum(error_attack_classify(:)) / length(dec_attack_test);
    end
    dec_real_test = dec3(cross_test_labels == 1);
    error_real_classify = dec_real_test < threshold_start;
    BPCER_20 = sum(error_real_classify(:)) / length(dec_real_test);
end
if APCER > 0.05
    APCER_5 = APCER;
    counter = 0;
    while abs(APCER_5 - 0.05) >= 0.001
        counter = counter + 1;
        disp(counter);
        threshold_start = threshold_start + 0.001;
        % APCER_5
        dec_attack_test = dec3(cross_test_labels == 2);
        error_attack_classify = dec_attack_test > threshold_start;
        APCER_5 = sum(error_attack_classify(:)) / length(dec_attack_test);
    end
    dec_real_test = dec3(cross_test_labels == 1);
    error_real_classify = dec_real_test < threshold_start;
    BPCER_20 = sum(error_real_classify(:)) / length(dec_real_test);
end
Cross_Early_Fusion_lsp_cnn_APCER_BPCER.BPCER_20.RGB_test = BPCER_20;

%% Cross Late Fusion LSP and CNN
load('.\results\Cross_Late_Fusion_LSP_cnn_hist_OriginalVideo.mat');
dec = Cross_Late_Fusion_LSP_cnn_hist_OriginalVideo.dec;
dec1 = Cross_Late_Fusion_LSP_cnn_hist_OriginalVideo.dec1;
dec2 = Cross_Late_Fusion_LSP_cnn_hist_OriginalVideo.dec2;
dec3 = Cross_Late_Fusion_LSP_cnn_hist_OriginalVideo.dec3;
dev_labels = Cross_Late_Fusion_LSP_cnn_hist_OriginalVideo.dev_labels;
cross_train_labels = Cross_Late_Fusion_LSP_cnn_hist_OriginalVideo.Cross_train_labels;
cross_dev_labels = Cross_Late_Fusion_LSP_cnn_hist_OriginalVideo.Cross_dev_labels;
cross_test_labels = Cross_Late_Fusion_LSP_cnn_hist_OriginalVideo.Cross_test_labels;

%% train set
[com.epc.dev, com.epc.eva, epc_cost] = epc(dec(dev_labels == 2), dec(dev_labels == 1),...
    dec1(cross_train_labels == 2), dec1(cross_train_labels == 1), 1, [0.5 0.5]);
HTER = com.epc.eva.hter_apri(1) * 100;
Cross_Late_Fusion_lsp_cnn_APCER_BPCER.HTER.RGB_train = HTER;
[com.epc.dev, com.epc.eva, epc_cost] = epc(dec(dev_labels == 2, 1), dec(dev_labels == 1, 1), dec(dev_labels == 2, 1),dec(dev_labels == 1,1), 1, [0.5 0.5]);
EER = com.epc.dev.wer_apost(1) * 100;
Cross_Late_Fusion_lsp_cnn_APCER_BPCER.EER.RGB_train = EER;

threshold = com.epc.dev.thrd_fv;
% APCER
dec_attack_test = dec1(cross_train_labels == 2);
error_attack_classify = dec_attack_test > threshold;
APCER = sum(error_attack_classify(:)) / length(dec_attack_test);
Cross_Late_Fusion_lsp_cnn_APCER_BPCER.APCER.RGB_train = APCER;
% BPCER
dec_real_test = dec1(cross_train_labels == 1);
error_real_classify = dec_real_test < threshold;
BPCER = sum(error_real_classify(:)) / length(dec_real_test);
Cross_Late_Fusion_lsp_cnn_APCER_BPCER.BPCER.RGB_train = BPCER;
% ACER
ACER = (APCER + BPCER) / 2;
Cross_Late_Fusion_lsp_cnn_APCER_BPCER.ACER.RGB_train = ACER;
% BPCER20
threshold_start = threshold;
if APCER < 0.05
    APCER_5 = APCER;
    counter = 0;
    while abs(APCER_5 - 0.05) >= 0.001
        counter = counter + 1;
        disp(counter);
        threshold_start = threshold_start - 0.001;
        % APCER_5
        dec_attack_test = dec1(cross_train_labels == 2);
        error_attack_classify = dec_attack_test > threshold_start;
        APCER_5 = sum(error_attack_classify(:)) / length(dec_attack_test);
    end
    dec_real_test = dec1(cross_train_labels == 1);
    error_real_classify = dec_real_test < threshold_start;
    BPCER_20 = sum(error_real_classify(:)) / length(dec_real_test);
end
if APCER > 0.05
    APCER_5 = APCER;
    counter = 0;
    while abs(APCER_5 - 0.05) >= 0.001
        counter = counter + 1;
        disp(counter);
        threshold_start = threshold_start + 0.001;
        % APCER_5
        dec_attack_test = dec1(cross_train_labels == 2);
        error_attack_classify = dec_attack_test > threshold_start;
        APCER_5 = sum(error_attack_classify(:)) / length(dec_attack_test);
    end
    dec_real_test = dec1(cross_train_labels == 1);
    error_real_classify = dec_real_test < threshold_start;
    BPCER_20 = sum(error_real_classify(:)) / length(dec_real_test);
end
Cross_Late_Fusion_lsp_cnn_APCER_BPCER.BPCER_20.RGB_train = BPCER_20;

%% dev set
[com.epc.dev, com.epc.eva, epc_cost] = epc(dec(dev_labels == 2), dec(dev_labels == 1),...
    dec2(cross_dev_labels == 2), dec2(cross_dev_labels == 1), 1, [0.5 0.5]);
HTER = com.epc.eva.hter_apri(1) * 100;
Cross_Late_Fusion_lsp_cnn_APCER_BPCER.HTER.RGB_dev = HTER;
[com.epc.dev, com.epc.eva, epc_cost] = epc(dec(dev_labels == 2, 1), dec(dev_labels == 1, 1), dec(dev_labels == 2, 1),dec(dev_labels == 1,1), 1, [0.5 0.5]);
EER = com.epc.dev.wer_apost(1) * 100;
Cross_Late_Fusion_lsp_cnn_APCER_BPCER.EER.RGB_dev = EER;

threshold = com.epc.dev.thrd_fv;
% APCER
dec_attack_test = dec2(cross_dev_labels == 2);
error_attack_classify = dec_attack_test > threshold;
APCER = sum(error_attack_classify(:)) / length(dec_attack_test);
Cross_Late_Fusion_lsp_cnn_APCER_BPCER.APCER.RGB_dev = APCER;
% BPCER
dec_real_test = dec2(cross_dev_labels == 1);
error_real_classify = dec_real_test < threshold;
BPCER = sum(error_real_classify(:)) / length(dec_real_test);
Cross_Late_Fusion_lsp_cnn_APCER_BPCER.BPCER.RGB_dev = BPCER;
% ACER
ACER = (APCER + BPCER) / 2;
Cross_Late_Fusion_lsp_cnn_APCER_BPCER.ACER.RGB_dev = ACER;
% BPCER20
threshold_start = threshold;
if APCER < 0.05
    APCER_5 = APCER;
    counter = 0;
    while abs(APCER_5 - 0.05) >= 0.001
        counter = counter + 1;
        disp(counter);
        threshold_start = threshold_start - 0.001;
        % APCER_5
        dec_attack_test = dec2(cross_dev_labels == 2);
        error_attack_classify = dec_attack_test > threshold_start;
        APCER_5 = sum(error_attack_classify(:)) / length(dec_attack_test);
    end
    dec_real_test = dec2(cross_dev_labels == 1);
    error_real_classify = dec_real_test < threshold_start;
    BPCER_20 = sum(error_real_classify(:)) / length(dec_real_test);
end
if APCER > 0.05
    APCER_5 = APCER;
    counter = 0;
    while abs(APCER_5 - 0.05) >= 0.001
        counter = counter + 1;
        disp(counter);
        threshold_start = threshold_start + 0.001;
        % APCER_5
        dec_attack_test = dec2(cross_dev_labels == 2);
        error_attack_classify = dec_attack_test > threshold_start;
        APCER_5 = sum(error_attack_classify(:)) / length(dec_attack_test);
    end
    dec_real_test = dec2(cross_dev_labels == 1);
    error_real_classify = dec_real_test < threshold_start;
    BPCER_20 = sum(error_real_classify(:)) / length(dec_real_test);
end
Cross_Late_Fusion_lsp_cnn_APCER_BPCER.BPCER_20.RGB_dev = BPCER_20;

%% test set
[com.epc.dev, com.epc.eva, epc_cost] = epc(dec(dev_labels == 2), dec(dev_labels == 1),...
    dec3(cross_test_labels == 2), dec3(cross_test_labels == 1), 1, [0.5 0.5]);
HTER = com.epc.eva.hter_apri(1) * 100;
Cross_Late_Fusion_lsp_cnn_APCER_BPCER.HTER.RGB_test = HTER;
[com.epc.dev, com.epc.eva, epc_cost] = epc(dec(dev_labels == 2, 1), dec(dev_labels == 1, 1), dec(dev_labels == 2, 1),dec(dev_labels == 1,1), 1, [0.5 0.5]);
EER = com.epc.dev.wer_apost(1) * 100;
Cross_Late_Fusion_lsp_cnn_APCER_BPCER.EER.RGB_test = EER;

threshold = com.epc.dev.thrd_fv;
% APCER
dec_attack_test = dec3(cross_test_labels == 2);
error_attack_classify = dec_attack_test > threshold;
APCER = sum(error_attack_classify(:)) / length(dec_attack_test);
Cross_Late_Fusion_lsp_cnn_APCER_BPCER.APCER.RGB_test = APCER;
% BPCER
dec_real_test = dec3(cross_test_labels == 1);
error_real_classify = dec_real_test < threshold;
BPCER = sum(error_real_classify(:)) / length(dec_real_test);
Cross_Late_Fusion_lsp_cnn_APCER_BPCER.BPCER.RGB_test = BPCER;
% ACER
ACER = (APCER + BPCER) / 2;
Cross_Late_Fusion_lsp_cnn_APCER_BPCER.ACER.RGB_test = ACER;
% BPCER20
threshold_start = threshold;
if APCER < 0.05
    APCER_5 = APCER;
    counter = 0;
    while abs(APCER_5 - 0.05) >= 0.001
        counter = counter + 1;
        disp(counter);
        threshold_start = threshold_start - 0.001;
        % APCER_5
        dec_attack_test = dec3(cross_test_labels == 2);
        error_attack_classify = dec_attack_test > threshold_start;
        APCER_5 = sum(error_attack_classify(:)) / length(dec_attack_test);
    end
    dec_real_test = dec3(cross_test_labels == 1);
    error_real_classify = dec_real_test < threshold_start;
    BPCER_20 = sum(error_real_classify(:)) / length(dec_real_test);
end
if APCER > 0.05
    APCER_5 = APCER;
    counter = 0;
    while abs(APCER_5 - 0.05) >= 0.001
        counter = counter + 1;
        disp(counter);
        threshold_start = threshold_start + 0.001;
        % APCER_5
        dec_attack_test = dec3(cross_test_labels == 2);
        error_attack_classify = dec_attack_test > threshold_start;
        APCER_5 = sum(error_attack_classify(:)) / length(dec_attack_test);
    end
    dec_real_test = dec3(cross_test_labels == 1);
    error_real_classify = dec_real_test < threshold_start;
    BPCER_20 = sum(error_real_classify(:)) / length(dec_real_test);
end
Cross_Late_Fusion_lsp_cnn_APCER_BPCER.BPCER_20.RGB_test = BPCER_20;


%% Baseline MoirePattern
load('.\results\baseline\MoirePattern\LBP_hist.mat');
dec1 = LBP_hist.dec1;
dev_labels = LBP_hist.dev_labels;
dec2 = LBP_hist.dec2;
test_labels = LBP_hist.test_labels;

[com.epc.dev, com.epc.eva, epc_cost] = epc(dec1(dev_labels == 2), dec1(dev_labels == 1),...
    dec2(test_labels == 2), dec2(test_labels == 1), 1, [0.5 0.5]);
HTER = com.epc.eva.hter_apri(1) * 100;
BaselineMoirePattern_APCER_BPCER.HTER = HTER;
[com.epc.dev, com.epc.eva, epc_cost] = epc(dec1(dev_labels == 2, 1), dec1(dev_labels == 1, 1), dec1(dev_labels == 2, 1),dec1(dev_labels == 1,1), 1, [0.5 0.5]);
EER = com.epc.dev.wer_apost(1) * 100;
BaselineMoirePattern_APCER_BPCER.EER = EER;

threshold = com.epc.dev.thrd_fv;
% APCER
dec_attack_test = dec2(test_labels == 2);
error_attack_classify = dec_attack_test > threshold;
APCER = sum(error_attack_classify(:)) / length(dec_attack_test);
BaselineMoirePattern_APCER_BPCER.APCER = APCER;
% BPCER
dec_real_test = dec2(test_labels == 1);
error_real_classify = dec_real_test < threshold;
BPCER = sum(error_real_classify(:)) / length(dec_real_test);
BaselineMoirePattern_APCER_BPCER.BPCER = BPCER;
% ACER
ACER = (APCER + BPCER) / 2;
BaselineMoirePattern_APCER_BPCER.ACER = ACER;
% BPCER20
threshold_start = threshold;
if APCER < 0.05
    APCER_5 = APCER;
    counter = 0;
    while abs(APCER_5 - 0.05) >= 0.001
        counter = counter + 1;
        disp(counter);
        threshold_start = threshold_start - 0.001;
        % APCER_5
        dec_attack_test = dec2(test_labels == 2);
        error_attack_classify = dec_attack_test > threshold_start;
        APCER_5 = sum(error_attack_classify(:)) / length(dec_attack_test);
    end
    dec_real_test = dec2(test_labels == 1);
    error_real_classify = dec_real_test < threshold_start;
    BPCER_20 = sum(error_real_classify(:)) / length(dec_real_test);
end
if APCER > 0.05
    APCER_5 = APCER;
    counter = 0;
    while abs(APCER_5 - 0.05) >= 0.001
        counter = counter + 1;
        disp(counter);
        threshold_start = threshold_start + 0.001;
        % APCER_5
        dec_attack_test = dec2(test_labels == 2);
        error_attack_classify = dec_attack_test > threshold_start;
        APCER_5 = sum(error_attack_classify(:)) / length(dec_attack_test);
    end
    dec_real_test = dec2(test_labels == 1);
    error_real_classify = dec_real_test < threshold_start;
    BPCER_20 = sum(error_real_classify(:)) / length(dec_real_test);
end
BaselineMoirePattern_APCER_BPCER.BPCER_20 = BPCER_20;

%% Cross Baseline of MoirePattern
load('.\results\Cross_BaselineMoirePattern.mat');
dec = Cross_BaselineMoirePattern.dec;
dec1 = Cross_BaselineMoirePattern.dec1;
dec2 = Cross_BaselineMoirePattern.dec2;
dec3 = Cross_BaselineMoirePattern.dec3;
dev_labels = Cross_BaselineMoirePattern.dev_labels;
cross_train_labels = Cross_BaselineMoirePattern.cross_train_labels;
cross_dev_labels = Cross_BaselineMoirePattern.cross_dev_labels;
cross_test_labels = Cross_BaselineMoirePattern.cross_test_labels;

%% train set
[com.epc.dev, com.epc.eva, epc_cost] = epc(dec(dev_labels == -1), dec(dev_labels == 1),...
    dec1(cross_train_labels == -1), dec1(cross_train_labels == 1), 1, [0.5 0.5]);
HTER = com.epc.eva.hter_apri(1) * 100;
Cross_BaselineMoirePattern_APCER_BPCER.HTER.RGB_train = HTER;
[com.epc.dev, com.epc.eva, epc_cost] = epc(dec(dev_labels == -1, 1), dec(dev_labels == 1, 1), dec(dev_labels == -1, 1),dec(dev_labels == 1,1), 1, [0.5 0.5]);
EER = com.epc.dev.wer_apost(1) * 100;
Cross_BaselineMoirePattern_APCER_BPCER.EER.RGB_train = EER;

threshold = com.epc.dev.thrd_fv;
% APCER
dec_attack_test = dec1(cross_train_labels == -1);
error_attack_classify = dec_attack_test > threshold;
APCER = sum(error_attack_classify(:)) / length(dec_attack_test);
Cross_BaselineMoirePattern_APCER_BPCER.APCER.RGB_train = APCER;
% BPCER
dec_real_test = dec1(cross_train_labels == 1);
error_real_classify = dec_real_test < threshold;
BPCER = sum(error_real_classify(:)) / length(dec_real_test);
Cross_BaselineMoirePattern_APCER_BPCER.BPCER.RGB_train = BPCER;
% ACER
ACER = (APCER + BPCER) / 2;
Cross_BaselineMoirePattern_APCER_BPCER.ACER.RGB_train = ACER;
% BPCER20
threshold_start = threshold;
if APCER < 0.05
    APCER_5 = APCER;
    counter = 0;
    while abs(APCER_5 - 0.05) >= 0.001
        counter = counter + 1;
        disp(counter);
        threshold_start = threshold_start - 0.001;
        % APCER_5
        dec_attack_test = dec1(cross_train_labels == -1);
        error_attack_classify = dec_attack_test > threshold_start;
        APCER_5 = sum(error_attack_classify(:)) / length(dec_attack_test);
    end
    dec_real_test = dec1(cross_train_labels == 1);
    error_real_classify = dec_real_test < threshold_start;
    BPCER_20 = sum(error_real_classify(:)) / length(dec_real_test);
end
if APCER > 0.05
    APCER_5 = APCER;
    counter = 0;
    while abs(APCER_5 - 0.05) >= 0.001
        counter = counter + 1;
        disp(counter);
        threshold_start = threshold_start + 0.001;
        % APCER_5
        dec_attack_test = dec1(cross_train_labels == -1);
        error_attack_classify = dec_attack_test > threshold_start;
        APCER_5 = sum(error_attack_classify(:)) / length(dec_attack_test);
    end
    dec_real_test = dec1(cross_train_labels == 1);
    error_real_classify = dec_real_test < threshold_start;
    BPCER_20 = sum(error_real_classify(:)) / length(dec_real_test);
end
Cross_BaselineMoirePattern_APCER_BPCER.BPCER_20.RGB_train = BPCER_20;

%% dev set
[com.epc.dev, com.epc.eva, epc_cost] = epc(dec(dev_labels == -1), dec(dev_labels == 1),...
    dec2(cross_dev_labels == -1), dec2(cross_dev_labels == 1), 1, [0.5 0.5]);
HTER = com.epc.eva.hter_apri(1) * 100;
Cross_BaselineMoirePattern_APCER_BPCER.HTER.RGB_dev = HTER;
[com.epc.dev, com.epc.eva, epc_cost] = epc(dec(dev_labels == -1, 1), dec(dev_labels == 1, 1), dec(dev_labels == -1, 1),dec(dev_labels == 1,1), 1, [0.5 0.5]);
EER = com.epc.dev.wer_apost(1) * 100;
Cross_BaselineMoirePattern_APCER_BPCER.EER.RGB_dev = EER;

threshold = com.epc.dev.thrd_fv;
% APCER
dec_attack_test = dec2(cross_dev_labels == -1);
error_attack_classify = dec_attack_test > threshold;
APCER = sum(error_attack_classify(:)) / length(dec_attack_test);
Cross_BaselineMoirePattern_APCER_BPCER.APCER.RGB_dev = APCER;
% BPCER
dec_real_test = dec2(cross_dev_labels == 1);
error_real_classify = dec_real_test < threshold;
BPCER = sum(error_real_classify(:)) / length(dec_real_test);
Cross_BaselineMoirePattern_APCER_BPCER.BPCER.RGB_dev = BPCER;
% ACER
ACER = (APCER + BPCER) / 2;
Cross_BaselineMoirePattern_APCER_BPCER.ACER.RGB_dev = ACER;
% BPCER20
threshold_start = threshold;
if APCER < 0.05
    APCER_5 = APCER;
    counter = 0;
    while abs(APCER_5 - 0.05) >= 0.001
        counter = counter + 1;
        disp(counter);
        threshold_start = threshold_start - 0.001;
        % APCER_5
        dec_attack_test = dec2(cross_dev_labels == -1);
        error_attack_classify = dec_attack_test > threshold_start;
        APCER_5 = sum(error_attack_classify(:)) / length(dec_attack_test);
    end
    dec_real_test = dec2(cross_dev_labels == 1);
    error_real_classify = dec_real_test < threshold_start;
    BPCER_20 = sum(error_real_classify(:)) / length(dec_real_test);
end
if APCER > 0.05
    APCER_5 = APCER;
    counter = 0;
    while abs(APCER_5 - 0.05) >= 0.001
        counter = counter + 1;
        disp(counter);
        threshold_start = threshold_start + 0.001;
        % APCER_5
        dec_attack_test = dec2(cross_dev_labels == -1);
        error_attack_classify = dec_attack_test > threshold_start;
        APCER_5 = sum(error_attack_classify(:)) / length(dec_attack_test);
    end
    dec_real_test = dec2(cross_dev_labels == 1);
    error_real_classify = dec_real_test < threshold_start;
    BPCER_20 = sum(error_real_classify(:)) / length(dec_real_test);
end
Cross_BaselineMoirePattern_APCER_BPCER.BPCER_20.RGB_dev = BPCER_20;


%% test set
[com.epc.dev, com.epc.eva, epc_cost] = epc(dec(dev_labels == -1), dec(dev_labels == 1),...
    dec3(cross_test_labels == -1), dec3(cross_test_labels == 1), 1, [0.5 0.5]);
HTER = com.epc.eva.hter_apri(1) * 100;
Cross_BaselineMoirePattern_APCER_BPCER.HTER.RGB_test = HTER;
[com.epc.dev, com.epc.eva, epc_cost] = epc(dec(dev_labels == -1, 1), dec(dev_labels == 1, 1), dec(dev_labels == -1, 1),dec(dev_labels == 1,1), 1, [0.5 0.5]);
EER = com.epc.dev.wer_apost(1) * 100;
Cross_BaselineMoirePattern_APCER_BPCER.EER.RGB_test = EER;

threshold = com.epc.dev.thrd_fv;
% APCER
dec_attack_test = dec3(cross_test_labels == -1);
error_attack_classify = dec_attack_test > threshold;
APCER = sum(error_attack_classify(:)) / length(dec_attack_test);
Cross_BaselineMoirePattern_APCER_BPCER.APCER.RGB_test = APCER;
% BPCER
dec_real_test = dec3(cross_test_labels == 1);
error_real_classify = dec_real_test < threshold;
BPCER = sum(error_real_classify(:)) / length(dec_real_test);
Cross_BaselineMoirePattern_APCER_BPCER.BPCER.RGB_test = BPCER;
% ACER
ACER = (APCER + BPCER) / 2;
Cross_BaselineMoirePattern_APCER_BPCER.ACER.RGB_test = ACER;
% BPCER20
threshold_start = threshold;
if APCER < 0.05
    APCER_5 = APCER;
    counter = 0;
    while abs(APCER_5 - 0.05) >= 0.001
        counter = counter + 1;
        disp(counter);
        threshold_start = threshold_start - 0.001;
        % APCER_5
        dec_attack_test = dec3(cross_test_labels == -1);
        error_attack_classify = dec_attack_test > threshold_start;
        APCER_5 = sum(error_attack_classify(:)) / length(dec_attack_test);
    end
    dec_real_test = dec3(cross_test_labels == 1);
    error_real_classify = dec_real_test < threshold_start;
    BPCER_20 = sum(error_real_classify(:)) / length(dec_real_test);
end
if APCER > 0.05
    APCER_5 = APCER;
    counter = 0;
    while abs(APCER_5 - 0.05) >= 0.001
        counter = counter + 1;
        disp(counter);
        threshold_start = threshold_start + 0.001;
        % APCER_5
        dec_attack_test = dec3(cross_test_labels == -1);
        error_attack_classify = dec_attack_test > threshold_start;
        APCER_5 = sum(error_attack_classify(:)) / length(dec_attack_test);
    end
    dec_real_test = dec3(cross_test_labels == 1);
    error_real_classify = dec_real_test < threshold_start;
    BPCER_20 = sum(error_real_classify(:)) / length(dec_real_test);
end
Cross_BaselineMoirePattern_APCER_BPCER.BPCER_20.RGB_test = BPCER_20;

%% Baseline HOOF LDA
load('.\results\baseline\HOOF\HOOF_LDA.mat');
dec1 = HOOF_LDA.dec1;
dev_labels = HOOF_LDA.dev_labels;
dec2 = HOOF_LDA.dec2;
test_labels = HOOF_LDA.test_labels;

[com.epc.dev, com.epc.eva, epc_cost] = epc(dec1(dev_labels == 2), dec1(dev_labels == 1),...
    dec2(test_labels == 2), dec2(test_labels == 1), 1, [0.5 0.5]);
HTER = com.epc.eva.hter_apri(1) * 100;
BaselineHOOF_APCER_BPCER.HTER = HTER;
[com.epc.dev, com.epc.eva, epc_cost] = epc(dec1(dev_labels == 2, 1), dec1(dev_labels == 1, 1), dec1(dev_labels == 2, 1),dec1(dev_labels == 1,1), 1, [0.5 0.5]);
EER = com.epc.dev.wer_apost(1) * 100;
BaselineHOOF_APCER_BPCER.EER = EER;

threshold = com.epc.dev.thrd_fv;
% APCER
dec_attack_test = dec2(test_labels == 2);
error_attack_classify = dec_attack_test > threshold;
APCER = sum(error_attack_classify(:)) / length(dec_attack_test);
BaselineHOOF_APCER_BPCER.APCER = APCER;
% BPCER
dec_real_test = dec2(test_labels == 1);
error_real_classify = dec_real_test < threshold;
BPCER = sum(error_real_classify(:)) / length(dec_real_test);
BaselineHOOF_APCER_BPCER.BPCER = BPCER;
% ACER
ACER = (APCER + BPCER) / 2;
BaselineHOOF_APCER_BPCER.ACER = ACER;
% BPCER20
threshold_start = threshold;
if APCER < 0.05
    APCER_5 = APCER;
    counter = 0;
    while abs(APCER_5 - 0.05) >= 0.001
        counter = counter + 1;
        disp(counter);
        threshold_start = threshold_start - 0.001;
        % APCER_5
        dec_attack_test = dec2(test_labels == 2);
        error_attack_classify = dec_attack_test > threshold_start;
        APCER_5 = sum(error_attack_classify(:)) / length(dec_attack_test);
    end
    dec_real_test = dec2(test_labels == 1);
    error_real_classify = dec_real_test < threshold_start;
    BPCER_20 = sum(error_real_classify(:)) / length(dec_real_test);
end
if APCER > 0.05
    APCER_5 = APCER;
    counter = 0;
    while abs(APCER_5 - 0.05) >= 0.001
        counter = counter + 1;
        disp(counter);
        threshold_start = threshold_start + 0.001;
        % APCER_5
        dec_attack_test = dec2(test_labels == 2);
        error_attack_classify = dec_attack_test > threshold_start;
        APCER_5 = sum(error_attack_classify(:)) / length(dec_attack_test);
    end
    dec_real_test = dec2(test_labels == 1);
    error_real_classify = dec_real_test < threshold_start;
    BPCER_20 = sum(error_real_classify(:)) / length(dec_real_test);
end
BaselineHOOF_APCER_BPCER.BPCER_20 = BPCER_20;

%% Cross Baseline of HOOF
load('.\results\Cross_BaselineHOOF.mat');
dec = Cross_BaselineHOOF.dec;
dec1 = Cross_BaselineHOOF.dec1;
dec2 = Cross_BaselineHOOF.dec2;
dec3 = Cross_BaselineHOOF.dec3;
dev_labels = Cross_BaselineHOOF.dev_labels;
cross_train_labels = Cross_BaselineHOOF.cross_train_labels;
cross_dev_labels = Cross_BaselineHOOF.cross_dev_labels;
cross_test_labels = Cross_BaselineHOOF.cross_test_labels;

%% train set
[com.epc.dev, com.epc.eva, epc_cost] = epc(dec(dev_labels == -1), dec(dev_labels == 1),...
    dec1(cross_train_labels == -1), dec1(cross_train_labels == 1), 1, [0.5 0.5]);
HTER = com.epc.eva.hter_apri(1) * 100;
Cross_BaselineHOOF_APCER_BPCER.HTER.RGB_train = HTER;
[com.epc.dev, com.epc.eva, epc_cost] = epc(dec(dev_labels == -1, 1), dec(dev_labels == 1, 1), dec(dev_labels == -1, 1),dec(dev_labels == 1,1), 1, [0.5 0.5]);
EER = com.epc.dev.wer_apost(1) * 100;
Cross_BaselineHOOF_APCER_BPCER.EER.RGB_train = EER;

threshold = com.epc.dev.thrd_fv;
% APCER
dec_attack_test = dec1(cross_train_labels == -1);
error_attack_classify = dec_attack_test > threshold;
APCER = sum(error_attack_classify(:)) / length(dec_attack_test);
Cross_BaselineHOOF_APCER_BPCER.APCER.RGB_train = APCER;
% BPCER
dec_real_test = dec1(cross_train_labels == 1);
error_real_classify = dec_real_test < threshold;
BPCER = sum(error_real_classify(:)) / length(dec_real_test);
Cross_BaselineHOOF_APCER_BPCER.BPCER.RGB_train = BPCER;
% ACER
ACER = (APCER + BPCER) / 2;
Cross_BaselineHOOF_APCER_BPCER.ACER.RGB_train = ACER;
% BPCER20
threshold_start = threshold;
if APCER < 0.05
    APCER_5 = APCER;
    counter = 0;
    while abs(APCER_5 - 0.05) >= 0.001
        counter = counter + 1;
        disp(counter);
        threshold_start = threshold_start - 0.001;
        % APCER_5
        dec_attack_test = dec1(cross_train_labels == -1);
        error_attack_classify = dec_attack_test > threshold_start;
        APCER_5 = sum(error_attack_classify(:)) / length(dec_attack_test);
    end
    dec_real_test = dec1(cross_train_labels == 1);
    error_real_classify = dec_real_test < threshold_start;
    BPCER_20 = sum(error_real_classify(:)) / length(dec_real_test);
end
if APCER > 0.05
    APCER_5 = APCER;
    counter = 0;
    while abs(APCER_5 - 0.05) >= 0.001
        counter = counter + 1;
        disp(counter);
        threshold_start = threshold_start + 0.001;
        % APCER_5
        dec_attack_test = dec1(cross_train_labels == -1);
        error_attack_classify = dec_attack_test > threshold_start;
        APCER_5 = sum(error_attack_classify(:)) / length(dec_attack_test);
    end
    dec_real_test = dec1(cross_train_labels == 1);
    error_real_classify = dec_real_test < threshold_start;
    BPCER_20 = sum(error_real_classify(:)) / length(dec_real_test);
end
Cross_BaselineHOOF_APCER_BPCER.BPCER_20.RGB_train = BPCER_20;

%% dev set
[com.epc.dev, com.epc.eva, epc_cost] = epc(dec(dev_labels == -1), dec(dev_labels == 1),...
    dec2(cross_dev_labels == -1), dec2(cross_dev_labels == 1), 1, [0.5 0.5]);
HTER = com.epc.eva.hter_apri(1) * 100;
Cross_BaselineHOOF_APCER_BPCER.HTER.RGB_dev = HTER;
[com.epc.dev, com.epc.eva, epc_cost] = epc(dec(dev_labels == -1, 1), dec(dev_labels == 1, 1), dec(dev_labels == -1, 1),dec(dev_labels == 1,1), 1, [0.5 0.5]);
EER = com.epc.dev.wer_apost(1) * 100;
Cross_BaselineHOOF_APCER_BPCER.EER.RGB_dev = EER;

threshold = com.epc.dev.thrd_fv;
% APCER
dec_attack_test = dec2(cross_dev_labels == -1);
error_attack_classify = dec_attack_test > threshold;
APCER = sum(error_attack_classify(:)) / length(dec_attack_test);
Cross_BaselineHOOF_APCER_BPCER.APCER.RGB_dev = APCER;
% BPCER
dec_real_test = dec2(cross_dev_labels == 1);
error_real_classify = dec_real_test < threshold;
BPCER = sum(error_real_classify(:)) / length(dec_real_test);
Cross_BaselineHOOF_APCER_BPCER.BPCER.RGB_dev = BPCER;
% ACER
ACER = (APCER + BPCER) / 2;
Cross_BaselineHOOF_APCER_BPCER.ACER.RGB_dev = ACER;
% BPCER20
threshold_start = threshold;
if APCER < 0.05
    APCER_5 = APCER;
    counter = 0;
    while abs(APCER_5 - 0.05) >= 0.001
        counter = counter + 1;
        disp(counter);
        threshold_start = threshold_start - 0.001;
        % APCER_5
        dec_attack_test = dec2(cross_dev_labels == -1);
        error_attack_classify = dec_attack_test > threshold_start;
        APCER_5 = sum(error_attack_classify(:)) / length(dec_attack_test);
    end
    dec_real_test = dec2(cross_dev_labels == 1);
    error_real_classify = dec_real_test < threshold_start;
    BPCER_20 = sum(error_real_classify(:)) / length(dec_real_test);
end
if APCER > 0.05
    APCER_5 = APCER;
    counter = 0;
    while abs(APCER_5 - 0.05) >= 0.001
        counter = counter + 1;
        disp(counter);
        threshold_start = threshold_start + 0.001;
        % APCER_5
        dec_attack_test = dec2(cross_dev_labels == -1);
        error_attack_classify = dec_attack_test > threshold_start;
        APCER_5 = sum(error_attack_classify(:)) / length(dec_attack_test);
    end
    dec_real_test = dec2(cross_dev_labels == 1);
    error_real_classify = dec_real_test < threshold_start;
    BPCER_20 = sum(error_real_classify(:)) / length(dec_real_test);
end
Cross_BaselineHOOF_APCER_BPCER.BPCER_20.RGB_dev = BPCER_20;

%% test set
[com.epc.dev, com.epc.eva, epc_cost] = epc(dec(dev_labels == -1), dec(dev_labels == 1),...
    dec3(cross_test_labels == -1), dec3(cross_test_labels == 1), 1, [0.5 0.5]);
HTER = com.epc.eva.hter_apri(1) * 100;
Cross_BaselineHOOF_APCER_BPCER.HTER.RGB_test = HTER;
[com.epc.dev, com.epc.eva, epc_cost] = epc(dec(dev_labels == -1, 1), dec(dev_labels == 1, 1), dec(dev_labels == -1, 1),dec(dev_labels == 1,1), 1, [0.5 0.5]);
EER = com.epc.dev.wer_apost(1) * 100;
Cross_BaselineHOOF_APCER_BPCER.EER.RGB_test = EER;

threshold = com.epc.dev.thrd_fv;
% APCER
dec_attack_test = dec3(cross_test_labels == -1);
error_attack_classify = dec_attack_test > threshold;
APCER = sum(error_attack_classify(:)) / length(dec_attack_test);
Cross_BaselineHOOF_APCER_BPCER.APCER.RGB_test = APCER;
% BPCER
dec_real_test = dec3(cross_test_labels == 1);
error_real_classify = dec_real_test < threshold;
BPCER = sum(error_real_classify(:)) / length(dec_real_test);
Cross_BaselineHOOF_APCER_BPCER.BPCER.RGB_test = BPCER;
% ACER
ACER = (APCER + BPCER) / 2;
Cross_BaselineHOOF_APCER_BPCER.ACER.RGB_test = ACER;
% BPCER20
threshold_start = threshold;
if APCER < 0.05
    APCER_5 = APCER;
    counter = 0;
    while abs(APCER_5 - 0.05) >= 0.001
        counter = counter + 1;
        disp(counter);
        threshold_start = threshold_start - 0.001;
        % APCER_5
        dec_attack_test = dec3(cross_test_labels == -1);
        error_attack_classify = dec_attack_test > threshold_start;
        APCER_5 = sum(error_attack_classify(:)) / length(dec_attack_test);
    end
    dec_real_test = dec3(cross_test_labels == 1);
    error_real_classify = dec_real_test < threshold_start;
    BPCER_20 = sum(error_real_classify(:)) / length(dec_real_test);
end
if APCER > 0.05
    APCER_5 = APCER;
    counter = 0;
    while abs(APCER_5 - 0.05) >= 0.001
        counter = counter + 1;
        disp(counter);
        threshold_start = threshold_start + 0.001;
        % APCER_5
        dec_attack_test = dec3(cross_test_labels == -1);
        error_attack_classify = dec_attack_test > threshold_start;
        APCER_5 = sum(error_attack_classify(:)) / length(dec_attack_test);
    end
    dec_real_test = dec3(cross_test_labels == 1);
    error_real_classify = dec_real_test < threshold_start;
    BPCER_20 = sum(error_real_classify(:)) / length(dec_real_test);
end
Cross_BaselineHOOF_APCER_BPCER.BPCER_20.RGB_test = BPCER_20;

%% Baseline Image Quality
load('.\results\baseline\ImageQuality\ImageQuality.mat');
dec1 = ImageQuality.dec1;
dev_labels = ImageQuality.dev_labels;
dec2 = ImageQuality.dec2;
test_labels = ImageQuality.test_labels;

[com.epc.dev, com.epc.eva, epc_cost] = epc(dec1(dev_labels == 2), dec1(dev_labels == 1),...
    dec2(test_labels == 2), dec2(test_labels == 1), 1, [0.5 0.5]);
HTER = com.epc.eva.hter_apri(1) * 100;
BaselineImageQuality_APCER_BPCER.HTER = HTER;
[com.epc.dev, com.epc.eva, epc_cost] = epc(dec1(dev_labels == 2, 1), dec1(dev_labels == 1, 1), dec1(dev_labels == 2, 1),dec1(dev_labels == 1,1), 1, [0.5 0.5]);
EER = com.epc.dev.wer_apost(1) * 100;
BaselineImageQuality_APCER_BPCER.EER = EER;

threshold = com.epc.dev.thrd_fv;
% APCER
dec_attack_test = dec2(test_labels == 2);
error_attack_classify = dec_attack_test > threshold;
APCER = sum(error_attack_classify(:)) / length(dec_attack_test);
BaselineImageQuality_APCER_BPCER.APCER = APCER;
% BPCER
dec_real_test = dec2(test_labels == 1);
error_real_classify = dec_real_test < threshold;
BPCER = sum(error_real_classify(:)) / length(dec_real_test);
BaselineImageQuality_APCER_BPCER.BPCER = BPCER;
% ACER
ACER = (APCER + BPCER) / 2;
BaselineImageQuality_APCER_BPCER.ACER = ACER;
% BPCER20
threshold_start = threshold;
if APCER < 0.05
    APCER_5 = APCER;
    counter = 0;
    while abs(APCER_5 - 0.05) >= 0.001
        counter = counter + 1;
        disp(counter);
        threshold_start = threshold_start - 0.001;
        % APCER_5
        dec_attack_test = dec2(test_labels == 2);
        error_attack_classify = dec_attack_test > threshold_start;
        APCER_5 = sum(error_attack_classify(:)) / length(dec_attack_test);
    end
    dec_real_test = dec2(test_labels == 1);
    error_real_classify = dec_real_test < threshold_start;
    BPCER_20 = sum(error_real_classify(:)) / length(dec_real_test);
end
if APCER > 0.05
    APCER_5 = APCER;
    counter = 0;
    while abs(APCER_5 - 0.05) >= 0.001
        counter = counter + 1;
        disp(counter);
        threshold_start = threshold_start + 0.001;
        % APCER_5
        dec_attack_test = dec2(test_labels == 2);
        error_attack_classify = dec_attack_test > threshold_start;
        APCER_5 = sum(error_attack_classify(:)) / length(dec_attack_test);
    end
    dec_real_test = dec2(test_labels == 1);
    error_real_classify = dec_real_test < threshold_start;
    BPCER_20 = sum(error_real_classify(:)) / length(dec_real_test);
end
BaselineImageQuality_APCER_BPCER.BPCER_20 = BPCER_20;

%% Cross Baseline Image Quality
load('.\results\Cross_BaselineImageQuality.mat');
dec = Cross_BaselineImageQuality.dec;
dec1 = Cross_BaselineImageQuality.dec1;
dec2 = Cross_BaselineImageQuality.dec2;
dec3 = Cross_BaselineImageQuality.dec3;
dev_labels = Cross_BaselineImageQuality.dev_labels;
cross_train_labels = Cross_BaselineImageQuality.cross_train_labels;
cross_dev_labels = Cross_BaselineImageQuality.cross_dev_labels;
cross_test_labels = Cross_BaselineImageQuality.cross_test_labels;

%% train set
[com.epc.dev, com.epc.eva, epc_cost] = epc(dec(dev_labels == -1), dec(dev_labels == 1),...
    dec1(cross_train_labels == -1), dec1(cross_train_labels == 1), 1, [0.5 0.5]);
HTER = com.epc.eva.hter_apri(1) * 100;
Cross_BaselineImageQuality_APCER_BPCER.HTER.RGB_train = HTER;
[com.epc.dev, com.epc.eva, epc_cost] = epc(dec(dev_labels == -1, 1), dec(dev_labels == 1, 1), dec(dev_labels == -1, 1),dec(dev_labels == 1,1), 1, [0.5 0.5]);
EER = com.epc.dev.wer_apost(1) * 100;
Cross_BaselineImageQuality_APCER_BPCER.EER.RGB_train = EER;

threshold = com.epc.dev.thrd_fv;
% APCER
dec_attack_test = dec1(cross_train_labels == -1);
error_attack_classify = dec_attack_test > threshold;
APCER = sum(error_attack_classify(:)) / length(dec_attack_test);
Cross_BaselineImageQuality_APCER_BPCER.APCER.RGB_train = APCER;
% BPCER
dec_real_test = dec1(cross_train_labels == 1);
error_real_classify = dec_real_test < threshold;
BPCER = sum(error_real_classify(:)) / length(dec_real_test);
Cross_BaselineImageQuality_APCER_BPCER.BPCER.RGB_train = BPCER;
% ACER
ACER = (APCER + BPCER) / 2;
Cross_BaselineImageQuality_APCER_BPCER.ACER.RGB_train = ACER;
% BPCER20
threshold_start = threshold;
if APCER < 0.05
    APCER_5 = APCER;
    counter = 0;
    while abs(APCER_5 - 0.05) >= 0.001
        counter = counter + 1;
        disp(counter);
        threshold_start = threshold_start - 0.001;
        % APCER_5
        dec_attack_test = dec1(cross_train_labels == -1);
        error_attack_classify = dec_attack_test > threshold_start;
        APCER_5 = sum(error_attack_classify(:)) / length(dec_attack_test);
    end
    dec_real_test = dec1(cross_train_labels == 1);
    error_real_classify = dec_real_test < threshold_start;
    BPCER_20 = sum(error_real_classify(:)) / length(dec_real_test);
end
if APCER > 0.05
    APCER_5 = APCER;
    counter = 0;
    while abs(APCER_5 - 0.05) >= 0.001
        counter = counter + 1;
        disp(counter);
        threshold_start = threshold_start + 0.001;
        % APCER_5
        dec_attack_test = dec1(cross_train_labels == -1);
        error_attack_classify = dec_attack_test > threshold_start;
        APCER_5 = sum(error_attack_classify(:)) / length(dec_attack_test);
    end
    dec_real_test = dec1(cross_train_labels == 1);
    error_real_classify = dec_real_test < threshold_start;
    BPCER_20 = sum(error_real_classify(:)) / length(dec_real_test);
end
Cross_BaselineImageQuality_APCER_BPCER.BPCER_20.RGB_train = BPCER_20;

%% dev set
[com.epc.dev, com.epc.eva, epc_cost] = epc(dec(dev_labels == -1), dec(dev_labels == 1),...
    dec2(cross_dev_labels == -1), dec2(cross_dev_labels == 1), 1, [0.5 0.5]);
HTER = com.epc.eva.hter_apri(1) * 100;
Cross_BaselineImageQuality_APCER_BPCER.HTER.RGB_dev = HTER;
[com.epc.dev, com.epc.eva, epc_cost] = epc(dec(dev_labels == -1, 1), dec(dev_labels == 1, 1), dec(dev_labels == -1, 1),dec(dev_labels == 1,1), 1, [0.5 0.5]);
EER = com.epc.dev.wer_apost(1) * 100;
Cross_BaselineImageQuality_APCER_BPCER.EER.RGB_dev = EER;

threshold = com.epc.dev.thrd_fv;
% APCER
dec_attack_test = dec2(cross_dev_labels == -1);
error_attack_classify = dec_attack_test > threshold;
APCER = sum(error_attack_classify(:)) / length(dec_attack_test);
Cross_BaselineImageQuality_APCER_BPCER.APCER.RGB_dev = APCER;
% BPCER
dec_real_test = dec2(cross_dev_labels == 1);
error_real_classify = dec_real_test < threshold;
BPCER = sum(error_real_classify(:)) / length(dec_real_test);
Cross_BaselineImageQuality_APCER_BPCER.BPCER.RGB_dev = BPCER;
% ACER
ACER = (APCER + BPCER) / 2;
Cross_BaselineImageQuality_APCER_BPCER.ACER.RGB_dev = ACER;
% BPCER20
threshold_start = threshold;
if APCER < 0.05
    APCER_5 = APCER;
    counter = 0;
    while abs(APCER_5 - 0.05) >= 0.001
        counter = counter + 1;
        disp(counter);
        threshold_start = threshold_start - 0.001;
        % APCER_5
        dec_attack_test = dec2(cross_dev_labels == -1);
        error_attack_classify = dec_attack_test > threshold_start;
        APCER_5 = sum(error_attack_classify(:)) / length(dec_attack_test);
    end
    dec_real_test = dec2(cross_dev_labels == 1);
    error_real_classify = dec_real_test < threshold_start;
    BPCER_20 = sum(error_real_classify(:)) / length(dec_real_test);
end
if APCER > 0.05
    APCER_5 = APCER;
    counter = 0;
    while abs(APCER_5 - 0.05) >= 0.001
        counter = counter + 1;
        disp(counter);
        threshold_start = threshold_start + 0.001;
        % APCER_5
        dec_attack_test = dec2(cross_dev_labels == -1);
        error_attack_classify = dec_attack_test > threshold_start;
        APCER_5 = sum(error_attack_classify(:)) / length(dec_attack_test);
    end
    dec_real_test = dec2(cross_dev_labels == 1);
    error_real_classify = dec_real_test < threshold_start;
    BPCER_20 = sum(error_real_classify(:)) / length(dec_real_test);
end
Cross_BaselineImageQuality_APCER_BPCER.BPCER_20.RGB_dev = BPCER_20;

%% test set
[com.epc.dev, com.epc.eva, epc_cost] = epc(dec(dev_labels == -1), dec(dev_labels == 1),...
    dec3(cross_test_labels == -1), dec3(cross_test_labels == 1), 1, [0.5 0.5]);
HTER = com.epc.eva.hter_apri(1) * 100;
Cross_BaselineImageQuality_APCER_BPCER.HTER.RGB_test = HTER;
[com.epc.dev, com.epc.eva, epc_cost] = epc(dec(dev_labels == -1, 1), dec(dev_labels == 1, 1), dec(dev_labels == -1, 1),dec(dev_labels == 1,1), 1, [0.5 0.5]);
EER = com.epc.dev.wer_apost(1) * 100;
Cross_BaselineImageQuality_APCER_BPCER.EER.RGB_test = EER;

threshold = com.epc.dev.thrd_fv;
% APCER
dec_attack_test = dec3(cross_test_labels == -1);
error_attack_classify = dec_attack_test > threshold;
APCER = sum(error_attack_classify(:)) / length(dec_attack_test);
Cross_BaselineImageQuality_APCER_BPCER.APCER.RGB_test = APCER;
% BPCER
dec_real_test = dec3(cross_test_labels == 1);
error_real_classify = dec_real_test < threshold;
BPCER = sum(error_real_classify(:)) / length(dec_real_test);
Cross_BaselineImageQuality_APCER_BPCER.BPCER.RGB_test = BPCER;
% ACER
ACER = (APCER + BPCER) / 2;
Cross_BaselineImageQuality_APCER_BPCER.ACER.RGB_test = ACER;
% BPCER20
threshold_start = threshold;
if APCER < 0.05
    APCER_5 = APCER;
    counter = 0;
    while abs(APCER_5 - 0.05) >= 0.001
        counter = counter + 1;
        disp(counter);
        threshold_start = threshold_start - 0.001;
        % APCER_5
        dec_attack_test = dec3(cross_test_labels == -1);
        error_attack_classify = dec_attack_test > threshold_start;
        APCER_5 = sum(error_attack_classify(:)) / length(dec_attack_test);
    end
    dec_real_test = dec3(cross_test_labels == 1);
    error_real_classify = dec_real_test < threshold_start;
    BPCER_20 = sum(error_real_classify(:)) / length(dec_real_test);
end
if APCER > 0.05
    APCER_5 = APCER;
    counter = 0;
    while abs(APCER_5 - 0.05) >= 0.001
        counter = counter + 1;
        disp(counter);
        threshold_start = threshold_start + 0.001;
        % APCER_5
        dec_attack_test = dec3(cross_test_labels == -1);
        error_attack_classify = dec_attack_test > threshold_start;
        APCER_5 = sum(error_attack_classify(:)) / length(dec_attack_test);
    end
    dec_real_test = dec3(cross_test_labels == 1);
    error_real_classify = dec_real_test < threshold_start;
    BPCER_20 = sum(error_real_classify(:)) / length(dec_real_test);
end
Cross_BaselineImageQuality_APCER_BPCER.BPCER_20.RGB_test = BPCER_20;
