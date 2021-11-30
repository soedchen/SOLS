function [Kd,Kw,Kp,chi,e] = fun_Kd_Morel(chl,lambda)
% FUN_KD_MOREL calculate Kd using equation (3)(5) in Morel 2001
% USAGE:
%    [Kd,Kw,Kp,chi,e] = fun_Kd_Morel(chl,lambda)
% INPUTS:
%    chl: numeric, chlorophyll concentration mg/m3
%    lambda: numeric, wavelength nm
% OUTPUTS:
%    Kd: numeric, diffuse attenuation coefficient
%    Kw: numeric, diffuse attenuation coefficient of pure water
%    Kp: numeric, diffuse attenuation coefficient of particle
%    chi: numeric, coefficient of lambda
%    e: numeric, coefficient of lambda
% EXAMPLE:
%    
% HISTORY:
%    2021-05-22: first edition by OLIDAR
% .. Authors: - 

% calculate Kd using equation (3)(5) in Morel 2001
data = load('Kd_Morel');
lambdas = data.lambda;
Kws = data.Kw;
es = data.e;
chis = data.chi;
Kw = interp1(lambdas,Kws,lambda);
e = interp1(lambdas,es,lambda);
chi = interp1(lambdas,chis,lambda);
Kp = chi.*(chl).^e;
Kd = Kw+Kp;
end