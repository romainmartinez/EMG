function [Col_assign,MatMVCMat,forceindex] = load_param(name)

% col assignment
load(['\\10.89.24.15\e\Projet_IRSST_LeverCaisse\ElaboratedData\matrices\EMG\col_assign\' lower(name(7:end)) '_ColAssign.mat']);
% MVC
load(['\\10.89.24.15\e\Projet_IRSST_LeverCaisse\ElaboratedData\matrices\EMG\MVC\MaxMVC_' lower(name(7:end)) '.mat']);
% force index
load(['\\10.89.24.15\e\Projet_Reconstructions\DATA\Romain\' name 'd\forceindex\' name '_forceindex']);


