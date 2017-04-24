function [assign,MatMVCMat,forceindex,sex] = load_param(name, path2)

% col assignment
load([path2.E '/Projet_IRSST_LeverCaisse/ElaboratedData/matrices/col_assign/' name '.mat']);
% MVC
load([path2.E '/Projet_IRSST_LeverCaisse/ElaboratedData/matrices/EMG/MVC/MaxMVC_' lower(name(7:end)) '.mat']);
% force index
load([path2.E '/Projet_IRSST_LeverCaisse/ElaboratedData/matrices/forceindex/' name '_forceindex.mat']);

    if length(forceindex) == 36
        sex = 2;
    elseif length(forceindex) == 54
        sex = 1;
    end

