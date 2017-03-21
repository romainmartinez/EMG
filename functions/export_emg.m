function export_emg(result,path,comparaison)

batch = {'anova', 'interaction', 'mainA', 'mainB'};
for ibatch = 1 : length(batch)
    if isempty([result(:).(batch{ibatch})]) ~= 1
        % cat structure
        export.(batch{ibatch}) = [result(:).(batch{ibatch})];
        % headers
        header.(batch{ibatch}) = fieldnames(export.(batch{ibatch}))';
        % struct2cell
        export.(batch{ibatch}) = struct2cell(export.(batch{ibatch}));
        % 2D cell to 3D cell
        export.(batch{ibatch}) = permute(export.(batch{ibatch}),[3,1,2]);
        % export matrix
        export.(batch{ibatch}) = vertcat(header.(batch{ibatch}),export.(batch{ibatch}));
        
        if     comparaison == '%'
            xlswrite([path.exportpath 'emg_relative.xlsx'], export.(batch{ibatch}), batch{ibatch});
        elseif comparaison == '='
            xlswrite([path.exportpath 'emg_absolute.xlsx'], export.(batch{ibatch}), batch{ibatch});
        end
    end
end

