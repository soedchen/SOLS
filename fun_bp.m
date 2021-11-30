function bp = fun_bp(chl,lambda)
% FUN_BP calculate particle scattering coefficient using equation (3)(4) in 
%        https://www.oceanopticsbook.info/view/optical-constituents-of-the-ocean/level-2/new-iop-model-case-1-water
%        cited from Eq.14 in Morel 2002
% USAGE:
%    bp = fun_bp(chl,lambda)
% INPUTS:
%    chl: numeric, chlorophyll concentration mg/m3
%    lambda: numeric, wavelength nm
% OUTPUTS:
%    bp: numeric, scattering coefficient of particle
% EXAMPLE:
%    bp = fun_bbp(1,532)
% HISTORY:
%    2021-05-22: first edition by OLIDAR
% .. Authors: - 

v = zeros(size(chl));
v(chl<2)=0.5*(log10(chl(chl<2))-0.3);
bp550 = 0.416.*(chl).^0.766;
bp = bp550.*(lambda./550).^v;
end