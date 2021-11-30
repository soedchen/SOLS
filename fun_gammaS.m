function [gammaS] = fun_gammaS(W,theta)
% FUN_gammaS calculate lidar sea surface backscatter gamma
%            using Eq.3 in Y.Hu2008
% USAGE:
%   [gammaS] = fun_gammaS(W,theta)
% INPUTS:
%   W: sea surface wind speed
%   theta: incident angle
% OUTPUTS:
%   gammaS: lidar sea surface backscatter
% EXAMPLE:
%    
% HISTORY:
%    2021-05-22: first edition by OLIDAR
% .. Authors: - 

sigma2 = 0.0276*log10(W)+0.009;
idx = W>=7;
sigma2(idx) = 0.138*log10(W(idx))-0.084;
rho = 0.0209;
gammaS = rho./(4*pi*sigma2*cos(theta).^2).*exp(-tan(theta).^2./(2.*sigma2));
