%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  ____                       _         __  __            _   _                  %
% |  _ \ ___  _ __ ___   __ _(_)_ __   |  \/  | __ _ _ __| |_(_)_ __   ___ ____  %
% | |_) / _ \| '_ ` _ \ / _` | | '_ \  | |\/| |/ _` | '__| __| | '_ \ / _ \_  /  %
% |  _ < (_) | | | | | | (_| | | | | | | |  | | (_| | |  | |_| | | | |  __// /   %
% |_| \_\___/|_| |_| |_|\__,_|_|_| |_| |_|  |_|\__,_|_|   \__|_|_| |_|\___/___|  %
%                                                                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                            clc; clear; close all 
%% Chemin des dossier et caractéristiques de l'essai
    % Caractéristiques
annee = 2016;
    % Nom du sujet
subject = input('Enter subjet name : ','s');
%% Load des fonctions
    if isempty(strfind(path, '\\10.89.24.15\e\Projet_Romain\Codes\Functions_Matlab'))
        % Librairie S2M
            loadS2MLib;
        % Fonctions perso
            addpath(genpath('\\10.89.24.15\e\Projet_Romain\Codes\Functions_Matlab'));
    end
    % Chemin des fichiers à analyser
folderPath = ['\\10.89.24.15\f\Data\Epaule_manutention\Hommes-Femmes\Data\RAW\' num2str(annee) '\' subject '\Results\'];

%% Loader la matrice RMS
matfiles = dir([folderPath '*.mat']);

for i = 1:length(matfiles)
    % Nom du fichier
    filename = [folderPath matfiles(i).name];
    % Affichage de l'essai
	fprintf('Traitement de l''essai %d (%s)\n', i, matfiles(i).name);
    % Ouvrir le fichier
	data(i) = load(filename);
%% determination de la condition
    for o = 1:6 % hauteur de 1 à 6
        if length(matfiles(i).name) == 14 && strcmp(matfiles(i).name(8),num2str(o)) == 1; % condition 1 à 6
            condition(i) = o;
        elseif strcmp(matfiles(i).name(7),'2')==1 && strcmp(matfiles(i).name(9),num2str(o))==1; % condition 7 à 12
            condition(i) = o+6;
        elseif strcmp(matfiles(i).name(7),'8')==1 && strcmp(matfiles(i).name(9),num2str(o))==1; % condition 13 à 18
            condition(i) = o+12;
        end
    end
end

%% Suppression des colonnes avec NaN
for i = 1 : length(data)
    nandata = find(isnan(data(i).EMGcut(1,:)) == 1);
    for d = 1 : length(nandata)
        data(i).EMGcut(:,nandata(d)) = 0;
    end
% %     suppression de muscle si problématique
%         data(i).EMGcut(:,9:11) = 0;
end

%% Interpolation
for i = 1 : length(matfiles)
    oldframe = (1:size(data(i).EMGcut,1))./size(data(i).EMGcut,1)*100;
    newframe = linspace(oldframe(1,1),100,1000);
    data(i).EMGinterp = interp1(oldframe,data(i).EMGcut,newframe,'spline');
end

%% Interface graphique de suppresion des essais
set(figure,'units','normalized','outerposition',[0 0 1 1]);
ex.ax = axes('Units','normalized','Position',[0.02 0.1 0.8 0.8],'NextPlot','replacechildren');
index = 0;
legend('1-delt ant','2-delt med','3-delt post','4-biceps','5-triceps','6-trap sup','7-trap inf','8-gd dent','9-supra','10-infra','11-subscap','12-pec','13-gd dors');
ex.but(1) = uicontrol('Units','normalized','Position',[0.89 0.5 0.05 0.05],'String','0','Style','edit');
ex.but(2) = uicontrol('Units','normalized','Position',[0.94 0.5 0.05 0.05],'String','Next','Callback','Next');
ex.but(3) = uicontrol('Units','normalized','Position',[0.84 0.5 0.05 0.05],'String','Previous','Callback','Previous');
ex.but(4) = uicontrol('Units','normalized','Position',[0.89 0.45 0.05 0.05],'String','Store','Callback','Store');

%% Statistiques de suppression des essais
for i = 1 : length(data)
	xi(i,:) = data(i).EMGcut(1,:);
	stat = sum(isnan(xi));
end

%% Ajout des conditions à la variable data
for i=1:length(matfiles)
    data(i).condition = condition(i);
end

%% Calcul des variables dépendantes
for m =1:size(data(1).EMGcut,2)
    for e=1:length(matfiles)
            % RMS moyenne
        data(e).meanRMS(:,m) = mean(data(e).EMGcut(:,m));
            % RMS max
        data(e).maxRMS(:,m) = max(data(e).EMGcut(:,m));
            % IEMG
        data(e).IEMG(:,m) = trapz(data(e).ntime,data(e).EMGcut(:,m));	
    end
end

        %Détermination des variables dépendantes pour chaque condition : moyenne des essais
for i = 1:max([condition])
	id(i,:)=find([condition]==i);
	result.meanRMS(i,:) = nanmean([data(id(i,1)).meanRMS ; data(id(i,2)).meanRMS ; data(id(i,3)).meanRMS],1);
	result.maxRMS(i,:) = nanmean([data(id(i,1)).maxRMS ; data(id(i,2)).maxRMS ; data(id(i,3)).maxRMS],1);
	result.IEMG(i,:) = nanmean([data(id(i,1)).IEMG ; data(id(i,2)).IEMG ; data(id(i,3)).IEMG],1);
end

%% Export des variables
save(['\\10.89.24.15\f\Data\Epaule_manutention\Hommes-Femmes\Data\RAW\' num2str(annee) '\' subject '\' subject '_result.mat'],'-struct','result','meanRMS','maxRMS','IEMG');
%% Export des data (EMGcut, Interp, ntime, meanRMS, maxRMS, IEMG)
save(['\\10.89.24.15\f\Data\Epaule_manutention\Hommes-Femmes\Data\RAW\' num2str(annee) '\' subject '\' subject '_data.mat'],'data','stat');
%%