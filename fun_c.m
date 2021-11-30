function [c,a,b] = fun_c(chl,lambda)
% FUN_C calculate the total attenuation coefficient 
% USAGE:
%    [c,a,b] = fun_c(chl,lambda)
% INPUTS:
%    chl: numeric, chlorophyll concentration mg/m3
%    lambda: numeric, wavelength, nm
% OUTPUTS:
%    a: numeric, attenuation coefficient
%    a: numeric, absorption coefficient
%    b: numeric, scattering coefficient
% EXAMPLE:
%    [c,a,b] = fun_c(1,532)
% HISTORY:
%    2021-10-14: first edition by OLIDAR
% .. Authors: - 

aw = fun_w(lambda);
ap= fun_ap(chl,lambda);
a = aw+ap;
b = fun_b(chl,lambda);
c = a+b;
end