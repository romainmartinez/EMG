%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  ____                       _         __  __            _   _                  %
% |  _ \ ___  _ __ ___   __ _(_)_ __   |  \/  | __ _ _ __| |_(_)_ __   ___ ____  %
% | |_) / _ \| '_ ` _ \ / _` | | '_ \  | |\/| |/ _` | '__| __| | '_ \ / _ \_  /  %
% |  _ < (_) | | | | | | (_| | | | | | | |  | | (_| | |  | |_| | | | |  __// /   %
% |_| \_\___/|_| |_| |_|\__,_|_|_| |_| |_|  |_|\__,_|_|   \__|_|_| |_|\___/___|  %
%                                                                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                            clc; clear; close all                        
%% Caractéristique de la comparaison
    % muscle
muscle_name = char('anterior deltoid','medial deltoid','posterior deltoid','biceps','triceps','upper trapezius','lower trapezius','serratus anterior','supraspinatus','infraspinatus','subscapularis','pectoralis major','latissimus dorsi');                             
% muscle_nb = input('Which muscle (1-13) : ');
% muscle = strtrim(muscle_name(muscle_nb,:));
    % Hauteur
 hauteur = 'eyes - shoulders'
    % type d'essai
essai = 'lowering';
    % type de comparaison
poids = 'relative';

%% Chargement des fonctions
    if isempty(strfind(path, '\\10.89.24.15\e\Projet_IRSST_LeverCaisse\Codes\Functions_Matlab'))
        % Librairie S2M
            loadS2MLib;
        % Fonctions perso
            addpath(genpath('\\10.89.24.15\e\Projet_Romain\Codes\Functions_Matlab'));
    end
cd('\\10.89.24.15\f\Data\Epaule_manutention\Hommes-Femmes\Data\RAW\SPM');
    
%% Subplot (création d'un subplot à partir de fichier .fig)
    SubPlot

%% Titre des subplots a faire manuellement avec edit plot
% h=get(gcf,'children');
% get(get(gcf,'children'),'type')
% h(2) = gcf
%% Ajout des lignes de phases
phaseline(1) = vline(20,'black:')
phaseline(2) = vline(80,'black:')

%% xlabel, ylabel et titre (master)
    % Titre pour l'axe des X
xtitle = 'Normalized time (%)'
[ax1,t1]=suplabel(xtitle);
    % Titre pour l'axe des Y
ytitle = 'Root-mean-square EMG Envelope (%MVC)'
[ax2,t2]=suplabel(ytitle,'y');
    % Titre pour la figure
gentitle = [poids ' weight comparison for ' essai  ' tests at ' hauteur ' height']
[ax4,t3]=suplabel(gentitle  ,'t');
    % Augmenter la taille de la police
set(t3,'FontSize',15);
    % Figure en plein écran
set(gcf,'units','normalized','outerposition',[0 0 1 1])

%% Sauvegarde de la figure  
export_fig([hauteur '_' essai '_' poids],'-nocrop','-dpng','-m3')
%