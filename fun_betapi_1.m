function [beta_pi,beta_p,beta_w,bp,bw] = fun_betapi_1(chl,lambda)
% FUN_BETAPI_1 Calculate backscatter coefficient as the sum of beta_p and beta_w
% USAGE:
%    [beta_pi,beta_p,beta_w,bp,bw] = fun_betapi_1(chl,lambda)
% INPUTS:
%    chl: numeric, chlorophyll concentration mg/m3
%    lambda: numeric, wavelength nm
% OUTPUTS:
%    beta_pi: numeric, total backscatter coefficient
%    beta_p: numeric, backscatter coefficient of particle
%    beta_w: numeric, backscatter coefficient of pure water
%    bp: numeric, scattering coefficient of particle
%    bw: numeric, scattering coefficient of pure water
% EXAMPLE:
%    
% HISTORY:
%    2021-05-22: first edition by OLIDAR
% .. Authors: - 

bw = bw_fun(lambda);             % scattering coefficient of pure water
beta_w = bw.*SPFw_fun(pi);       % backscatter coefficient of pure water
bp = bp_fun(chl,lambda);         % scattering coefficient of particle
beta_p = bp.*SPFp_fun(chl);      % backscatter coefficient of particle
beta_pi = beta_p+beta_w;         % backscatter coefficient of sea water
end

% calculate cackscatter coefficient of particle
%   using equation 14 in morel 2002
function bp = bp_fun(chl,lambda)
bp550 = 0.416.*chl.^0.766;
v=zeros(size(chl));
v(chl<2) = 0.5*(log10(chl(chl<2))-0.3);
bp = bp550.*(lambda./550).^v;
end

% calcuulte particulate sacttering phase function  
%   using equation (9)(10) in Churnside, J. H., et al. (2014). "Lidar extinction-to-backscatter ratio of the ocean." Opt Express 22(15): 18698-18706
function [SPFp] = SPFp_fun(chl)
ratio = 0.002+0.01.*(0.5-0.25.*log10(chl));
SPFp = 0.151*ratio;
end

% calculate scattering coeficient of pure water
%   using equation(8.5) in Morel 2002
function [bw] = bw_fun(lambda)
bw_550 = 1.7e-3;
bw = bw_550.*(lambda/550).^-4.3;
end

% calculate scattering phase function of pure water
%   using equation 7 in Morel 2002
function SPFw = SPFw_fun(theta)
p = 0.84;
SPFw = 3./(4.*pi.*(3+p)).*(1+p.*(cos(theta).^2));
end

