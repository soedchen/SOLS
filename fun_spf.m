function spf = fun_spf(theta)
% FUN_SPF Calculate HG-SPF using Eq.3 in QLiu2020
% USAGE:
%    spf = fun_spf(theta)
% INPUTS:
%    theta: scattering angle
% OUTPUTS:
%    spf: scattering phase function
% EXAMPLE:
%    
% HISTORY:
%    2021-05-22: first edition by OLIDAR
% .. Authors: - 
g = 0.924;
spf = 1./(4*pi).*(1-g.^2)./ ...
    (1+g.^2-2*g*cos(theta)).^(3/2);
end