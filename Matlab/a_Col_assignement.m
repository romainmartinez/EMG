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
annee = 2015;
%% Load des fonctions
    if isempty(strfind(path, '\\10.89.24.15\e\Projet_Romain\Codes\Functions_Matlab'))
        % Librairie S2M
            loadS2MLib;
        % Fonctions perso
            addpath(genpath('\\10.89.24.15\e\Projet_Romain\Codes\Functions_Matlab'));
    end
    % Nom du sujet
subject = input('Enter subject name : ','s');
    % Chemin des fichiers à analyser
folderPath = ['Y:\Data\Epaule_manutention\Hommes-Femmes\Data\RAW\' num2str(annee) '\' subject '\Manip\'];
C3dfiles = dir([folderPath '*.c3d']);

%% Ouverture des fichiers
        % Trouve le nom du fichier et l'affiche en direct
	FileName = [folderPath C3dfiles(15).name];
	fprintf('Traitement Essai %d (%s)\n', 1, C3dfiles(1).name);
        % Ouverture du fichier
    btkc3d = btkReadAcquisition(FileName);
    btkanalog = btkGetAnalogs(btkc3d);
        % Noms des voies enregistrées
   fields = fieldnames(btkanalog);
        % Boucle pour supprimer les voies vides
    for b = 1 : length(fields)
        if sum(btkanalog.(fields{b})) == 0 
            btkanalog = rmfield(btkanalog,(fields{b}));
            fields{b} = [];
        end
    end
    fields = fields(~cellfun('isempty',fields));
    
   %% Lancement de la fonction permettant l'assignement des colonnes
    GUI_OrgData

   %% Sauvegarde 
   save(['Y:\Data\Epaule_manutention\Hommes-Femmes\Data\RAW\' num2str(annee) '\' subject '\' subject '_ColAssign.mat'],'Col_assign')

