function [oldlabel, handles] = GUI_emg_c3d(analog,col_assign)

channel   = {'anterior deltoid',...
    'medial deltoid',...
    'posterior deltoid',...
    'biceps',...
    'triceps',...
    'upper trapezius',...
    'lower trapezius',...
    'serratus anterior',...
    'supraspinatus',...
    'infraspinatus',...
    'subscapularis',...
    'pectoralis major',...
    'latissimus dorsi'};

analog{length(analog)+1,1} = 'x';
%% GUI
index    = 1;
oldlabel = [];

% Figure
handles(1) = figure('units','pixels',...
    'position',[200 200 800 500],...
    'menubar','none',...
    'numbertitle','off',...
    'resize','off');
% List 1
handles(2) = uicontrol('style','list',...
    'unit','pix',...
    'position',[10 70 300 400],...
    'min',0,'max',1,...
    'fontsize',14,...
    'string',analog);
% Bouton
handles(3) = uicontrol('style','push',...
    'units','pix',...
    'position',[330 430 180 40],...
    'fontsize',14,...
    'string',channel{index});
% List 2
handles(4) = uicontrol('style','list',...
    'unit','pix',...
    'position',[330 130 200 200],...
    'min',0,'max',1,...
    'fontsize',14);
% bouton NaN
handles(5) = uicontrol('style','push',...
    'units','pix',...
    'position',[330 360 180 40],...
    'fontsize',14,...
    'string','NaN');

set(handles(3),'Callback',@next_callback);
set(handles(5),'Callback',@nan_callback);

allParam = guidata(handles(1));

allParam.index    = index;
allParam.handles  = handles;
allParam.field    = analog;
allParam.oldlabel = oldlabel;
allParam.channel  = channel;

guidata(handles(1),allParam);
end


function next_callback(hObject,eventdata)

allParam = guidata(hObject);

% Get the current value
L  = get(allParam.handles(2),{'string','value'});

% Write the current value
allParam.oldlabel{1,allParam.index} = L{1}(L{2}(:));

% Hide current name for the next itiration
current = find(strcmp(allParam.field, L{1}(L{2}(:))));
allParam.field(current) = [];

% Next channel
allParam.index = allParam.index+1;

guidata(hObject,allParam);

    if allParam.index > 13
        assignin('caller', 'oldlabel', allParam.oldlabel)
        close gcf
    else
        % Set the next fieldname to list 1
        set(allParam.handles(2),'string',allParam.field);

        % Set the next channel to button
        set(allParam.handles(3),'string',allParam.channel{allParam.index});

        % Set the next channel to list 2
        initial_name=cellstr(get(allParam.handles(4),'String'));
        set(allParam.handles(4),'string',[initial_name;allParam.oldlabel{1,allParam.index-1}] );
    end
end

function nan_callback(hObject,eventdata)
allParam = guidata(hObject);

% Get the current value
L  = get(allParam.handles(2),{'string','value'});

% Write the current value
allParam.oldlabel{1,allParam.index} = NaN;

% Hide current name for the next itiration
current = find(strcmp(allParam.field, L{1}(L{2}(:))));
allParam.field(current) = [];

% Next channel
allParam.index = allParam.index+1;

guidata(hObject,allParam);

    if allParam.index > 13
        assignin('caller', 'oldlabel', allParam.oldlabel)
        close gcf
    else

        % Set the next channel to button
        set(allParam.handles(3),'string',allParam.channel{allParam.index});

        % Set the next channel to list 2
        initial_name=cellstr(get(allParam.handles(4),'String'));
        set(allParam.handles(4),'string',[initial_name;allParam.oldlabel{1,allParam.index-1}] );
    end
end
