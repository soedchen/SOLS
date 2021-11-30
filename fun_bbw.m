function bbw = fun_bbw(lambda)
% FUN_BBW calculate backscattering coefficient of pure water 
%         by using equation (5) in Q Liu 2020
% USAGE:
%    bbw = fun_bbw(lambda)
% INPUTS:
%    lambda: numeric, wavelength nm
% OUTPUTS:
%    bbw: numeric, backscattering coefficient of pure water
% EXAMPLE:
%    bbw = fun_bbw(532)
% HISTORY:
%    2021-05-22: first edition by OLIDAR
% .. Authors: - 

lambda0=550;
beta0 = 1.21e-4;
bbw = 0.5*16.06*(lambda0./lambda).^4.324.*beta0;
end
