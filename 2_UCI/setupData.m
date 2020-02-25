%% Setup Data
%
% Copyright 2018 The MathWorks, Inc.

% The original dataset is available from the following address:
% <http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones>
% 
% The dataset is available courtesy of:
% 
% Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra
% and Jorge L. Reyes-Ortiz. A Public Domain Dataset for Human Activity
% Recognition Using Smartphones. 21th European Symposium on Artificial
% Neural Networks, Computational Intelligence and Machine Learning,
% ESANN 2013. Bruges, Belgium 24-26 April 2013. 

if ~exist('dataset.zip', 'file')
    
    websave('dataset.zip', 'http://archive.ics.uci.edu/ml/machine-learning-databases/00240/UCI HAR Dataset.zip')
    unzip('dataset.zip')
end

%% Read labels

dname = fullfile(pwd, 'UCI HAR Dataset', 'train');

t = dlmread(fullfile(dname, 'y_train.txt'));
s = dlmread(fullfile(dname, 'subject_train.txt'));

%% Read sensor data

dname = fullfile(dname, 'Inertial Signals');

ax = dlmread(fullfile(dname, 'total_acc_x_train.txt'));
ay = dlmread(fullfile(dname, 'total_acc_y_train.txt'));
az = dlmread(fullfile(dname, 'total_acc_z_train.txt'));

dataA = table(ax, ay, az, s, t);

%% Read labels

dname = fullfile(pwd, 'UCI HAR Dataset', 'test');

t = dlmread(fullfile(dname, 'y_test.txt'));
s = dlmread(fullfile(dname, 'subject_test.txt'));

%% Read sensor data

dname = fullfile(dname, 'Inertial Signals');

ax = dlmread(fullfile(dname, 'total_acc_x_test.txt'));
ay = dlmread(fullfile(dname, 'total_acc_y_test.txt'));
az = dlmread(fullfile(dname, 'total_acc_z_test.txt'));

dataB = table(ax, ay, az, s, t);

%% Set string for each labels

actLabels = {'ï‡çs', 'äKíi-è„ÇË', 'äKíi-â∫ÇË', 'íÖê»', 'íºóß', 'êQÇÈ'};
% actLabels = {'WALKING', 'WALKING_UPSTAIRS', ...
%     'WALKING_DOWNSTAIRS', 'SITTING', 'STANDING', 'LAYING'};

%% Save data

clearvars -except dataA dataB actLabels
save 'HARdataset'
