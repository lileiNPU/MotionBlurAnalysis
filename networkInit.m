function [model, eraser_params] = networkInit(active_mode, bn, hist_size)

conv_counter = 0;
map_counter = 0;
relu_counter = 0;
pool_counter = 0;
sigmoid_counter = 0;
tanh_counter = 0;
matrixtrans_counter = 0;
concat_counter = 0;
batchNorm_counter = 0;
concat_input = {};
concat_size = 0;
eraser_params = {};

model =  dagnn.DagNN();

%% 1
% 300 * 300
% conv²ã
params = {};
convBlock = dagnn.Conv('size', [3, 1, 1, 64], 'hasBias', true);
convBlock.pad = [1 1 0 0];
convBlock.stride = 1;
conv_counter = conv_counter + 1;
model.addLayer(['conv_',num2str(conv_counter)], convBlock, {'input'}, {['map_', num2str(map_counter + 1)]}, ...
    {['map_filters', num2str(conv_counter)], ['map_biases', num2str(conv_counter)]});
p = model.getParamIndex(model.layers(end).params) ;
params = model.layers(end).block.initParams();
[model.params(p).value] = deal(params{:});
map_counter = map_counter + 1;

if bn == 1
    % batchNorm Layer
    ndim = size(params{1}, 4);
    batchNorm_counter = batchNorm_counter + 1;
    batchnormBlock = dagnn.BatchNorm();
    batchnormBlock.numChannels = ndim;
    params = initParams(batchnormBlock);
    model.addLayer(['batchNorm_',num2str(batchNorm_counter)], batchnormBlock, {['map_', num2str(map_counter)]}, {['map_', num2str(map_counter + 1)]}, ...
        {['norm_weights', num2str(batchNorm_counter)], ['norm_biases', num2str(batchNorm_counter)], ['trainMethod', num2str(batchNorm_counter)]});
    p = model.getParamIndex(model.layers(end).params) ;
    [model.params(p).value] = deal(params{:});
    map_counter = map_counter + 1;
end

%% 2
if strcmp(active_mode, 'relu')
    % Relu²ã
    relu_counter = relu_counter + 1;
    reluBlock = dagnn.ReLU();
    model.addLayer(['relu_',num2str(relu_counter)], reluBlock, {['map_', num2str(map_counter)]}, {['map_', num2str(map_counter + 1)]});
    map_counter = map_counter + 1;
end
if strcmp(active_mode, 'sigmoid')
    % Sigmoid²ã
    sigmoid_counter = sigmoid_counter + 1;
    sigmoidBlock = dagnn.Sigmoid();
    model.addLayer(['sigmoid_',num2str(sigmoid_counter)], sigmoidBlock, {['map_', num2str(map_counter)]}, {['map_', num2str(map_counter + 1)]});
    map_counter = map_counter + 1;
end
if strcmp(active_mode, 'tanh')
    % Tanh²ã
    tanh_counter = tanh_counter + 1;
    tanhBlock = dagnn.Tanh();
    model.addLayer(['tanh_',num2str(tanh_counter)], tanhBlock, {['map_', num2str(map_counter)]}, {['map_', num2str(map_counter + 1)]});
    map_counter = map_counter + 1;
end


%% 3
% pooling²ã  
pool_counter = pool_counter + 1;
poolBlock = dagnn.Pooling();
poolBlock.method = 'avg';
poolBlock.poolSize = [2 1];
poolBlock.pad = 0;
poolBlock.stride = [2 1];
model.addLayer(['pool_',num2str(pool_counter)], poolBlock, {['map_', num2str(map_counter)]}, {['map_', num2str(map_counter + 1)]});
map_counter = map_counter + 1;


%% 4
% 300 * 300
% conv²ã
params = {};
convBlock = dagnn.Conv('size', [3, 1, 64, 64], 'hasBias', true);
convBlock.pad = [1 1 0 0];
convBlock.stride = 1;
conv_counter = conv_counter + 1;
model.addLayer(['conv_',num2str(conv_counter)], convBlock, {['map_', num2str(map_counter)]}, {['map_', num2str(map_counter + 1)]}, ...
    {['map_filters', num2str(conv_counter)], ['map_biases', num2str(conv_counter)]});
p = model.getParamIndex(model.layers(end).params) ;
params = model.layers(end).block.initParams();
[model.params(p).value] = deal(params{:});
map_counter = map_counter + 1;
if isempty(eraser_params)
    eraser_params{1} = ['map_filters', num2str(conv_counter)];
    eraser_params{end + 1} = ['map_biases', num2str(conv_counter)];
