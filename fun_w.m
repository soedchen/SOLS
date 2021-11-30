function [aw, bw]=fun_w(lambda)
% FUN_W calculate absorption and scattering coefficients of pure water
%       using data H2OabDefaults.txt in HE5 (hydrolight)
% USAGE:
%    [aw, bw]=fun_w(lambda)
% INPUTS:
%    lambda: numeric, wavelength nm
% OUTPUTS:
%    aw: numeric, absorption coeficient of pure water
%    bw: numeric, scattering coeficient of pure water
% EXAMPLE:
%    [aw, bw]=fun_w(532)
% HISTORY:
%    2021-05-22: first edition by OLIDAR
% .. Authors: - 

wc=load('H2OabDefaults.mat');
lambdas = wc.lambda;
aws = wc.aw;
bws= wc.bw;
aw = interp1(lambdas,aws,lambda);
bw = interp1(lambdas,bws,lambda);
end