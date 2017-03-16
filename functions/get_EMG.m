function [emg] = get_EMG(analog,col_assign)
emg = [];
        for m = 13:-1:1 %nb muscles
            if char(col_assign{1,m}) == char(NaN)
                emg(:,m) = nan;
            else
                emg(:,m) = getfield(analog, char(col_assign{1,m} ) );
            end
        end

