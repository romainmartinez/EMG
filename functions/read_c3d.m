function [btkanalog, freq] = read_c3d(filename)
% FileName    = [path.raw C3dfiles(i).name];
btkc3d    = btkReadAcquisition(filename);
btkanalog = btkGetAnalogs(btkc3d);
freq      = btkGetAnalogFrequency(btkc3d);

btkCloseAcquisition(btkc3d);


