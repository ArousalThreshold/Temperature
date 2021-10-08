function [] = change_temp(s, controllerParamsStruct, temperature, varargin )
%change_temp(s, temperature )
%   s: serial object
%   temperature: int, desired setpoint


temp_setpoint_hex = dec2hex(temperature*10, 4);

device_address = controllerParamsStruct.address;
function_code = '06'; %write word to register
register_address = controllerParamsStruct.setpointRegister; %setpoint register
data_to_write = [temp_setpoint_hex(1:2); temp_setpoint_hex(3:4)];

message_less_CRC = [device_address; function_code; register_address; data_to_write];

%Third party CRC function
temp_dec_message = hex2dec(message_less_CRC);
amsg = append_crc(temp_dec_message); %original message with two CRC bytes at the end

fwrite(s, uint8(amsg))

if nargin>3
    disp(varargin{1})
end

end