end


if bn == 1
    % batchNorm Layer
    ndim = size(params{1}, 4);
    batchNorm_counter = batchNorm_counter + 1;
    batchnormBlock = dagnn.BatchNorm();
    batchnormBlock.numChannels = ndim;
    params = initParams(batchnormBlock);
    model.addLayer(['batchNorm_',num2str(batchNorm_counter)], batchnormBlock, {['map_', num2str(map_counter)]}, {['map_', num2str(map_counter + 1)]}, ...
        {['norm_weights', num2str(batchNorm_counter)], ['norm_biases', num2str(batchNorm_counter)], ['trainMethod', num2str(batchNorm_counter)]});
    p = model.getParamIndex(model.layers(end).params) ;
    [model.params(p).value] = deal(params{:});
    map_counter = map_counter + 1;
end

%% 5
if strcmp(active_mode, 'relu')
    % Relu²ã
    relu_counter = relu_counter + 1;
    reluBlock = dagnn.ReLU();
    model.addLayer(['relu_',num2str(relu_counter)], reluBlock, {['map_', num2str(map_counter)]}, {['map_', num2str(map_counter + 1)]});
    map_counter = map_counter + 1;
end
if strcmp(active_mode, 'sigmoid')
    % Sigmoid²ã
    sigmoid_counter = sigmoid_counter + 1;
    sigmoidBlock = dagnn.Sigmoid();
    model.addLayer(['sigmoid_',num2str(sigmoid_counter)], sigmoidBlock, {['map_', num2str(map_counter)]}, {['map_', num2str(map_counter + 1)]});
    map_counter = map_counter + 1;
end
if strcmp(active_mode, 'tanh')
    % Tanh²ã
    tanh_counter = tanh_counter + 1;
    tanhBlock = dagnn.Tanh();
    model.addLayer(['tanh_',num2str(tanh_counter)], tanhBlock, {['map_', num2str(map_counter)]}, {['map_', num2str(map_counter + 1)]});
    map_counter = map_counter + 1;
end

%% 6
% pooling²ã  
pool_counter = pool_counter + 1;
poolBlock = dagnn.Pooling();
poolBlock.method = 'avg';
poolBlock.poolSize = [2 1];
poolBlock.pad = 0;
poolBlock.stride = [2 1];
model.addLayer(['pool_',num2str(pool_counter)], poolBlock, {['map_', num2str(map_counter)]}, {['map_', num2str(map_counter + 1)]});
map_counter = map_counter + 1;


%% 7
% 300 * 300
% conv²ã
params = {};
convBlock = dagnn.Conv('size', [3, 1, 64, 64], 'hasBias', true);
convBlock.pad = [1 1 0 0];
convBlock.stride = 1;
conv_counter = conv_counter + 1;
model.addLayer(['conv_',num2str(conv_counter)], convBlock, {['map_', num2str(map_counter)]}, {['map_', num2str(map_counter + 1)]}, ...
    {['map_filters', num2str(conv_counter)], ['map_biases', num2str(conv_counter)]});
p = model.getParamIndex(model.layers(end).params) ;
params = model.layers(end).block.initParams();
[model.params(p).value] = deal(params{:});
map_counter = map_counter + 1;
eraser_params{end + 1} = ['map_filters', num2str(conv_counter)];
eraser_params{end + 1} = ['map_biases', num2str(conv_counter)];


if bn == 1
    % batchNorm Layer
    ndim = size(params{1}, 4);
    batchNorm_counter = batchNorm_counter + 1;
    batchnormBlock = dagnn.BatchNorm();
    batchnormBlock.numChannels = ndim;
    params = initParams(batchnormBlock);
    model.addLayer(['batchNorm_',num2str(batchNorm_counter)], batchnormBlock, {['map_', num2str(map_counter)]}, {['map_', num2str(map_counter + 1)]}, ...
        {['norm_weights', num2str(batchNorm_counter)], ['norm_biases', num2str(batchNorm_counter)], ['trainMethod', num2str(batchNorm_counter)]});
    p = model.getParamIndex(model.layers(end).params) ;
    [model.params(p).value] = deal(params{:});
    map_counter = map_counter + 1;
end

%% 8
if strcmp(active_mode, 'relu')
    % Relu²ã
    relu_counter = relu_counter + 1;
    reluBlock = dagnn.ReLU();
    model.addLayer(['relu_',num2str(relu_counter)], reluBlock, {['map_', num2str(map_counter)]}, {['map_', num2str(map_counter + 1)]});
    map_counter = map_counter + 1;
