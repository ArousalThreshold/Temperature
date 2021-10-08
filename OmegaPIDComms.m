%instrhwinfo('serial')
%instrfind

%% Make serial object and open connection
s=serial('com4');%this needs to be the port which shows Silicon Labs bridge in Windows device manager
set(s, 'stopbit', 1, 'databits', 8, 'parity', 'none', 'baudrate', 9600)%make identical to those on the controller
fopen(s);

%% PID controller parameters
%MODBUS over serial implementation
controllerParams.address = '01'; %device address
controllerParams.setpointRegister = ['10'; '01']; %address of the register that holds the setpoint value
controllerParams.processValueRegister = ['10'; '00']; %read current temp. not used for now.
controllerParams.unitDisplaySelectionRegister = ['08'; '11']; %change units from F to C
controllerParams.runStopRegister = ['08'; '14']; %start/stop register

%% Stimulation Profile
experimentStartTime = [2017 3 27  10 47 00];

stimStruct.setpoint = [25 35 45 33 20]; %desired temp
stimStruct.stimDuration = [60 50 30 20 30]; %temp on time
stimStruct.refractoryPeriod = [120 180 180 60 60]; %inter-trial interval
stimStruct.controlParams = controllerParams;
stimStruct.serial = s;

%Make sure that stim.Struct setpoint, stumDuration and refractory period
%lengths are consistent.
if (length(stimStruct.setpoint) ~= length(stimStruct.stimDuration) ||...
    length(stimStruct.setpoint) ~= length(stimStruct.refractoryPeriod))
    
    error('Make sure that stimulation structure length is consistent')
end

%TODO: Randomize intertrial interval between specified values
%TODO: Integrate with Benjamin's controll GUI


%% Start timer for execution loop
t = timer;
t.StartDelay = 0;
t.TimerFcn = @(~, ~) stimulusLoop(stimStruct);
t.StopFcn = {@(~, ~) cleanUpPID(stimStruct, t)};
%t.StartFcn = {@(~, ~) fclose(s); @(~, ~) disp('end of run')};

startat(t, experimentStartTime);
%delete(t) %delete timer object

%% Make RTU Message
% change_temp_units(s, controllerParams, 'C');
% change_temp(s, controllerParams, temperature);
% startPID(s, controllerParams);
% stopPID(s, controllerParams);


%% Clean up
%fclose(s); %close serial port


