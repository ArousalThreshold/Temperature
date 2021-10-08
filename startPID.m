function [] = startPID(s, controllerParamsStruct, varargin)
%startPID 

device_address = controllerParamsStruct.address;
function_code = '05'; %write 1 bit to register
register_address = controllerParamsStruct.runStopRegister;
data_to_write = ['FF';'00']; 

message_less_CRC = [device_address; function_code; register_address; data_to_write];

%Third party CRC function
temp_dec_message = hex2dec(message_less_CRC);
amsg = append_crc(temp_dec_message); %original message with two CRC bytes at the end

fwrite(s, uint8(amsg))

if nargin>2
    disp(varargin{1})
end

end







