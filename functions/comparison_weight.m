function [data] = comparison_weight(data, comparaison)
switch comparaison
    case '='
        data([data.poids] == 18) = [];                % 18kg
        [data([data.poids] == 6).poids] = deal(1);    % 12kg
        [data([data.poids] == 12).poids] = deal(2);   % 6kg
    case '%'
        data([data.poids] == 6 & [data.sex] == 1) = [];                   % men 18kg
        [data([data.poids] == 12 & [data.sex] == 1).poids] = deal(1);     % men 12kg
        [data([data.poids] == 18 & [data.sex] == 1).poids] = deal(2);     % men 18kg
        [data([data.poids] == 6 & [data.sex] == 2).poids] = deal(1);      % women 6kg
        [data([data.poids] == 12 & [data.sex] == 2).poids] = deal(2);     % women 12kg
end