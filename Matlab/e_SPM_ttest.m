%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  ____                       _         __  __            _   _                  %
% |  _ \ ___  _ __ ___   __ _(_)_ __   |  \/  | __ _ _ __| |_(_)_ __   ___ ____  %
% | |_) / _ \| '_ ` _ \ / _` | | '_ \  | |\/| |/ _` | '__| __| | '_ \ / _ \_  /  %
% |  _ < (_) | | | | | | (_| | | | | | | |  | | (_| | |  | |_| | | | |  __// /   %
% |_| \_\___/|_| |_| |_|\__,_|_|_| |_| |_|  |_|\__,_|_|   \__|_|_| |_|\___/___|  %
%                                                                                %
% Auteur : Romain Martinez                                 Date : Juin 2016      %
% Description : Analyse SPM                                                      %
% Input : Matrice RMS corrigée ; Sujets à enlever ; essais à selectionner        %
% Output : Figures SPM                                                           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
						  clc; clear; close all
%% Chemin des dossier et caractéristiques de l'essai
   % Chemin des fonctions
addpath(genpath('\\10.89.24.15\f\Data\Epaule_manutention\Hommes-Femmes\Codes\FonctionMatlab'))
   % Chemin des fichiers
folderPath = ['Y:\Data\Epaule_manutention\Hommes-Femmes\Data\RAW\Mat\'];
   % Noms des fichiers
matfiles = dir([folderPath '*_data.mat']);
   % Noms des muscles
muscle = char('deltoid anterior','deltoid medial','deltoid posterior','biceps','triceps','upper trapezius','lower trapezius','serratus anterior','supraspinatus','infraspinatus','subscapularis','pectoralis major','latissimus dorsi');
   % Chargement des fichiers
for i = 1 : length(matfiles)
sujet(i).data = load([folderPath matfiles(i).name]);
sujet(i).name = matfiles(i).name(1:4);
    if length(sujet(i).data.data) == 54
        sujet(i).sexe = 'hommes'
    elseif length(sujet(i).data.data) == 36
        sujet(i).sexe = 'femmes'
    end 
end

%% Zone de correction pour sujets problématiques
sujet(29).data.data(3) = sujet(29).data.data(2)

%% Sujets à écarter pour le muscle étudié, selon rapport de suppressions
deltant = {'laug'};
deltmed ={''} ;
deltpost ={'vivs'};
biceps ={''};
triceps ={'marc','gatb'} ;
trapup = {''};
traplow = {''} ;
gddent = {''} ;
supra={'camb','sylg','aimq','alef','ameg','daml','danf','emmb','fabg','naus','nicl','noel','marm','adrc','amia','anns','arst','carb','chac','damg','doca','emyc','fabd','geoa','jawr','laug','matr','nemk','phil','romr','roxd','steb','vivs','yoab'}; 
infra ={'camb','gabf','aimq','alef','ameg','daml','danf','emmb','fabg','naus','nicl','noel','marm','adrc','amia','anns','arst','carb','chac','damg','doca','emyc','fabd','geoa','jawr','laug','matr','nemk','phil','romr','roxd','steb','vivs','yoab'};
subscap ={'camb','aimq','alef','ameg','daml','danf','emmb','fabg','naus','nicl','noel','marm','adrc','amia','anns','arst','carb','chac','damg','doca','emyc','fabd','geoa','jawr','laug','matr','nemk','phil','romr','roxd','steb','vivs','yoab'};
pec ={'roxd','aimq','alef','ameg','daml','danf','emmb','fabg','naus','nicl','noel','aleb','karm','camb','sylg','emid','eved','gabf','luia','marc','marh','romm','samn','verc','patm','vicj'};
gddors ={'gatb','aimq','alef','ameg','daml','danf','emmb','fabg','naus','nicl','noel','aleb','karm','sylg','emid','eved','gabf','luia','marc','marh','romm','samn','verc'};

blacklist{1,:} = deltant;
blacklist{2,:} = deltmed;
blacklist{3,:} = deltpost;
blacklist{4,:} = biceps;
blacklist{5,:} = triceps;
blacklist{6,:} = trapup;
blacklist{7,:} = traplow;
blacklist{8,:} = gddent;
blacklist{9,:} = supra;
blacklist{10,:} = infra;
blacklist{11,:} = subscap;
blacklist{12,:} = pec;
blacklist{13,:} = gddors;
clear deltant deltmed deltpost biceps triceps trapup traplow gddent supra infra subscap pec gddors

%% Création du dataframe 
    % Sélection des essais à comparer
essai_h = input('Which trial (Man) : ');
essai_f = input('Which trial (Women) : ');
    % Définition du poids et de la hauteur en fonction de l'essai
[poids_h,poids_f,hauteur] = trialdefinition(essai_h,essai_f);

    % Fermeture des figures et désactivation des warnings car inutiles
close all;
warning('off');

for m = 1 : 13
% Initialisation des variables
df_h = [];
df_f = [];    
    for s = 1 : length(sujet) % pour tous les sujets 
        % Savoir si le nom du sujet est dans la blacklist pour ce muscle
    xi = strfind(blacklist{m, 1},sujet(s).name);
    S = [xi{:}];
        if isempty(S) == 1
            if sujet(s).sexe == 'hommes'
        % Si le nom du sujet n'est pas dans la blacklist & sexe correspond
                    SPMdata_h_temp = [ sujet(s).data.data( [sujet(s).data.data.condition] == essai_h ).EMGinterp ];
                    SPMdata_h_temp = SPMdata_h_temp(:,m:13:end);
        % Création d'une matrice avec les 3 essais de chaque sujet pour le muscle étudié
                    df_h = [df_h SPMdata_h_temp];
            elseif sujet(s).sexe == 'femmes'
                    SPMdata_f_temp = [ sujet(s).data.data( [sujet(s).data.data.condition] == essai_f ).EMGinterp ];
                    SPMdata_f_temp = SPMdata_f_temp(:,m:13:end);
                    df_f = [df_f SPMdata_f_temp];
            end
        else
%            disp(sujet(s).name)
        end
    end

        % Suppression des NaN dans le dataframe
    df_h( :, all( isnan( df_h ), 1 ) ) = [];
    df_f( :, all( isnan( df_f ), 1 ) ) = [];
        %% Transposition des dataframe pour SPM
df_h = df_h';
df_f = df_f';    
        %Suppression des signaux très petits
moyh = find(mean(df_h,2) < 1);
moyf = find(mean(df_f,2) < 1);
df_f([moyf],:) = [];
df_h([moyh],:) = [];
%     %% Vérification figure df_h & df_f
% figure('units','normalized','outerposition',[0 0 1 1])
% plot(df_h') ; title(m)
% figure('units','normalized','outerposition',[0 0 1 1])
% plot(df_f') ; title(m)

%% Rapporter le nombre d'echantillons pour la comparaison
nbf(m).echantillon = size(df_f,1);
nbh(m).echantillon = size(df_h,1);
echantillon(m,:) = [nbf(m).echantillon nbh(m).echantillon];
disp(['Muscle ' num2str(m) ':' num2str(nbf(m).echantillon) ' signaux feminins vs. ' num2str(nbh(m).echantillon) ' signaux maculins'])
%% Correction de bonferroni
    % Seuil alpha
alpha = 0.05;
    % Nombre de tests : hauteurs (6) * poids (3) * sexe (2) = 36
nTests = 6*3*2;
    % p corrigé = 0.0014
p = spm1d.util.p_critical_bonf(alpha, nTests);    
%% Analyse SPM
spm = spm1d.stats.ttest2(df_f, df_h);
spmi = spm.inference(p, 'two_tailed', true);
%% Temps normalisé
x = 0:100/(length(df_f)):100;
ntime = x(1:end-1);
%% Extraction des zones significatives
[x_blue,x_red]=Zones_Grises_ttest(ntime,spmi);
%% Plot du signal EMG moyen +- SD
figure
H(1) = shadedErrorBar(ntime,mean(df_h,1),std(df_h),{'-b','Linewidth',2},1); hold on
H(2) = shadedErrorBar(ntime,mean(df_f,1),std(df_f),{'-r','Linewidth',2},1);
ylim([0 100])
title(muscle(m,:));
%% Plot des zones significatives 
zone = [];
zoneforte = [];
zoneforte_h = [];
zoneforte_f = [];
    
if length(x_blue) == length(x_red) & isempty(x_blue) ~= 1
        % Création d'une variable contenant les zones en %
    for i=1:length(x_blue)             
         zone(i,:) = [x_blue(i)/10 x_red(i)/10];
    end
        % Merge des zones avec différence de moins de 10%
    index = 2;
    while index <= size(zone,1)
        if zone(index,1) - zone(index-1,2) < 10
           zone(index-1,1) = zone(index-1,1);
           zone(index-1,2) = zone(index,2);
           zone(index,:) = [];
        else
            index = index + 1;
        end
    end
        % Suppression des zones significatives durant moins de 10%
    for i = 1 : size(zone,1)
        if zone(i,2) - zone(i,1) >= 10
            zoneforte(i,1) = zone(i,1);
            zoneforte(i,2) = zone(i,2);
        else
            zoneforte(i,:) = NaN;
        end
    end
        % Suppression des NaN
    if sum(isnan(zoneforte(:,1))) ~= 0
        [row,col] = find(isnan(zoneforte) == 1);
        zoneforte(row,:) = [];
    end
        % Distinction des zones significatives : hommes ou femmes     
    for i = 1 : size(zoneforte,1)
        if spmi.z(zoneforte(i,1)*10) < 0 & spmi.z(zoneforte(i,2)*10) < 0
            zoneforte_h(i,1) = zoneforte(i,1);
            zoneforte_h(i,2) = zoneforte(i,2);
        elseif spmi.z(zoneforte(i,1)*10) > 0 & spmi.z(zoneforte(i,1)*10) > 0
            zoneforte_f(i,1) = zoneforte(i,1);
            zoneforte_f(i,2) = zoneforte(i,2);
        end
    end
    
%% Plot des aires significatives hommes
    for i = 1 : size(zoneforte_h,1)
        aire_coloreeforte(i) = area(zoneforte_h(i,1):zoneforte_h(i,2), repmat(100,length(zoneforte_h(i,1):zoneforte_h(i,2)),1), 'facecolor', 'b', 'edgecolor', 'none','facealpha',0.3);
    end
%% Plot des aires significatives femmes
    for i = 1 : size(zoneforte_f,1)
        aire_coloreeforte(i) = area(zoneforte_f(i,1):zoneforte_f(i,2), repmat(100,length(zoneforte_f(i,1):zoneforte_f(i,2)),1), 'facecolor', 'r', 'edgecolor', 'none','facealpha',0.3);
    end
end
%% Export de la figure
title([poids_h ' vs ' poids_f ', ' hauteur]);
savefig(['Y:\Data\Epaule_manutention\Hommes-Femmes\Data\RAW\SPM\' num2str(essai_h) 'vs' num2str(essai_f) 'muscle' num2str(m)])
%% Nettoyage workspace
clear xi s SPMdata_h_temp  SPMdata_f_temp spm spmi x ntime x_blue x_red H
end
warning('on');


%% Statistiques de suppression
% for i = 1:length(data)
% 	stat(i,:) = data(i).resultats.stat;
%     first(i,:) = data(i).resultats.data(1).EMGinterp(1,:)
% end

% % Zone pour detection de Nan dans EMGcut provoquant des pb d'interpolation
% for s = 1 : length(sujet)
%     for e = 1 : length(sujet(s).data.data)
%         for c  = 1 : size(sujet(s).data.data(e).EMGcut,2)
%             if isnan(sujet(s).data.data(e).EMGcut(1,c)) == 0 & isnan(sujet(s).data.data(e).EMGcut(end,c)) == 1
%                   % Affichage des essais problématique : sujet,essai,colonne
%                 disp([sujet(s).name ' essai ' num2str(e) ' colonne ' num2str(c)])
%                 
%                   % Création d'une matrice comportant les NaN
%                 NaNmat = find(isnan(sujet(s).data.data(e).EMGcut(:,c)));
%                   % Suppression des NaN
%                 sujet(s).data.data(e).EMGcorrected(:,:) = sujet(s).data.data(e).EMGcut(1:NaNmat(1) - 1,:);
%                 sujet(s).data.data(e).EMGcut = sujet(s).data.data(e).EMGcorrected;
%                   % Interpolation avec données corrigées
%                         oldframe = (1:size(sujet(s).data.data(e).EMGcut,1))./size(sujet(s).data.data(e).EMGcut,1)*100;
%                         newframe = linspace(oldframe(1,1),100,1000);
%                         sujet(s).data.data(e).EMGinterp = interp1(oldframe,sujet(s).data.data(e).EMGcut,newframe,'spline');
%             end
%         end
%     end
% end

%% Exportation dans R
ntime = ntime';
df_h_moy = mean(df_h,1); df_h_moy = df_h_moy';
df_f_moy = mean(df_f,1); df_f_moy = df_f_moy';
df_h_std = std(df_h); df_h_std = df_h_std';
df_f_std = std(df_f); df_f_std = df_f_std';
df_h=df_h' ; df_f=df_f';

export_r = [ntime df_h_moy df_f_moy df_h_std df_f_std];

filename = ['Y:\Data\Epaule_manutention\Hommes-Femmes\Data\RAW\SPM\' num2str(essai_h) 'vs' num2str(essai_f) 'muscle' num2str(m) '.xlsx'];
   
col_header={'ntime','mean_h','mean_f','std_h','std_f'};     %Row cell array (for column labels)
zone_header = {'start','end'};

xlswrite(filename,export_r,'Feuil1','A2');     %Write data

xlswrite(filename,col_header,'Feuil1','A1');    %Write column header

if isempty(zoneforte_h) == 1
else
xlswrite(filename,zone_header,'zone_h','A1');    %Write column header    
xlswrite(filename,zoneforte_h,'zone_h','A2');     %Write column header
end

if isempty(zoneforte_f) == 1
else
xlswrite(filename,zone_header,'zone_f','A1');    %Write column header    
xlswrite(filename,zoneforte_f,'zone_f','A2');     %Write column header
end


