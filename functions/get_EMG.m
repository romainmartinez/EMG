function [emg, assign] = get_EMG(analog,assign)
emg = [];

noms = fieldnames(analog);
taille = size(getfield(analog,noms{1}),1);
nb = size(assign,1);

for m = 13:-1:1 %nb muscles
    for iassign = 1:nb
        if char(assign{iassign,m}) == char(NaN) % si NaN -> NaN
            emg(1:taille,m) = nan;
        elseif isfield(analog, char(assign{iassign,m})) % si exist -> emg
            emg(:,m) = getfield(analog, char(assign{iassign,m}));
        end
    end
    if isempty(emg) % si exist pas -> gui
        [oldlabel, handles] = GUI_emg_c3d(fieldnames(analog),assign);
        waitfor(handles(1));
        assign = [assign;oldlabel];
        nb = nb + 1;
        if char(assign{nb,m}) == char(NaN) % si NaN -> NaN
            emg(1:taille,m) = nan;
        else % si exist -> emg
            emg(:,m) = getfield(analog, char(assign{nb,m}));
        end
    end
end
