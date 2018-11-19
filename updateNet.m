function state = updateNet(state, net, opts, batchSize)

for p = 1 : numel(net.params)   
    thisDecay = opts.weightDecay * net.params(p).weightDecay ;
    thisLR = state.learningRate * net.params(p).learningRate ;
    state.momentum{p} = opts.momentum * state.momentum{p} ...
                        - thisDecay * net.params(p).value ...
                        - (1 / batchSize) * net.params(p).der;
    net.params(p).value = net.params(p).value + thisLR * state.momentum{p};  
end