end
if strcmp(active_mode, 'sigmoid')
    % Sigmoid²ã
    sigmoid_counter = sigmoid_counter + 1;
    sigmoidBlock = dagnn.Sigmoid();
    model.addLayer(['sigmoid_',num2str(sigmoid_counter)], sigmoidBlock, {['map_', num2str(map_counter)]}, {['map_', num2str(map_counter + 1)]});
    map_counter = map_counter + 1;
end
if strcmp(active_mode, 'tanh')
    % Tanh²ã
    tanh_counter = tanh_counter + 1;
    tanhBlock = dagnn.Tanh();
    model.addLayer(['tanh_',num2str(tanh_counter)], tanhBlock, {['map_', num2str(map_counter)]}, {['map_', num2str(map_counter + 1)]});
    map_counter = map_counter + 1;
end

%% 9
% pooling²ã  
pool_counter = pool_counter + 1;
poolBlock = dagnn.Pooling();
poolBlock.method = 'avg';
poolBlock.poolSize = [2 1];
poolBlock.pad = 0;
poolBlock.stride = [2 1];
model.addLayer(['pool_',num2str(pool_counter)], poolBlock, {['map_', num2str(map_counter)]}, {['map_', num2str(map_counter + 1)]});
map_counter = map_counter + 1;


%% 10
% 300 * 300
% conv²ã
params = {};
convBlock = dagnn.Conv('size', [3, 1, 64, 64], 'hasBias', true);
convBlock.pad = [1 1 0 0];
convBlock.stride = 1;
conv_counter = conv_counter + 1;
model.addLayer(['conv_',num2str(conv_counter)], convBlock, {['map_', num2str(map_counter)]}, {['map_', num2str(map_counter + 1)]}, ...
    {['map_filters', num2str(conv_counter)], ['map_biases', num2str(conv_counter)]});
p = model.getParamIndex(model.layers(end).params) ;
params = model.layers(end).block.initParams();
[model.params(p).value] = deal(params{:});
map_counter = map_counter + 1;
eraser_params{end + 1} = ['map_filters', num2str(conv_counter)];
eraser_params{end + 1} = ['map_biases', num2str(conv_counter)];

if bn == 1
    % batchNorm Layer
    ndim = size(params{1}, 4);
    batchNorm_counter = batchNorm_counter + 1;
    batchnormBlock = dagnn.BatchNorm();
    batchnormBlock.numChannels = ndim;
    params = initParams(batchnormBlock);
    model.addLayer(['batchNorm_',num2str(batchNorm_counter)], batchnormBlock, {['map_', num2str(map_counter)]}, {['map_', num2str(map_counter + 1)]}, ...
        {['norm_weights', num2str(batchNorm_counter)], ['norm_biases', num2str(batchNorm_counter)], ['trainMethod', num2str(batchNorm_counter)]});
    p = model.getParamIndex(model.layers(end).params) ;
    [model.params(p).value] = deal(params{:});
    map_counter = map_counter + 1;
end

%% 11
if strcmp(active_mode, 'relu')
    % Relu²ã
    relu_counter = relu_counter + 1;
    reluBlock = dagnn.ReLU();
    model.addLayer(['relu_',num2str(relu_counter)], reluBlock, {['map_', num2str(map_counter)]}, {['map_', num2str(map_counter + 1)]});
    map_counter = map_counter + 1;
end
if strcmp(active_mode, 'sigmoid')
    % Sigmoid²ã
    sigmoid_counter = sigmoid_counter + 1;
    sigmoidBlock = dagnn.Sigmoid();
    model.addLayer(['sigmoid_',num2str(sigmoid_counter)], sigmoidBlock, {['map_', num2str(map_counter)]}, {['map_', num2str(map_counter + 1)]});
    map_counter = map_counter + 1;
end
if strcmp(active_mode, 'tanh')
    % Tanh²ã
    tanh_counter = tanh_counter + 1;
    tanhBlock = dagnn.Tanh();
    model.addLayer(['tanh_',num2str(tanh_counter)], tanhBlock, {['map_', num2str(map_counter)]}, {['map_', num2str(map_counter + 1)]});
    map_counter = map_counter + 1;
end

