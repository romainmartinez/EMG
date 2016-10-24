%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  ____                       _         __  __            _   _                  %
% |  _ \ ___  _ __ ___   __ _(_)_ __   |  \/  | __ _ _ __| |_(_)_ __   ___ ____  %
% | |_) / _ \| '_ ` _ \ / _` | | '_ \  | |\/| |/ _` | '__| __| | '_ \ / _ \_  /  %
% |  _ < (_) | | | | | | (_| | | | | | | |  | | (_| | |  | |_| | | | |  __// /   % 
% |_| \_\___/|_| |_| |_|\__,_|_|_| |_| |_|  |_|\__,_|_|   \__|_|_| |_|\___/___|  %
%                                                                                %  
% Auteur : Romain Martinez                                 Date : Juin 2016      %
% Description : Obtenir les différents % de différence                           %
% Input : Matrice SPM                                                            % 
% Output : % de différences                                                      %                                      
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
						  clc; clear; close all
                          

p = get(gca, 'children')

zone = get(p(1), 'xdata');

femme = get(p(2), 'ydata');

homme = get(p(3), 'ydata');

moyfemme = mean(femme(1,zone(1)*10:zone(end)*10))

moyhomme = mean(homme(1,zone(1)*10:zone(end)*10))

diff = moyfemme - moyhomme

%%
h = get(gca, 'children')

lines = findobj(h, 'Type', 'line');
nlines = length(lines);
points = cell(nlines,2);

for i = 1:nlines
    points{i,1} = get(lines(i),'XData'); points{i,1} = points{i,1}'
    points{i,2} = get(lines(i),'YData'); points{i,2} = points{i,2}'
end
