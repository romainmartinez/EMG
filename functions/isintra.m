function [spm] = isintra(bigstruct,spm)
blacklist = [];
blacklist.name = {'aimq' 'alef' 'ameg' 'daml' 'danf' 'emmb' 'fabg' 'naus' 'nicl' 'noel' 'marm' 'adrc' 'amia' 'anns' 'arst' 'carb' 'chac' 'damg' 'doca' 'emyc' 'fabd' 'geoa' 'jawr' 'laug' 'matr' 'nemk' 'phil' 'romr' 'roxd' 'steb' 'vivs' 'yoab'};
blacklist.participants = cellstr(unique(vertcat(bigstruct.name),'rows'));

for i = length(blacklist.name):-1:1
    idx = strcmpi(blacklist.name{i}, blacklist.participants);
    if sum(idx) ~= 0
        blacklist.idx(i) = find(idx);
    end
end

blacklist.idx(blacklist.idx == 0) = [];

sujet = logical(sum(spm.nsubject == blacklist.idx,2));

for iIntra = 9:11
    current = spm.emg(iIntra:13:end,:);
    current(sujet,:) = NaN;
    spm.emg(iIntra:13:end,:) = current;
end

% 1. trouve les index des sujets blacklister
% 2. remplacer spm.emg des intras par NaN ici pour les sujets blacklister