%% 12
% pooling²ã  
pool_counter = pool_counter + 1;
poolBlock = dagnn.Pooling();
poolBlock.method = 'avg';
poolBlock.poolSize = [2 1];
poolBlock.pad = 0;
poolBlock.stride = [2 1];
model.addLayer(['pool_',num2str(pool_counter)], poolBlock, {['map_', num2str(map_counter)]}, {['map_', num2str(map_counter + 1)]});
map_counter = map_counter + 1;


%% 13
% 300 * 300
% conv²ã
params = {};
convBlock = dagnn.Conv('size', [3, 1, 64, 64], 'hasBias', true);
convBlock.pad = [1 1 0 0];
convBlock.stride = 1;
conv_counter = conv_counter + 1;
model.addLayer(['conv_',num2str(conv_counter)], convBlock, {['map_', num2str(map_counter)]}, {['map_', num2str(map_counter + 1)]}, ...
    {['map_filters', num2str(conv_counter)], ['map_biases', num2str(conv_counter)]});
p = model.getParamIndex(model.layers(end).params) ;
params = model.layers(end).block.initParams();
[model.params(p).value] = deal(params{:});
map_counter = map_counter + 1;
eraser_params{end + 1} = ['map_filters', num2str(conv_counter)];
eraser_params{end + 1} = ['map_biases', num2str(conv_counter)];

if bn == 1
    % batchNorm Layer
    ndim = size(params{1}, 4);
    batchNorm_counter = batchNorm_counter + 1;
    batchnormBlock = dagnn.BatchNorm();
    batchnormBlock.numChannels = ndim;
    params = initParams(batchnormBlock);
    model.addLayer(['batchNorm_',num2str(batchNorm_counter)], batchnormBlock, {['map_', num2str(map_counter)]}, {['map_', num2str(map_counter + 1)]}, ...
        {['norm_weights', num2str(batchNorm_counter)], ['norm_biases', num2str(batchNorm_counter)], ['trainMethod', num2str(batchNorm_counter)]});
    p = model.getParamIndex(model.layers(end).params) ;
    [model.params(p).value] = deal(params{:});
    map_counter = map_counter + 1;
end

%% 14
if strcmp(active_mode, 'relu')
    % Relu²ã
    relu_counter = relu_counter + 1;
    reluBlock = dagnn.ReLU();
    model.addLayer(['relu_',num2str(relu_counter)], reluBlock, {['map_', num2str(map_counter)]}, {['map_', num2str(map_counter + 1)]});
    map_counter = map_counter + 1;
end
if strcmp(active_mode, 'sigmoid')
    % Sigmoid²ã
    sigmoid_counter = sigmoid_counter + 1;
    sigmoidBlock = dagnn.Sigmoid();
    model.addLayer(['sigmoid_',num2str(sigmoid_counter)], sigmoidBlock, {['map_', num2str(map_counter)]}, {['map_', num2str(map_counter + 1)]});
    map_counter = map_counter + 1;
end
if strcmp(active_mode, 'tanh')
    % Tanh²ã
    tanh_counter = tanh_counter + 1;
    tanhBlock = dagnn.Tanh();
    model.addLayer(['tanh_',num2str(tanh_counter)], tanhBlock, {['map_', num2str(map_counter)]}, {['map_', num2str(map_counter + 1)]});
    map_counter = map_counter + 1;
end

%% 15
% pooling²ã  
pool_counter = pool_counter + 1;
poolBlock = dagnn.Pooling();
poolBlock.method = 'avg';
poolBlock.poolSize = [2 1];
poolBlock.pad = 0;
poolBlock.stride = [2 1];
model.addLayer(['pool_',num2str(pool_counter)], poolBlock, {['map_', num2str(map_counter)]}, {['map_', num2str(map_counter + 1)]});
map_counter = map_counter + 1;


%% 16
% 300 * 300
% conv²ã
params = {};
convBlock = dagnn.Conv('size', [2, 1, 64, 64], 'hasBias', true);
convBlock.pad = [0 0 0 0];
convBlock.stride = 1;
conv_counter = conv_counter + 1;
model.addLayer(['conv_',num2str(conv_counter)], convBlock, {['map_', num2str(map_counter)]}, {['map_', num2str(map_counter + 1)]}, ...
    {['map_filters', num2str(conv_counter)], ['map_biases', num2str(conv_counter)]});
p = model.getParamIndex(model.layers(end).params) ;
params = model.layers(end).block.initParams();
[model.params(p).value] = deal(params{:});
map_counter = map_counter + 1;
eraser_params{end + 1} = ['map_filters', num2str(conv_counter)];
eraser_params{end + 1} = ['map_biases', num2str(conv_counter)];

