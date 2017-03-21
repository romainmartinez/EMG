function [btkanalog, freq] = read_c3d(filename)
btkc3d      = btkReadAcquisition(filename);
btkanalog   = btkGetAnalogs(btkc3d);
freq.emg    = btkGetAnalogFrequency(btkc3d);
freq.camera = btkGetPointFrequency(btkc3d);

btkCloseAcquisition(btkc3d);


