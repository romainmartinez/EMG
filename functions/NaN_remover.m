function [spm, deleted] = NaN_remover(spm,imuscle,iheight)
% replace 0 by NaN
spm.comp(spm.comp == 0) = NaN;

% find NaN index
[~, idx] = find(isnan(spm.comp(1,:)));

% deleted info
deleted = [];
deleted.muscle = imuscle;
deleted.id = idx;
deleted.total = length(idx);

% replace NaN by mean of same muscle, sex, weight & height
for iNaN = length(idx):-1:1
    same.muscle = imuscle;
    same.sex = spm.sex(idx(iNaN));
    same.height = spm.height(idx(iNaN));
    same.weight = spm.weight(idx(iNaN));
    
    same.idx = spm.sex == same.sex &...
        spm.height == same.height &...
        spm.weight == same.weight;
    
    same.data = spm.comp(:,same.idx);
    
    spm.comp(:,idx(iNaN)) = mean(same.data,2,'omitnan');
    
    clearvars same
end


