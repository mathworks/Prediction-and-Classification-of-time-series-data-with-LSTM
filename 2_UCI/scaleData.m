%% Scale Data for Neural Network
%
% Copyright 2018 The MathWorks, Inc.

clear
load('HARDataset')

%% Find min and max

data = [dataA; dataB];

ax = (data.ax)';
ay = (data.ay)';
az = (data.az)';

ax = ax(:)';
ay = ay(:)';
az = az(:)';

[~, psax] = mapminmax(ax);
[~, psay] = mapminmax(ay);
[~, psaz] = mapminmax(az);

%% Scale data (max value -> +1, min value -> -1)

NA = size(dataA, 1);

for k = 1:NA
        
    dataA(k, :).ax = mapminmax('apply', dataA(k, :).ax, psax);
    dataA(k, :).ay = mapminmax('apply', dataA(k, :).ay, psay);
    dataA(k, :).az = mapminmax('apply', dataA(k, :).az, psaz);
    
end

NB = size(dataB, 1);

for k = 1:NB
    
    dataB(k, :).ax = mapminmax('apply', dataB(k, :).ax, psax);
    dataB(k, :).ay = mapminmax('apply', dataB(k, :).ay, psay);
    dataB(k, :).az = mapminmax('apply', dataB(k, :).az, psaz);
    
end

%% Save scaled data

clearvars -except dataA dataB actLabels
save 'ScaledHARDataset'
