%% 水疱瘡の件数の予測
%
% Copyright 2018 The MathWorks, Inc.

%% 系列データの読み込み

data = chickenpox_dataset;
data = [data{:}];

time = datetime('1931/1/1'):calmonths(1):datetime('1972/6/1');

figure
plot(time, data);
ylabel("患者数")
title("月あたりの水疱瘡の患者数")

h = gca;
h.FontName = 'Meiryo UI';
h.FontSize = 14;

%% 学習データとテストデータの分割

numTimeStepsTrain = floor(0.9 * numel(data));

XTrain = data(1:numTimeStepsTrain);
YTrain = data(2:numTimeStepsTrain+1);
XTest = data(numTimeStepsTrain+1:end-1);
YTest = data(numTimeStepsTrain+2:end);

numTimeStepsTest = numel(XTest);

idxTrain = 1:numTimeStepsTrain;
idxTest = (numTimeStepsTrain+1):(numTimeStepsTrain + numTimeStepsTest);

%% データの標準化

mu = mean(XTrain);
sig = std(XTrain);

XTrain = (XTrain - mu) / sig;
YTrain = (YTrain - mu) / sig;

XTest = (XTest - mu) / sig;

%% LSTM Network の構築

inputSize = 1;
numResponses = 1;
numHiddenUnits = 200;

layers = [ ...
    sequenceInputLayer(inputSize)
    lstmLayer(numHiddenUnits)
    fullyConnectedLayer(numResponses)
    regressionLayer];

%% 学習オプションの設定

opts = trainingOptions('adam', ...
    'MaxEpochs', 250, ...
    'GradientThreshold', 1, ...
    'InitialLearnRate', 0.005, ...
    'LearnRateSchedule', 'piecewise', ...
    'LearnRateDropPeriod', 125, ...
    'LearnRateDropFactor', 0.2, ...
    'Verbose', 0, ...
    'Plots', 'training-progress');

%% LSTM Network の学習

net = trainNetwork(XTrain, YTrain, layers, opts);

%% 未来の時間領域での予測

% 過去データを入力して状態を更新
net = predictAndUpdateState(net, XTrain);

% １ステップ目の予測
[net, YPred(1)] = predictAndUpdateState(net, XTest(1));

% ２ステップ目以降の予測
for i = 2:numTimeStepsTest
    
    [net, YPred(i)] = predictAndUpdateState(net, YPred(i - 1));

end

YPred = sig * YPred + mu;

%% RMSE（平均二乗誤差平方根）の算出

rmse = sqrt(mean((YPred - YTest).^2));
disp(rmse)

%% 観測値・予測値の可視化

figure

plot(time(idxTrain), data(idxTrain))
hold on

plot(time(idxTest), YPred, '.-')
hold off
ylabel("患者数")
title("水疱瘡の患者数の予測")
legend(["観測値" "予測値"])

%% 観測値・予測値・予測誤差の可視化

figure
subplot(2, 1, 1)
plot(time(idxTest), YTest)
hold on
plot(time(idxTest), YPred, '.-')
hold off
legend(["観測値" "予測値"])
ylabel("患者数")
title("水疱瘡の患者数の予測")

h = gca;
h.FontName = 'Meiryo UI';
h.FontSize = 14;

subplot(2, 1, 2)
stem(time(idxTest), YPred - YTest)
ylabel("予測誤差")
title("RMSE = " + rmse)

h = gca;
h.FontName = 'Meiryo UI';
h.FontSize = 14;

%% 観測値によりネットワークの状態を更新

% 状態をリセット
net = resetState(net);

% 過去データを入力して、状態を更新
net = predictAndUpdateState(net, XTrain);

%% 月ごとの観測値を供給しつつ予測

YPred = [];
numTimeStepsTest = numel(XTest);

for i = 1:numTimeStepsTest
    
    [net, YPred(i)] = predictAndUpdateState(net, XTest(i));
    
end

YPred = sig * YPred + mu;

%% 予測誤差の算出

rmse = sqrt(mean((YPred - YTest).^2));
disp(rmse)

%% 観測値・予測値・予測誤差の可視化

figure
subplot(2, 1, 1)
plot(time(idxTest), YTest)
hold on
plot(time(idxTest), YPred,'.-')
hold off
legend(["観測値" "予測値"])
ylabel("患者数")
title("水疱瘡の患者数の予測（月ごとの更新）")

h = gca;
h.FontName = 'Meiryo UI';
h.FontSize = 14;

subplot(2, 1, 2)
stem(time(idxTest), YPred - YTest)
ylabel("予測誤差")
title("RMSE = " + rmse)

h = gca;
h.FontName = 'Meiryo UI';
h.FontSize = 14;
