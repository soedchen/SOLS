function [beta_pi,bb,bbp,bbw] = fun_betapi_2(chl,lambda)
% FUN_BETAPI_2 Calculate backscatter coefficient using Eq2 in Q Liu 2020
% USAGE:
%    [beta_pi,bb,bbp,bbw] = fun_betapi_2(chl,lambda)
% INPUTS:
%    chl: numeric, chlorophyll concentration mg/m3
%    lambda: numeric, wavelength nm
% OUTPUTS:
%    beta_pi: numeric, backscatter coefficient
%    bb: numeric, total backscattering coefficient 
%    bbp: numeric, backscattering coefficient of particle
%    bbw: numeric, backscattering coefficient of pure water
% EXAMPLE:
%    
% HISTORY:
%    2021-05-22: first edition by OLIDAR
% .. Authors: - 

bbp = fun_bbp(chl,lambda);
bbw = fun_bbw(lambda);
bb = bbp+bbw;
f = @(theta) (fun_spf(theta).*sin(theta));
beta_pi = fun_spf(pi).*bb./ ...
    (2.*pi.*integral(f,pi/2,pi));
end
