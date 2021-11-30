function [bb,bbw,bbp] = fun_bb(chl,lambda)
% FUN_BB calculate total backscattering coefficient
% USAGE:
%    [bb,bbw,bbp] = fun_bb(chl,lambda)
% INPUTS:
%    chl: numeric, chlorophyll concentration mg/m3
%    lambda: numeric, wavelength nm
% OUTPUTS:
%    bb: numeric, total backscattering coefficient
%    bbw: numeric, backscattering coefficient of pure water
%    bbp: numeric, backscattering coefficient of particle
% EXAMPLE:
%    [bb,bbw,bbp] = fun_bb(1,532)
% HISTORY:
%    2021-05-22: first edition by OLIDAR
% .. Authors: - 

bbw = fun_bbw(lambda);
bbp=fun_bbp(chl,lambda);
bb = bbw+bbp;
end