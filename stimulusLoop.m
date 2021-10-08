function [] = stimulusLoop(stimStruct)

controllerParams = stimStruct.controlParams;
s = stimStruct.serial;
%Include some error checking to make sure all sizes are consistent
N = length(stimStruct.setpoint);

%Make text log file with timing information
filename = [datestr(clock, 29), '_logfile.txt'];
fileID = fopen(filename, 'w');

for ii = 1:N
    string = sprintf('Changing Setpoint to %.1f', stimStruct.setpoint(ii));
    change_temp(s, controllerParams, stimStruct.setpoint(ii), string);
    
    pause(.05)
    string = sprintf('Starting PID for %.1f seconds', stimStruct.stimDuration(ii));
    currentTimeVec = clock;
    fprintf(fileID, '%s\n', [datestr(currentTimeVec, 23), ' ', datestr(currentTimeVec, 13)]);
    startPID(s, controllerParams, string);
    
    tic
    pause(stimStruct.stimDuration(ii));
    duration = toc;
    string = sprintf('Stimulus was on for %.1f seconds', duration);
    disp(string);
    
    string = sprintf('Stopping PID for %.1f seconds', stimStruct.refractoryPeriod(ii));
    currentTimeVec = clock;
    fprintf(fileID, '%s\n', [datestr(currentTimeVec, 23), ' ', datestr(currentTimeVec, 13)]);
    stopPID(s, controllerParams, string);
    tic
    pause(stimStruct.refractoryPeriod(ii))
    duration = toc;
    string = sprintf('Refractory period was %.2f seconds\n', duration);
    disp(string);
end
fclose(fileID)
