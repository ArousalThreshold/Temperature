function [] = cleanUpPID( stimStruct, t )
%cleanUpPID
%   stimStruct
%   t: timer object
%   Cleanup function. Turn off PID, close serial object.
%   Detailed explanation goes here

controllerParams = stimStruct.controlParams;
s = stimStruct.serial;

stopPID(s, controllerParams);
disp('Session Ended')
delete(t)
fclose(s)
disp('Serial Port Closed')
end

