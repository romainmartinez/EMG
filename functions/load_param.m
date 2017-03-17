function [assign,MatMVCMat,forceindex] = load_param(name)

% col assignment
load(['\\10.89.24.15\e\Projet_IRSST_LeverCaisse\ElaboratedData\matrices\col_assign\' name '.mat']);
% MVC
load(['\\10.89.24.15\e\Projet_IRSST_LeverCaisse\ElaboratedData\matrices\EMG\MVC\MaxMVC_' lower(name(7:end)) '.mat']);
% force index
load(['\\10.89.24.15\e\Projet_IRSST_LeverCaisse\ElaboratedData\matrices\forceindex\' name '_forceindex.mat']);

