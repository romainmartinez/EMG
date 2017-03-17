function [Data_start,Data_end,Data_time] = force_index(trialname,forceindex)
%% Phase du mouvement
cellfind      = @(string)(@(cell_contents)(strcmp(string,cell_contents)));
logical_cells = cellfun(cellfind(trialname),forceindex);
[row,~]       = find(logical_cells == 1);
Data_start = forceindex{row,1};
Data_end   = forceindex{row,2};
Data_time  = forceindex{row,4};

