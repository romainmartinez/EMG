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
%% Chargement des fonctions
    if isempty(strfind(path, '\\10.89.24.15\e\Projet_IRSST_LeverCaisse\Codes\Functions_Matlab'))
        % Librairie S2M
            loadS2MLib;
        % Fonctions perso
            addpath(genpath('\\10.89.24.15\e\Projet_IRSST_LeverCaisse\Codes\Functions_Matlab'));
    end
    % Chemin des fichiers à analyser
folderPath = ['\\10.89.24.15\f\Data\Epaule_manutention\Hommes-Femmes\Data\RAW\' num2str(annee) '\' subject '\Manip\'];
C3dfiles = dir([folderPath '*.c3d']);
    % Chargement de la matrice MVC
load(['\\10.89.24.15\f\Data\Epaule_manutention\Hommes-Femmes\Data\RAW\' num2str(annee) '\' subject '\MVC\MaxMVC_' subject '.mat']);

%% Traitement des fichiers

for i = 1 : length(C3dfiles)
    % Nom du fichier
filename = [folderPath C3dfiles(i).name];
    % Affichage de l'essai
fprintf('Traitement de %d (%s)\n', i, C3dfiles(i).name);
    % Ouverture du fichier
btkc3d = btkReadAcquisition(filename);
btkanalog = btkGetAnalogs(btkc3d); 
%% a supprimer  
% names = char(fieldnames(btkanalog));
% names = names(7,1:5);
% name = char(Col_assign{1,1} ) ;
% name = name(1,1:5);
% if names == name
    % EMG data
EMGBrut = [];
    for m = 1:13
        if char(Col_assign{1,m}) == char(NaN);
            EMGBrut(:,m) = nan;
        else
            EMGBrut(:,m) = getfield(btkanalog, char(Col_assign{1,m} ) );
        end
    end
    % Force data
ForceBrut = [];
    for m = 14:19
        if char(Col_assign{1,m}) == char(NaN);
            ForceBrut(:,m-13) = nan;
        else
            ForceBrut(:,m-13) = getfield(btkanalog, char(Col_assign{1,m} ) );
        end
    end
%% Traitement Force pour onset|offset
    % Rebase
Forcerebase = [];
    for j =1:6
        Forcerebase(:,j) = ForceBrut(:,j)-mean(ForceBrut(1:100,j));
    end
	% Fonction permettant de trouver les onset|offset avec force
[~, FTA, F_onset, F_offset] = Force_thre_output(Forcerebase);
onoff_force = [F_onset;F_offset];
%% Traitement EMG
	% Rebase
EMGrebase = [];
    for u =1:size(EMGBrut,2)
        EMGrebase(:,u) = EMGBrut(:,u)-mean(EMGBrut(:,u));
    end	
	% Filtre Passe bande Fc=15-500Hz
datafiltre = bandfilter(EMGrebase,15,500,FreqEMG);
	% RMS glissante
RMS = nan(size(datafiltre));
    for j = FenetreRMS:size(datafiltre,1)-FenetreRMS-1
        RMS(j,:) = rms(datafiltre(j-FenetreRMS+1:j+FenetreRMS,:));
    end	
    % Normalisation
    for m=1:length(RMS)
        RMSn(m,:) = (RMS(m,:)./MatMVCMat)*100;  
    end
    % Découpage de l'essai a partir du onset/offset de la force
EMGcut = RMSn(onoff_force(1):onoff_force(2),:); 
    % Vecteur temps normalisé
ntime=[];
    for t=1:length(EMGcut)
        ntime(t) = (t*100)/length(EMGcut);
    end
%% Sauvegarde
savepath = ['\\10.89.24.15\f\Data\Epaule_manutention\Hommes-Femmes\Data\RAW\' num2str(annee) '\' subject '\Results\'];
	if ~exist(savepath, 'file')
		mkdir(savepath);
	end
save([savepath C3dfiles(i).name(1:end-4) '.mat'],'EMGcut','ntime','datafiltre')
%     end
end