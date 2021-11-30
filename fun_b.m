function b = fun_b(chl,lambda)
% FUN_B calculate scattering coefficient using euqation in p7 in
%       Hydrolight-软件原理及应用介绍.ppt  (hydrolight)
% USAGE:
%    b = fun_b(chl,lambda)
% INPUTS:
%    chl: numeric, chlorophyll concentration mg/m3
%    lambda: numeric, wavelength nm
% OUTPUTS:
%    b: numeric, scattering coeficient
% EXAMPLE:
%    b = fun_b(1,532)
% HISTORY:
%    2021-05-22: first edition by OLIDAR
% .. Authors: - 

b = 0.3.*(chl).^0.62.*(550./lambda);
end