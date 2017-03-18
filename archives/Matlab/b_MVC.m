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
FreqEMG = 2000;
FenetreRMS = 250;
NbreMuscle = 13;
annee = 2016;
    % Nom du sujet
subject = input('Enter subject name : ','s');
    % Chargement de l'assignement des colonnes
load(['\\10.89.24.15\f\Data\Epaule_manutention\Hommes-Femmes\Data\RAW\' num2str(annee) '\' subject '\' subject '_ColAssign.mat'])
    % Chemin des fonctions
%% Chargement des fonctions
    if isempty(strfind(path, '\\10.89.24.15\e\Projet_IRSST_LeverCaisse\Codes\Functions_Matlab'))
        % Librairie S2M
            loadS2MLib;
        % Fonctions perso
            addpath(genpath('\\10.89.24.15\e\Projet_IRSST_LeverCaisse\Codes\Functions_Matlab'));
    end
    % Chemin des fichiers à analyser
folderPath = ['\\10.89.24.15\f\Data\Epaule_manutention\Hommes-Femmes\Data\RAW\' num2str(annee) '\' subject '\MVC\'];
C3dfiles = dir([folderPath '*.c3d']);

%% Ouverture des fichiers

for i = 1:length(C3dfiles)
        % Trouve le nom du fichier et l'affiche en direct
	FileName = [folderPath C3dfiles(i).name];
	fprintf('Traitement Essai %d (%s)\n', i, C3dfiles(i).name);
        % Ouverture du fichier
    btkc3d = btkReadAcquisition(FileName);
    btkanalog = btkGetAnalogs(btkc3d);  
        % EMG data
    EMGBrut = [];
    for m = 1:13
        if char(Col_assign{1,m}) == char(NaN);
            EMGBrut(:,m) = nan;
        else
            EMGBrut(:,m) = getfield(btkanalog, char(Col_assign{1,m} ) );
        end
    end
%% Traitement des fichiers MVC
        % Rebase 
    EMGrebase = [];
        for u =1:size(EMGBrut,2)
            EMGrebase(:,u) = EMGBrut(:,u)-mean(EMGBrut(:,u));
        end	
        % Filtre Passe bande Fc=15-500
    DataFiltre = bandfilter(EMGrebase,15,500,FreqEMG);
        %RMS glissante
    RMS = nan(size(DataFiltre));
        for j = FenetreRMS:size(DataFiltre,1)-FenetreRMS-1
            RMS(j,:) = rms(DataFiltre(j-FenetreRMS+1:j+FenetreRMS,:));
        end 
        % Recupère le max de tout les muscles de l'essai en cours de traitement
    Maxdesmuscles(i,:)=max(RMS);
%% Identication d'essai à supprimer
	essai(i).RMS = RMS;
	essai(i).RMS(isnan(essai(i).RMS(:,1)),:)=[];
end

%% Interface graphique de suppression des essais problématique
    index = 0;
    set(figure,'units','normalized','outerposition',[0 0 1 1]);            
    ex.but(1) = uicontrol('Units','normalized','Position',[0.89-0.2 0.5-0.35 0.05 0.05],'String','0','Style','edit');
    ex.but(2) = uicontrol('Units','normalized','Position',[0.94-0.2 0.5-0.35 0.05 0.05],'String','Next','Callback','NextMVC');
    ex.but(3) = uicontrol('Units','normalized','Position',[0.84-0.2 0.5-0.35 0.05 0.05],'String','Previous','Callback','PreviousMVC');
    ex.but(4) = uicontrol('Units','normalized','Position',[0.89-0.2 0.45-0.35 0.05 0.05],'String','Store','Callback','StoreMVC');
    
%% Trouver IMVC
	MaxTrial = NaN(length(C3dfiles),NbreMuscle);
		for i = 1:length(C3dfiles)
			tempMax = sort(essai(i).RMS,1,'descend'); % sort to find highest values in trial
			MaxTrial(i,1:NbreMuscle) = mean(tempMax(1:FreqEMG,:)); % IMVC for trial is average of the highest values over 1sec period
		end
	MatMVCMat = nanmax(MaxTrial);
    
%% Enregistrer la matrice des max
% 	save([folderPath 'MaxMVC_' subject '.mat'],'MatMVCMat');   
    
