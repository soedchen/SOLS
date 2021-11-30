function  Ta = fun_Ta(lambda)
% FUN_TA Calculate one-way transimission trough atmosphere
% USAGE:
%    Ta = fun_Ta(lambda)
% INPUTS:
%    lambda: numeric, wavelength nm
% OUTPUTS:
%    Ta: numeric, one-way transimission trough atmosphere
% EXAMPLE:
%    
% HISTORY:
%    2021-05-22: first edition by OLIDAR
% .. Authors: - 
    Ta_data = load('Ta_data.mat');
    lambdas = Ta_data.lambdas;
    Tas = Ta_data.Tas;
    Ta = interp1(lambdas,Tas,lambda);
    
end