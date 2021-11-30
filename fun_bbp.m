function bbp = fun_bbp(chl,lambda)
% FUN_BBP calculate backscattering coefficient of particle
%         by using equation 13 in Morel 2001
% USAGE:
%    bbp = fun_bbp(chl,lambda)
% INPUTS:
%    chl: numeric, chlorophyll concentration mg/m3
%    lambda: numeric, wavelength nm
% OUTPUTS:
%    bbp: numeric, backscattering coefficient of particle
% EXAMPLE:
%    bbp = fun_bbp(1,532)
% HISTORY:
%    2021-05-22: first edition by OLIDAR
% .. Authors: - 

v = zeros(size(chl));
v(chl<2)=0.5*(log10(chl(chl<2))-0.3);
bp550 = 0.416.*(chl).^0.766;
bbp = (0.002+0.01.*(0.5-0.25.*(log10(chl))).*(lambda./550).^v).*bp550;
end