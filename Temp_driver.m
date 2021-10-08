daq.getDevices;
s1 = daq.createSession('ni');
s1.addAnalogInputChannel('Dev1', 0, 'Thermocouple');
s1.Channels.ThermocoupleType = 'K';

s1.addAnalogInputChannel('Dev3', 0, 'Voltage');

% for i=1:100
%     temp = s1.inputSingleScan
% end
v = s1.startForeground;


daq.getDevices;
%s2 = daq.createSession('ni');
s1.addAnalogOutputChannel('Dev3', 0, 'Voltage');
outputData = [linspace(5, 5, 1000)'; linspace(0, 0, 1000)'];
s1.queueOutputData(outputData);
s1.startForeground();