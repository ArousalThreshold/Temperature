function [] = change_temp_units( s, controllerParamsStruct, unit_string )
%   change_temp_units(s, unit_string) 
%   s: Serial Object
%   unit_string: 'C' or 'F'
%   change_temp_units(s, 'C') 
%
%   Change the temperature display units on the MODBUS target. 
%   PVG 3/22/2017
%
%   Used with Omega CN7800 PID controller for Rogulja Lab thermal
%   stimulus

switch unit_string
    case {'C', 'c'}
        data_to_write = ['FF';'00']; 
        
    case {'F', 'f'}
        data_to_write = ['00';'00'];
end

device_address = controllerParamsStruct.address;
function_code = '05'; %write one bit
register_address = controllerParamsStruct.unitDisplaySelectionRegister; %temperature unit selection

message_less_CRC = [device_address; function_code; register_address; data_to_write];

%Third party CRC function
temp_dec_message = hex2dec(message_less_CRC);
amsg = append_crc(temp_dec_message); %original message with two CRC bytes at the end

fwrite(s, uint8(amsg))
end
