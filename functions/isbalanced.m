function isbalanced(sexe)
femmes = sum(sexe == 2)/36;
hommes = sum(sexe == 1)/36;
if femmes ~= hommes
    disp('Number of participants is not balanced: please add names in the blacklist')
end

