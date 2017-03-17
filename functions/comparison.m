function [data] = comparison(data, comparaison)
switch comparaison
    case '='
        for i = length(data):-1:1
            if data(i).poids == 18
                data(i) = [];
            elseif data(i).poids == 6
                data(i).poids = 1;
            elseif data(i).poids == 12
                data(i).poids = 2;
            end
        end
    case '%'
        for i = length(data):-1:1
            if data(i).poids == 6 && data(i).sex == 1
                data(i) = [];
            elseif data(i).poids == 12 && data(i).sex == 1
                data(i).poids = 1;
            elseif data(i).poids == 18 && data(i).sex == 1
                data(i).poids = 2;
            elseif data(i).poids == 6 && data(i).sex == 2
                data(i).poids = 1;
            elseif data(i).poids == 12 && data(i).sex == 2
                data(i).poids = 2;
            end
        end
end