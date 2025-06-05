clear;
clc;
close all;

% Parameters
DATA_WIDTH = 14;            % Output bit width
LUT_DEPTH  = 4096;          % Total samples in the LUT

% Generate values from 0 to 2*pi
x = linspace(0, 2*pi, LUT_DEPTH);
sin_values = sin(x);

% Scale to 14-bit signed integer range (-8192 to 8191)
max_val = 2^(DATA_WIDTH-1) - 1;  % 8191
scaled_sin = round(sin_values * max_val);  % Signed integers

% Plot for visualization
figure;
plot(scaled_sin);
title('14-bit Signed Sine Wave (LUT)');
xlabel('Index');
ylabel('Amplitude');

% Write to .coe file
filename = 'full_sin_LUT.coe';
fid = fopen(filename, 'w');
fprintf(fid, 'memory_initialization_radix=2;\n');
fprintf(fid, 'memory_initialization_vector=\n');

for i = 1:LUT_DEPTH
    val = scaled_sin(i);
    
    % Convert to 2's complement binary string
    if val < 0
        val = 2^DATA_WIDTH + val;  % 2's complement
    end
    
    bin_str = dec2bin(val, DATA_WIDTH);
    
    % Write value, comma at end except last entry
    if i ~= LUT_DEPTH
        fprintf(fid, '%s,\n', bin_str);
    else
        fprintf(fid, '%s;\n', bin_str);  % end with semicolon
    end
end

fclose(fid);