if bn == 1
    % batchNorm Layer
    ndim = size(params{1}, 4);
    batchNorm_counter = batchNorm_counter + 1;
    batchnormBlock = dagnn.BatchNorm();
    batchnormBlock.numChannels = ndim;
    params = initParams(batchnormBlock);
    model.addLayer(['batchNorm_',num2str(batchNorm_counter)], batchnormBlock, {['map_', num2str(map_counter)]}, {['map_', num2str(map_counter + 1)]}, ...
        {['norm_weights', num2str(batchNorm_counter)], ['norm_biases', num2str(batchNorm_counter)], ['trainMethod', num2str(batchNorm_counter)]});
    p = model.getParamIndex(model.layers(end).params) ;
    [model.params(p).value] = deal(params{:});
    map_counter = map_counter + 1;
end

%% 17
if strcmp(active_mode, 'relu')
    % Relu²ã
    relu_counter = relu_counter + 1;
    reluBlock = dagnn.ReLU();
    model.addLayer(['relu_',num2str(relu_counter)], reluBlock, {['map_', num2str(map_counter)]}, {['map_', num2str(map_counter + 1)]});
    map_counter = map_counter + 1;
end
if strcmp(active_mode, 'sigmoid')
    % Sigmoid²ã
    sigmoid_counter = sigmoid_counter + 1;
    sigmoidBlock = dagnn.Sigmoid();
    model.addLayer(['sigmoid_',num2str(sigmoid_counter)], sigmoidBlock, {['map_', num2str(map_counter)]}, {['map_', num2str(map_counter + 1)]});
    map_counter = map_counter + 1;
end
if strcmp(active_mode, 'tanh')
    % Tanh²ã
    tanh_counter = tanh_counter + 1;
    tanhBlock = dagnn.Tanh();
    model.addLayer(['tanh_',num2str(tanh_counter)], tanhBlock, {['map_', num2str(map_counter)]}, {['map_', num2str(map_counter + 1)]});
    map_counter = map_counter + 1;
end

%% 18
% 300 * 300
% conv²ã
params = {};
convBlock = dagnn.Conv('size', [1, 1, 64, 1], 'hasBias', true);
convBlock.pad = [0 0 0 0];
convBlock.stride = 1;
conv_counter = conv_counter + 1;
model.addLayer(['conv_',num2str(conv_counter)], convBlock, {['map_', num2str(map_counter)]}, {['map_', num2str(map_counter + 1)]}, ...
    {['map_filters', num2str(conv_counter)], ['map_biases', num2str(conv_counter)]});
p = model.getParamIndex(model.layers(end).params) ;
params = model.layers(end).block.initParams();
[model.params(p).value] = deal(params{:});
map_counter = map_counter + 1;
eraser_params{end + 1} = ['map_filters', num2str(conv_counter)];
eraser_params{end + 1} = ['map_biases', num2str(conv_counter)];

%% 19
matrixtransBlock = dagnn.MatrixTrans();
matrixtrans_counter = matrixtrans_counter + 1;
model.addLayer(['matrixtrans_',num2str(matrixtrans_counter)], matrixtransBlock, {['map_', num2str(map_counter)]}, {['map_', num2str(map_counter + 1)]});
map_counter = map_counter + 1;

% % dropout²ã
% dropout_counter = dropout_counter + 1;
% dropoutBlock = dagnn.DropOut();
% model.addLayer(['dropout_',num2str(dropout_counter)], dropoutBlock, {['map_', num2str(map_counter)]}, {['map_', num2str(map_counter + 1)]});
% map_counter = map_counter + 1;

%% 20
% conv²ã
params = {};
convBlock = dagnn.Conv('size', [1, 1, hist_size, 2], 'hasBias', true);
convBlock.pad = 0;
convBlock.stride = 1;
conv_counter = conv_counter + 1;
model.addLayer(['conv_',num2str(conv_counter)], convBlock, {['map_', num2str(map_counter)]}, {['map_', num2str(map_counter + 1)]}, ...
    {['map_filters', num2str(conv_counter)], ['map_biases', num2str(conv_counter)]});
p = model.getParamIndex(model.layers(end).params) ;
params = model.layers(end).block.initParams();
[model.params(p).value] = deal(params{:});
map_counter = map_counter + 1;

% softmax²ã
softmaxlossBlock = dagnn.Loss('loss', 'softmaxlog') ;
model.addLayer('softmaxloss', softmaxlossBlock, {['map_', num2str(map_counter)], 'label'}, {'objective'});
