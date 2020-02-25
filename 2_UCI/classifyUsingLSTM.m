%% Classify Data using LSTM
%
% Copyright 2018 The MathWorks, Inc.

clear
load 'ScaledHARDataset'

%% Data conversion

NA = size(dataA, 1);
XA = cell(NA, 1);

for k = 1:NA
    
    XA{k} = [dataA{k, 'ax'}; dataA{k, 'ay'}; dataA{k, 'az'}];
    
end

TA = categorical(dataA.t);

%% Define network

layers = [ ...
    sequenceInputLayer(3)
    lstmLayer(50)
    lstmLayer(70, 'OutputMode', 'last')
    fullyConnectedLayer(6)
    softmaxLayer
    classificationLayer];

%% Define training options

options = trainingOptions('sgdm', ...
    'InitialLearnRate', 0.1, ...
    'L2Regularization', 0.0001, ...
    'LearnRateSchedule', 'piecewise', ...
    'LearnRateDropFactor', 0.1, ...
    'LearnRateDropPeriod', 100, ...
    'MaxEpochs', 200, ...
    'MiniBatchSize', 128, ...
    'Shuffle', 'every-epoch', ...
    'Plots', 'training-progress');

%% Train LSTM

[net, info] = trainNetwork(XA, TA, layers, options);

%% Data conversion

NB = size(dataB, 1);
XB = cell(NB, 1);

for k = 1:NB
    
    XB{k} = [dataB{k, 'ax'}; dataB{k, 'ay'}; dataB{k, 'az'}];
    
end

TB = categorical(dataB.t);

%% Check performance

TBHat = classify(net, XB);
displayResult(TB, TBHat, actLabels)

%% Save results

save 'classifyUsingLSTM'

