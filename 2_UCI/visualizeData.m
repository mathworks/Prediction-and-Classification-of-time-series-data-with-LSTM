%% Visualize Data
%
% Copyright 2018 The MathWorks, Inc.

clear
load('HARDataset')

%% センサーデータの可視化

g = 9.80665;

f = 50;
t = (0:127) / f;

kk = 199;
trgt = dataA(kk, :);

plot(t, g * trgt.ax), hold on
plot(t, g * trgt.ay)
plot(t, g * trgt.az), hold off
xlim([min(t) max(t)])

str = [actLabels{trgt.t} '(被験者番号 : ' num2str(trgt.s) ')'];

xlabel('時間 [sec]')
ylabel('加速度 [m/s^2]')
title(str)
grid on

h = gca;
h.FontName = 'Meiryo UI';
h.FontSize = 12;
