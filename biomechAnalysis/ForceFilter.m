function y = ForceFilter(x)
%FORCEFILTER Filters input x and returns output y.

% MATLAB Code
% Generated by MATLAB(R) 8.5 and the DSP System Toolbox 9.0.
% Generated on: 01-Aug-2016 21:17:06

%#codegen

% To generate C/C++ code from this function use the codegen command.
% Type 'help codegen' for more information.

persistent Hd;

if isempty(Hd)
    
    % The following code was used to design the filter coefficients:
    %
    % N    = 1;      % Order
    % F3dB = 10800;  % 3-dB Frequency
    % Fs   = 48000;  % Sampling Frequency
    %
    % h = fdesign.lowpass('n,f3db', N, F3dB, Fs);
    %
    % Hd = design(h, 'butter', ...
    %     'SystemObject', true);
    
    Hd = dsp.BiquadFilter( ...
        'Structure', 'Direct form II', ...
        'SOSMatrix', [1 1 0 1 -0.0787017068246185 0], ...
        'ScaleValues', [0.460649146587691; 1]);
end

y = step(Hd,x);


