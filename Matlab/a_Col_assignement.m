%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  ____                       _         __  __            _   _                  %
% |  _ \ ___  _ __ ___   __ _(_)_ __   |  \/  | __ _ _ __| |_(_)_ __   ___ ____  %
% | |_) / _ \| '_ ` _ \ / _` | | '_ \  | |\/| |/ _` | '__| __| | '_ \ / _ \_  /  %
% |  _ < (_) | | | | | | (_| | | | | | | |  | | (_| | |  | |_| | | | |  __// /   % 
% |_| \_\___/|_| |_| |_|\__,_|_|_| |_| |_|  |_|\__,_|_|   \__|_|_| |_|\___/___|  %
%                                                                                %  
% Auteur : Romain Martinez                                 Date : Juin 2016      %
% Description : Assigne chaque voie du fichier c3d à une colonne de matrice      %
% Input : Fichier "*.c3d" de votre essai                                         % 
% Output : Matrice avec chaque colonne correspondant à un muscle (ou voie)       %                                      
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
						  clc; clear; close all                          
%% Chemin des dossier et caractéristiques de l'essai
    % Caractéristiques
annee = 2015;
    % Chemin des fonctions
loadS2MLib;
addpath(genpath('\\10.89.24.15\f\Data\Epaule_manutention\Hommes-Femmes\Codes\FonctionMatlab'))
    % Nom du sujet
subject = input('Enter subjet name : ','s');
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

