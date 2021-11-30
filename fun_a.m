function [a,aw,ap] = fun_a(chl,lambda)
% FUN_A calculate the total absorption coefficient 
% USAGE:
%    [a,aw,ap] = fun_a(chl,lambda)
% INPUTS:
%    chl: numeric, chlorophyll concentration mg/m3
%    lambda: numeric, wavelength, nm
% OUTPUTS:
%    a: numeric, total absorption coeficient
%    aw: numeric, absorption coefficient of water
%    ap: numeric, absorption coefficient of particle
% EXAMPLE:
%    [a,aw,ap] = fun_a(1,532)
% HISTORY:
%    2021-10-14: first edition by OLIDAR
% .. Authors: - 

aw = fun_w(lambda);
ap= fun_ap(chl,lambda);
a = aw+ap;
end