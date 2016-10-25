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
annee = 2015;
    % Nom du sujet
subject = input('Enter subjet name : ','s');
    % Chargement de l'assignement des colonnes
load(['Y:\Data\Epaule_manutention\Hommes-Femmes\Data\RAW\' num2str(annee) '\' subject '\' subject '_ColAssign.mat'])
    % Chemin des fonctions
loadS2MLib;
    % Chemin des fonctions perso
addpath(genpath('\\10.89.24.15\Projet_Romain\Codes\Functions_Matlab'))
    % Chemin des fichiers à analyser
folderPath = ['Y:\Data\Epaule_manutention\Hommes-Femmes\Data\RAW\' num2str(annee) '\' subject '\Manip\'];
C3dfiles = dir([folderPath '*.c3d']);
    % Chargement de la matrice MVC
load(['Y:\Data\Epaule_manutention\Hommes-Femmes\Data\RAW\' num2str(annee) '\' subject '\MVC\MaxMVC_' subject '.mat']);

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
    % Matrice d'étalonnage
EtalonnageForce=[15.7377 -178.4176 172.9822 7.6998 -192.7411 174.1840;208.3629 -109.1685 -110.3583  209.3269 -104.9032 -103.5278;227.6774 222.8613 219.1087 234.3732 217.1453 221.2831;5.6472 -0.7266 -0.3242 5.4650 -8.9705 -8.4179;5.7700 6.7466 -6.9682 -4.1899 1.5741 -2.4571;-1.2722 1.6912 -3.0543 5.1092 -5.6222 3.3049];
	% Fonction permettant de trouver les onset|offset	
[~, FTA, F_onset, F_offset] = Force_thre_output(Forcerebase, EtalonnageForce);
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
savepath = ['Y:\Data\Epaule_manutention\Hommes-Femmes\Data\RAW\' num2str(annee) '\' subject '\Results\'];
	if ~exist(savepath, 'file')
		mkdir(savepath);
	end
save([savepath C3dfiles(i).name(1:end-4) '.mat'],'EMGcut','ntime','datafiltre')
%     end
end