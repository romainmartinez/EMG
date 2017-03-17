function [emg, col_assign] = get_EMG(analog,col_assign)
emg = [];

noms = fieldnames(analog);
taille = size(getfield(analog,noms{1}),1);

for m = 13:-1:1 %nb muscles
    if char(col_assign{1,m}) == char(NaN)
        emg(1:taille,m) = nan;
    elseif isfield(analog, char(col_assign{1,m}))
        emg(:,m) = getfield(analog, char(col_assign{1,m}));
    else
        [oldlabel, handles] = GUI_emg_c3d(fieldnames(analog),col_assign);
        waitfor(handles(1));
        col_assign = oldlabel;
        if char(col_assign{1,m}) == char(NaN)
            emg(1:taille,m) = nan;
        else
            emg(:,m) = getfield(analog, char(col_assign{1,m}));
        end
    end
end
