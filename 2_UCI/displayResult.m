%% Display Confusion Map
%
% Copyright 2018 The MathWorks, Inc.

function displayResult(varargin)

group = varargin{1};
grouphat = varargin{2};

C = confusionmat(group, grouphat);
A = sum(trace(C)) / sum(C(:));

if numel(varargin) > 2
    
    labels = varargin{3};
    h = heatmap(labels, labels, C);
    
else
    
    h = heatmap(C);
    h.XLabel = 'Predicted Class';
    h.YLabel = 'True Class';

end

colorbar off

S = 'Accuracy : ' + string(A);

h.Title = S;
h.FontName = 'Meiryo UI';

disp(S)

