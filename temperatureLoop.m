function [] = executeStimulusLoop(stimStruct)


%Include some error checking to make sure all sizes are consistent
N = length(stimStruct.setpoint);

for ii = 1:N
    string = sprintf('Changing Setpoint to %.1f', stimStruct.setpoint(ii));
    change_temp(s, controllerParams, stimStruct.setpoint(ii), string);
    
    pause(.05)
    string = sprintf('Starting PID for %.1f seconds', stimStruct.stimDuration(ii));
    startPID(s, controllerParams, string);
    
    tic
    pause(stimStruct.stimDuration(ii));
    duration = toc;
    string = sprintf('stimulus was on for %.1f seconds\n', duration);
    disp(string);
    
    string = sprintf('Stopping PID for %.1f seconds', stimStruct.refractoryPeriod(ii));
    stopPID(s, controllerParams, string);
    tic
    pause(stimStruct.refractoryPeriod(ii))
    duration = toc;
    string = sprintf('refractory period was %.2f seconds\n', duration);
    disp(string);

    
end